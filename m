Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbYI3I1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbYI3I1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYI3I1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:27:24 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:17936 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYI3I1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:27:23 -0400
Date: 30 Sep 2008 10:27:18 +0200
From: krzysztof.h1@poczta.fm
Subject: Re: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
To: Jeremy Fitzhardinge <jeremy@goop.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 83.17.101.58
X-Mailer: PSE
Message-Id: <20080930082719.1E680E435B6@f11.poczta.interia.pl>
X-EMID: 56840acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yinghai Lu wrote:
> > On Mon, Sep 29, 2008 at 11:14 PM, Jeremy Fitzhardinge <jeremy@goop.org>
> wrote:
> >   
> >> Krzysztof Helt wrote:
> >>     
> >>> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> >>>
> >>> The flag_is_changeable_p() is used by
> >>> has_cpuid_p() which can return different results
> >>> in the code sequence below:
> >>>
> >>>  if (!have_cpuid_p())
> >>>       identify_cpu_without_cpuid(c);
> >>>
> >>>   /* cyrix could have cpuid enabled via c_identify()*/
> >>>   if (!have_cpuid_p())
> >>>       return;
> >>>
> >>> Otherwise, the gcc 3.4.6 optimizes these two calls
> >>> into one which make the code not working correctly.
> >>> Cyrix cpus have the CPUID instruction enabled but
> >>> it is not detected due to the gcc optimization.
> >>> Thus the ARR registers (mtrr like) are not detected
> >>> on such a cpu.
> >>>
> >>>       
> >> If "asm volatile" changes the code and fixes the bug, it seems like
> >> you're making use of an undocumented - or at least non-portable -
> behaviour.
> >>

Why you call it undocumented. This is information you can find with "info gcc" in the Extendend Asm section:

If your assembler instructions access memory in an unpredictable
fashion, add `memory' to the list of clobbered registers.  This will
cause GCC to not keep memory values cached in registers across the
assembler instruction and not optimize stores or loads to that memory.
You will also want to add the `volatile' keyword if the memory affected
is not listed in the inputs or outputs of the `asm', as the `memory'
clobber does not count as a side-effect of the `asm'.  If you know how
large the accessed memory is, you can add it as input or output but if
this is not known, you should add `memory'.

> >> Does adding a "memory" clobber also fix the problem?  That would have
> >> better defined characteristics.
> >>

A changeable flag bit is hardly a memory side effect. IMO, the volatile attribute is better as it says that each evaluation may have a different results despite the inputs and outputs are the same.

> 
> The trouble is that flag_is_changeable_p() doesn't have any obvious
> global dependencies; it just takes a constant argument and returns a
> result.   The asm() needs to be updated to have a "memory" constraint as
> a stand-in for the specific constraint of "cpu has switched into
> cpuid-supporting state".
> 

See above about adding the memory constrain.

Kind regards,
Krzysztof

----------------------------------------------------------------------
Tanie i proste polaczenia telefoniczne!
Sprawdz >>  http://link.interia.pl/f1f23 


