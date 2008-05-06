Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYEFEmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYEFEmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbYEFEll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:41:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:23016 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbYEFElk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jMpIL+8Kb+4N5Rn4b+xphprgwqdEvVvdszx43R4aXsolbSNkDde+IbWUgaWbQSIYdMbfi+i0EkDRDbaJHlnt1Bvk8QefTgyIi7rEe9q62xRzXZYSWeecKmZcRV/3O/2ac+fYejuPz6l3lPrF3nLeykFLN/SA1PQLdaWP5bQ28SM=
Date: Tue, 6 May 2008 12:45:35 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [Resend Patch] fs/binfmt_elf.c: fix a wrong free
Message-ID: <20080506044535.GH2893@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In kmalloc failing path, we shouldn't free pointers in 'info',
because the struct 'info' is uninitilized when kmalloc is called.

And when kmalloc returns NULL, it's needless to kfree it.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

--
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f6d5a9d..357b503 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1900,7 +1900,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	/* alloc memory for large data structures: too large to be on stack */
 	elf = kmalloc(sizeof(*elf), GFP_KERNEL);
 	if (!elf)
-		goto cleanup;
+		goto out;
 	
 	segs = current->mm->map_count;
 #ifdef ELF_CORE_EXTRA_PHDRS
@@ -2034,8 +2034,9 @@ end_coredump:
 	set_fs(fs);
 
 cleanup:
-	kfree(elf);
 	free_note_info(&info);
+	kfree(elf);
+out:
 	return has_dumped;
 }
 
