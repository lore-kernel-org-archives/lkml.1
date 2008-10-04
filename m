Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYJDRWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYJDRWC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 13:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYJDRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 13:21:51 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:20951 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYJDRVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 13:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BEFZYLfoezbxFo6AgDO9OV9W2r2MMSsLnSNioeRDnQ13yPpFXEhBo+AYiG7NAvvvf2
         LaowLS+LpWjVCdi+By44EQdGa9wkcHYql7onIIEY1mk/UdmwLFLWgAHBZnUvoddXRx9j
         ibjR0rYsmlehFz3BDpeQKItR+g5ly6ewuvAFw=
From: crquan@gmail.com
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [MD] need another print_sb for mdp_superblock_1
Date: Sun,  5 Oct 2008 01:21:14 +0800
Message-Id: <1223140874-7067-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.2
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current print_sb function is only for superblock 0.90.xx, not for
superblock 1.00.00 above, otherwise it would drop silly messages like

  md:	**********************************
  md:	* <COMPLETE RAID STATE PRINTOUT> *
  md:	**********************************
  md2: <ram2><ram3><ram1><ram0>
  md: rdev ram2, SZ:00065472 F:0 S:1 DN:4
  md: rdev superblock:
  md:  SB: (V:1.0.0) ID:<35550a8f.00000000.00000000.00000000> CT:4f45a9ef
  md:     L978400564 S1684889970 ND:762016617 RD:1684627826 md13613 LO:65536 CS:-2
  md:     UT:00000010 ST:0 AD:131056 WD:0 FD:0 SD:0 CSUM:00000000 E:00000000
       D  0:  DISK<N:-1,(-1,-1),R:-1,S:-1>
       D  1:  DISK<N:-1,(-1,-1),R:-1,S:-1>
       D  2:  DISK<N:-1,(-1,-1),R:-1,S:-1>
       D  3:  DISK<N:-1,(-1,-1),R:-1,S:-1>
  md:     THIS:  DISK<N:0,(0,0),R:0,S:0>

So we need another print_mdp_superblock_1 function, either directly used in
print_rdev or or we can add an function pointer to struct super_type.

Denis ChengRq

---

This little patch is just an implementation example, we can revamp print_rdev,
but I'm more intended for another pointer in struct super_type.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index deeac4b..d7f1b22 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1634,7 +1634,7 @@ static void print_sb(mdp_super_t *sb)
 
 }
 
-static void print_rdev(mdk_rdev_t *rdev)
+static void print_rdev(mdk_rdev_t *rdev, int major_version)
 {
 	char b[BDEVNAME_SIZE];
 	printk(KERN_INFO "md: rdev %s, SZ:%08llu F:%d S:%d DN:%u\n",
@@ -1643,7 +1643,9 @@ static void print_rdev(mdk_rdev_t *rdev)
 	        rdev->desc_nr);
 	if (rdev->sb_loaded) {
 		printk(KERN_INFO "md: rdev superblock:\n");
-		print_sb((mdp_super_t*)page_address(rdev->sb_page));
+		if (major_version == 0)
+			print_sb((mdp_super_t*)page_address(rdev->sb_page));
+		/* if major_version 1: print mdp_superblock_1 */
 	} else
 		printk(KERN_INFO "md: no rdev superblock!\n");
 }
@@ -1670,7 +1672,7 @@ static void md_print_devices(void)
 		printk("\n");
 
 		rdev_for_each(rdev, tmp2, mddev)
-			print_rdev(rdev);
+			print_rdev(rdev, mddev->major_version);
 	}
 	printk("md:	**********************************\n");
 	printk("\n");
