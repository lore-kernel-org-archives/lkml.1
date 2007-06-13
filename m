Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXFMWUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXFMWUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbXFMWUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:20:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37671 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbXFMWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:20:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706061229.24486.jesse.barnes@intel.com>
	<m14plcpsjq.fsf@ebiederm.dsl.xmission.com>
	<200706121929.07527.jbarnes@virtuousgeek.org>
Date: Wed, 13 Jun 2007 16:19:04 -0600
In-Reply-To: <200706121929.07527.jbarnes@virtuousgeek.org> (Jesse Barnes's
	message of "Tue, 12 Jun 2007 19:29:07 -0700")
Message-ID: <m1zm33o5uv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> On Tuesday, June 12, 2007 6:11:21 Eric W. Biederman wrote:
>> Jesse Barnes <jesse.barnes@intel.com> writes:
>> > On some machines, buggy BIOSes don't properly setup WB MTRRs to
>> > cover all available RAM, meaning the last few megs (or even gigs)
>> > of memory will be marked uncached.  Since Linux tends to allocate
>> > from high memory addresses first, this causes the machine to be
>> > unusably slow as soon as the kernel starts really using memory
>> > (i.e. right around init time).
>> >
>> > This patch works around the problem by scanning the MTRRs at
>> > boot and figuring out whether the current end_pfn value (setup
>> > by early e820 code) goes beyond the highest WB MTRR range, and
>> > if so, trimming it to match.  A fairly obnoxious KERN_WARNING
>> > is printed too, letting the user know that not all of their
>> > memory is available due to a likely BIOS bug.
>>
>> A quick update.  This patch is horribly incorrect on a socket F
>> opteron/Athlon 64 with memory above 4GB.
>>
>> In particular those cpus are capable of mapping all of memory
>> above 4GB as write back without using a single MTRR.
>>
>> So examining MTRRs is insufficient.
>
> Hm, yuck.  What do you suggest?  Should we only run this check when Intel 
> chips are present?  Checking only the bottom 4G isn't sufficient since we've 
> seen platforms that have issues above that range...

My gut feel says that we need to call a function that is potentially cpu specific,
older AMD cpus and Intel cpus can just use the generic mtrr code.

I would also suggest we build a list of ranges of write-back memory.  Which
until we handle overlapping MTRRs in the generic MTRR case is just the write-back
MTRRs.

Then we get the data in a linux specific form we can check the linux specific
data structure against the e820 map.

I don't think that is going to much harder and it allows for creative cpu
designers.

Although this suggests that we want to worry about all memory holes as
well.  Because I have seen at least one system which failed to cover
the lower 4G with MTRRs.  While everything above 4G was fine.

Eric

