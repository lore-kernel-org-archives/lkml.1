Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYE0OyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYE0OyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756448AbYE0Ox4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:53:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:46362 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756445AbYE0Oxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:53:54 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/lSxRoXyLlv+MTxu40tTYQduJh7c58VjG1crqjSe
	H41oTgA6zv+5nq
Date: Tue, 27 May 2008 16:53:51 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Message-ID: <20080527145351.GA3147@alice>
References: <20080526143422.GA3203@alice> <20080527140031.GA3380@alice> <19f34abd0805270723u71b46527g41c42ea236c49095@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0805270723u71b46527g41c42ea236c49095@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26-rc3 (x86_64)
X-Uptime: 16:42:38 up  4:00,  1 user,  load average: 0.04, 0.17, 0.36
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

* Vegard Nossum (vegard.nossum@gmail.com) wrote:
> On Tue, May 27, 2008 at 4:00 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> > hi,
> >
> > i tested a kmemcheck kernel as an attempt to debug
> > this further... seems CONFIG_SECURITY is unrelated to
> > this, but slub debugging only catches the
> > overwrite it if i enable CONFIG_SECURITY.
> 
> This is sort of expected. kmemcheck is not directly incompatible with
> slub debugging, but it may produce some false positives (that we
> haven't worked out yet). So I recommend that you turn slub debugging
> off, like you did below.

ah, wouldnt a config option or warning message make sense while
this gets sorted out?

> > if i set slub_debug=- i get the kmemcheck warning at
> >
> > (gdb) l *(__slab_alloc+0x238)
> > 0xc0187bc8 is in __slab_alloc (mm/slub.c:303).
> > 298             return *(void **)(object + s->offset);
> > 299     }
> > 300
> > 301     static inline void set_freepointer(struct kmem_cache *s, void
> > *object, void *fp)
> > 302     {
> > 303             *(void **)(object + s->offset) = fp;
> > 304     }
> > 305
> > 306     /* Loop over all objects in a slab */
> > 307     #define for_each_object(__p, __s, __addr, __objects) \
> 
> Hm, yes. It would be nice to see the actual kmemcheck error message as
> well in order to determine the cause of this.

Ok, here we go, i tried to write it down as good as possible

BUG: unable to handle kernel paging request at cb801000
IP: [(c0187bc8)] __slab_alloc+0x238/0x5e0
*pde = 01019067 *pte = 0x801962
Thread overran stack, or stack corrupted
Oops: 0002 [#1] PREEMPT
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.25-x86-latest,git....)
EIP: 0060:[(c0187bc8)] EFLAGS: 00010286 CPU:0
EIP is at __slab_alloc+0x238/0x5e0
EAX: c08a3d40 EBC: cf801000 ECX: 00000000 EDX: c125b024
ESI: cf801000 EDI: cf801000 EBP: c08a9f54 ESP: c08a9f24
 DS: 007b ES: 007b FS: 0000 CS: 0000 SS: 0068
Process swapper (pid: 0, ti=c08a9000 task=c08583c0, task.ti=c08a9000)
Stack: c125b024 c0441b07 00000008 00000000 ffffffff 000000d0 c08a3d40 00000010
	c125b024 00000000 c08a3d40 00000286 c08a9f78 c0189187 c0443d85 c08a3ddc
	c04433d85 000000d0 00000000 c08a9fb4 0000000a c08a9f98 c0443d85 c08a9fb8
Call Trace:
? vsnprintf+0x2d7
? __ kmalloc+0xf7
? kvasprintf+0x35
? kvasprintf+0x35
? kvasprintf+0x35
? kasprintf+0x17
? kmem_cache_init+0xcd
? start_kernel+0x1c9
? unknown_bootoption+0x0
? i386_start_kernel+0x8
=====
Copde: 0a 8b 59 04 0f af c3 8d 04 07 39 f8 76 36 89 fb eb 04 89 f3 89 ce 8b 55 f0 89 d9 8b 45 e8 e8 d0 ea ff ff 8b 45 e8 8b 48 0c 01 cb(89) 33 8b 5d f0 8b 50 04 0f b7 43 0a 8d 0c 32 0f af c2 8d 04 07
EIP: [(c0187bc8)] __slab_alloc+0x238/0x5e0 SS:ESP 0068:c08a9f24
--- end trace ---
Kernel panic - not syncing: attempted to kill the idle task!
< and a second stack trace >

> I don't really see how that write (= fp) can cause an error, so it has
> to be the s->offset dereference that is doing it. That seems extremely
> unlikely and would indicate a bug in SLUB itself...
> 
> Out of curiosity, will your crash go away entirely if you compile the
> kernel using SLAB?

I am currently compiling the kernel, will report once this is finished

> It would be nice to see the whole dmesg if you can get it.

At the moment i dont have a camera at hand and netconsole doesnt
catch it since it is too early
 
> You should also make sure you have either
> 
> CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT=y

is set to 'y'

> There is actually a newer kmemcheck tree which supports
> kmemcheck+SLAB, but the version you are running should be usable for
> debugging your problem, so I'm not going to ask you to try that.

wouldnt be a problem to try it
 
> Thanks for trying it out, it would feel good if kmemcheck would
> finally be useful for something :-) Good luck.

yeah, its a nice project, is there a reason why it isnt in mainline yet?

Thanks for your help, Eric

