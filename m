Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbYBKRf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbYBKRf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYBKRfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:35:15 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:44287 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYBKRfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:35:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=L8UlTpWSYonrkJuOBynEiCtGxUZxr9Gow6kBaQqli/2BF60Dd+B7C6dRYAEtUTEcxeXhDvX650sHuIkYZqvcd99b1/9nCelyE8iEDF1UbrIDEjtQOl+bACjrhjzrsSWnTQD9V1DQf3WbvoJRmmZc3qXn2lAkjw3FCcSZIaKUT6c=
From: Mike Frysinger <vapier.adi@gmail.com>
Organization: ADI
To: gerg@uclinux.org
Subject: [patch] FLAT binaries: drop BINFMT_FLAT bad header magic warning
Date: Mon, 11 Feb 2008 12:35:03 -0500
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, bernds_cb1@t-online.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111235.03761.vapier.adi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warning issued by fs/binfmt_flat.c when the format handler is given a
non-FLAT and non-script executable is annoying to say the least when working
with FDPIC ELF objects.  If you build a kernel that supports both FLAT and
FDPIC ELFs on no-mmu, every time you execute an FDPIC ELF, the kernel spits
out this message.  While I understand a lot of newcomers to the no-mmu world
screw up generation of FLAT binaries, this warning is not usable for systems
that support more than just FLAT.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Bernd Schmidt <bernds_cb1@t-online.de>
CC: Greg Ungerer <gerg@snapgear.com>
---
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index d8a02f1..0498b18 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -443,12 +443,12 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 	if (strncmp(hdr->magic, "bFLT", 4)) {
 		/*
+		 * Previously, here was a printk to tell people
+		 *   "BINFMT_FLAT: bad header magic".
+		 * But for the kernel which also use ELF FD-PIC format, this
+		 * error message is confusing.
 		 * because a lot of people do not manage to produce good
-		 * flat binaries,  we leave this printk to help them realise
-		 * the problem.  We only print the error if its not a script file
 		 */
-		if (strncmp(hdr->magic, "#!", 2))
-			printk("BINFMT_FLAT: bad header magic\n");
 		ret = -ENOEXEC;
 		goto err;
 	}
