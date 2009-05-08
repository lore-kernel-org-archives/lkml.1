Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZEHTN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZEHTN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZEHTNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:13:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36793 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZEHTNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:13:13 -0400
Message-ID: <4A048413.4060406@redhat.com>
Date: Fri, 08 May 2009 22:12:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com> <4A03EA83.6040907@redhat.com> <4A044DB5.7050304@novell.com> <4A046519.30604@redhat.com> <4A04802B.9000003@novell.com>
In-Reply-To: <4A04802B.9000003@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>> And likewise, in both cases, G1 would (should?) know what to do with
>>> that "address" as it relates to G2, just as it would need to know what
>>> the PIO address is for.  Typically this would result in some kind of
>>> translation of that "address", but I suppose even this is completely
>>> arbitrary and only G1 knows for sure.  E.g. it might translate from
>>> hypercall vector X to Y similar to your PIO example, it might completely
>>> change transports, or it might terminate locally (e.g. emulated device
>>> in G1).   IOW: G2 might be using hypercalls to talk to G1, and G1 might
>>> be using MMIO to talk to H.  I don't think it matters from a topology
>>> perspective (though it might from a performance perspective).
>>>   
>>>       
>> How can you translate a hypercall?  G1's and H's hypercall mechanisms
>> can be completely different.
>>     
>
> Well, what I mean is that the hypercall ABI is specific to G2->G1, but
> the path really looks like G2->(H)->G1 transparently since H gets all
> the initial exits coming from G2.  But all H has to do is blindly
> reinject the exit with all the same parameters (e.g. registers,
> primarily) to the G1-root context.
>
> So when the trap is injected to G1, G1 sees it as a normal HC-VMEXIT,
> and does its thing according to the ABI.  Perhaps the ABI for that
> particular HC-id is a PIOoHC, so it turns around and does a
> ioread/iowrite PIO, trapping us back to H.
>
> So this transform of the HC-id "X" to PIO("Y") is the translation I was
> referring to.  It could really be anything, though (e.g. HC "X" to HC
> "Z", if thats what G1s handler for X told it to do)
>   

That only works if the device exposes a pio port, and the hypervisor 
exposes HC_PIO.  If the device exposes the hypercall, things break once 
you assign it.

>>   Of course mmio is faster in this case since it traps directly.
>>
>> btw, what's the hypercall rate you're seeing? at 10K hypercalls/sec, a
>> 0.4us difference will buy us 0.4% reduction in cpu load, so let's see
>> what's the potential gain here.
>>     
>
> Its more of an issue of execution latency (which translates to IO
> latency, since "execution" is usually for the specific goal of doing
> some IO).  In fact, per my own design claims, I try to avoid exits like
> the plague and generally succeed at making very few of them. ;)
>
> So its not really the .4% reduction of cpu use that allures me.  Its the
> 16% reduction in latency.  Time/discussion will tell if its worth the
> trouble to use HC or just try to shave more off of PIO.  If we went that
> route, I am concerned about falling back to MMIO, but Anthony seems to
> think this is not a real issue.
>   

You need to use absolute numbers, not percentages off the smallest 
component.  If you want to reduce latency, keep things on the same core 
(IPIs, cache bounces are more expensive than the 200ns we're seeing here).



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

