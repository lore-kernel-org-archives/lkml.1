Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYGOJMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYGOJMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 05:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYGOJM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 05:12:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44456 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbYGOJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 05:12:28 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5338"; a="4716466"
Message-ID: <487C69F8.80906@qualcomm.com>
Date: Tue, 15 Jul 2008 02:12:24 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
References: <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com> <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org> <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com> <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org> <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com> <487C1374.8020404@qualcomm.com> <alpine.LFD.1.10.0807142104250.3017@woody.linux-foundation.org> <20080715083223.GA2600@elte.hu> <487C62FB.6030304@qualcomm.com> <20080715085738.GA6325@elte.hu>
In-Reply-To: <20080715085738.GA6325@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>>> On Mon, 14 Jul 2008, Max Krasnyansky wrote:
>>>>> Did you guys an updated patch ? Dmitry pointed out several things that Linus
>>>>> missed in his original version. I guess I can go through the thread and
>>>>> reconstruct that but if you have a patch I can try let me know.
>>>> I didn't update it, and right now I'm just merging too much (and  
>>>> discussing the merges) to have time.
>>>>
>>>> The patch really needs to have some scheduler person look at the use  
>>>> fo cpu_active_map - I was kind of hoping that Ingo would.
>>> yeah - it's very high on our TODO list :-) Peter, Dmitry and me are  
>>> looking into it.
>>>
>>> I didnt touch most of -tip in the past few days to get a rock solid QA  
>>> track record for all items we have.
>> I just sent you guys a patch. Please take a look. I've probably missed 
>> something but it should close (I think). Also we'd probably at least 
>> want the bits that streamline the domain reinitialization because it 
>> helps with cpusets (ie uses same exact path for all cases).
> 
> thanks Max. Since upstream already has Dmitry's it conflicted with your 
> patch - i fixed the interactions up, see it below. (completely untested)
Hmm, I did it on top of 2.6.26 final which has Dmitry's patch. It must have
been something in the -tip.
Anyway, I'll apply it here and retest.

> It's not ready for inclusion yet though - these new
> #ifdefs are quite ugly:
> 
>  +#if !defined(CONFIG_CPUSETS)
>  +       partition_sched_domains(0, NULL, NULL);
>  +#else
>  +       rebuild_sched_domains();
>  +#endif
> 
> we should just have a single method for refreshing sched domains 
> hierarchy, and in the !CONFIG_CPUSETS case that should simply fall back 
> to partition_sched_domains().
> 
> We can do that by making rebuild_sched_domains() the primary method that 
> is called - and in the !CPUSETS case it's an inline that calls 
> partition_sched_domains().

Actually that's exactly what I have in the cpuset part of the patch. But as
I mentioned there is some circular locking issues with rebuild_sched_domains().
(cgroup_lock and get_online_cpus()) and I wanted to fix that fix. Now that I
think about it's kind of unrelated. So in other words I totally agree. I'll
go ahead fix it and resend.

btw While we're at it. Does arch_init_sched_domains() and arch_reinit_sched_domains()
still make sense. I'm talking about naming here. I suppose arch_ part means that it
can be replaced by the arch code. But it's not the case with those two guys.
What do you think ?

> also, small nits:
> 
> use #ifdef CONFIG_CPUSETS instead of "#if !defined(CONFIG_CPUSETS)".
Will do.

> and while at it:
> 
>  +#if !defined(CONFIG_CPUSETS)
>          /* XXX: Theoretical race here - CPU may be hotplugged now */
>          hotcpu_notifier(update_sched_domains, 0);
>  +#endif
> 
> that race should be closed now, hm?
Yeah, I stared at that comment for a second and decided to leave it.
I guess it's still there. I mean in theory cpu can still be hotplugged just
before sched or cpuset register their notifier callbacks.

Max
