Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYLLP3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYLLP3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758240AbYLLP3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:29:31 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54102 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbYLLP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:29:30 -0500
Date: Fri, 12 Dec 2008 08:29:29 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081212152929.GM26095@parisc-linux.org>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229090440-32120-1-git-send-email-kraxel@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 03:00:40PM +0100, Gerd Hoffmann wrote:
> The patch sports the actual system call implementation and the windup in
> the x86 system call tables.  Other archs are TBD.

> +asmlinkage ssize_t sys_preadv(unsigned long fd, const struct iovec __user *vec,
> +                              unsigned long vlen, loff_t pos)
> +asmlinkage ssize_t sys_pwritev(unsigned long fd, const struct iovec __user *vec,
> +                               unsigned long vlen, loff_t pos)

Are these prototypes required?  MIPS and PARISC will need wrappers to
fix them if they are.  These two architectures have an ABI which
requires 64-bit arguments to be passed in aligned pairs of registers,
but glibc doesn't know that (and given the existence of syscall(3),
can't do much about it even if it knew), so some of the arguments end up
in the wrong registers.

Things will go much better if we can prototype these as:

asmlinkage ssize_t sys_preadv(unsigned int fd, const struct iovec __user *vec,
				loff_t pos, unsigned long vlen);
asmlinkage ssize_t sys_pwritev(unsigned int fd, const struct iovec __user *vec,
				loff_t pos, unsigned long vlen);

That way 'pos' ends up split between arg2 and arg3 and vlen ends up in
arg4 instead of having vlen in arg2 and pos in arg3 and arg4 which then
have to be munged to be in arg4 and arg5 by a compat wrapper.

I seem to recall the s390 folks having some concerns with this kind of
thing too, but I forget what they are, so I'll let them weigh in on
this.

By the way, why did you make 'fd' an unsigned long?  The rest of the
kernel uses unsigned int.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
