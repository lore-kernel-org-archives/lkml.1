Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYLLPtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYLLPtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757323AbYLLPsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:48:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56025 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165AbYLLPsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:48:53 -0500
Message-ID: <494287D4.2070909@redhat.com>
Date: Fri, 12 Dec 2008 16:48:36 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org>
In-Reply-To: <20081212152929.GM26095@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
>> +asmlinkage ssize_t sys_preadv(unsigned long fd, const struct iovec __user *vec,
>> +                              unsigned long vlen, loff_t pos)
>> +asmlinkage ssize_t sys_pwritev(unsigned long fd, const struct iovec __user *vec,
>> +                               unsigned long vlen, loff_t pos)
> 
> Are these prototypes required?  MIPS and PARISC will need wrappers to
> fix them if they are.  These two architectures have an ABI which
> requires 64-bit arguments to be passed in aligned pairs of registers,
> but glibc doesn't know that (and given the existence of syscall(3),
> can't do much about it even if it knew), so some of the arguments end up
> in the wrong registers.
>
> Things will go much better if we can prototype these as:
>
> asmlinkage ssize_t sys_preadv(unsigned int fd,
>                               const struct iovec __user *vec,
> 				loff_t pos, unsigned long vlen);
> asmlinkage ssize_t sys_pwritev(unsigned int fd,
>                                const struct iovec __user *vec,
> 				 loff_t pos, unsigned long vlen);

Hmm.  It is the argument ordering used by NetBSD, thats why I used that
too.  It certainly should be the application-visible ordering.  We'll
have glibc between apps and kernel though, so I think we can reorder the
arguments at syscall level if that helps on these archs.  Cc'ing Ulrich
Drepper for comments on that.

> By the way, why did you make 'fd' an unsigned long?  The rest of the
> kernel uses unsigned int.

sys_{readv,writev} have unsigned long too, this is where I got it from.
 Don't know what the reason for this is, it looks a bit odd indeed.

cheers,
  Gerd

