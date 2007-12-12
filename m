Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbXLLCkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbXLLCkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXLLCkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:40:35 -0500
Received: from pat.uio.no ([129.240.10.15]:42310 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbXLLCke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:40:34 -0500
Subject: Re: [PATCH 1/1] fix 2.6.24-rc1 nfs_file_mmap change for NOMMU
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Berkhan, Enrik (GE Infra, Oil & Gas)" <enrik.berkhan@ge.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <050A770C1DB41144817F02E395E493104CE014@FLRMLVEM02.e2k.ad.ge.com>
References: <050A770C1DB41144817F02E395E493104CE014@FLRMLVEM02.e2k.ad.ge.com>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 21:40:30 -0500
Message-Id: <1197427230.27750.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=5.0, autolearn=disabled, AWL=-0.250)
X-UiO-Scanned: 4ECA167DE81C82C281EA811CC47711568FB0DBEA
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 91 total 5695591 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-09 at 19:52 +0100, Berkhan, Enrik (GE Infra, Oil & Gas)
wrote:
> - generic_file_mmap returns -ENOSYS for NOMMU systems; replicate this
>   behaviour
> 
> Signed-off-by: Enrik Berkhan <Enrik.Berkhan@ge.com>
> ---
>  fs/nfs/file.c |    4 ++++
>  1 files changed, 4 insertions(+)
> 
> Index: fs/nfs/file.c
> ===================================================================
> --- fs/nfs/file.c.orig	2007-12-05 09:48:59.000000000 +0100
> +++ fs/nfs/file.c	2007-12-05 09:49:56.000000000 +0100
> @@ -283,7 +283,11 @@ nfs_file_mmap(struct file * file, struct
>  	if (!status) {
>  		vma->vm_ops = &nfs_file_vm_ops;
>  		vma->vm_flags |= VM_CAN_NONLINEAR;
> +#ifdef CONFIG_MMU
>  		file_accessed(file);
> +#else
> +		return -ENOSYS;
> +#endif
>  	}
>  	return status;
>  }

Why do that after going through the process of revalidating the inode
etc.? Just replace nfs_file_mmap() with a function returning ENOSYS in
the case of CONFIG_MMU.

Better still, in the case of CONFIG_MMU, instead of having an
nfs_file_mmap(), just replace the .mmap field in nfs_file_operations
with a call to generic_file_mmap().

Trond

