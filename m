Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbXFMSQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbXFMSQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbXFMSQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:16:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758941AbXFMSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:16:23 -0400
Date: Wed, 13 Jun 2007 11:15:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holzheu@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-Id: <20070613111549.db1fa4d9.akpm@linux-foundation.org>
In-Reply-To: <1181747217.29512.9.camel@localhost.localdomain>
References: <1181747217.29512.9.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 13 Jun 2007 17:06:57 +0200 holzheu <holzheu@linux.vnet.ibm.com> wrote:
> Greetings,
> 
> The operation of a Linux system sometimes requires to decode the
> meaning of a specific kernel message, e.g. an error message of a
> driver. Especially on our mainframe zSeries platform system
> administrators want to have descriptions for Linux kernel messages.
> They are used to that, because all other operating systems on that
> platform like z/OS, z/VM or z/VSE have message catalogs with detailed
> descriptions about the semantics of the messages.
> 
> In general we think, that also for Linux it is a good thing to have
> documentation for the most important kernel/driver messages. Even
> kernel hackers not always are aware of the meaning of kernel messages
> for components, which they don't know in detail. Most of the messages
> are self explaining but sometimes you get something like "Clocksource
> tsc unstable (delta = 7304132729 ns)" and you wonder if your system is
> going to explode.
> 
> Unfortunately currently there is no general infrastructure in the Linux
> kernel for the documentation of messages. I worked on a proposal, how
> that could be implemented in an easy way using the already existing
> kernel-doc infrastructure and using printk. The proposal is as follows
> 
> 1. We use message identifiers in order to map messages to message
> descriptions. A message identifier consists out of a component name and
> within that component unique message number.
> 
> 2. Messages and message descriptions are maintained together in the
> kernel sources in order to keep them up to date. Messages catalog are
> generated automatically for exactly one kernel level.
> 
> 3. A special tool checks, if messages are not documented or if there
> are message descriptions without corresponding messages.
> 
> 4. We use the already existing kernel-doc tool to generate an online
> message catalog or e.g. a pdf for offline documentation.
> 
> Current prototype implementation:
> ================================= 
> 
> The structure of a kernel message is: <component>.<msg number>: <msg>
> 
> * component: Name of the kernel or driver component e.g. "pci", "ide", 
>   etc.
> * msg number: Within the component unique number of a kernel message.
> * msg: printk message
> 
> New macros KMSG_ERR(), KMSG_WARN(), etc. are defined, which have to be
> used in printk. These macros have as parameter the message number and
> are using a per c-file defined macro KMSG_COMPONENT.
> 
> Example: Define message 2 in component "kmsgtest":
> 
> #define KMSG_COMPONENT "kmsgtest"
> 
> void f(void)
> {
>         printk(KMSG_ERR(1) "device %x not online\n", devno);
> }
> 
> The output of that kernel message would be:
> "kmsgtest.1: device 4711 not online"
> 
> The messages have to be documented within the C source file
> in the following way:
> 
> /**
>  * message
>  * @0: device number of device.
>  *
>  * Description:
>  * An operation has been performed on the msgtest device, but the
>  * device has not been set online. Therefore the operation failed
>  *
>  * User Response:
>  * Operator should set device online.
>  * Issue "chccwdev -e <device number>".
>  *
>  */
> 
> KMSG_DOC(kmsgtest, 2,  "Device %x not online");
> 
> I created a patch for the kernel-doc tool so it can be used to generate
> a catalog of all kernel messages:
> 
> >> kernel-doc -man kmsgtest.c > kmsgtest.2
> >> man ./kmsgtest.2 
> 
> # Kernel API(9)               Linux Messages               Kernel API(9)
> # 
> # MESSAGE:
> #       kmsgtest.2: "device %x not online"
> #
> # Parameter:
> #       1           Device number of device.
> #
> # Description:
> #       An  operation  has been performed on the msgtest device, but
> #       the device has not been set online. Therefore the operation failed.
> #
> # User Response:
> #       Operator should set device online.
> #       Issue "chccwdev -e <device number>".
> #
> # May 2007                      kmsgtest.2                 Kernel API(9)
> 
> A nice thing would be to include the online kernel message catalog in
> the kernel rpm. One possibility for that would be to have one man page
> per message. If an operator finds the message kmsgtest.2 in
> var/log/messages and wants to know what the message means, he simply
> issues "man kmsgtest.2" and gets the description.
> 
> To ensure that all messages are documented and there are no message
> descriptions without corresponding messages, a checker tool is
> provided. To enable message checking, in the toplevel Makefile the
> following has to be added:
> 
> CHECK = scripts/kmsg_check.pl check
> 
> To enable message checking during kernel build, the "C" option has
> to be used:
> 
> >> make modules C=1
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHECK   drivers/kmsgtest/kmsgtest.c
> drivers/kmsgtest/kmsgtest.c: Missing description for: kmsgtest.1
> drivers/kmsgtest/kmsgtest.c: Description without message for: kmsgtest.3
> 
> Please note, that the patch for the kernel-doc and kmsg-doc tools
> is just a prototype and is neither complete nor perfect.
> 
> Michael
> 
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Michael Holzheu <holzheu@linux.vmnet.ibm.com>

