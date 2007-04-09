Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbXDIRFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbXDIRFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXDIRFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:05:17 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:57413 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXDIRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:05:14 -0400
Date: Mon, 09 Apr 2007 13:05:08 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
In-reply-to: <20070409160047.GA609@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Dave Dillow <dave@thedillows.org>,
       ray-gmail@madrabbit.org, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Message-id: <200704091305.08779.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
 <200704091133.44684.gene.heskett@gmail.com> <20070409160047.GA609@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> I'll try this, I just put both in the kernel command line for
>> 2.6.21-rc6, except I set it for the 238 it was at before the patch was
>> reverted.  I'd put the patch back in myself, but my searching of the
>> lkml corpus here hasn't turned it up.
>
>Andrew has already sent a revert patch to Linus and it's in -rc6. The
>commit is below.
>
Is this not the patch that reverts it?  I want the patch that put it in, 
because that will be a one time churn and be done with it, hopefully for 
good.  As it is, its going crazy everytime I rebuild the kernel because 
there are other "EXPERIMENTAL" things too, like md and pktcdvd that are 
constantly sirring the pot and changing the device-mappers major, almost 
on a per boot basis, and this is a hell of a lot less tolerable than a 1 
time churn would have been.  Please note that the finger doing the 
pointing here has two ends, one of which is pointed at the one who 
started this fuss, aka me.  OTOH, that patch that apparently went in 
sometime around 2.6.20.4-rc1 and 2.6.21-rc1, while it was a right patch, 
needed a little more advertising as to what effect it might have.  You'll 
recall I had several of you spinning wheels looking for the culprit, 
something that _should_ have been deducible by looking at the changelog.

As far as the churn is concerned someone has I believe started on a script 
that will fix the churn by editing all the device numbers contained in 
the reference files amanda feeds tar for its 'is it new' detection, to 
whatever the current number is, hopefully something I can incorporate 
into my GenesAmandaHelper package as a separate script to be run 10 
minutes ahead of amdump, or even as a sequential execution.

FWIW, contact with the tar folks has not been productive in this, their 
attitude is that if the device number changed, its a new disk, and if its 
not stable, then its a linux problem and linux should fix it.  And 
grudgingly, I have to admit they are righter than we are in this 
particular dogfight.  I have the -rc5 patch here, and if I thought I 
would recognize it properly, I'd slice it out and use it on rc6 + plus, 
until applying it breaks, indicating its been re-applied by you.  I 
would, in the meantime, have a stable system again.


>	Ingo
>
>------------>
>commit 2363cc0264c42636e9e7622f78dde5c2f66beb8e
>Author: Andrew Morton <akpm@linux-foundation.org>
>Date:   Wed Apr 4 19:08:22 2007 -0700
>
>    [PATCH] remove protection of LANANA-reserved majors
>
>    Revert all this.  It can cause device-mapper to receive a different
> major from earlier kernels and it turns out that the Amanda backup
> program (via GNU tar, apparently) checks major numbers on files when
> performing incremental backups.
>
>    Which is a bit broken of Amanda (or tar), but this feature isn't
> important enough to justify the churn.
>
>    Cc: Ingo Molnar <mingo@elte.hu>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
>diff --git a/block/genhd.c b/block/genhd.c
>index 050a1f0..441432a 100644
>--- a/block/genhd.c
>+++ b/block/genhd.c
>@@ -62,8 +62,6 @@ int register_blkdev(unsigned int major, const char
> *name) /* temporary */
> 	if (major == 0) {
> 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
>-			if (is_lanana_major(index))
>-				continue;
> 			if (major_names[index] == NULL)
> 				break;
> 		}
>diff --git a/drivers/base/core.c b/drivers/base/core.c
>index ad0f4a2..d7fcf82 100644
>--- a/drivers/base/core.c
>+++ b/drivers/base/core.c
>@@ -28,20 +28,6 @@ int (*platform_notify)(struct device * dev) = NULL;
> int (*platform_notify_remove)(struct device * dev) = NULL;
>
> /*
>- * Detect the LANANA-assigned LOCAL/EXPERIMENTAL majors
>- */
>-bool is_lanana_major(unsigned int major)
>-{
>-	if (major >= 60 && major <= 63)
>-		return 1;
>-	if (major >= 120 && major <= 127)
>-		return 1;
>-	if (major >= 240 && major <= 254)
>-		return 1;
>-	return 0;
>-}
>-
>-/*
>  * sysfs bindings for devices.
>  */
>
>diff --git a/fs/char_dev.c b/fs/char_dev.c
>index 78ced72..164a45c 100644
>--- a/fs/char_dev.c
>+++ b/fs/char_dev.c
>@@ -109,8 +109,6 @@ __register_chrdev_region(unsigned int major,
> unsigned int baseminor, /* temporary */
> 	if (major == 0) {
> 		for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
>-			if (is_lanana_major(i))
>-				continue;
> 			if (chrdevs[i] == NULL)
> 				break;
> 		}
>diff --git a/include/linux/kdev_t.h b/include/linux/kdev_t.h
>index 4c2c373..2dacab8 100644
>--- a/include/linux/kdev_t.h
>+++ b/include/linux/kdev_t.h
>@@ -87,8 +87,6 @@ static inline unsigned sysv_minor(u32 dev)
> 	return dev & 0x3ffff;
> }
>
>-bool is_lanana_major(unsigned int major);
>-
> #else /* __KERNEL__ */
>
> /*



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Q:	Why do the police always travel in threes?
A:	One to do the reading, one to do the writing, and the other keeps
	an eye on the two intellectuals.
