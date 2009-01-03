Return-Path: <linux-kernel-owner+w=401wt.eu-S933009AbZACVNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbZACVNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbZACVNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:13:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:42596 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbZACVNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:13:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=To/Qj83omHkcmOoWKzTBtTs+yF24YUlxJCITRYHH7pIeYria4+xzdjmeuPHvansgiw
         h9ide0gvuwUf522yzZxJ4jwWrkrzz+rL96r+lxNz+BrL+HaL0tI9cRQ4SAxvWnueJzMB
         p9W+I1XgFwmKyv7qXuTXhxi7B/igKIotwqrak=
Message-ID: <2f11576a0901031313u791d7dcex94b927cc56026e40@mail.gmail.com>
Date: Sun, 4 Jan 2009 06:13:16 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: [PATCH for -mm] getrusage: fill ru_maxrss value
Cc: "Jiri Pirko" <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       "Hugh Dickins" <hugh@veritas.com>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20090103175913.GA21180@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081230201052.128B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081231110816.5f80e265@psychotron.englab.brq.redhat.com>
	 <20081231213705.1293.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20090103175913.GA21180@redhat.com>
X-Google-Sender-Auth: 632e42486f0eb596
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sorry for delay!
>
>>
>> Jiri's resend3 -> v1
>>  - At wait_task_zombie(), parent process doesn't only collect child maxrss,
>>    but also cmaxrss.
>
> Ah yes, this looks very right to me.

hehe, therefore I like testcase driven development :)


>>  - ru_maxrss inherit at exec()
>
> I must admit, I hate this ;)

Your feelings are understood well.


> That said, I agree with you point about compatibility. So I have to
> agree with this change.
>
> Still, I'd like to know what other people think ;)

Yeah, me too.


> And I also agree that xacct is linux specific feature, but I still
> I dislike the fact that xacct and getrusage report different numbers.
> Perhaps we should change xacct as well?

I don't have any strong opinion.
it seems good idea. but I don't know xacct so much.



>
>> --- a/kernel/exit.c   2008-12-29 23:27:59.000000000 +0900
>> +++ b/kernel/exit.c   2008-12-31 21:08:08.000000000 +0900
>> @@ -1053,6 +1053,12 @@ NORET_TYPE void do_exit(long code)
>>       if (group_dead) {
>>               hrtimer_cancel(&tsk->signal->real_timer);
>>               exit_itimers(tsk->signal);
>> +             if (tsk->mm) {
>> +                     unsigned long hiwater_rss = get_mm_hiwater_rss(tsk->mm);
>> +
>> +                     if (tsk->signal->maxrss < hiwater_rss)
>> +                             tsk->signal->maxrss = hiwater_rss;
>> +             }
> [...snip...]
>> --- a/fs/exec.c       2008-12-25 08:26:37.000000000 +0900
>> +++ b/fs/exec.c       2008-12-31 21:11:28.000000000 +0900
>> @@ -870,6 +870,13 @@ static int de_thread(struct task_struct
>>       sig->notify_count = 0;
>>
>>  no_thread_group:
>> +     if (current->mm) {
>> +             unsigned long hiwater_rss = get_mm_hiwater_rss(current->mm);
>> +
>> +             if (sig->maxrss < hiwater_rss)
>> +                     sig->maxrss = hiwater_rss;
>> +     }
>
> Perhaps it makes sense to factor out this code and make a helper?
>
> Unfortunately, exit_mm() and exec_mmap() do not have the common
> path which can update sig->maxrss, mm_release() can't do this...

last problem are, function name and which file have it :)


>> +     if (who != RUSAGE_CHILDREN) {
>> +             struct mm_struct *mm = get_task_mm(p);
>> +             if (mm) {
>> +                     unsigned long hiwater_rss = get_mm_hiwater_rss(mm);
>> +
>> +                     if (maxrss < hiwater_rss)
>> +                             maxrss = hiwater_rss;
>> +                     mmput(mm);
>> +             }
>> +     }
>> +     r->ru_maxrss = maxrss * (PAGE_SIZE / 1024); /* convert pages to KBs */
>
> Hmm... So, RUSAGE_THREAD always report maxrss == get_mm_hiwater_rss(mm)
> and ignores signal->maxrss. Doesn't look right to me...
>
> Unless I missed something, Jiris's patch was fine, but given that now
> we inherit maxrss at exec(), signal->maxrss can have the "inherited"
> value?

you are right. thanks.
will fix.
