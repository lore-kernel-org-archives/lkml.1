Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbXCNSr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbXCNSr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932517AbXCNSr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:47:59 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:7361 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbXCNSr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:47:58 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2007 14:47:58 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Clarification required about select vs wake_up race condition
Date: Wed, 14 Mar 2007 11:38:18 -0700
Message-ID: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A41E@xmb-sjc-214.amer.cisco.com>
In-Reply-To: <b647ffbd0703141008o3f0d6bfsfbd9e9d793efdee@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Clarification required about select vs wake_up race condition
thread-index: AcdmW1iAm9OjFYbAThS7wq3v+3vg/wACqYuA
References: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A411@xmb-sjc-214.amer.cisco.com> <b647ffbd0703141008o3f0d6bfsfbd9e9d793efdee@mail.gmail.com>
From: "Ravinandan Arakali \(rarakali\)" <rarakali@cisco.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Mar 2007 18:38:19.0113 (UTC) FILETIME=[EF9E1D90:01C76667]
Authentication-Results: sj-dkim-2; header.From=rarakali@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,
Thanks for the explanation. That would mean that if
process is not put to sleep, it will go back to
top of for() loop in do_select(), set state back
to TASK_INTERRUPTIBLE and re-check for incoming data.

Ravi 

-----Original Message-----
From: Dmitry Adamushko [mailto:dmitry.adamushko@gmail.com] 
Sent: Wednesday, March 14, 2007 10:08 AM
To: Ravinandan Arakali (rarakali)
Cc: Linux Kernel
Subject: Re: Clarification required about select vs wake_up race
condition

On 12/03/07, Ravinandan Arakali (rarakali) <rarakali@cisco.com> wrote:
> Hi,
> I am facing following problem and was wondering if somebody could help

> me out.
> Our char driver(pretty much like all other char drivers) does a
> poll_wait()
> and returns status depending on whether data is available to be read.
> Even though some data is available to be read(verified using one of 
> our internal commands), the select() never wakes up, inspite of any 
> no. of messages sent.
>
> To understand this, I was looking at the code of select vs 
> wake_up_interruptible().
> I feel I am misunderstanding some part of the kernel code but will be 
> glad if somebody can point it out.
>
> My understanding:
> The do_select() sets the state of task to TASK_INTERRUPTIBLE and calls

> the driver's poll entry point. In our poll(), let's say immediately 
> after we determine that there's nothing to be read, some data arrives 
> causing a wake_up_interruptible() on another CPU.
> The wake up happens in the context of process sending the data. Since 
> the receiving process was already added to the list of listeners, from

> looking at the code of try_to_wake_up(), it looks like it can set the 
> state of the receiving process to TASK_RUNNING(I don't see any lock 
> preventing this). After this happens, the receiving process goes to 
> sleep (because of schedule_timeout called by do_select) but state is 
> still set to TASK_RUNNING.

No, it's not going to sleep then.

The effect of schedule() being called with current->state ==
TASK_RUNNING is a re-scheduling to another task with a higher prio (if
any) or just getting back (iow, the task doesn't lose a cpu). For both
cases, the task is on the runqueue.

/ Look how/when deactivate_task() is called in schedule() /

Maybe there is a race in your code between (1) how you check "data is
available" in poll and (2) a part that sets this fact (data is
available)...


--
Best regards,
Dmitry Adamushko
