Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752151AbYLRK47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbYLRK47 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYLRK4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:56:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:30183 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYLRK4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:56:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kAG60ZZzPqjxZXSG9KBpBjzI12yp4L+uUi8lFo+KQu/aq4GmFMPkjm/4r96olcBiqY
         cCEUHEHE/SEl6m/kVT/h4r7SuqOK+MNwG2OdpitL4RTR0KER0c1v82KB+JHfo2WhTxeW
         FJUr0YH5JsIjE1m9VAadCFGK8RAz2UoF6h0W0=
Message-ID: <c62985530812180256l34f1d9bs55dfe705f74838ed@mail.gmail.com>
Date: Thu, 18 Dec 2008 11:56:47 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt infinite loop
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu>
	 <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/18 Thomas Gleixner <tglx@linutronix.de>:
> On Thu, 18 Dec 2008, Ingo Molnar wrote:
>> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> > Impact: fix a system hang on slow systems
>> >
>> > While testing the function graph tracer on VirtualBox, I had a system hang
>> > immediatly after enabling the tracer.
>> >
>> > If hrtimer is enabled on kernel, a slow system can spend too much time
>> > during tracing the hrtimer_interrupt which will do eternal loops,
>> > assuming it always have to retry its process because too much time
>> > elapsed during its time update. Now we provide a feature which lurks at
>> > the number of retries on hrtimer_interrupt. After 10 retries, the
>> > function graph tracer will definetly stop its tracing.
>>
>> hm, i dont really like this solution - it just works around the problem by
>> 'speeding up' the system. If we have a _real_ slow system, there's no such
>> way for us to speed it up.
>>
>> Thomas, what do you think - would you expect this lockup to happen on
>> really slow systems? If yes, is there a way we could avoid it from
>> happening - by driving some sort of 'mandatory interval', that is doubled
>> in size every time we detect such a bad hrtimer loop?
>
> In reality I have not seen such a problem yet, even on an old real
> slow P1 which I tricked to do highres, but of course if we add such
> time consuming debugs and make it slow enough the system will spend
> all the time running the tick timer :)
>
> We should at least warn once about such a loop.
>
> I'm not sure about the mandatory interval though:
>
> Try the same test with HZ=1000 periodic mode (HIGHRES/NOHZ=off) and I
> bet you see the same problem, just not in hrtimer_interrupt().
>
> Thanks,
>
>        tglx
>

That's right. I hesitate to propagate this patch more globally for all
interrupts....
