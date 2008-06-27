Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYF0Q5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYF0Q5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYF0Q5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:57:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:39872 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYF0Q5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SkDwxRQ29/gsOzIbKYVqXa/wna8G4uRcU8M50g/HSQC3qO5IKdptpYXZANIXQ5aAkP
         Xk5nBohXWFflIZU3Zf061hf+7n/9A7vfpqAuISmbxEWNnXxHMeIFTK89PQM1uGrikw3c
         x/k6SLvvVmM3k52omOk5kesrQ/Sbe96xLoDPU=
Date: Fri, 27 Jun 2008 20:53:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: + proc-always-do-release.patch added to -mm tree
Message-ID: <20080627165322.GA15798@martell.zuzino.mipt.ru>
References: <200806240345.m5O3jiOD031208@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806240345.m5O3jiOD031208@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>      proc-always-do-release.patch

Ouch, please fold following incremental patch into it.



Don't add ->release'less PDEs into openers list.

This fixes possible call to NULL if ->release is not needed for some reason.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/generic.c |    3 +--
 fs/proc/inode.c   |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -797,8 +797,7 @@ continue_removing:
 		pdeo = list_first_entry(&de->pde_openers, struct pde_opener, lh);
 		list_del(&pdeo->lh);
 		spin_unlock(&de->pde_unload_lock);
-		if (pdeo->release)
-			pdeo->release(pdeo->inode, pdeo->file);
+		pdeo->release(pdeo->inode, pdeo->file);
 		kfree(pdeo);
 		spin_lock(&de->pde_unload_lock);
 	}
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -348,7 +348,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 		rv = open(inode, file);
 
 	spin_lock(&pde->pde_unload_lock);
-	if (rv == 0) {
+	if (rv == 0 && release) {
 		/* To know what to release. */
 		pdeo->inode = inode;
 		pdeo->file = file;

