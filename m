Return-Path: <linux-kernel-owner+w=401wt.eu-S966065AbXDIQBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966065AbXDIQBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966017AbXDIQBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:01:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966065AbXDIQBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:01:05 -0400
Date: Mon, 9 Apr 2007 18:00:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Dillow <dave@thedillows.org>,
       ray-gmail@madrabbit.org, amanda-hackers@amanda.org,
       amanda-users@amanda.org
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
Message-ID: <20070409160047.GA609@elte.hu>
References: <200704010100.19016.gene.heskett@verizon.net> <1175488272.3161.28.camel@obelisk.thedillows.org> <1175661256.31439.23.camel@obelisk.thedillows.org> <200704091133.44684.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704091133.44684.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> I'll try this, I just put both in the kernel command line for 
> 2.6.21-rc6, except I set it for the 238 it was at before the patch was 
> reverted.  I'd put the patch back in myself, but my searching of the 
> lkml corpus here hasn't turned it up.

Andrew has already sent a revert patch to Linus and it's in -rc6. The 
commit is below.

	Ingo

------------>
commit 2363cc0264c42636e9e7622f78dde5c2f66beb8e
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Apr 4 19:08:22 2007 -0700

    [PATCH] remove protection of LANANA-reserved majors
    
    Revert all this.  It can cause device-mapper to receive a different major from
    earlier kernels and it turns out that the Amanda backup program (via GNU tar,
    apparently) checks major numbers on files when performing incremental backups.
    
    Which is a bit broken of Amanda (or tar), but this feature isn't important
    enough to justify the churn.
    
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/block/genhd.c b/block/genhd.c
index 050a1f0..441432a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -62,8 +62,6 @@ int register_blkdev(unsigned int major, const char *name)
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			if (is_lanana_major(index))
-				continue;
 			if (major_names[index] == NULL)
 				break;
 		}
diff --git a/drivers/base/core.c b/drivers/base/core.c
index ad0f4a2..d7fcf82 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -28,20 +28,6 @@ int (*platform_notify)(struct device * dev) = NULL;
 int (*platform_notify_remove)(struct device * dev) = NULL;
 
 /*
- * Detect the LANANA-assigned LOCAL/EXPERIMENTAL majors
- */
-bool is_lanana_major(unsigned int major)
-{
-	if (major >= 60 && major <= 63)
-		return 1;
-	if (major >= 120 && major <= 127)
-		return 1;
-	if (major >= 240 && major <= 254)
-		return 1;
-	return 0;
-}
-
-/*
  * sysfs bindings for devices.
  */
 
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 78ced72..164a45c 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -109,8 +109,6 @@ __register_chrdev_region(unsigned int major, unsigned int baseminor,
 	/* temporary */
 	if (major == 0) {
 		for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
-			if (is_lanana_major(i))
-				continue;
 			if (chrdevs[i] == NULL)
 				break;
 		}
diff --git a/include/linux/kdev_t.h b/include/linux/kdev_t.h
index 4c2c373..2dacab8 100644
--- a/include/linux/kdev_t.h
+++ b/include/linux/kdev_t.h
@@ -87,8 +87,6 @@ static inline unsigned sysv_minor(u32 dev)
 	return dev & 0x3ffff;
 }
 
-bool is_lanana_major(unsigned int major);
-
 #else /* __KERNEL__ */
 
 /*
