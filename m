Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZFEEO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZFEEO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZFEEOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:14:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbZFEEOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:14:20 -0400
Date: Thu, 4 Jun 2009 21:13:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       jason.wessel@windriver.com, kgdb-bugreport@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kgdbts: unify/generalize gdb breakpoint adjustment
Message-Id: <20090604211350.9aafa731.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0906042100j9a44f95g7d05a515725c9d5@mail.gmail.com>
References: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
	<20090604175030.55cc4a68.akpm@linux-foundation.org>
	<8bd0f97a0906041755q7588ba76l1e4e1eb8bdbe336@mail.gmail.com>
	<20090604180420.2805fcdd.akpm@linux-foundation.org>
	<8bd0f97a0906041850v4a41082fkf9726ae1bdd299cb@mail.gmail.com>
	<20090604192723.36874fcb.akpm@linux-foundation.org>
	<8bd0f97a0906042100j9a44f95g7d05a515725c9d5@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 00:00:22 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> your version after all requires every arch to copy & paste this crap:
> static inline unsigned long instruction_pointer(struct pt_regs *regs)
> {
>     return regs->ip;
> }
> static inline void instruction_pointer_set(struct pt_regs *regs,
> unsigned long val)
> {
>     regs->ip = val;
> }
> 
> and then actual usage turns into:
> instruction_pointer_set(regs, instruction_pointer(regs) + foo);
> 
> whereas mine is two lines:
> #define instruction_pointer(regs) ((regs)->ip)
> instruction_pointer(regs) += val;

The aim isn't really to reduce the amount of typing one needs to do. 
Let's get things right, and if getting it right involves more typing
then so be it.


If it really worries you then you could do

#define GET_IP(regs)	((regs)->ip)
#include <asm/generic/instruction_pointer.h>

and

static inline unsigned long instruction_pointer(struct pt_regs *regs)
{
	return GET_IP(regs);
}

static inline void instruction_pointer_set(struct pt_regs *regs,
					unsigned long val)
{
	GET_IP(regs) = val;
}

Note that GET_IP() is all-caps, which says "this is a macro".

But I don't think it's worth the ickyness, unless we also incorporate
kernel_stack_pointer(), frame_pointer(), user_stack_pointer() and
perhaps the _set() versions of those also.



Do we know how to implement instruction_pointer_set() on ia64, btw?
