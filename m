Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbXFWRys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbXFWRys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXFWRym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:54:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:7788 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXFWRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:54:41 -0400
Date: Sat, 23 Jun 2007 19:54:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexander Wuerstlein <arw@arw.name>
cc: linux-kernel@vger.kernel.org,
       Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
In-Reply-To: <1182536729847-git-send-email-arw@arw.name>
Message-ID: <Pine.LNX.4.64.0706231954190.11964@fbirervta.pbzchgretzou.qr>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
 <1182536729847-git-send-email-arw@arw.name>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 22 2007 20:25, Alexander Wuerstlein wrote:
>+#ifdef CONFIG_SNS_SIGNED
>+#include <linux/sns.h>
>+#endif
> 
> #include <asm/uaccess.h>
> #include <asm/mmu_context.h>
>@@ -928,13 +931,21 @@ int prepare_binprm(struct linux_binprm *bprm)
> 	mode = inode->i_mode;
> 	if (bprm->file->f_op == NULL)
> 		return -EACCES;
>+#ifdef CONFIG_SNS_SIGNED
>+	if (mode & S_ISUID)
>+		current->sns_valid_sig = sns_signature_valid(bprm->file);
>+#endif
> 
> 	bprm->e_uid = current->euid;
> 	bprm->e_gid = current->egid;
> 
> 	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
> 		/* Set-uid? */
>-		if (mode & S_ISUID) {
>+#ifdef CONFIG_SNS_SIGNED_SETUID
>+               if (mode & S_ISUID && current->sns_valid_sig) {
>+#else
>+               if (mode & S_ISUID) {
>+#endif /*SNS_SIGNED_SETUID*/
> 			current->personality &= ~PER_CLEAR_ON_SETID;
> 			bprm->e_uid = inode->i_uid;
> 		}
>@@ -945,7 +956,11 @@ int prepare_binprm(struct linux_binprm *bprm)
> 		 * is a candidate for mandatory locking, not a setgid
> 		 * executable.
> 		 */
>-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
>+#ifdef CONFIG_SNS_SIGNED_SETGID
>+               if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) && current->sns_valid_sig) {
>+#else
>+               if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
>+#endif /*SNS_SIGNED_SETGID*/
> 			current->personality &= ~PER_CLEAR_ON_SETID;
> 			bprm->e_gid = inode->i_gid;
> 		}

...
That's a lot of unwanted ifdefs!



	Jan
-- 
