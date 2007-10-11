Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbXJKVsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbXJKVsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXJKVsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:48:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036AbXJKVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:48:02 -0400
Date: Thu, 11 Oct 2007 14:47:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ryan@finnie.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Message-Id: <20071011144740.136b31a8.akpm@linux-foundation.org>
In-Reply-To: <200710071920.l97JKJX5018871@agora.fsl.cs.sunysb.edu>
References: <200710071920.l97JKJX5018871@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2007 15:20:19 -0400
Erez Zadok <ezk@cs.sunysb.edu> wrote:

> According to vfs.txt, ->writepage() may return AOP_WRITEPAGE_ACTIVATE back
> to the VFS/VM.  Indeed some filesystems such as tmpfs can return
> AOP_WRITEPAGE_ACTIVATE; and stackable file systems (e.g., Unionfs) also
> return AOP_WRITEPAGE_ACTIVATE if the lower f/s returned it.
> 
> Anyway, some Ubuntu users of Unionfs reported that msync(2) sometimes
> returns AOP_WRITEPAGE_ACTIVATE (decimal 524288) back to userland.
> Therefore, some user programs fail, esp. if they're written such as this:
> 
>      err = msync(...);
>      if (err != 0)
> 	// fail
> 
> They temporarily fixed the specific program in question (apt-get) to check
> 
>      if (err < 0)
> 	// fail
> 
> Is this a bug indeed, or are user programs supposed to handle
> AOP_WRITEPAGE_ACTIVATE (I hope not the latter).  If it's a kernel bug, what
> should the kernel return: a zero, or an -errno (and which one)?
> 

shit.  That's a nasty bug.  Really userspace should be testing for -1, but
the msync() library function should only ever return 0 or -1.

Does this fix it?

--- a/mm/page-writeback.c~a
+++ a/mm/page-writeback.c
@@ -850,8 +850,10 @@ retry:
 
 			ret = (*writepage)(page, wbc, data);
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
+			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
 				unlock_page(page);
+				ret = 0;
+			}
 			if (ret || (--(wbc->nr_to_write) <= 0))
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
_

