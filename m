Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYLLPnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYLLPnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYLLPm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:42:57 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:44923 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757314AbYLLPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:42:56 -0500
Date: Fri, 12 Dec 2008 15:40:24 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081212154024.GA31555@linux-mips.org>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 03:00:40PM +0100, Gerd Hoffmann wrote:

> This patch adds preadv and pwritev system calls.  These syscalls are a
> pretty straightforward combination of pread and readv (same for write).
> They are quite useful for doing vectored I/O in threaded applications.
> Using lseek+readv instead opens race windows you'll have to plug with
> locking.
> 
> Other systems have such system calls too, for example NetBSD, check
> here: http://www.daemon-systems.org/man/preadv.2.html
> 
> The patch sports the actual system call implementation and the windup in
> the x86 system call tables.  Other archs are TBD.

> +asmlinkage ssize_t sys_preadv(unsigned long fd, const struct iovec __user *vec,
> +                              unsigned long vlen, loff_t pos)

> +asmlinkage ssize_t sys_pwritev(unsigned long fd, const struct iovec __user *vec,
> +                               unsigned long vlen, loff_t pos)

As so often before the devil is in the function prototype.  On some
architectures - 32-bit MIPS and PARISC, maybe others - 64-bit arguments
such as loff_t need to be passed in an _aligned_ pair of 32-bit
arguments which effectivly requires another wrapper like this around
your compat wrapper:

asmlinkage int sys32_preadv(unsigned long fd,
       const struct compat_iovec __user *vec,
       unsigned long vlen, int dummy, unsigned a5, unsigned a6)
{
	return compat_sys_preadv(fd, vec, vlen, merge_64(a5, a6));
}

merge_64() takes two 32-bit halves of a 64-bit argument and combines them
into a 64-bit argument again.

I wonder, does that merging happen magically on x86 or?

  Ralf
