Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXLAXp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXLAXp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXLAXpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:45:51 -0500
Received: from gw.goop.org ([64.81.55.164]:51255 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbXLAXpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:45:50 -0500
In-Reply-To: <20071129194416.GB15245@elte.hu>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F01F6.2030509@zytor.com> <alpine.LFD.0.9999.0711291027070.8458@woody.linux-foundation.org> <474F08E1.2090806@zytor.com> <alpine.LFD.0.9999.0711291057320.8458@woody.linux-foundation.org> <474F1027.2020801@zytor.com> <20071129192721.GP24223@one.firstfloor.org> <20071129194416.GB15245@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0E451C72-3F30-4921-8C1B-60754899B19E@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, zach@vmware.com
Content-Transfer-Encoding: 7bit
From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
Date: Sat, 1 Dec 2007 18:44:10 -0500
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29, 2007, at 2:44 PM, Ingo Molnar wrote:

>
> * Andi Kleen <andi@firstfloor.org> wrote:
>
>> For i386 iirc Jeremy/Zach did the benchmarking and they settled on  
>> %fs
>> because it was faster for something (originally it was %gs too)
>
> yep. IIRC, some CPUs only optimize %fs because that's what Windows  
> uses
> and leaves Linux with %gs out in the cold.

I did measure some anomalies with the AMD K6+ (or something like  
that), in which %gs was faster than %fs.  It was pretty much  
inexplicable, but also unique - all other processors I tested (which  
was a range from Pentium MMX to current) had identical performance.

> There's also a performance
> penalty for overlapping segment use, if the segment cache is single
> entry only with an additional optimization for NULL [which just hides
> the segment cache].

Some processors do perform slightly better with null selector loads  
than GDT/LDT ones, but it wasn't really noticeable for modern  
processors.  The Intel architecture guy I asked about this said that  
it might be worth doing, but it would likely be swamped by a GDT  
cache miss.  I looked at rearranging the kernel's GDT to pack all the  
kernel entry/exit entries into as few cachelines as possible, but it  
was surprisingly fiddley.

> But if it's good for unification we could switch that to %gs again on
> 32-bit. I was one of the people who advocated the use of the 'other'
> segment register, so that the hardware has less overlap, but clean and
> unified code trumps this concern. It shouldnt be an issue on  
> reasonably
> modern CPUs anyway.

Well, overall it should be fairly easy to make the two arches use  
their own segment registers with a simple #define.  But things like  
ptrace and vm86 were tricky, though I guess the latter isn't an issue  
for 64-bit.

I originally chose %gs for the kernel, partly in the hope that  
compiler support for TLS would be helpful in the kernel, though that  
doesn't seem like a good idea in retrospect.  %gs for the sake of  
consistency would be reasonable, and wouldn't have a measurable  
downside.

	J
