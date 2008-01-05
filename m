Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYAESKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYAESKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 13:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbYAESKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 13:10:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:15992 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbYAESKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:10:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,248,1196668800"; 
   d="scan'208";a="273391025"
Message-ID: <477FC78F.6060109@linux.intel.com>
Date: Sat, 05 Jan 2008 10:08:15 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com> <477F2697.5050407@goop.org> <477FC613.7020807@linux.intel.com>
In-Reply-To: <477FC613.7020807@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Jeremy Fitzhardinge wrote:
>> Arjan van de Ven wrote:
>>> This patch moves WARN_ON() out of line entirely. I've considered keeping
>>> the test inline and moving only the slowpath out of line, but I decided
>>> against that: an out of line test reduces the pressure on the CPUs
>>> branch predictor logic and gives smaller code, while a function call
>>> to a fixed location is quite fast. Likewise I've considered doing
>>> something
>>> similar to BUG() (eg use a trapping instruction) but that's not really
>>> better (it needs the test inline again and recovering from an invalid
>>> instruction isn't quite fun).
>>
>> Power implements WARN_ON this way, and all the machinery is in place to
>> generically implement WARN_ON that way if you want.  It does generate
>> denser code than the call (since its just a single trapping instruction
>> with no need for argument setup), and the performance cost of the trap
>> shouldn't matter if warnings are rare (which one would hope).
> 
> I just did an experiment with this to see how much is on the table. I made
> a file with 1024 WARN_ON()'s (new style, eg the out of line call) and 
> 1024 BUG_ON()'s,
> which on i386 already use the trap.
> This shows that the BUG_ON() case is 2Kb shorter in generated code. From 
> this 2Kb you
> need to subtract all the code size that is needed to deal with the trap 
> and the module
> merging/unmerging of trap points etc etc, so lets say that a total of 
> 1Kb is left on the table.
> HOWEVER, if you have a module with, say, only 4 WARN_ON()/BUG_ON()'s, 
> you actually LOOSE
> 48 bytes, because of the extra overhead of how the trap data is stored.
> 
> So... call me unconvinced for now. There's 30 Kb on the table with the 
> easy, obviously safe
> transform, and maybe another 1Kb with the much more tricky trapping 
> scenario, but only
> for the vmlinux case; the module case seems to be a loss instead.
> 
> 
Eh I have to retract my math here; I used a slightly older version of the WARN_ON patch series.
(before Ingo's suggestion)
In the new model, even at 1024 the out of line WARN_ON function call is smaller than the BUG_ON method.

So I think that at least for x86, it's a loss to do what you suggest....

