Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZIZODd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZIZODd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZIZODd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:03:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:40961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZIZODc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:03:32 -0400
Date: Sat, 26 Sep 2009 16:03:43 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, tglx@tglx.de, hpa@zytor.com
Subject: Re: [PATCH] x86: Use __builtin_object_size to validate the buffer
 size for copy_from_user
Message-ID: <20090926160343.218bb52c@infradead.org>
In-Reply-To: <20090926124151.GA648@elte.hu>
References: <20090926143301.2c396b94@infradead.org>
	<20090926124151.GA648@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009 14:41:51 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > From 524a1da3c45683cec77480acc6cab1d33ae8d5cb Mon Sep 17 00:00:00
> > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Sat, 26 Sep 2009 12:36:21 +0200
> > Subject: [PATCH] x86: Use __builtin_object_size to validate the
> > buffer size for copy_from_user
> > 
> > gcc (4.x) supports the __builtin_object_size() builtin, which
> > reports the size of an object that a pointer point to, when known
> > at compile time. If the buffer size is not known at compile time, a
> > constant -1 is returned.
> > 
> > This patch uses this feature to add a sanity check to
> > copy_from_user(); if the target buffer is known to be smaller than
> > the copy size, the copy is aborted and a WARNing is emitted in
> > memory debug mode.
> > 
> > These extra checks compile away when the object size is not known,
> > or if both the buffer size and the copy length are constants.
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > Reviewed-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/include/asm/uaccess_32.h |   19 ++++++++++++++++++-
> >  arch/x86/include/asm/uaccess_64.h |   19 ++++++++++++++++++-
> >  arch/x86/kernel/x8664_ksyms_64.c  |    2 +-
> >  arch/x86/lib/copy_user_64.S       |    4 ++--
> >  arch/x86/lib/usercopy_32.c        |    4 ++--
> >  include/linux/compiler-gcc4.h     |    2 ++
> >  include/linux/compiler.h          |    4 ++++
> >  7 files changed, 47 insertions(+), 7 deletions(-)
> 
> I have tested this on a buffer overflow and it caught it:
> 
> [   87.056952] ------------[ cut here ]------------
> [   87.061628] WARNING:
> at /home/mingo/linux/arch/x86/include/asm/uaccess_64.h:35
> sys_perf_counter_open+0x112/0x65b() [   87.072600] Hardware name:
> System Product Name [   87.077072] Buffer overflow detected!
> [   87.080762] Modules linked in: [   87.083858] Pid: 2670, comm:
> exploit Not tainted 2.6.31 #17235 [   87.089708] Call Trace:
> [   87.092180]  [<ffffffff810a3241>] ?
> sys_perf_counter_open+0x112/0x65b [   87.098654]
> [<ffffffff8104303c>] warn_slowpath_common+0x77/0xa4 [   87.104684]
> [<ffffffff810430b6>] warn_slowpath_fmt+0x3c/0x3e [   87.110458]
> [<ffffffff810e41c3>] ? putname+0x30/0x39 [   87.115570]
> [<ffffffff810a3241>] sys_perf_counter_open+0x112/0x65b
> [   87.121880]  [<ffffffff8105b6df>] ? up_read+0x9/0xb
> [   87.126802]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
> [   87.132851] ---[ end trace 7469dba2cd3cfea8 ]---
> 
> 
> > +static inline unsigned long __must_check copy_from_user(void *to,
> > +					  const void __user *from,
> > +					  unsigned long n)
> > +{
> > +	int sz = __compiletime_object_size(to);
> > +	int ret = -EFAULT;
> > +
> > +	if (likely(sz == -1 || sz >= n))
> > +		ret = _copy_from_user(to, from, n);
> > +#ifdef CONFIG_DEBUG_VM
> > +	else
> > +		WARN(1, "Buffer overflow detected!\n");
> > +#endif
> > +	return ret;
> > +}
> 
> This is pretty optimal in the !CONFIG_DEBUG_VM case. Would be nice to 
> see precisely how optimal - how many new instructions in the default 
> !CONFIG_DEBUG_VM case?
> 

a test ->write method:

static ssize_t test_write(struct file *fp, const char __user *buf,
                         size_t len, loff_t *off)
{
        char buffer[10];
        int ret;

        ret = copy_from_user(&buffer, buf, len);

        return ret;
}

with the patch turns into

   0:   55                      push   %ebp

*  1:   b8 f2 ff ff ff          mov    $0xfffffff2,%eax
   6:   89 e5                   mov    %esp,%ebp
   8:   83 ec 0c                sub    $0xc,%esp
*  b:   83 f9 0a                cmp    $0xa,%ecx
*  e:   77 08                   ja     18 <test_write+0x18>
  10:   8d 45 f6                lea    -0xa(%ebp),%eax
  13:   e8 fc ff ff ff          call   14 <_copy_from_user>
  18:   c9                      leave  
  19:   c3                      ret  

while without it gets

   0:   55                      push   %ebp
   1:   89 e5                   mov    %esp,%ebp
   3:   83 ec 0c                sub    $0xc,%esp
   6:   8d 45 f6                lea    -0xa(%ebp),%eax
   9:   e8 fc ff ff ff          call   <copy_from_user>
   e:   c9                      leave  
   f:   c3                      ret  

This is for the case where you have a known stack variable, but
variable copy size.
If you have either an unknown target size and/or a fixed sized copy,
the code goes away entirely.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
