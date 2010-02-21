Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0BUFhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 00:37:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51211 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab0BUFhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 00:37:54 -0500
Message-ID: <4B80C699.1030302@zytor.com>
Date: Sat, 20 Feb 2010 21:37:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
References: <20100114002118.436172066@sbs-t61.sc.intel.com>      <20100114002118.521826763@sbs-t61.sc.intel.com>         <alpine.LFD.2.00.1001240545180.13034@eddie.linux-mips.org>      <4B5C00EB.3000208@zytor.com>    <alpine.LFD.2.00.1001310705280.31764@eddie.linux-mips.org> <1265059497.2802.178.camel@sbs-t61.sc.intel.com> <4B674C82.9050703@zytor.com> <alpine.LFD.2.00.1002210438220.1146@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1002210438220.1146@eddie.linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2010 09:20 PM, Maciej W. Rozycki wrote:
> 
>  Correct, the problem only affected B1, B3 and B5 steppings of the P54C 
> Pentium processor.  These are probably extremely rare these days.  It was 
> fixed later on.
> 
>  But they can be run-time detected -- if we don't support them anymore 
> (assuming keeping them supported is too much of maintenance hassle; Linux 
> used to be proud to support hardware nobody else seemed to care of 
> anymore, so it's really disappointing to see it go), we should panic() on 
> bootstrap and print an appropriate message.  They are CPUID family 5, 
> model 2 and steppings 1, 2 and 4, respectively.
> 
>  Also the note in arch/x86/kernel/smp.c should be adjusted accordingly 
> stating that the erratum is no longer worked around (preferably stating 
> the last Linux version it was).
> 

My philosophy is generally that I'm happy to keep old hardware (that
actually exist in any kind of meaningful quantity) alive, but I'm not
willing to go through herculean efforts nor willing to make widely
available modern hardware suck over it.

It looks like this really isn't too hard to deal with, though.

>  I'm not sure how fatal for Linux the implications are though; even then 
> it looks to me the approach we took was an overkill.  It's enough to 
> guarantee that the APIC error interrupt, the APIC timer interrupt and 
> self-IPIs (do we use any at all though?) do not share their priority 
> level(s) with any external interrupt (but they can share the level with 
> one another).  We only use ever LINT0/1 interrupts as NMIs (for the NMI 
> watchdog and the system error, respectively), or ExtINT (in the case of 
> LINT0), so this erratum does not apply to them.

The APIC error is on vector 0xfe, the APIC timer is on vector 0xef, and
self IPI (vector 0xeb) we only use for MCA, which wouldn't be supported
on these processors.

However, these are mixed with externally-generated IPIs which will be
seen as serial interrupts: in particular 0xf0-0xfd are all different IPI
which share with the error vector 0xde, and 0xeb shares with 0xed is
used for "platform" IPIs.

It sounds like the right solution for supporting these processors would
be to reshuffle the special vectors so that we use one level (presumably
0xfx) for locally generated interrupts and one (presumably 0xex) for
external IPIs, and make sure that it is not possible for external
interrupts to get assigned to the local-only level.  The assignment of
external interrupts, which seems to be where focus has been in the past,
is actually irrelevant (but might still be good for performance, by
maximizing the number of interrupts that can be held in the LAPIC and
not bounced.)

Either way, this doesn't exactly sound too bad.  A bigger question is if
we want to do this globally or end up having different vector
assignments for these oddball CPUs.  Testing it, too, will be almost
impossible...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

