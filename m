Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbZL2Orn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbZL2Orn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 09:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZL2Orn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 09:47:43 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28424 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZL2Orm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 09:47:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ptCHj6yX+pOLooeSuQ1/vqoJue5m15fFEPLz0BcQHeIYjQ9km11CcRHxqytjGp0gM
	ZcWMHWa6pFR+brkZ4u1wA==
MIME-Version: 1.0
In-Reply-To: <20091222010238.GB31264@drongo>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
	 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
	 <1261410040.4314.178.camel@laptop> <20091222010238.GB31264@drongo>
Date: Tue, 29 Dec 2009 15:47:38 +0100
Message-ID: <bd4cb8900912290647wa79615bs3ac8618ca36808c3@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: Stephane Eranian <eranian@google.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>, eranian@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,


So if I understand what both of you are saying, it seems that
event scheduling has to take place in the pmu->enable() callback
which is per-event.

In the case of X86, you can chose to do a best-effort scheduling,
i.e., only assign
the new event if there is a compatible free counter. That would be incremental.

But the better solution would be to re-examine the whole situation and
potentially
move existing enabled events around to free a counter if the new event is more
constrained. That would require stopping the PMU, rewriting config and
data registers
and re-enabling the PMU. This latter solution is the only possibility
to avoid ordering
side effects, i.e., the assignment of events to counters depends on
the order in which
events are created (or enabled).

The register can be considered freed by pmu->disable() if scheduling takes place
in pmu->enable().

>From what Paul was saying about hw_perf_group_sched_in(), it seems like this
function can be used to check if a new group is compatible with the existing
enabled events. Compatible means that there is a possible assignment of
events to counters.

As for the n_added logic, it seems like perf_disable() resets n_added to zero.
N_added is incremented in pmu->enable(), i.e., add one event, or the
hw_perf_group_sched_in(), i.e., add a whole group. Scheduling is based on
n_events. The point of n_added is to verify whether something needs to be
done, i.e., event scheduling, if an event or group was added between
perf_disable()
and perf_enable(). In pmu->disable(), the list of enabled events is
compacted and
n_events is decremented.

Did I get this right?

All the enable and disable calls can be called from NMI interrupt context
and thus must be very careful with locks.



On Tue, Dec 22, 2009 at 2:02 AM, Paul Mackerras <paulus@samba.org> wrote:
> On Mon, Dec 21, 2009 at 04:40:40PM +0100, Peter Zijlstra wrote:
>
>> I'm not really seeing the problem here...
>>
>>
>>  perf_disable() <-- shut down the full pmu
>>
>>  pmu->disable() <-- hey someone got removed (easy free the reg)
>>  pmu->enable()  <-- hey someone got added (harder, check constraints)
>>
>>  hw_perf_group_sched_in() <-- hey a full group got added
>>                               (better than multiple ->enable)
>>
>>  perf_enable() <-- re-enable pmu
>>
>>
>> So ->disable() is used to track freeing, ->enable is used to add
>> individual counters, check constraints etc..
>>
>> hw_perf_group_sched_in() is used to optimize the full group enable.
>>
>> Afaict that is what power does (Paul?) and that should I think be
>> sufficient to track x86 as well.
>
> That sounds right to me.
>
>> Since sched_in() is balanced with sched_out(), the ->disable() calls
>> should provide the required information as to the occupation of the pmu.
>> I don't see the need for more hooks.
>>
>> Paul, could you comment, since you did all this for power?
>
> On powerpc we maintain a list of currently enabled events in the arch
> code.  Does x86 do that as well?
>
> If you have the list (or array) of events easily accessible, it's
> relatively easy to check whether the whole set is feasible at any
> point, without worrying about which events were recently added.  The
> perf_event structure has a spot where the arch code can store which
> PMU register is used for that event, so you can easily optimize the
> case where the event doesn't move.
>
> Like you, I'm not seeing where the difficulty lies.  Perhaps Stephane
> could give us a detailed example if he still thinks there's a
> difficulty.
>
> Paul.
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
