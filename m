Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYKNOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYKNOjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 09:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYKNOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 09:39:31 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:13417 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYKNOjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 09:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xt9WEUV8Yw6qGnw9ATFD4ZkaMxJtXaiOoLTnivVZsOlhKSZRd6CH+3Mij0a8ufrq8z
         U2WNWcC7zRTY2KvHcRVzlzdcjYDZisSn6jXNeSVd8K8yuWbwC8gTRF+5y+jd4EQBOn3R
         EU3W+/eKOUpcSRRQdyOzagJsO3NLRAlMhqz54=
Message-ID: <c62985530811140639k1004a8f9k968c3e0949d1a309@mail.gmail.com>
Date: Fri, 14 Nov 2008 15:39:29 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ftrace: Add debug_print trace to print data from kernel to userspace
Cc: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081114134600.GA29700@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <c62985530811140321p481354f9j489955c1e9ee1f3f@mail.gmail.com>
	 <20081114134600.GA29700@skywalker>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/14 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> We also want to make sure dp_printk doesn't do anything when tracer
> is disabled. We do
>
> int do_dp_printk(const char *fmt, ...)
> {
>        int ret;
>        va_list args;
>
>        if (!tracer_enabled)
>                return 0;


In this case you just have to do
echo 0 > /debug/tracing/tracing_enabled
And the entries will not be printed anymore....

> .........
> .......
>
>>
>>
>>
>> > +static void dp_trace_ctrl_update(struct trace_array *tr)
>> > +{
>> > +       /* When starting a new trace, reset the buffers */
>> > +       if (tr->ctrl)
>> > +               start_dp_trace(tr);
>> > +       else
>> > +               stop_dp_trace(tr);
>> > +}
>>
>>
>> BTW, ctrl_update() have been removed very recently.
>> Perhaps are you implementing this against the mainline? Its a better idea to
>> submit a new tracer against latest -tip tree.
>
> Yes the patches are against mainline.


> I am looking at this. I don't see TRACE_TYPE_PARTIAL_LINE in other
> places in the code. Will look more.


This return has been set because several entries can be submitted to a
tracer before it finally reach the user.
If the last one submitted didn't fir is the remaining free bytes in
the seq, then we want to tell the tracing api that
the seq is full and we want this entry to be handled later.
If you don't use it, you could loose entries.
Have a look in trace.c, trace_boot.c, trace_mmiotrace.c, all of these
make use of this return value.

See latest -tip:
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git


> What I wanted to get was a dmesg style output. The default output will
> add pid and other information. That is why i did a print_line callback.


I understand...
Why not append a flag to ignore pid/cpu/timestamp on the output in trace.c ?

> I also wanted to drop the header in the trace file.  I didn't find a way
> to do that.


This one should be dropped too when the flag I mentioned above is set....
Currently, when one cat /debug/tracing/trace, we have these headers,
whatever the current tracer is.
This thing could be fixed...

Perhaps others would have better ideas....
