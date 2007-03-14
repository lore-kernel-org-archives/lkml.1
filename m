Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXCNRIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXCNRIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXCNRIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:08:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:20707 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXCNRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ABUKHAvzb3omb9oS77oHg8lwFon4k9gMRPsMbF3ZZrbLoyQfFSpUcDUXBceclO0liE51LqcFAkBSM004UahbCQjuTg5GuTFwjykt4xvcd0P1vn6qDpxecsctAbWsrHHxwwOukNnio63pN1eyNRX/ZLT5RWkym1NMU2VVg7/uA8Q=
Message-ID: <b647ffbd0703141008o3f0d6bfsfbd9e9d793efdee@mail.gmail.com>
Date: Wed, 14 Mar 2007 18:08:02 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ravinandan Arakali (rarakali)" <rarakali@cisco.com>
Subject: Re: Clarification required about select vs wake_up race condition
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A411@xmb-sjc-214.amer.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <FA6FB5FA4DA6BF4386D129273B2E3EC30183A411@xmb-sjc-214.amer.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/07, Ravinandan Arakali (rarakali) <rarakali@cisco.com> wrote:
> Hi,
> I am facing following problem and was wondering if somebody could help
> me out.
> Our char driver(pretty much like all other char drivers) does a
> poll_wait()
> and returns status depending on whether data is available to be read.
> Even though some data is available to be read(verified using one of our
> internal
> commands), the select() never wakes up, inspite of any no. of messages
> sent.
>
> To understand this, I was looking at the code of select vs
> wake_up_interruptible().
> I feel I am misunderstanding some part of the kernel code but will be
> glad if
> somebody can point it out.
>
> My understanding:
> The do_select() sets the state of task to TASK_INTERRUPTIBLE and calls
> the driver's
> poll entry point. In our poll(), let's say immediately after we
> determine that there's
> nothing to be read, some data arrives causing a wake_up_interruptible()
> on another CPU.
> The wake up happens in the context of process sending the data. Since
> the receiving
> process was already added to the list of listeners, from looking at the
> code of
> try_to_wake_up(), it looks like it can set the state of the receiving
> process to
> TASK_RUNNING(I don't see any lock preventing this). After this happens,
> the receiving
> process goes to sleep (because of schedule_timeout called by do_select)
> but
> state is still set to TASK_RUNNING.

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
