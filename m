Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbZKXNSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbZKXNSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932541AbZKXNSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:18:04 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62872 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbZKXNSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=fFmUWNHg48wQqOpnMg0t+qvHgL3QMj7XxkpO1Ho4flEcR93jJIEi9CIwMCOUmF0BUr
         /ZaxU7d5cvgi0TvPqmGTig7yG5AyXQimrnO8MYUT7HLY/Qs/aVo/2xlbZuvwbN3K49Ex
         aHlZvym8aQAW04rcGzyfJiZnQf/ro0OdQLa3U=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1258983953.4531.456.camel@laptop>
References: <1256223091-6002-1-git-send-email-eranian@gmail.com>
	 <1258562785.3918.685.camel@laptop>
	 <7c86c4470911230534i4119734k1478550567852220@mail.gmail.com>
	 <1258983953.4531.456.camel@laptop>
Date: Tue, 24 Nov 2009 14:18:07 +0100
Message-ID: <7c86c4470911240518qe0c3e87k589437ef43f4a3d4@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix validate_event bug
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, eranian@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 2:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-11-23 at 14:34 +0100, stephane eranian wrote:
>
>> > Won't this give very funny results for mixed pmu groups?
>> >
>>
>> What do you mean by 'mixed pmu groups'?
>
> We currently have a number of struct pmu objects:
>
>  perf_ops_generic
>  perf_ops_cpu_clock
>  perf_ops_task_clock
>
> which are all software based PMUs, and one of:
>
>  pmu        (arch/x86/kernel/cpu/perf_event.c)
>  power_pmu  (arch/powerpc/kernel/perf_event.c)
>
> To represent the hardware PMU.
>
> Now say you mix software events and hardware events into a single group,
> the loop in validate_group:
>
>  list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
>        if (!validate_event(&fake_pmu, sibling))
>                        return -ENOSPC;
>  }
>
> could pass a !hardware event into validate_event(), which currently
> ignores it because event->pmu won't be &pmu, however if you remove that
> check, it'll try and call x86 routines on a software event, which is
> bound to go funny.
>
Ok, so it seems the only valid test to check if the event is related to the
HW PMU is to compare event->pmu with pmu (arch/x86/.../perf_event.c).

In that case you first suggestion is fine.

> Now Frederic is going to make things more interesting by representing HW
> breakpoints as another HW PMU (the distinction between hw/sw pmu is in
> scheduling, you can always schedule a software event).
>
> This weakens the !is_software_event(), in that !software doesn't tell
> you which hardware event it is -- something which needs mending in your
> more complex x86 constraints scheduling patch.
>
That means we can drop is_software_event() in this code and instead
define locally
in x86 a is_hw_pmu_event() function as event->pmu == &pmu.
