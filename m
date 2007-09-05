Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbXIEBOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbXIEBOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 21:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXIEBOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 21:14:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60000 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXIEBOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 21:14:14 -0400
Date: Wed, 5 Sep 2007 06:57:24 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Evgeniy Dushistov <dushistov@mail.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] ufs: Fix mount check in ufs_fill_super()
In-Reply-To: <20070819180445.GA1814@rain>
Message-ID: <alpine.LFD.0.999.0709050652260.20571@enigma.security.iitk.ac.in>
References: <20070819180445.GA1814@rain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,


On Sun, 19 Aug 2007, Evgeniy Dushistov wrote:
> 
> Different types of ufs hold state in different places,
> to hide complexity of this, there is ufs_get_fs_state,
> it returns state according to "UFS_SB(sb)->s_flags",
> but during mount ufs_get_fs_state is called,
> before setting s_flags, this cause message for
> ufs types like sun ufs: "fs need fsck",
> and remount in readonly state.

I noticed another strange thing with that same compound condition in
ufs_fill_super(). In the present code, if (flags & UFS_ST_MASK) ==
UFS_ST_44BSD, then the whole ufs_get_fs_state() == UFS_FSOK check gets
completely skipped (!)

Is this intentional? If so, I'd recommend plonking a comment in there.
But doesn't look that way to me, because ufs_get_fs_state() does handle
the UFS_ST_44BSD case also ... Does the patch below look correct to you?

Satyam


[PATCH -mm] ufs: Fix mount check in ufs_fill_super()

The current code skips the check to verify whether the filesystem was
previously cleanly unmounted, if (flags & UFS_ST_MASK) == UFS_ST_44BSD
or UFS_ST_OLD. This looks like an inadvertent bug that slipped in due
to parantheses in the compound conditional to me, especially given that
ufs_get_fs_state() handles the UFS_ST_44BSD case perfectly well. So,
let's fix the compound condition appropriately.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 fs/ufs/super.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- linux-2.6.23-rc4-mm1/fs/ufs/super.c~fix	2007-09-05 06:35:12.000000000 +0530
+++ linux-2.6.23-rc4-mm1/fs/ufs/super.c	2007-09-05 06:40:05.000000000 +0530
@@ -934,19 +934,20 @@ magic_found:
 		flags |=  UFS_ST_SUN;
 	}
 
-	sbi->s_flags = flags;/*after that line some functions use s_flags*/
+	/* Set sbi->s_flags here, used by ufs_get_fs_state() below */
+	sbi->s_flags = flags;
 	ufs_print_super_stuff(sb, usb1, usb2, usb3);
 
 	/*
 	 * Check, if file system was correctly unmounted.
 	 * If not, make it read only.
 	 */
-	if (((flags & UFS_ST_MASK) == UFS_ST_44BSD) ||
-	  ((flags & UFS_ST_MASK) == UFS_ST_OLD) ||
-	  (((flags & UFS_ST_MASK) == UFS_ST_SUN || 
-	    (flags & UFS_ST_MASK) == UFS_ST_SUNOS ||
-	  (flags & UFS_ST_MASK) == UFS_ST_SUNx86) && 
-	  (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time))))) {
+	if ((((flags & UFS_ST_MASK) == UFS_ST_44BSD)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_OLD)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUN)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUNOS)	||
+	     ((flags & UFS_ST_MASK) == UFS_ST_SUNx86))	&&
+	    (ufs_get_fs_state(sb, usb1, usb3) == (UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time)))) {
 		switch(usb1->fs_clean) {
 		case UFS_FSCLEAN:
 			UFSD("fs is clean\n");
