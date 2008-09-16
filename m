Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbYIPFuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbYIPFuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 01:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYIPFuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 01:50:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:35145 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYIPFuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 01:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bztvWrvfLlqxujQEc3aLOY9YnNmt+PV9wb0N98mqTYtRupzboVWzRddjBD7RyxhPpR
         cG3VGX/FyKl4wjRn6zhKp2Q4Dzw/OPmiaSmzMSeoOu/2/db37RahaZoPlDdLGrdU+z3/
         9hjXvb0Sv45NOt4uvhLWLcJMN5h176GYMVZNI=
Message-ID: <3bedf6ab0809152249r524cce0v1c14bfdff46aa12d@mail.gmail.com>
Date: Tue, 16 Sep 2008 11:19:58 +0530
From: "karthikeyan S" <karthispeaks@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: A bug (probably) in stop_all_threads
Cc: "Grant Coady" <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080916051751.GA28475@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3bedf6ab0809130127j7ed9d372pcb15e1b001178600@mail.gmail.com>
	 <o44nc4dd8tpl94vf9bv81oklq8lt29112t@4ax.com>
	 <20080916051751.GA28475@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

Thanks for getting back. Yes, I tried to set the state to
TASK_INTERRUPTIBLE. It solves the issue. The other processes now get a
chance to handle the SIGSTOP sent to them.

-karthik

On Tue, Sep 16, 2008 at 10:47 AM, Willy Tarreau <w@1wt.eu> wrote:
> Hi karthik,
>
> Just a quick note to tell you that I have not missed your mail, I
> just need some time to analyse your report and the code related
> to it. Have you tried setting TASK_INTERRUPTIBLE as you suggest ?
> At first sight, it seems to make sense.
>
> Regards,
> Willy
>
> On Sat, Sep 13, 2008 at 08:07:04PM +1000, Grant Coady wrote:
>> On Sat, 13 Sep 2008 13:57:28 +0530, "karthikeyan S" <karthispeaks@gmail.com> wrote:
>>
>> CC added.
>>
>> >Hi,
>> >
>> >Apologies if I am posting this message in an incorrect mailing list
>> >and for bringing up an issue with older kernel version (2.4), and if
>> >the issue had been brought up earlier and I missed it.
>> >
>> >There seems to be a bug with stop_all_threads function in 2.4. The
>> >function sends SIGSTOP to all the threads in the thread group and
>> >waits until all the threads get their state changed accordingly.
>> >
>> >While waiting, if it finds that the event has not occurred, it tires
>> >to yield the processor to other processes by calling
>> >schedule_timeout().
>> >
>> >Bur before calling schedule_timeout() it does not set the task state
>> >to either TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE.
>> >So schedule_timeout() does not do anything effectively.
>> >
>> >This causes a problem in our device which uses kernel 2.4. When we
>> >have a sigsegv from the task which runs at highest priority, the
>> >control is stuck waiting for all the threads in the thread group to
>> >change their task state. But the other threads never get a chance to
>> >run and the SIGSTOP sent to them is of no effect.
>> >
>> >When  I changed the stop_all_threads function to set the task state to
>> >TASK_INTERRUPTIBLE, the problem disappears.
>> >
>> >So is this a real issue that stop_all_threads() does not set the
>> >current task to TASK_INTERRUPTIBLE before calling schedule_timeout()?
>> >
>> >Please provide your feedback. Thanks a lot.
>> >
>> >-karthik
>
