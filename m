Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZJDOo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZJDOo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 10:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbZJDOo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 10:44:57 -0400
Received: from mail-iw0-f195.google.com ([209.85.223.195]:64918 "EHLO
	mail-iw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZJDOo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 10:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nnG+LZ0LjbhuYOl8DbdbH/tOfVXxcu8gqn+GA2hGW+xGe+g4N0MLVtPJIM2Qof20m5
         4G/7DrU3NBRywnZqmL7Bh5orPLCVLGlpmUtQt+MrLidpweqzlvIez9WtO7tHDzko+diH
         OmvHZAYljtnhXTZiowPTx6lNkhhtVklt/BkAM=
MIME-Version: 1.0
In-Reply-To: <3e8340490910021959n304e6870r6df97cfd637283c4@mail.gmail.com>
References: <1254518602.5050.4.camel@hurina>
	 <3e8340490910021901i35ba8a5v7647b1e02b054270@mail.gmail.com>
	 <3DB386D4-C03F-4F2A-B0DD-7F4236325B4B@iki.fi>
	 <3e8340490910021959n304e6870r6df97cfd637283c4@mail.gmail.com>
Date: Sun, 4 Oct 2009 23:44:19 +0900
Message-ID: <2f11576a0910040744u575d3afbwd2e27e811060f206@mail.gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Timo Sirainen <tss@iki.fi>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


>>>> -       // If the nul at the end of args has been overwritten, then
>>>> -       // assume application is using setproctitle(3).
>>>> -       if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
>>>> +       if (mm->arg_end != mm->env_start) {
>>>> +               // PR_SET_PROCTITLE_AREA used
>>>> +               res = strnlen(buffer, res);
>>>
>>> Is this check really needed? Surely it's enough to simply state that
>>> behavior if the area isn't null-terminated is undefined.
>>
>> Well, that depends. I was hoping to use the syscall only once per process.
>> That would allow me to just update the process title whenever I feel like
>> it, possibly hundreds of times per second. This is much cheaper if I don't
>> have to use a syscall every time.
>>
>> So if I'm setting the PR_SET_PROCTITLE_AREA initially to e.g. 1 kB memory
>> area, without the above code ps will show it entirely regardless of any \0
>> characters (because parameters are separated by \0).
>
> That makes sense - but note that it's not completely atomic still -
> with a syscall you could insert some kind of barrier (rwsem?) to
> ensure other processes don't see a halfway updated process name. With
> infrequent updates this isn't a problem, but if you're really
> intending to update it at a rate where syscall overhead becomes a
> problem, then you're also going to see these kinds of issues as well.


Yes.  this patch seems buggy. The lock is necessary.
following scenario makes disaster, I think.

CPU0 (prctl caller)                                CPU1 (ps)
-------------------------------------------------------------------------------------------
mm->arg_start = arg2;
                                                                len =
mm->arg_end - mm->arg_start; in proc_pid_cmdline()
mm->arg_end = arg3;
