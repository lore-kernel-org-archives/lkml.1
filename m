Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbZJVOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbZJVOxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZJVOxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:53:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341AbZJVOxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:53:15 -0400
Message-ID: <4AE071DC.7020405@suse.com>
Date: Thu, 22 Oct 2009 10:53:16 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Luck, Tony" <tony.luck@intel.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <4ADD48D1.1040701@kernel.org> <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de> <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org> <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de> <4ADDC69A.5000701@suse.com> <4ADDCDED.6060706@suse.com> <20091021061109.GA27195@elte.hu> <4ADF2691.7070304@kernel.org> <57C9024A16AD2D4C97DC78E552063EA3E337CF79@orsmsx505.amr.corp.intel.com> <alpine.LSU.2.00.0910221640430.8582@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910221640430.8582@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2009 10:49 AM, Jiri Kosina wrote:
> On Wed, 21 Oct 2009, Luck, Tony wrote:
> 
>> But ... the architecturally supported page sizes go up by powers of 4, 
>> so next choice from 64K is 256K then 1M, 4M, etc.  This is also requires 
>> an edit of source code and re-compile.  We could easily make it a config 
>> option ... but that is still inconvenient.
>>
>> The bloat introduced by adding percpu variables is multiplied by NR_CPUS 
>> ... and in my case that is 4096.  It is easy to just shrug this off and 
>> say that such big systems have plenty of memory anyway, but the case 
>> that led to this issue (adding a percpu object that included a [NR_CPUS] 
>> array) shows that, IMHO, people are do not care enough about the bloat.
>>
>> I suspect that if I just increase the percpu area to 256K or 1M, I'll 
>> see this same issue when someone adds:
>>
>> struct foo {
>>        char buf[NR_CPUS][PAGE_SIZE];
>> };
>> DECLARE_PER_CPU(struct foo, bar);
>>
>> which needs 4k * 64k = 256M of per-cpu space ... i.e. 1T total.
>>
>> If such code is going to be deemed acceptable, then we do need
>> to move away from the ia64 TLB mapped percpu area.
> 
> Well, I must say I slightly agree that my gut feeling is that we should 
> try to avoid arrays which size depends on NR_CPUS as much as possible.

Agreed.

> Now, what to do for 2.6.32? We definitely need some kind of fix for this, 
> otherwise the Altix guys would kill us.
> 
> Tony, is the change that will eventually have to be made to ia64 pagefault 
> handler too intrusive for -rc6, and should we rather go with my workaround 
> instead, and try to find something proper for 2.6.33?

It's not an either-or situation. It's not really a workaround. Distros
configure NR_CPUS for the maximum possible for a given architecture even
though the majority of systems don't come close to it. We're just
wasting memory. I've seen other fixes that are just "make percpu xyz
dynamic" without much debate. I don't see why this one should be much
different other than the fact that the original report raised a red flag
about an implementation limitation.

Yes, the ia64 limitation should be revisited, but that is a separate issue.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
