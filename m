Return-Path: <linux-kernel-owner+w=401wt.eu-S1764642AbZAULpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764642AbZAULpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbZAULpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:45:14 -0500
Received: from main.gmane.org ([80.91.229.2]:40438 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764509AbZAULpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:45:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alessandro Di Marco <dmr@c0nc3pt.com>
Subject: [PATCH] input: Introduces activity counters revealing user interactivity
Date: Wed, 21 Jan 2009 12:42:08 +0100
Organization: Julian Assange Memorial Society
Message-ID: <87hc3s3my7.fsf@c0nc3pt.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 213-140-6-115.ip.fastwebnet.it
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
Cancel-Lock: sha1:oNJW+A1IP8DsjIKtYnNzhjnqF0s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the attached patch* introduces activity counters into input device drivers so
that a proper user-space daemon leveraging these counters can implement event
notification facilities (e.g. screen savers, intrusion detection, etc.)  At
this purpose, a second patch has been also attached: it provides a working Perl
daemon simulating the activity of a screen saver.

I had submitted something similar a couple of years ago, by way of a kernel
module named SIN (http://lkml.org/lkml/2007/1/18/138)

Despite SIN has been properly maintained in this period, it revealed soon some
design weaknesses which urged me towards alternative approaches. So here I am
once more. The submitted patch is quite straightforward yet provides good
features, such as:

1) daemons retain the whole control logic

2) daemons are EVIOCGRAB hassle free

3) daemons do not get biased towards a specific environment (e.g. one monitor,
   one keyboard...)

That's it.

Cheers,
Alessandro

* 2.6.28.1 friendly

Signed-off-by: Alessandro Di Marco <dmr@c0nc3pt.com>

==============================================================================
diff -uprN old/drivers/input/input.c new/drivers/input/input.c
--- old/drivers/input/input.c	2009-01-21 01:30:10.000000000 +0100
+++ new/drivers/input/input.c	2009-01-21 01:30:10.000000000 +0100
@@ -72,6 +72,12 @@ static void input_pass_event(struct inpu
 			     unsigned int type, unsigned int code, int value)
 {
 	struct input_handle *handle;
+	
+	dev->activity = ktime_get();
+
+	if (dev->activity_notifier) {
+		sysfs_notify_dirent(dev->activity_notifier);
+	}

 	rcu_read_lock();

@@ -1012,11 +1018,25 @@ static ssize_t input_dev_show_modalias(s
 }
 static DEVICE_ATTR(modalias, S_IRUGO, input_dev_show_modalias, NULL);

+static ssize_t input_dev_show_activity(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct input_dev *id = to_input_dev(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "A: %Ld\nD: %Ld\n",
+			 ktime_to_ns(id->activity),
+			 ktime_to_us(ktime_sub(ktime_get(), id->activity)));
+}
+
+static DEVICE_ATTR(activity, S_IRUGO, input_dev_show_activity, NULL);
+
 static struct attribute *input_dev_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_phys.attr,
 	&dev_attr_uniq.attr,
 	&dev_attr_modalias.attr,
+	&dev_attr_activity.attr,
 	NULL
 };

@@ -1227,10 +1247,34 @@ static int input_dev_uevent(struct devic
 	return 0;
 }

