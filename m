Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbXCSLX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbXCSLX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXCSLX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:23:29 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:1916 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbXCSLX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:23:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 19 Mar 2007 11:23:25.0821 (UTC) FILETIME=[02DE7AD0:01C76A19]
Content-class: urn:content-classes:message
Subject: Re: i386: Why putting __USER_DS in kernel threads stack initialization?
Date: Mon, 19 Mar 2007 07:23:25 -0400
Message-ID: <Pine.LNX.4.61.0703190717240.19254@chaos.analogic.com>
In-Reply-To: <20070318225831.GB3802@Ahmed>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: i386: Why putting __USER_DS in kernel threads stack initialization?
thread-index: AcdqGQLo3ZPlJgEsQXW7X1TGXDFpkQ==
References: <20070318225831.GB3802@Ahmed>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 18 Mar 2007, Ahmed S. Darwish wrote:

> Hi list,
>
> Reading the kernel threads initialization code I see:
>
> int kernel_thread(...) {
>
> 	struct pt_regs regs;
> 	memset(&regs, 0, sizeof(regs));
> 	[...]
> **	regs.xds = __USER_DS;
> **	regs.xes = __USER_DS;
> 	[...]
> 	/* Ok, create the new process.. */
> 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, \
> 	       	       0, NULL, NULL);
>
> Continuing with the code, the threads stack (beginning from %esp) is
> initialized with the passed *regs from do_fork:
>
> int copy_thread(..., struct task_struct *p, struct pt_regs *regs) {
>
> 	struct pt_regs * childregs;
> 	struct task_struct *tsk;
> 	childregs = task_pt_regs(p);
> **	*childregs = *regs;
> 	[...]
> ** 	p->thread.esp = (unsigned long) childregs;
>
>
> So the question is what will a _kernel_ thread do with the Usermode Segment
> address ?
>
> Thanks,
>
> P.S. I've tried commenting out both lines which led to a non functional init,
> Also setting them to __USER_DS made init start but stopped issuing the error:
> `Panic: Segment violation at 0x8049798 - Sleeping for 30 seconds'
>
> -- 
> Ahmed S. Darwish
> http://darwish.07.googlepages.com

You might be confusing two routines. The kernel thread routine sets
DS and ES to the kernel data segment, __KERNEL_DS, not the user data
segment. This is so the kernel thread can access the kernel data. Note
that this is done by putting the values in the pt_regs structure so
it doesn't happen 'now', but after the fork.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.68 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
