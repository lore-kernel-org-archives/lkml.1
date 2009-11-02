Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZKBHAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZKBHAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZKBHAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:00:53 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:34288 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZKBHAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:00:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uGW7ug7X6nRcq70kEWneRGeV96M2kI/E6SF0yXfoPicOTHjj6ARBfNlUHlM2PQAxVw
         0o4LIiatPbw7PE4/pzMoBPGuPGfX6JB4i152r+PTG8yz3oSt8ZB0s3NPKqjRsywEkDXJ
         Fa/1SGHTdYawlJl3QOQaRXTQBjT1VecxhLihM=
MIME-Version: 1.0
In-Reply-To: <20091102155543.E60E.A69D9226@jp.fujitsu.com>
References: <20091102005218.8352.A69D9226@jp.fujitsu.com>
	 <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
	 <20091102155543.E60E.A69D9226@jp.fujitsu.com>
Date: Mon, 2 Nov 2009 16:00:57 +0900
Message-ID: <28c262360911012300h4535118ewd65238c746b91a52@mail.gmail.com>
Subject: Re: OOM killer, page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 3:59 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Mon,  2 Nov 2009 13:24:06 +0900 (JST)
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> > Hi,
>> >
>> > (Cc to linux-mm)
>> >
>> > Wow, this is very strange log.
>> >
>> > > Dear all,
>> > >
>> > > (please Cc)
>> > >
>> > > With 2.6.32-rc5 I got that one:
>> > > [13832.210068] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0
>> >
>> > order = 0
>>
>> I think this problem results from 'gfp_mask = 0x0'.
>> Is it possible?
>>
>> If it isn't H/W problem, Who passes gfp_mask with 0x0?
>> It's culpit.
>>
>> Could you add BUG_ON(gfp_mask == 0x0) in __alloc_pages_nodemask's head?
>
> No.
> In page fault case, gfp_mask show meaningless value. Please ignore it.
> pagefault_out_of_memory() always pass gfp_mask==0 to oom.
>
>
> mm/oom_kill.c
> ====================================
> void pagefault_out_of_memory(void)
> {
>        unsigned long freed = 0;
>
>        blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
>        if (freed > 0)
>                /* Got some memory back in the last second. */
>                return;
>
>        /*
>         * If this is from memcg, oom-killer is already invoked.
>         * and not worth to go system-wide-oom.
>         */
>        if (mem_cgroup_oom_called(current))
>                goto rest_and_return;
>
>        if (sysctl_panic_on_oom)
>                panic("out of memory from page fault. panic_on_oom is selected.\n");
>
>        read_lock(&tasklist_lock);
>        __out_of_memory(0, 0);       <---- here!
>        read_unlock(&tasklist_lock);
>
>

Yeb. Kame already noticed it. :)
Thanks for pointing me out, again.

I already suggested another patch.
What do you think about it?


-- 
Kind regards,
Minchan Kim
