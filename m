Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZAMESP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZAMESP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 23:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZAMER7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 23:17:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42402 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbZAMER6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 23:17:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu>
	<49649C65.6000706@kernel.org>
	<200901101716.04220.rusty@rustcorp.com.au>
	<Pine.LNX.4.64.0901121120280.30369@quilx.com>
	<m1mydwxvtx.fsf@frodo.ebiederm.org> <496BE157.2000009@kernel.org>
	<m1y6xfx62a.fsf@frodo.ebiederm.org> <496C071F.3000408@kernel.org>
Date: Mon, 12 Jan 2009 20:07:38 -0800
In-Reply-To: <496C071F.3000408@kernel.org> (Tejun Heo's message of "Tue, 13
	Jan 2009 12:14:39 +0900")
Message-ID: <m1k58zx305.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: regarding the x86_64 zero-based percpu patches
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Eric.
>
> Eric W. Biederman wrote:
>> Right, there are cases where you could hit 2MB but they aren't likely
>> to be that common.
>> 
>> In particular the common case is to allocate a single word of per
>> cpu data, with a given allocation request.  To get 2 2MB with
>> 8byte requests requires 262144 different, which is a lot
>> more than I expect to be common any time soon.
>> 
>> So I figure reserving a 2MB tlb entry is not likely what we want,
>> in the common case.
>
> Yeap, it probably won't hit 2MB in common cases but it still needs to
> scale for uncommon cases and if 4K TLB pressure becomes too high for
> such cases, promoting to 2MB TLB makes sense for those.  IIUC, that's
> what Christoph Lameter is intending to do (haven't looked at the code
> yet tho).
>
>>>> The most common user of per cpu data I am aware of is allocating one
>>>> word per cpu for counters.
>>>>
>>>> What would be better is simply to: 
>>>> - Require a lock to access another cpus per cpu data.
>>>> - Do large page allocations for the per cpu data.
>>>>
>>>> At which point we could grow the per cpu data by simply reallocating it on
>>>> each cpu and updating the register that holds the base pointer.
>>> I don't think moving live objects is such a good idea for the
>>> following reasons.
>>>
>>> 1. Programming convenience is usually much more important than people
>>>    think it is.  Even in the kernel.  I think it's very likely that
>>>    we'll have unending stream of small feature requirements which
>>>    would step just outside the supported bounds and ever smart
>>>    workaround until the restriction is finally removed years later.
>> 
>>> 2. Moving live objects is inherently dangerous + it won't happen
>>>    often.  Thinking about possible subtle bugs is scary.
>> 
>> But the question is what is per cpu memory.  Per cpu memory is
>> something we can access quickly without creating cross cpu
>> cache line contention.
>> 
>> Accessing that memory from other cpus implies we create that
>> contention and will be the slow path.   We need to do cross
>> cpu access for the rollup of the statistics, but we clearly
>> don't want to do it often.
>> 
>> So I expect most times we will want to store a pointer to per
>> cpu data will be a bug. 
>> 
>> per cpu memory is not something we ever want to use to lightly.
>> So as long as the rules are clear we should be ok.  And simply
>> removing the address of function for per cpu data would make it impossible
>> to point into it.  So I think it is worth a look, to see if we can
>> move live per cpu data.  As it noticeably simplifies the problem of
>> growing a per cpu area in the rare case when we need to.
>
> I don't know.  I think it's a dangerous thing which can be avoided.
> If there's no other solution, then we might have to live with it but I
> don't see the winning benefit of such design over per-cpu virtual
> mapping.

It isn't incompatible with a per-cpu virtual mapping.  It allows the
possibility of each cpu reusing the same chunk of virtual address
space for per cpu memory.

On x86_64 and other architectures with enough address space bits it allows
us to share the large pages that we use for the normal memory mapping with
the ones for per cpu access.

I definitely think the work of combining the pda and the percpu areas
into a common area is worthwhile.

I think it would be nice if the percpu area could grow and would not be
a fixed size at boot time, I'm not particularly convinced it has to.

Eric

