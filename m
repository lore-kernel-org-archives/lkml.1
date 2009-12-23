Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZLWNfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZLWNfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 08:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZLWNfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 08:35:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40592 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZLWNfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 08:35:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B321C2A.80805@s5r6.in-berlin.de>
Date: Wed, 23 Dec 2009 14:33:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org>	 <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org>	 <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org>	 <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org>	 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>	 <20091223060229.GA14805@elte.hu>  <4B31B508.5040903@garzik.org> <1261557674.4937.117.camel@laptop> <4B31F028.7060209@garzik.org>
In-Reply-To: <4B31F028.7060209@garzik.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On 12/23/2009 03:41 AM, Peter Zijlstra wrote:
>> On Wed, 2009-12-23 at 01:13 -0500, Jeff Garzik wrote:
>>> We are dealing with situations where drivers are using workqueues to
>>> provide a sleep-able context, and trying to solve problems related to
>>> that.
>>
>> So why are threaded interrupts not considered? Isn't the typical atomic
>> context of drivers the IRQ handler?
> 
> 
> I don't see a whole lot of driver authors rushing to support threaded
> interrupts.  It is questionable whether the myriad crazy IDE interrupt
> routing schemes are even compatible.  Thomas's Mar 23 2009 email says
> "the primary handler must disable the interrupt at the device level"
> That is not an easy request for all the hardware libata must support.
> 
> But the most obvious reason is also the most compelling:  Tejun's work
> maps precisely to libata's needs.  And his work would seem to mesh well
> with other drivers in similar situations.

Exactly; threaded interrupts are not a solution for much of what
workqueues, slow-work, async... are used for and cmwq would be (more)
useful for.

In case of FireWire for example, each FireWire bus ( = FireWire link
layer controller) is associated with a single interrupt handler, yet
contains several DMA units for very different purposes (input vs.
output, isochronous vs. asynchronous); but more importantly, one link
layer controller is merely the gateway to 0...n FireWire peer nodes
(cameras, storage devices etc.).  Everything of what happens at a
somewhat higher level needs concurrency per FireWire peer, not per
FireWire bus.
-- 
Stefan Richter
-=====-==--= ==-- =-===
http://arcgraph.de/sr/
