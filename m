Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbXGaLoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbXGaLoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXGaLoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:44:16 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:17481 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750864AbXGaLoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:44:15 -0400
Message-Id: <46AEE8420200005A0002865A@mcclure.wal.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 31 Jul 2007 07:44:02 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] RT: Preemptible Function-Call-IPI Support
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 11:21 +0200, Ingo Molnar wrote:
> [ mail re-sent with lkml Cc:-ed. _Please_ Cc: all patches to lkml too! 
>   Unless you want -rt to suffer the fate of -ck, keep upstream involved 
>   all the time. The recent /proc/interrupts-all discussion with upstream 
>   folks showed the clear benefits of that approach. ]

My apologies.  I wasn't getting really any responses to my proposal, so
I shortened the distribution to avoid becoming a pest to people that
didn't care.  I will CC both from now on.


> 
> why do we need this? 

I wrote this when I discovered that KVM was having problems with
smp_call_function() on -rt.  It was utilizing spinlock_t which of course
was transparently converted to rt_mutex.  This blew up in the interrupt
context of the FUNCTION_CALL whenever the lock was acquired.  I was
thinking to myself "why is the FCIPI vector being treated any different
that other IRQs?".  That question drove the design/implementation of
this series.


> It's quite complex 


I think if you look closely at the code you will see its actually pretty
straight forward.  However, for whatever complexity you may perceive,
note that I made the choices I did (as opposed to something like
modifying the work-queue infrastructure) because I felt it had the
minimum impact on other subsystems unrelated to FCIPI.  There are, of
course, many ways to skin a rabbit. ;)

> and brings little extra AFAICS.

Brings little extra to what?  Do you think the whole concept of "FCIPIs
in a thread" is a waste of time, or do you just think my implementation
choices are bad?

> See the "schedule_on_each_cpu-enhance.patch" from Peter Ziljstra that 
> lets a function to be executed on all CPUs. That should be extended 
> (trivially) to execute a function on another CPU. That's all we need.

I haven't seen that.  I will take a look.  

The key part of my design is as follows:

1) No new API: smp_call_function_[single]) must just transparently
switch over to threaded mode (Just like the IRQ handler in
PREEMPT_HARDIRQs does)
2) Support priority inheritance:  Unlike normal HARDIRQs which can use a
relatively static priority assignment, FCIPIs are driven by another
software entity which may or may not have RT priority.  Therefore, being
able to execute the call in the same priority as the caller is critical,
IMO.  Calls are sorted and scheduled by priority.
3) More robust parallelism:  mainline smp_call_function has a system
wide serialization point when a call is made.  We should be able to
support a high degree of parallel access to prevent priority inversion.
This means more than one call can be in-flight at a time.  
4) Preemptible/sleepable code on both the caller and callee sides.
Today, both the caller and callee sides of the link are critical
sections with preemption disabled.
5) The API must work from both in_atomic()==1 and in_atomic()==0 modes.
In addition, it will opportunistically sleep while waiting for replies
if in_atomic()==0.

If we can make Peter's patch work within this criteria and people like
it better than what I put forth, that is fine by me.

Regards,
-Greg

