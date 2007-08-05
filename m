Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbXHET5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbXHET5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbXHET5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:57:02 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42258 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754017AbXHET5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:57:00 -0400
Date: Sun, 5 Aug 2007 21:56:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vojtech Pavlik <vojtech@suse.cz>, seife@suse.de
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
Subject: encrypted hibernation (was Re: Hibernation considerations)
Message-ID: <20070805195628.GA1947@elf.ucw.cz>
References: <200707151433.34625.rjw@sisk.pl> <20070715125855.GA1737@gallifrey> <200707160038.12943.rjw@sisk.pl> <20070729065352.GB17084@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729065352.GB17084@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Two things which I think would be nice to consider are:
> > >    1) Encryption - I'd actually prefer if my luks device did not
> > >        remember the key accross a hibernation; I want to be forced to
> > >        reenter the phrase.  However I don't know what the best thing
> > >        to do to partitions/applications using the luks device is.
> > 
> > Encryption is possible with both the userland hibernation (aka uswsusp) and
> > TuxOnIce (formerly known as suspend2).  Still, I don't consider it as a "must
> > have" feature for a framework to be generally useful (many users don't use it
> > anyway).
> 
> If a user uses an encrypted filesystem, then he also needs an encrypted
> swap and encrypted hibernation image: Otherwise the fileystem encryption
> is not very useful.

Actually, we can do most of that stuff already. 

We can encrypt filesystems, encrypt swaps (LVM), and encrypt hibernation.

What we _can't_ do is to hibernate on LVM encrypted partition, and we
could only suspend to swap partition. Bad combination, but here's way
out: just use separate (raw) partition for hibernation.

Ok, that needs re-partitioning; if that's bad, just swapoff before
hibernation and mkswap/swapon after its done.

Index: suspend.c
===================================================================
RCS file: /cvsroot/suspend/suspend/suspend.c,v
retrieving revision 1.82
diff -u -u -r1.82 suspend.c
--- suspend.c	29 Jul 2007 12:48:10 -0000	1.82
+++ suspend.c	5 Aug 2007 19:49:05 -0000
@@ -59,6 +59,7 @@
 static unsigned long pref_image_size = IMAGE_SIZE;
 static int suspend_loglevel = SUSPEND_LOGLEVEL;
 static char compute_checksum;
+static int raw_partition = 1;
 #ifdef CONFIG_COMPRESS
 static char compress;
 #else
@@ -184,6 +185,9 @@
 	int error;
 	loff_t free_swap;
 
+	if (raw_partition)
+		return 1*1024*1024*1024;
+
 	error = ioctl(dev, SNAPSHOT_AVAIL_SWAP, &free_swap);
 	if (!error)
 		return free_swap;
@@ -197,6 +201,12 @@
 	int error;
 	loff_t offset;
 
+	if (raw_partition) {
+		static int cur_offset = 0;
+		cur_offset += page_size;
+		return cur_offset;
+	}
+
 	error = ioctl(dev, SNAPSHOT_GET_SWAP_PAGE, &offset);
 	if (!error)
 		return offset;
@@ -205,6 +215,8 @@
 
 static inline int free_swap_pages(int dev)
 {
+	if (raw_partition)
+		return 0;
 	return ioctl(dev, SNAPSHOT_FREE_SWAP_PAGES, 0);
 }
 
@@ -213,6 +225,8 @@
 	struct resume_swap_area swap;
 	int error;
 
+	if (raw_partition)
+		return 0;
 	swap.dev = blkdev;
 	swap.offset = offset;
 	error = ioctl(dev, SNAPSHOT_SET_SWAP_AREA, &swap);



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
