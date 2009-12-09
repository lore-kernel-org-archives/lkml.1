Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbZLIID4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbZLIID4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZLIID4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:03:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:46879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbZLIIDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:03:55 -0500
Message-ID: <4B1F59EC.3030400@kernel.org>
Date: Wed, 09 Dec 2009 17:03:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] sched: implement force_cpus_allowed()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-5-git-send-email-tj@kernel.org>	 <1259923259.3977.1928.camel@laptop> <1259923381.3977.1934.camel@laptop>	 <4B1C85D3.3080401@kernel.org> <1260174900.8223.1159.camel@laptop>	 <4B1CDA1C.3000802@kernel.org> <1260183278.8223.1500.camel@laptop>	 <4B1CE1E8.2070803@kernel.org>  <4B1E1130.9050108@kernel.org>	 <1260262963.3935.1002.camel@laptop>  <4B1E189B.1070204@kernel.org>	 <1260268453.3935.1106.camel@laptop>  <4B1E378A.5050101@kernel.org>	 <1260272885.3935.1189.camel@laptop>  <4B1E3EE0.7030001@kernel.org>	 <1260274232.3935.1223.camel@laptop>  <4B1E4548.5040408@kernel.org>	 <1260279351.3935.1375.camel@laptop>  <4B1F34B6.3090107@kernel.org> <1260344486.5489.38.camel@laptop>
In-Reply-To: <1260344486.5489.38.camel@laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/09/2009 04:41 PM, Peter Zijlstra wrote:
> On Wed, 2009-12-09 at 14:25 +0900, Tejun Heo wrote:
>> As for the force_cpus_allowed() bit, I think it's a rather natural
>> interface to have and maybe we can replace kthread_bind() with it or
>> make kthread_bind() in terms of it.  It's the basic migration function
>> which adheres to the cpu hot plug/unplug synchronization rules.
> 
> I quite disagree, its quite unnatural to be adding threads to a cpu that
> is about to go down or about to come up for that matter, and we most
> certainly don't want to add to the hotplug rules, there are quite enough
> of them already.

I don't think it adds to hotplug rules in any way.  While cpu is going
down, there's this single atomic moment when all threads are taken off
the cpu and that's the natural synchronization point.  You can add
more restrictions on top of that like the cpu activeness test to avoid
certain desirable behavior but in the end the natural ultimate sync
point is the final migration off the cpu.  That said, let's agree to
disagree here.  We're talking about what's being 'natural' and it
depends largely on personal POVs, right?

> You could always do it from CPU_ONLINE, since they don't care about
> cpu-affinity anyway (the thing was down for crying out loud), it really
> doesn't matter when they're moved back if at all.
> 
> I still think its utter insanity to even consider moving them back, or
> for that matter to have worklets that take minutes to complete, that's
> just daft.
>
> I think I'm going to NAK all this, it looks quite ill conceived.

Alright, fair enough.  So, I get that you NACK the whole concurrency
managed workqueue thing.  The reason why this part was split out and
sent separately for scheduler tree was that because I thought there
was general consensus toward having concurrency managed workqueues and
its basic design.  It looks like we'll need to have another round
about that.

Here's what I'll do.  I'm about done with the second round, properly
split cmwq patches.  It's feature complete and should be able to
replace existing workqueue implementation without any problem (well,
theoretically).  I'll send them as a whole series with these scheduler
patches and cc all the interested people and explain Ingo's concern
about notification framework and your general objection to the whole
thing.  Let's continue there, okay?

Thanks.

-- 
tejun
