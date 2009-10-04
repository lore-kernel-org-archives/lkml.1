Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZJDSG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZJDSG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbZJDSG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:06:57 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:41590 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZJDSG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HibhI1IIsXg45vTEJOGoOrOeTLF2ABxrWvYAm9P7uJeB1BDTwREkb7uYX3bQA7b0YC
         GP7yFbu/x4ZD9LP+dBYJfWNj2BUtDi1V3H0PU6+QLnjvMN/o0eGKEw1zBwzxJDZ6MMx2
         YZB9ndvaUVc2NWYYuvL6LEhMKou1V/sxBoUXA=
MIME-Version: 1.0
In-Reply-To: <2f11576a0910040744u575d3afbwd2e27e811060f206@mail.gmail.com>
References: <1254518602.5050.4.camel@hurina> <3e8340490910021901i35ba8a5v7647b1e02b054270@mail.gmail.com> 
	<3DB386D4-C03F-4F2A-B0DD-7F4236325B4B@iki.fi> <3e8340490910021959n304e6870r6df97cfd637283c4@mail.gmail.com> 
	<2f11576a0910040744u575d3afbwd2e27e811060f206@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sun, 4 Oct 2009 14:05:59 -0400
Message-ID: <3e8340490910041105p327396e8v39b1a3454c0922bf@mail.gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Timo Sirainen <tss@iki.fi>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 10:44 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> Hi
>
>
>>>>> -       // If the nul at the end of args has been overwritten, then
>>>>> -       // assume application is using setproctitle(3).
>>>>> -       if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
>>>>> +       if (mm->arg_end != mm->env_start) {
>>>>> +               // PR_SET_PROCTITLE_AREA used
>>>>> +               res = strnlen(buffer, res);
>>>>
>>>> Is this check really needed? Surely it's enough to simply state that
>>>> behavior if the area isn't null-terminated is undefined.
>>>
>>> Well, that depends. I was hoping to use the syscall only once per process.
>>> That would allow me to just update the process title whenever I feel like
>>> it, possibly hundreds of times per second. This is much cheaper if I don't
>>> have to use a syscall every time.
>>>
>>> So if I'm setting the PR_SET_PROCTITLE_AREA initially to e.g. 1 kB memory
>>> area, without the above code ps will show it entirely regardless of any \0
>>> characters (because parameters are separated by \0).
>>
>> That makes sense - but note that it's not completely atomic still -
>> with a syscall you could insert some kind of barrier (rwsem?) to
>> ensure other processes don't see a halfway updated process name. With
>> infrequent updates this isn't a problem, but if you're really
>> intending to update it at a rate where syscall overhead becomes a
>> problem, then you're also going to see these kinds of issues as well.
>
>
> Yes.  this patch seems buggy. The lock is necessary.
> following scenario makes disaster, I think.
>
> CPU0 (prctl caller)                                CPU1 (ps)
> -------------------------------------------------------------------------------------------
> mm->arg_start = arg2;
>                                                                len =
> mm->arg_end - mm->arg_start; in proc_pid_cmdline()
> mm->arg_end = arg3;
>

Since len is unsigned and clamped to PAGE_SIZE, the worst this will do
is expose one page of userspace memory starting at the new value of
arg_start. Note that this can also happen currently, exposing one env
variable, when all NULs in the argument array have been overwritten,
but before the new NUL has been written (that is, there is no NUL
terminator from arg_start until the end of envp[0]).

It is, however, still undesirable, of course, particularly if
userspace isn't prepared for this kind of thing to happen.
