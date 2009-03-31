Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbZCaUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbZCaUTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbZCaUTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:19:00 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:59014 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109AbZCaUS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:18:57 -0400
Date: Tue, 31 Mar 2009 22:18:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090331221847.50ea3356@skybase>
In-Reply-To: <alpine.DEB.1.10.0903311318300.1912@qirst.com>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325122241.GE11571@elte.hu>
	<49CA2345.70204@kernel.org>
	<20090325141330.2717dc97@skybase>
	<49CA2FBF.9000207@kernel.org>
	<20090325142525.2d31c522@skybase>
	<49CA32F6.2030408@kernel.org>
	<20090331185431.72ff1707@skybase>
	<alpine.DEB.1.10.0903311318300.1912@qirst.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 13:20:42 -0400 (EDT)
Christoph Lameter <cl@linux.com> wrote:

> On Tue, 31 Mar 2009, Martin Schwidefsky wrote:
> 
> > I got the dynamic cpu allocator to work with the patch below. Anybody
> > with an objection against the SHIFT_PERCPU_VAR macro ?
> 
> Please include the patch inline next time.

What do you mean by "inline"? That the patch should not be the last
thing in the mail?

> Why is there a difference between percpu alloc and "static" percpu
> variables? The "static" percpu variables can be dynamically allocated when
> a module is loaded.

We need to hide the static per cpu symbol from the compiler, otherwise
the compiler will try to load the address of the symbol with an
instruction that is limited in the addressing range of a single elf
object. We do that will the inline assembly in SHIFT_PERCPU_PTR

#define SHIFT_PERCPU_PTR(ptr,offset) (({                \
        extern int simple_identifier_##var(void);       \
        unsigned long *__ptr;                           \
        asm ( "larl %0, %1@GOTENT"                      \
            : "=a" (__ptr) : "X" (ptr) );               \
        (typeof(ptr))((*__ptr) + (offset));     }))

The "X" constraint only works if ptr is the name of a symbol. The
per_cpu_ptr macro will use SHIFT_PERCPU_PTR on an pointer which does
not compile. For pointers we do not need to trick the compiler, we can
just use the standard RELOC_HIDE.

> Isnt this mmore an issue that can be addressed by changing the way the initial per cpu
> segment is allocated? If its also dynamically allocated then there should
> be no problem?
 
I don't see how changes to the initial per cpu segment should help with
access to per cpu symbols.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

