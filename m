Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbXF3TXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbXF3TXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbXF3TX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:23:29 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2049 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXF3TX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:23:28 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Jun 2007 12:23:25 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
In-Reply-To: <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0>
 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007, Ulrich Drepper wrote:

> On 6/29/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > [include/linux/indirect.h]
> >         #define SYSIND_CTX_OPENFLAGS    0
> >         struct sysind_ctx_OPENFLAGS {
> >                 __u32 ctx;
> >                 __u32 flags;
> 
> I agree that this interface is more than any other in danger of
> needing an interface change.  But I think your solution is a bit too
> expensive and complex.  You need two reads from userlevel.

But, a __get_user(), once you scrap off all the gcc wrapping, is bacially 
a move. That could even be removed, but really I don't see the reason 
since it allows for a cleaner strcture definition in userland.




> The standard way to handle this is a versioned struct.  I.e., define a
> struct for the current needs, define an initial version.  To use the
> syscall pass the version number and the struct pointer to the syscall.
> If the kernel doesn't know the version number it fails.  Otherwise it
> might have to read old versions of the struct which is trivial to do.
> E.g.:
> 
> #define SYSIND_VERSION 1
> #define SYSIND_CTX_OPENFLAGS 0
> #define SYSIND_CTX_SIGMASK 1
> struct sysind_ctx {
>  int ctx;
>  union {
>    int flags;
>    kernel_sigset_t  sset;
>  };
> };

But this does not allow more than one context to be set at a time, like 
the current implementation does. Ie, the current implementation allow you 
to:

#define SYSIND_CTX_OPENFLAGS    0
struct sysind_ctx_OPENFLAGS {
	__u32 ctx;
	__u32 flags;
};

#define SYSIND_CTX_SIGSET       1
struct sysind_ctx_SIGSET {
	__u32 ctx;
	__compat_sigset set;
};

struct sysind_ctx_OPENFLAGS octx;
struct sysind_ctx_SIGSET sctx;
struct indirect_ctx *ctxs[2];
unsigned long params[6];

octx.ctx = SYSIND_CTX_OPENFLAGS;
octx.flags = O_CLOEXEC;
sctx.ctx = SYSIND_CTX_SIGSET;
sctx.set = SIG_XYZ | SIG_ABC;
ctxs[0] = (struct indirect_ctx *) &octx;
ctxs[1] = (struct indirect_ctx *) &sctx;
params[0] = blah;
params[1] = blew;
...
res = indirect(__NR_xxxx, ctxs, 2, params);


So you basically keep the context strcture separated, and allow to pass 
down more then one context to be set.
Another solution would be to have:

struct sysind_ctx_OPENFLAGS {
	__u32 flags;
};
struct sysind_ctx_SIGSET {
	__compat_sigset set;
};
struct monster_struct {
	__u32 size;
	__u64 flags;
	struct sysind_ctx_OPENFLAGS octx;
	struct sysind_ctx_SIGSET sctx;
	...
};

Where size gives you the size of the monster structure, and every bit on 
flags tells you which strcture inside monster is valid.
But I'd clearly prefer the former.



- Davide


