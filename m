Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYD2MI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYD2MI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYD2MIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:08:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYD2MIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:08:48 -0400
Date: Tue, 29 Apr 2008 14:08:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080429120827.GB31271@elte.hu>
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429004739.GA23281@redhat.com> <481674FA.4030306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481674FA.4030306@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>> At least one complication though is that in the case of markers, 
>> tracing parameter evaluation is itself conditional (and placed out of 
>> the hot path due to -freorder-blocks).  With your suggested kind of 
>> assembly ("g" constraints for all the expressions), those expressions 
>> would be evaluated unconditionally, just to make them live somewhere. 
>> That unconditional evaluation can easily entail memory reads and 
>> dependent arithmetic, which could swamp the savings of eliminating 
>> the marker-style conditional branch.
>
> Well, it depends a bit on what kind of expressions you put in there. 
> You don't really want to put *expressions* in there as much as you 
> want to put *data* references in there, although, of course, if your 
> have something like "foo->bar[baz]->quux" then it's easy to trip upon.

and that's exactly what was tripped upon in sched.o and analyzed.

Furthermore, the suggestion of doing this exclusively within the DWARF2 
space - besides the not particularly minor complication of it not being 
implemented yet - is:

 - quite substantially complex on its own

 - would make Linux instrumentation dependent on all sorts of DWARF2
   details which we had our 'fun' with before. (I proffer that that's
   more fragile than any code patching can ever be.)

 - if done self-sufficiently (i.e. if a kernel image can be used to
   trace things, which i believe any usable kernel tracer must offer),
   it would, with the current debug info format, enlargen the kernel RAM
   image with quite a substantial amount of unswappable kernel memory. 

But i would not mind such a scheme at all (it is in essence SystemTap 
integrated into the core kernel) - in fact if your scheme gets 
implemented then the current marker facilities could be ported to that 
scheme transparently.

So i dont see how it can be a loss to stick with the current markers for 
the time being. If the super-optimized runtime patching in this thread 
is deemed too fragile we simply wont do that and live with the (small) 
runtime overhead that current markers have.

This is a sane plan IMO, basically all the instrumentation folks agree 
with it (SystemTap, LTTNG, kprobes, ftrace), the scheduler folks agree 
with it as well and we'd like to move on.

	Ingo
