Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZALRsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZALRsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZALRsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:48:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36851 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZALRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:48:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu>
	<49649C65.6000706@kernel.org>
	<200901101716.04220.rusty@rustcorp.com.au>
	<Pine.LNX.4.64.0901121120280.30369@quilx.com>
Date: Mon, 12 Jan 2009 09:44:58 -0800
In-Reply-To: <Pine.LNX.4.64.0901121120280.30369@quilx.com> (Christoph
	Lameter's message of "Mon, 12 Jan 2009 11:23:27 -0600 (CST)")
Message-ID: <m1mydwxvtx.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christoph Lameter <cl@linux-foundation.org>
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

Christoph Lameter <cl@linux-foundation.org> writes:

> On Sat, 10 Jan 2009, Rusty Russell wrote:
>
>> > As I was trying to do more stuff per-cpu
>> > (not putting a lot of stuff into per-cpu area but even with small
>> > things limited per-cpu area poses scalability problems), cpu_alloc
>> > seems to fit the bill better.
>>
>> Unfortunately cpu_alloc didn't solve this problem either.
>>
>> We need to grow the areas, but for NUMA layouts it's non-trivial.  I don't
>> like the idea of remapping: one TLB entry per page per cpu is going to suck.
>> Finding pages which are "congruent" with the original percpu pages is more
>> promising, but it will almost certainly need to elbow pages out the way to
>> have a chance of succeeding on a real system.
>
> An allocation automatically falls back to the nearest node on NUMA
> cpu_to_node() gives you the current node.
>
> There are 2M TLB entries on x86_64. If we really get into a high usage
> scenario then the 2M entry makes sense. Average server memory sizes likely
> already are way beyond 10G per box. The higher that goes the more
> reasonable the 2M TLB entry will be.

2M of per cpu data doesn't make sense, and likely indicates a design
flaw somewhere.  It just doesn't make sense to have large amounts of
data allocated per cpu.

The most common user of per cpu data I am aware of is allocating one
word per cpu for counters.

What would be better is simply to: 
- Require a lock to access another cpus per cpu data.
- Do large page allocations for the per cpu data.

At which point we could grow the per cpu data by simply reallocating it on
each cpu and updating the register that holds the base pointer.

Eric
