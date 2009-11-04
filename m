Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbZKDLuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbZKDLuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:50:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZKDLuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:50:07 -0500
Received: from www84.your-server.de ([213.133.104.84]:50868 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbZKDLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:50:06 -0500
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for
 threads
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <874opaa68v.fsf@basil.nowhere.org>
References: <1257233486.22553.6.camel@wall-e>
	 <874opaa68v.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 Nov 2009 12:50:04 +0100
Message-ID: <1257335404.2123.29.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 04.11.2009, 12:17 +0100 schrieb Andi Kleen:
> Stefani Seibold <stefani@seibold.net> writes:
> >  
> > +#ifdef CONFIG_IA32_EMULATION
> > +unsigned long KSTK_ESP(struct task_struct *task)
> > +{
> > +	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
> > +			(task_pt_regs(task)->sp) : \
> > +			((task)->thread.usersp);
> 
> Usersp is only set for system calls, but not when the process is blocked
> in a interrupt.
> 
> In general if you really want a reliable implementation of this
> you would really need to stop the task and grab the stack pointer;
> otherwise it can be arbitarily outdated anyways.
> 

This is true, but i think it is better to get an outdated value than a
complete wrong value like -1.

The truth is that KSTK_ESP always return an outdated value on a multi
core system if the process never do a system call.

But we can work on the next step and try to implement it better ;-)

Question: is task_pt_regs(task)->sp set in 64 bit mode when the process
is blocked in an interrupt? If true, we can add two additional assembly
instruction to the system call handler and store the stack pointer into
this. Than KSTK_ESP wil be again a simple macro like

#define KST_ESP(task)	task_pt_regs(task)->sp

The drawback is that this will cost a litte bit performance for a litte
bit more accuracy.
 
Stefani