Your proposal is similar to one I made to some Japanese developers
earlier this year.  I was more modest, proposing that we

- add an enhanced printk

	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);

- An externally managed database will provide translations, diagnostics,
  remedial actions, etc, keyed off the msgid string

- Format and management of the msgid hasn't been clearly identified yet
  as far as I know.  But all we really need is that each ID be unique,
  kernel-wide.  We develop a simple tool which can check the whole tree
  for duplicated msgids.

- From a practical day-to-day POV what this means is that a person
  from the kernel-messages team will prepare a patch for your driver
  which adds the msgids and you the driver author should take care not
  to break the tagging.

  This is deliberately designed to be minimum-impact upon general 
  developers.  We want a system in place where driver/fs/etc developers
  can concentrate on what they do, and kernel-message developers can
  as independently as possibe take care of what _they_ do.

- A project has started up and there is a mailing list (cc'ed here) and
  meetings are happening at the LF collaboration summit this week.

  Please see https://lists.linux-foundation.org/mailman/listinfo/lf_kernel_messages
  and don't miss the next conference call ;)

  (argh.  The lf_kernel_messages archives are subscriber-only and it could be that
  only members can post to it.  Oh well.  Please subscribe, and review the archives)

> 
>  Makefile                    |    5
>  drivers/Makefile            |    1
>  drivers/kmsgtest/Makefile   |    5
>  drivers/kmsgtest/kmsgtest.c |   59 +++++++++++
>  include/linux/kmsg.h        |   32 ++++++
>  scripts/kernel-doc          |  116 +++++++++++++++++++++-
>  scripts/kmsg-doc            |  231 ++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 445 insertions(+), 4 deletions(-)
> 
> diff -Naur linux-2.6.21/Makefile linux-2.6.21-kmsg/Makefile
> --- linux-2.6.21/Makefile	2007-04-26 05:08:32.000000000 +0200
> +++ linux-2.6.21-kmsg/Makefile	2007-06-05 15:17:51.000000000 +0200
> @@ -293,9 +293,8 @@
>  DEPMOD		= /sbin/depmod
>  KALLSYMS	= scripts/kallsyms
>  PERL		= perl
> -CHECK		= sparse
> -
> -CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise $(CF)
> +CHECK		= scripts/kmsg-doc check
> +CHECKFLAGS	=
>  MODFLAGS	= -DMODULE
>  CFLAGS_MODULE   = $(MODFLAGS)
>  AFLAGS_MODULE   = $(MODFLAGS)
> diff -Naur linux-2.6.21/drivers/Makefile linux-2.6.21-kmsg/drivers/Makefile
> --- linux-2.6.21/drivers/Makefile	2007-04-26 05:08:32.000000000 +0200
> +++ linux-2.6.21-kmsg/drivers/Makefile	2007-06-05 15:17:51.000000000 +0200
> @@ -8,6 +8,7 @@
>  obj-$(CONFIG_PCI)		+= pci/
>  obj-$(CONFIG_PARISC)		+= parisc/
>  obj-$(CONFIG_RAPIDIO)		+= rapidio/
> +obj-m				+= kmsgtest/
>  obj-y				+= video/
>  obj-$(CONFIG_ACPI)		+= acpi/
>  # PnP must come after ACPI since it will eventually need to check if acpi
> diff -Naur linux-2.6.21/drivers/kmsgtest/Makefile linux-2.6.21-kmsg/drivers/kmsgtest/Makefile
> --- linux-2.6.21/drivers/kmsgtest/Makefile	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.21-kmsg/drivers/kmsgtest/Makefile	2007-06-05 15:17:51.000000000 +0200
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for kernel message test module
> +#
> +
> +obj-m		+= kmsgtest.o
> diff -Naur linux-2.6.21/drivers/kmsgtest/kmsgtest.c linux-2.6.21-kmsg/drivers/kmsgtest/kmsgtest.c
> --- linux-2.6.21/drivers/kmsgtest/kmsgtest.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.21-kmsg/drivers/kmsgtest/kmsgtest.c	2007-06-05 15:17:51.000000000 +0200
> @@ -0,0 +1,59 @@
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/kmsg.h>
> +
> +static int devno = 0x4711;
> +static int status = 1;
> +
> +#define KMSG_COMPONENT "kmsgtest"
> +
> +static int __init kmsgtest_init(void)
> +{
> +	printk(KMSG_INFO(1) "device %x has status %i\n", devno, status);
> +	printk(KMSG_ERR(2) "device %x not online\n", devno);
> +
> +	return 0;
> +}
> +
> +static void __exit kmsgtest_exit(void)
> +{
> +	printk("kmsgtest module exit\n");
> +}
> +
> +module_init(kmsgtest_init);
> +module_exit(kmsgtest_exit);
> +
> +/**
> + * message
> + * @0: Device number of device
> + * @1: Status of device
> + *
> + * Description:
> + * Information message about the status of our virtual msgtest device. The
> + * following values for the status parameter are available.
> + *
> + *   0 - Device is offline
> + *
> + *   1 - Device is online
> + *
> + *   2 - Device is broken
> + *
> + * User Response:
> + * If device is broken, replace it or fix it.
> + */
> +
> +KMSG_DOC(kmsgtest, 1, "device %x has status %i");
> +
> +/**
> + * message
> + * @0: Device number of device.
> + *
> + * Description:
> + * An operation has been performed on the msgtest device, but the device has
> + * not been set online. Therefore the operation failed.
> + *
> + * User Response:
> + * Operator should set device online. Issue "chccwdev -e <device number>".
> + */
> +
> +KMSG_DOC(kmsgtest, 2, "device %x not online");
> diff -Naur linux-2.6.21/include/linux/kmsg.h linux-2.6.21-kmsg/include/linux/kmsg.h
> --- linux-2.6.21/include/linux/kmsg.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.21-kmsg/include/linux/kmsg.h	2007-06-05 15:17:51.000000000 +0200
> @@ -0,0 +1,32 @@
> +#ifndef _LINUX_KMSG_H
> +#define _LINUX_KMSG_H
> +
> +#ifdef __KMSG_CHECKER
> +
> +#define KMSG_EMERG(num)   __KMSG_CHECK(EMERG, num)
> +#define KMSG_ALERT(num)   __KMSG_CHECK(ALERT, num)
> +#define KMSG_CRIT(num)    __KMSG_CHECK(CRIT, num)
> +#define KMSG_ERR(num)     __KMSG_CHECK(ERR, num)
> +#define KMSG_WARNING(num) __KMSG_CHECK(WARNING, num)
> +#define KMSG_NOTICE(num)  __KMSG_CHECK(NOTICE, num)
> +#define KMSG_INFO(num)    __KMSG_CHECK(INFO, num)
> +#define KMSG_DEBUG(num)   __KMSG_CHECK(DEBUG, num)
> +
> +#define KMSG_DOC(comp, num, str) __KMSG_DOC(comp, num, str)
> +
> +#else
> +
> +#define KMSG_EMERG(num)   KERN_EMERG KMSG_COMPONENT "." #num ": "
> +#define KMSG_ALERT(num)   KERN_ALERT KMSG_COMPONENT "." #num ": "
> +#define KMSG_CRIT(num)    KERN_CRIT KMSG_COMPONENT "." #num ": "
> +#define KMSG_ERR(num)     KERN_ERR KMSG_COMPONENT "." #num ": "
> +#define KMSG_WARNING(num) KERN_WARNING KMSG_COMPONENT "." #num ": "
> +#define KMSG_NOTICE(num)  KERN_NOTICE KMSG_COMPONENT "." #num ": "
> +#define KMSG_INFO(num)    KERN_INFO KMSG_COMPONENT "." #num ": "
> +#define KMSG_DEBUG(num)   KERN_DEBUG KMSG_COMPONENT "." #num ": "
> +
> +#define KMSG_DOC(comp, num, str)
> +
> +#endif /* __KMSG_CHECKER */
> +
> +#endif /* _LINUX_KMSG_H */
> diff -Naur linux-2.6.21/scripts/kernel-doc linux-2.6.21-kmsg/scripts/kernel-doc
> --- linux-2.6.21/scripts/kernel-doc	2007-04-26 05:08:32.000000000 +0200
> +++ linux-2.6.21-kmsg/scripts/kernel-doc	2007-06-05 15:17:51.000000000 +0200
> @@ -256,7 +256,7 @@
>  my $in_doc_sect;
>  
>  #declaration types: can be
> -# 'function', 'struct', 'union', 'enum', 'typedef'
> +# 'function', 'struct', 'union', 'enum', 'typedef', 'message'
>  my $decl_type;
>  
>  my $doc_special = "\@\%\$\&";
> @@ -1163,6 +1163,55 @@
>      output_section_text(@_);
>  }
>  
> +##
> +# output message in text
> +sub output_message_text(%) {
> +	my %args = %{$_[0]};
> +	my ($parameter);
> +
> +	print $args{'id'}.": \"".$args{'message'}."\"\n\n";
> +
> +	print "Parameters:\n\n";
> +	foreach $parameter (@{$args{'parameterlist'}}) {
> +		($parameter =~ /^#/) && next;
> +		my $parameter_name = $parameter;
> +		$parameter_name =~ s/\[.*//;
> +		($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
> +		print "$parameter\n\t";
> +		print $args{'parameterdescs'}{$parameter_name}."\n";
> +	}
> +	output_section_text(@_);
> +}
> +
> +##
> +# output message in man
> +sub output_message_man(%) {
> +	my %args = %{$_[0]};
> +	my ($parameter, $section);
> +
> +	print ".TH \"$args{'module'}\" 9 \"".$args{'id'}."\" \"$man_date\" \"Linux Messages\" LINUX\n";
> +
> +	print ".SH MESSAGE\n";
> +	print $args{'id'}.": "."\"".$args{'message'}."\"\n";
> +
> +	print ".SH Parameters\n";
> +	foreach $parameter (@{$args{'parameterlist'}}) {
> +		($parameter =~ /^#/) && next;
> +
> +		my $parameter_name = $parameter;
> +		$parameter_name =~ s/\[.*//;
> +
> +		($args{'parameterdescs'}{$parameter_name} ne $undescribed) || next;
> +		print ".IP \"".$parameter."\" 12\n";
> +		output_highlight($args{'parameterdescs'}{$parameter_name});
> +	}
> +	foreach $section (@{$args{'sectionlist'}}) {
> +		print ".SH \"$section\"\n";
> +		output_highlight($args{'sections'}{$section});
> +		print "\n";
> +	}
> +}
> +
>  #output sections in text
>  sub output_section_text(%) {
>      my %args = %{$_[0]};
> @@ -1607,6 +1656,69 @@
>  		       });
>  }
>  
> +sub create_parameterlist_msg($$) {
> +	my $args = shift;
> +	my $file = shift;
> +	my $splitter = "%";
> +	my $type;
> +	my $param = 0;
> +	my $first = 1;
> +
> +	# temporarily replace commas
> +	while ($args =~ /(\([^\),]+),/) {
> +		$args =~ s/(\([^\),]+),/$1#/g;
> +	}
> +
> +	foreach my $arg (split($splitter, $args)) {
> +		if ($first) {
> +			$first = 0;
> +			next;
> +		}
> +		$type = substr($arg,0,1);
> +
> +		# XXX introduce better type checking
> +
> +		push_parameter($param, $type, $file);
> +		$param += 1;
> +	}
> +}
> +
> +##
> +# takes a message prototype and the name of the current file being
> +# processed and spits out all the details stored in the global
> +# arrays/hashes.
> +sub dump_message($$) {
> +	my $x = shift;
> +	my $file = shift;
> +
> +	if ($x =~/(KMSG_DOC)\(\s*(\w+)\s*\,\s*(\w+)\s*\,\s*\"(.*)\"\)/) {
> +	$declaration_name = "$2.$3";
> +	my $members = $4;
> +	# strip comments:
> +	$members =~ s/\/\*.*?\*\///gos;
> +
> +	create_parameterlist_msg($members, $file);
> +
> +	output_declaration($declaration_name,
> +			   'message',
> +			   {'message' => $members,
> +			    'id' => $declaration_name,
> +			    'module' => $modulename,
> +			    'parameterlist' => \@parameterlist,
> +			    'parameterdescs' => \%parameterdescs,
> +			    'parametertypes' => \%parametertypes,
> +			    'sectionlist' => \@sectionlist,
> +			    'sections' => \%sections,
> +			    'purpose' => $declaration_purpose,
> +			    'type' => $decl_type
> +			   });
> +	}
> +	else {
> +		print STDERR "Error(${file}:$.): Cannot parse message!\n";
> +		++$errors;
> +	}
> +}
> +
>  sub process_file($);
>  
>  # Read the file that maps relative names to absolute names for
> @@ -1782,6 +1894,8 @@
>  		    $decl_type = 'enum';
>  		} elsif ($identifier =~ m/^typedef/) {
>  		    $decl_type = 'typedef';
> +		} elsif ($identifier =~ m/^message/) {
> +		    $decl_type = 'message';
>  		} else {
>  		    $decl_type = 'function';
>  		}
> diff -Naur linux-2.6.21/scripts/kmsg-doc linux-2.6.21-kmsg/scripts/kmsg-doc
> --- linux-2.6.21/scripts/kmsg-doc	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.21-kmsg/scripts/kmsg-doc	2007-06-05 15:17:51.000000000 +0200
> @@ -0,0 +1,231 @@
> +#!/usr/bin/perl
> +#
> +# Tool to check kernel messages
> +#
> +# Can be used in toplevel Linux Makefile in the following way:
> +#
> +# CHECK = scripts/kmsg-doc check
> +# CHECKFLAGS =
> +#
> +# Note: This is just a prototype and neither perfect nor complete!
> +#
> +# Copyright (C) IBM Corp. 2007
> +# Author(s): Michael Holzheu <holzheu@de.ibm.com>
> +#
> +
> +sub create_message($$$$$)
> +{
> +	my ($sev, $component, $number, $text, $params) = @_;
> +
> +	$text =~ s/\\n//; # remove trailing newline character
> +	$message_id = "$component.$number";
> +	$messages{$message_count}->{'ID'} = $message_id;
> +	$messages{$message_count}->{'COMP'} = $component;
> +	$messages{$message_count}->{'NR'} = $number;
> +	$messages{$message_count}->{'MSG'} = $text;
> +	$messages{$message_count}->{'SEV'} = $sev;
> +
> +	@parms = split(/[\s]*,[\s]*/,$params);
> +	$parm_count = 0;
> +	foreach $parm (@parms) {
> +		if (!($parm eq "")) {
> +			$messages{$message_count}->{'PARM_NAME'}->{$parm_count} = $parm;
> +			$parm_count += 1;
> +		}
> +	}
> +	$messages{$message_count}->{'PARM_COUNT'} = $parm_count;
> +	$message_count += 1;
> +}
> +
> +sub get_msgs($)
> +{
> +	my ($filename)=@_;
> +
> +	$message_count = 0;
> +	open(FD, $filename);
> +	my @lines=<FD>;
> +	foreach $line (@lines) {
> +		if ($line =~ /\s*printk\([\s]*__KMSG_CHECK\((.*)\,[\s]*(.*)\)[\s]*"(.*)"[\s]*(.*)[\s]*\);/) {
> +			create_message($1, $component, $2, $3, $4);
> +		}
> +	}
> +}
> +
> +sub get_descriptions($)
> +{
> +	my ($filename)=@_;
> +	my $desc_start;
> +
> +	$description_count = 0;
> +	$desc_start = 0;
> +	open(FD, $filename);
> +	my @lines=<FD>;
> +	foreach $line (@lines) {
> +		if ($line =~ /#define [\s]*KMSG_COMPONENT [\s]*"(.*)"/) {
> +			$component = $1;
> +		}
> +		if ($line =~ /\s*\/\*\*$/) {
> +			$msg_start = 1;
> +			$parm_count = 0;
> +			next;
> +		}
> +		if (($msg_start == 1) && ($line =~ / \* message/)) {
> +			$desc_start = 1;
> +			next;
> +		}
> +		if ($line =~ / \*\//) {
> +			$desc_start = 0;
> +			next;
> +		}
> +		if ($desc_start == 1) {
> +			$descriptions{$description_count}->{'DESC'} .= "$line";
> +			next;
> +		}
> +		if ($line =~
> +			/\s*KMSG_DOC\(\s*(.*)\s*\,\s*(.*)\s*\,\s*\"(.*)\"\s*\);/) {
> +			my $param_count = 0;
> +			my $first = 1;
> +			my $type;
> +
> +			$descriptions{$description_count}->{'ID'} = "$1\.$2";
> +			$descriptions{$description_count}->{'COMP'} = "$1";
> +			$descriptions{$description_count}->{'NR'} = "$2";
> +			$descriptions{$description_count}->{'MSG'} = "$3";
> +			foreach my $arg (split("%", $3)) {
> +				if ($first) {
> +					$first = 0;
> +					next;
> +				}
> +				$type = substr($arg, 0, 1);
> +				$descriptions{$description_count}->{'PARM_TYPE'}->{$param_count} = $type;
> +				$param_count += 1;
> +			}
> +			$descriptions{$description_count}->{'PARM_COUNT'} = $param_count;
> +			$description_count += 1;
> +		}
> +	}
> +}
> +
> +sub print_messages()
> +{
> +	for ($i = 0; $i < $message_count; $i++) {
> +		print "MESSAGE: $messages{$i}->{'ID'}\n";
> +	}
> +}
> +
> +sub print_descriptions($)
> +{
> +	my ($message_id)=@_;
> +
> +	for ($i = 0; $i < $description_count; $i++) {
> +		if (($descriptions{$i}->{'ID'} eq $message_id) || $message_id eq "all") {
> +			print "==============================================================================\n";
> +			print "\[$descriptions{$i}->{'COMP'}\.$descriptions{$i}->{'NR'}\] $descriptions{$i}->{'MSG'}\n";
> +			print "\n";
> +			print "Parameters:\n";
> +			for ($j = 0; $j < $descriptions{$i}->{'PARM_COUNT'}; $j++) {
> +				print " $descriptions{$i}->{'PARM_TYPE'}->{$j}: $descriptions{$i}->{'PARM_DESC'}->{$j}\n";
> +			}
> +			print "\n";
> +			print "Description:\n";
> +			print "$descriptions{$i}->{'DESC'}\n";
> +			print "==============================================================================\n";
> +		}
> +	}
> +}
> +
> +sub check_messages($)
> +{
> +	my ($filename)=@_;
> +
> +	for ($i = 0; $i < $message_count; $i++) {
> +		$found = 0;
> +		for ($j = 0; $j < $description_count; $j++) {
> +			if ($messages{$i}->{'ID'} eq $descriptions{$j}->{'ID'}) {
> +				$found = 1;
> +				last;
> +			}
> +		}
> +		if (!$found) {
> +			print STDERR "$filename: Missing description for: $messages{$i}->{'ID'}\n";
> +		}
> +	}
> +	for ($i = 0; $i < $description_count; $i++) {
> +		$found = 0;
> +		for ($j = 0; $j < $message_count; $j++) {
> +			if ($messages{$j}->{'ID'} eq $descriptions{$i}->{'ID'}) {
> +				$found = 1;
> +				last;
> +			}
> +		}
> +		if (!$found) {
> +			print STDERR "$filename: Description without message for: $descriptions{$i}->{'ID'}\n";
> +		}
> +	}
> +}
> +
> +sub print_templates()
> +{
> +
> +	for ($i = 0; $i < $message_count; $i++) {
> +		$found = 0;
> +		for ($j = 0; $j < $description_count; $j++) {
> +			if ($messages{$i}->{'ID'} eq $descriptions{$j}->{'ID'}) {
> +				$found = 1;
> +			}
> +		}
> +		if (!$found) {
> +			print "/**\n";
> +			print " * message\n";
> +			for ($k = 0; $k < $messages{$i}->{'PARM_COUNT'}; $k++) {
> +				print " * \@$k: $messages{$i}->{'PARM_NAME'}->{$k}\n";
> +			}
> +			print " *\n";
> +			print " * Description:\n";
> +			print " *\n";
> +			print " * User Response:\n";
> +			print " */\n";
> +			print "\n";
> +			print "KMSG_DOC($messages{$i}->{'COMP'}, $messages{$i}->{'NR'}, \"$messages{$i}->{'MSG'}\");\n"
> +		}
> +	}
> +}
> +
> +sub usage()
> +{
> +	print "USAGE: kmsg_tool print | check <file>\n";
> +	exit 1;
> +}
> +
> +$option = shift;
> +
> +if ($option eq "check") {
> +	$gcc_options = "-E -D __KMSG_CHECKER ";
> +	do {
> +		$filename = $tmp;
> +		$tmp = shift;
> +		$tmp =~ s/\(/\\\(/;
> +		$tmp =~ s/\)/\\\)/;
> +		$gcc_options .= " $tmp";
> +	} while (!($tmp eq ""));
> +
> +	$gcc_options =~ s/-Wbitwise//; # XXX hack to remove -Wbitwise CHECKFLAG
> +	$gcc_options =~ s/-D__STDC__//; # XXX hack to remove -D__STDC__
> +	$tmp_file = "$filename.msg";
> +	system("gcc $gcc_options > $tmp_file");
> +	get_descriptions($filename);
> +	get_msgs($tmp_file);
> +	check_messages($filename);
> +	print_templates();
> +	system("rm $tmp_file");
> +} elsif ($option eq "print") {
> +	$filename = shift;
> +	do {
> +		print STDERR "Processing: $filename\n";
> +		get_descriptions($filename);
> +		print_descriptions("all");
> +		$filename = shift;
> +	} while (!($filename eq ""));
> +} else {
> +	usage();
> +}
> 