+static inline int warp_activity(struct device *dev) 
+{
+	struct input_dev *id = to_input_dev(dev);
+
+	id->activity = ktime_sub(ktime_get(), id->activity);
+	return 0;
+}
+
+int input_dev_suspend(struct device *dev, pm_message_t state)
+{
+	if (state.event & (PM_EVENT_FREEZE|PM_EVENT_SUSPEND)) {
+		(void) warp_activity(dev);
+	}
+
+	return 0;
+}
+
+int input_dev_resume(struct device *dev)
+{
+	return warp_activity(dev);
+}
+
 static struct device_type input_dev_type = {
 	.groups		= input_dev_attr_groups,
 	.release	= input_dev_release,
 	.uevent		= input_dev_uevent,
+	.suspend	= input_dev_suspend,
+	.resume		= input_dev_resume,
 };

 struct class input_class = {
@@ -1401,6 +1445,8 @@ int input_register_device(struct input_d
 		dev->name ? dev->name : "Unspecified device", path ? path : "N/A");
 	kfree(path);

+	dev->activity_notifier = sysfs_get_dirent(dev->dev.kobj.sd, "activity");
+	
 	error = mutex_lock_interruptible(&input_mutex);
 	if (error) {
 		device_del(&dev->dev);
@@ -1446,6 +1492,9 @@ void input_unregister_device(struct inpu

 	mutex_unlock(&input_mutex);

+	sysfs_put(dev->activity_notifier);
+	dev->activity_notifier = NULL;
+
 	device_unregister(&dev->dev);
 }
 EXPORT_SYMBOL(input_unregister_device);
diff -uprN old/include/linux/input.h new/include/linux/input.h
--- old/include/linux/input.h	2009-01-21 01:30:10.000000000 +0100
+++ new/include/linux/input.h	2009-01-21 01:30:10.000000000 +0100
@@ -1094,6 +1094,9 @@ struct input_dev {

 	struct input_handle *grab;

+	struct sysfs_dirent *activity_notifier;
+	ktime_t activity;
+	
 	spinlock_t event_lock;
 	struct mutex mutex;

==============================================================================
diff -uprN old/SIN.pl new/SIN.pl
--- old/SIN.pl	2009-01-21 01:38:07.000000000 +0100
+++ new/SIN.pl	2009-01-21 01:38:01.000000000 +0100
@@ -0,0 +1,259 @@
+#!/usr/bin/perl -w
+
+# Copyright (C) 2009 Alessandro Di Marco <dmr@c0nc3pt.com>
+
+# This file is part of SIN.
+
+# SIN is free software: you can redistribute it and/or modify it under the
+# terms of the GNU General Public License as published by the Free Software
+# Foundation, either version 3 of the License, or (at your option) any later
+# version.
+
+# SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
+# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
+
+# You should have received a copy of the GNU General Public License along with
+# SIN.  If not, see <http://www.gnu.org/licenses/>.
+
+use strict;
+
+use IO::File;
+use IO::Select;
+use Getopt::Long;
+use Pod::Usage;
+
+use Storable;
+
+use constant CONFIG => 'SIN.conf';
+use constant ENROLL_TIMEOUT => 5;
+
+my @script = ( { timeout => 5, action => 'echo "dim screen"' },
+	       { timeout => 10, action => 'echo "blank screen"' },
+	       { timeout => 20, action => 'echo "system suspend"' } );
+
+use constant RESUME => 'echo "restore screen"';
+
+sub devices {
+    open my $devices, "/proc/bus/input/devices"
+	or die "uhm, no input devices?!?";
+
+    my $name;
+    my $devs;
+
+    while (<$devices>) {
+	$name = $1 if $_ =~ /^N: Name=\"(.*)\"\n$/;
+	$devs->{$1} = $name if $_ =~ /S: Sysfs=(.*)\n$/;
+    }
+
+    $devs;
+}
+
+sub activity {
+    my ($enrolled) = @_;
+
+    $enrolled = $_ unless defined $enrolled;
+
+    my $activities;
+
+    foreach (keys %$enrolled) {
+	open my $handle, "/sys$_/activity"
+	    or die "missing activity on $_; please apply the patch!";
+
+	my @data = <$handle>;
+
+	$data[0] =~ /A: (0|[1-9][0-9]*)\n$/;
+	my $last = $1;
+
+	$data[1] =~ /D: (0|[1-9][0-9]*)\n$/;
+	my $delta = $1;
+
+	$activities->{$handle} = {
+	    'path' => $_,
+	    'handle' => $handle,
+	    'last' => $last,
+	    'delta' => $delta,
+	};
+    }
+
+    $activities;
+}
+
+sub latest {
+    my ($activities) = @_;
+
+    $activities = $_ unless defined $activities;
+
+    foreach (values %$activities) {
+	my $handle = $_->{'handle'};
+
+	seek $handle, 0, SEEK_SET;
+
+	my @data = <$handle>;
+
+	$data[0] =~ /A: (0|[1-9][0-9]*)\n$/;
+	$_->{'last'} = $1;
+
+	$data[1] =~ /D: (0|[1-9][0-9]*)\n$/;
+	$_->{'delta'} = $1;
+    }
+
+    $activities;
+}
+
+sub configure {
+    my ($devs) = @_;
+
+    select(undef, undef, undef, 0.1);
+
+    print "Input device enrolling:\n";
+    print "  please interact with the desired input devices;\n";
+    print "  the process will terminate after " . ENROLL_TIMEOUT
+	. " seconds from the last enrollment.\n";
+
+    my $activities = activity($devs);
+
+    my $select = new IO::Select(map { $_->{'handle'} } values %$activities);
+
+    while ($select->handles) {
+	last unless my @picked = $select->can_read(ENROLL_TIMEOUT);
+
+    	foreach (@picked) {
+    	    print "Enrolled $devs->{$activities->{$_}->{'path'}}\n";
+    	}
+
+    	$select->remove(@picked);
+    }
+
+    delete $activities->{$_} foreach ($select->handles);
+
+    my $enrolled;
+
+    foreach (map { $_->{'path'} } values %$activities) {
+	$enrolled->{$_} = $devs->{$_};
+    }
+
+    $enrolled;
+}
+
+my %opts = ();
+
+GetOptions('configure' => \$opts{'configure'},
+	   'help|?' => \$opts{'help'},
+	   'man' => \$opts{'man'})
+    or pod2usage(2);
+
+pod2usage(1) if $opts{'help'};
+pod2usage('-exitstatus' => 0, '-verbose' => 2) if $opts{'man'};
+
+my $enrolled;
+
+if ($opts{'configure'}) {
+    $enrolled = configure devices;
+    store $enrolled, CONFIG;
+    exit 0;
+}
+
+die "No usable configuration found" unless -e CONFIG;
+
+$enrolled = retrieve(CONFIG)
+    or die "uhm, invalid configuration?!?\n";
+
+my $devs = devices;
+
+foreach (keys %$enrolled) {
+    die "uhm, stored configuration doesn't match?!?\n"
+	unless defined $devs->{$_};
+}
+
+sub latter_of {
+    my ($activities) = @_;
+
+    $activities = $_ unless defined $activities;
+
+    my $last = 0;
+    my $me;
+
+    foreach (values %$activities) {
+	if ($_->{'last'} > $last) {
+	    $last = $_->{'last'};
+	    $me = $_;
+	}
+    }
+
+    $me;
+}
+
+sub warp {
+    (($_[0]->{'timeout'} * 1000000) - $_[1]->{'delta'}) / 1000000;
+}
+
+my $activities = activity $enrolled;
+my $select = new IO::Select(map { $_->{'handle'} } values %$activities);
+
+start:
+    while (1) {
+	my $last = latter_of latest $activities;
+	my $trig = 0;
+
+	for (my $i = 0; $i < @script; $i++) {
+	    if ($trig) {
+		if ($select->can_read(warp($script[$i], $last))) {
+		    system RESUME;
+		    next start;
+		}
+
+		$last = latter_of latest $activities;
+	    } else {
+		while ((my $timeout = warp($script[$i], $last)) > 0) {
+		    select(undef, undef, undef, $timeout);
+		    $last = latter_of latest $activities;
+		}
+
+		$trig = 1;
+	    }
+
+	    system $script[$i]->{'action'};
+	}
+
+	$select->can_read;
+
+	system RESUME;
+}
+
+__END__
+
+=pod
+
+=head1 NAME
+
+SIN - System Inactivity Notifier
+
+=head1 SYNOPSIS
+
+B<SIN> [B<--configure>] [B<--help>] [B<--man>]
+
+=head1 OPTIONS
+
+=over 8
+
+=item B<--configure>
+
+Let the user configure SIN.
+
+=item B<--help>
+
+Print a brief help message and exits.
+
+=item B<--man>
+
+Prints the manual page and exits.
+
+=back
+
+=head1 DESCRIPTION
+
+B<SIN> is an inactivity notifier. This means that you can instruct SIN to
+perform different actions depending on user's activity.
+
+=cut

-- 
He who strikes terror into others is himself in continual fear. - Claudian

