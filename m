Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbXJDDBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbXJDDBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 23:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXJDDB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 23:01:28 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34729 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbXJDDB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 23:01:27 -0400
Date: Wed, 03 Oct 2007 20:59:49 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: File corruption when using kernels 2.6.18+
In-reply-to: <fa.PzpJEEoLXfC+eOQZjTWjdf9vdnE@ifi.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Neil Romig <neil@romig.demon.co.uk>,
       linux-kernel@vger.kernel.org, hyoshiok@miraclelinux.com,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <47045725.1070900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.VCoGTwbB+qeNlkBJ24MiuXcGSRA@ifi.uio.no>
 <fa.R+FhT6IGmV/dDweUt/MdSeA5YbQ@ifi.uio.no>
 <fa.7MxTIt/ik0uRFN/lMWUasYV/JyE@ifi.uio.no>
 <fa.YJ4uCPzXT5TQElSosyz98cpuMSc@ifi.uio.no>
 <fa.Tp9UUX9EYprQyLg0shgH1YG9DDM@ifi.uio.no>
 <fa.PzpJEEoLXfC+eOQZjTWjdf9vdnE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 3 Oct 2007, Pekka Enberg wrote:
>> On 10/3/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> I would bet that the reason the intel-optimized memcpy triggers this is
>>> that the non-temporal stores just means that you go out directly on the
>>> bus, and it probably just shows a weakness in the chipset or bus that
>>> doesn't show with the normal cacheline accesses.
>> But that should show up with memtest too, no?
> 
> Not unless memtest uses non-temporal stores with the same (or similar) 
> access patterns.
> 
> The thing is, the CPU cache hides a *lot* of activity from the chipset, 
> and changes the access patterns radically. 
> 
> With normal cached accesses, you'd normally see just the "fill cacheline" 
> and "write out cacheline" pattern. With movnt, you'd see non-cacheline 
> accesses to memory. If the chipset was tested under mostly normal loads, 
> the movnt cases have been getting a lot less coverage.
> 
> Now, I do agree that it certainly *can* be a CPU bug too.  I doubt it, 
> though. 
> 
> I'd check the power supply (brownouts cause random corruption, and it 
> might have a "peak power pattern" thing to it), and it's worth re-seating 
> any DIMM's etc. And it's definitely worth going into the BIOS setup screen 
> and making sure that nothing is even close to debatable (ie take RAM 
> timings down to non-aggressive levels, make sure bus frequencies and 
> multipliers are not even close to borderline, etc etc).

I didn't see what CPU this was, but there was this nasty erratum on some 
Athlon 64/Opteron processors. I was trying to debug a problem someone 
else mentioned a while ago (and which I could duplicate on my system) 
where doing huge memsets in userspace (which glibc uses non-temporal 
stores for) repeatedly would cause a system lockup or crash. Amazingly 
enough after I upgraded the CPU from my old Athlon 64 3500+ to a new X2 
4200+ the problem went away..

At the time I looked into whether this workaround could be applied in 
the kernel if the BIOS failed to, but it seemed that accesses to the MSR 
they mentioned failed, so I don't know what the story is..

from 
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf 


Erratum 97: 128-Bit Streaming Stores May Cause Coherency Failure
Description: Under a specific set of internal pipeline conditions, stale 
data may be left in the L1 cache when a 128-bit streaming store (MOVNT*) 
to a writeback (WB) memory type misses in the L1 data cache and both L1 
and L2 TLBs.
Potential Effect on System
Memory coherence failures leading to unpredictable operation.
Suggested Workaround
BIOS should set DC_CFG.DIS_CNV_WC_SSO (bit 3 of MSR 0xC001_1022). The 
performance effects of setting this bit are limited to streaming stores 
to the write-combining (WC) memory type, a case expected to rarely occur 
in actual usage. No loss of performance occurs in the general case (WB 
memory type).
This workaround must not be applied to processors prior to revision C0.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

