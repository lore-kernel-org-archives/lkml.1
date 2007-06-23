Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbXFWQlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbXFWQlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbXFWQln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:41:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857AbXFWQlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:41:42 -0400
Date: Sat, 23 Jun 2007 09:39:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: mingo@elte.hu, cebbert@redhat.com, jarkao2@o2.pl, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <E1I22yO-0004TX-00@dorka.pomaz.szeredi.hu>
Message-ID: <alpine.LFD.0.98.0706230933360.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621201624.GD22303@elte.hu> <20070622081702.GA14746@elte.hu>
 <E1I22yO-0004TX-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Jun 2007, Miklos Szeredi wrote:
> 
> What I notice is that the interrupt distribution between the CPUs is
> very asymmetric like this:
> 
>            CPU0       CPU1
>   0:     220496         42   IO-APIC-edge      timer
>   1:       3841          0   IO-APIC-edge      i8042
...
> LOC:     220499     220463
> ERR:          0
> 
> and the freezes don't really change that.  And the NMI traces show,
> that it's always CPU1 which is spinning in wait_task_inactive().

Well, the LOC thing is for the local apic timer, so while regular 
interrupts are indeed very skewed, both CPU's is nicely getting the local 
apic timer thing..

That said, the timer interrupt generally happens just a few hundred times 
a second, and if there's just a higher likelihood that it happens when the 
spinlock is taken, then half-a-second pauses could easily be just because 
even when the interrupt happens, it could be skewed to happen when the 
lock is held.

And that definitely is the case: the most expensive instruction _by_far_ 
in that loop is the actual locked instruction that acquires the lock 
(especially with the cache-line bouncing around), so an interrupt would be 
much more likely to happen right after that one rather than after the 
store that releases the lock, which can be buffered.

It can be quite interesting to look at instruction-level cycle profiling 
with oprofile, just to see where the costs are..

		Linus


