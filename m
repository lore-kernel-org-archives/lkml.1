Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYI2JVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYI2JVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYI2JVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:21:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:51873 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYI2JVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:21:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EoHtTh0N+O40423Zi8TeA7/EGNej321GTU225mkWHYwZY9YarqrQDJe2AzSmp2nnZN
         xWYATlRUlQXBg48edgfsWe4S3YF+8by1h19YiAQlQ9gQIqdtkf6+waTrv7DbVXUNzBcJ
         1kus0MH0+efgk6Lr4B9ExBtNm+cuoruXKMXsk=
Message-ID: <c62985530809290220p646e0839iec6068c03b6eaf9f@mail.gmail.com>
Date: Mon, 29 Sep 2008 11:20:59 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: trace_pipe tentative fix (Re: [PATCH -tip 2/3] Tracing/ftrace: Adapt mmiotrace to the new type of print_line)
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080928201259.09bbac54@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48DD0347.5070008@gmail.com>
	 <20080927002121.0038cdfe@daedalus.pq.iki.fi>
	 <c62985530809270517g179f1d21nca05cf50b289b2f5@mail.gmail.com>
	 <20080928201259.09bbac54@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/28 Pekka Paalanen <pq@iki.fi>:
> On Sat, 27 Sep 2008 14:17:47 +0200
> "Frédéric Weisbecker" <fweisbec@gmail.com> wrote:
>
>> 2008/9/26 Pekka Paalanen <pq@iki.fi>:
>> > Yes, I do disagree about printing stuff that doesn't belong there.
>> > First, I doubt printing bogus text is a right way to fix the
>> > early pipe EOF problem. Second, if you really have to do that,
>> > do it so that it obeys the mmiotrace log format specification.
>> > (I'd recommend a MARK entry.) The spec is in
>> > Documentation/tracers/mmiotrace.txt.
>>
>> No problem, I have one other option: ignoring and sleep again before
>> receiving another entries.
>> I can do another patch this week end to implement that.
>> The third patch only concerns the boot tracer. It relays to other
>> output functions.
>>
>> Just tell me if you agree with the ignoring...
>
> If I understand you suggestion, it looks like the right thing to do.
> Here is a tentative fix, which has not even been compile-tested.
>
> Is it so that the problem is triggered by consuming a trace entry
> which does not produce any output? If that entry is all there is
> in the ring at a time of a read call, then the last call to
> trace_seq_to_user() returns -EBUSY, because there is nothing to
> copy to user. What I failed to understand when I wrote that
> piece of code, is that returning 0 means EOF. The only cases
> when we do want to return an EOF are near the
>        while (trace_empty(iter)) {
> loop.
>
> Frederic, could you test the fix, and if it works, send it to Ingo?
>
>
> Thanks.
>
> ---
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6ada059..d85659a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2616,6 +2616,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>                        goto out;
>        }
>
> +waitagain:
>        while (trace_empty(iter)) {
>
>                if ((filp->f_flags & O_NONBLOCK)) {
> @@ -2749,8 +2750,13 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
>        sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
>        if (iter->seq.readpos >= iter->seq.len)
>                trace_seq_reset(&iter->seq);
> +
> +       /*
> +        * If there was nothing to send to user, inspite of consuming trace
> +        * entries, go back to wait for more entries.
> +        */
>        if (sret == -EBUSY)
> -               sret = 0;
> +               goto waitagain;
>
>  out:
>        mutex_unlock(&trace_types_lock);
>

Ok I will test it this evening.
