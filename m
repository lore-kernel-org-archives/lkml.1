Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYK0OCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYK0OCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYK0OCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:02:46 -0500
Received: from www.tglx.de ([62.245.132.106]:58187 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYK0OCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:02:46 -0500
Date: Thu, 27 Nov 2008 15:01:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@googlemail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, eranian@gmail.com,
       sfr@canb.auug.org.au
Subject: Re: [patch 20/24] perfmon: system calls interface
In-Reply-To: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
Message-ID: <alpine.LFD.2.00.0811271454120.3325@localhost.localdomain>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, eranian@googlemail.com wrote:

> +asmlinkage long sys_pfm_write(int fd, int uflags,
> +			      int type,
> +			      void __user *ureq,
> +			      size_t sz)

> +asmlinkage long sys_pfm_read(int fd, int uflags,
> +			     int type,
> +			     void __user *ureq,
> +			     size_t sz)

After looking at both I did a diff of the two functions:

--- r.c	2008-11-27 14:27:54.000000000 +0100
+++ w.c	2008-11-27 14:27:52.000000000 +0100
@@ -36,10 +36,12 @@
 	ret = pfm_check_task_state(ctx, PFM_CMD_STOPPED, &flags);
 	if (ret)
 		goto skip;
-
 	switch(type) {
+	case PFM_RW_PMC:
+		ret = __pfm_write_pmcs(ctx, req, count);
+		break;
 	case PFM_RW_PMD:
-		ret = __pfm_read_pmds(ctx, req, count);
+		ret = __pfm_write_pmds(ctx, req, count);
 		break;
 	default:
 		PFM_DBG("invalid type=%d", type);
@@ -48,12 +50,13 @@
 skip:
 	spin_unlock_irqrestore(&ctx->lock, flags);
 
-	if (copy_to_user(ureq, req, sz))
-		ret = -EFAULT;
-
+	/*
+	 * This function may be on the critical path.
+	 * We want to avoid the branch if unecessary.
+	 */
 	if (fptr)
 		kfree(fptr);
 error:
 	pfm_release_ctx_from_fd(&cookie);
 	return ret;
 }

Both read and write are multiplexing syscalls already and 90% of the
code is the same.

	case PFM_RD_PMC:
 	case PFM_RD_PMD:
	case PFM_WR_PMC:
 	case PFM_WR_PMD:

would make them the same and safe a syscall and duplicated code.

Thanks,

	tglx

