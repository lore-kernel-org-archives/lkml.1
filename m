Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYCJSgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYCJSgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYCJSgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:36:47 -0400
Received: from gw.goop.org ([64.81.55.164]:49414 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYCJSgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:36:46 -0400
Message-ID: <47D57F86.2020806@goop.org>
Date: Mon, 10 Mar 2008 11:35:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Hugh Dickins <hugh@veritas.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <87myp68r88.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803101707070.3398@blonde.site> <47D57056.3050204@goop.org> <20080310175305.GC7692@one.firstfloor.org>
In-Reply-To: <20080310175305.GC7692@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>   1. Xen marks the whole page as being of pgd-type, and so it can't
>>      have non-pgd contents (as the page would be RO, and any contents
>>      would be validated as pgd entries).  However I can fix that by
>>     
>
> That sounds more like a Xen bug. Why should it validate anything except
> the first four entries which are used by the hardware? 
>
> I can imagine that false sharing would be slow because you would
> have unnecessary traps, but it shouldn't be a correctness issue.
>   

Yeah, the most fundamental problem is that the whole page is RO, so even 
if Xen trapped and emulated, it still makes a very bad neighbour.  I was 
also going to say that there's no reason why you couldn't pack multiple 
pgds into one page, but I think we can only specify the cr3 at page 
resolution anyway.

>>      maintaining a separate per-cpu pgd page, and just copy the four
>>      entries over when cr3 is reloaded.  This would move the
>>      Xen-specific requirements into the Xen code without affecting the
>>      rest of the kernel.
>>     
>
> x86-64 used to do that, but it turned out this breaks some shared cache 
> optimizations on the P4 between SMT threads. So you might actually see 
> user space performance regressions from it.
>   

Hm, given that Xen doesn't make any topology guarantees about vcpus, I 
don't think it would make much difference.  I think it would only be 
observable if you actually pinned the vcpus to physical siblings.  
Besides we could easily maintain sibling info and look to see if we're 
about to reload cr3 to match the other thread(s), then just use the same 
pgd copy.

    J
