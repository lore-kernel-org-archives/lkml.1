Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZFVUCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZFVUCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbZFVUCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:02:37 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41560 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbZFVUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=JfChQfNXe2pL2hRXrlU7PFT61n2xXD8i59Ld2PpLLSnqOWImLmbjIJ3QVkNPW0CZle
         Fbbov48j1wMiw7evBVCzeWypIhfC/KNg/XhshBOw4kVhLpuwZehU27BkQcRwto4eEwmu
         iR9eK8SINpuUe5seXOltP4Dt/W0od2CiC56S0=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090622120133.GT24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622120133.GT24366@elte.hu>
Date: Mon, 22 Jun 2009 22:02:37 +0200
Message-ID: <7c86c4470906221302x2f18b0c2q1f719e1af5cdd44@mail.gmail.com>
Subject: Re: IV.5 - Intel Last Branch Record (LBR)
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 2:01 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> 5/ Intel Last Branch Record (LBR)
>>
>> Intel processors since Netburst have a cyclic buffer hosted in
>> registers which can record taken branches. Each taken branch is
>> stored into a pair of LBR registers (source, destination). Up
>> until Nehalem, there was not filtering capabilities for LBR. LBR
>> is not an architected PMU feature.
>>
>> There is no counter associated with LBR. Nehalem has a LBR_SELECT
>> MSR. However there are some constraints on it given it is shared
>> by threads.
>>
>> LBR is only useful when sampling and therefore must be combined
>> with a counter. LBR must also be configured to freeze on PMU
>> interrupt.
>>
>> How is LBR going to be supported?
>
> If there's interest then one sane way to support it would be to
> expose it as a new sampling format (PERF_SAMPLE_*).
>
LBR is very important, it becomes useable with Nehalem where you
can filter on priv level. It is important for statistical basic block
profiling, for instance. Another important feature is its ability to freeze
on PMU interrupt.

LBR is also interesting because it yield a path to an event.

LBR on NHM (and others) is not that easy to handle because:
   - need to read-modify-write IA32_DEBUGCTL
   - LBR_TOS, the position pointer is read-only
   - LBR_SELECT to configure LBR is shared at the core-level on NHM

but it is very much worthwhile.

> Regarding the constraints - if we choose to expose the branch-type
> filtering capabilities of Nehalem, then that puts a constraint on
> counter scheduling: two counters with conflicting constraints should
> not be scheduled at once, but should be time-shared via the usual
> mechanism.
>
You need to expose the branch filtering in some way. The return
branch filter is useful for statistical call graph sampling, for instance.
If you can't disable the other types of branches, then the relevance
of the data drops.

> The typical use-case would be to have no or compatible LBR filter
> attributes between counters though - so having the conflicts is not
> an issue as long as it works according to the usual model.
>
Conflict arises when two events request different filter value. The conflict
happens in both per-thread and per-cpu mode when HT is on. In per-cpu
mode it can be controlled at the core level. But in per-thread mode, it
has to be managed globally as a thread may migrate. Multiplexing
as it is implemented manages groups attached to one thread or CPU.
Here it would have to look across a pair of CPUs (or threads) and
ensure that no two groups using LBR with conflicting filter selections
can be scheduled at the same time on the two hyper-threads of the
same core. I think it may be easier, for now, to say LBR_SELECT
is global, first come, first serve.
