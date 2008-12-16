Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYLPQFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYLPQFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbYLPQFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:05:33 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:34967 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754086AbYLPQFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:05:31 -0500
Date: Tue, 16 Dec 2008 16:05:02 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Message-ID: <20081216160502.GA15331@linux-mips.org>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <20081215160311.GA23153@linux-mips.org> <4946C4B4.1020605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4946C4B4.1020605@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 09:57:24PM +0100, Gerd Hoffmann wrote:

> > It fixes the alignment issue but still won't work; on MIPS 32-bit userspace
> > will pass the 64-bit argument in two registers but the 64-bit kernel code
> > will assume it to be passed in a single registers.  It'd be ugly but passing
> > a pointer to a 64-bit argument would solve the issue; something like this:
> >
> > sys_preadv(unsigned long fd, const struct iovec __user *vec,
> >                   unsigned long vlen, loff_t __user *pos);
> > compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
> >                   unsigned long vlen, loff_t __user *pos);
> 
> Suggestion from the s390 front was to explicitly pass high and low part
> of pos as two arguments.  A bit ugly too, but should work fine as well
> and it avoids the user pointer dereference.  What do you think about this?

That's what the wrapper which you deleted, was doing ;-)  So yes, I like
it.  It just raises one new problem, endianess - are arguments being passed
as low/high or high/low?  On MIPS we've been solving the issue with the
merge_64() macro which is defined depending on the byte order:

#ifdef __MIPSEB__
#define merge_64(r1, r2) ((((r1) & 0xffffffffUL) << 32) + ((r2) & 0xffffffffUL))
#endif
#ifdef __MIPSEL__
#define merge_64(r1, r2) ((((r2) & 0xffffffffUL) << 32) + ((r1) & 0xffffffffUL))
#endif

The actual syscall wrapper could use it like:

asmlinkage int compat_sys_pwritev(unsigned long fd,
       const struct compat_iovec __user *vec,
       unsigned a3, unsigned a4, unsigned long vlen)
{
	loff_t offset = merge_64(a3, a4);
...

If merge_64() was a standard macro in <asm/compat.h> on all architectures,
compat_sys_pwrite() could invoke it directly and the need for the compat
wrapper around the compat wrapper would go away.

> > I'm surprised this works for x86; does x86-64 code really expect 64-bit
> > arguments as 2 32-bit arguments?
> 
> Args are passed on the stack, not in registers.

Same as 32-bit MIPS for argument #4 and up which will be passed on the
stack - but the requirement for passing a long long is for it to be
passed as an aligned pair of arguments and the original patch got
that wrong.

  Ralf
