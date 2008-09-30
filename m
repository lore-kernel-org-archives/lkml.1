Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYI3PXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYI3PXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYI3PXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:23:40 -0400
Received: from gw.goop.org ([64.81.55.164]:42049 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbYI3PXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:23:40 -0400
Message-ID: <48E24476.90402@goop.org>
Date: Tue, 30 Sep 2008 08:23:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: krzysztof.h1@poczta.fm
CC: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
References: <20080930082719.1E680E435B6@f11.poczta.interia.pl>
In-Reply-To: <20080930082719.1E680E435B6@f11.poczta.interia.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

krzysztof.h1@poczta.fm wrote:
> If your assembler instructions access memory in an unpredictable
> fashion, add `memory' to the list of clobbered registers.  This will
> cause GCC to not keep memory values cached in registers across the
> assembler instruction and not optimize stores or loads to that memory.
> You will also want to add the `volatile' keyword if the memory affected
> is not listed in the inputs or outputs of the `asm', as the `memory'
> clobber does not count as a side-effect of the `asm'.  If you know how
> large the accessed memory is, you can add it as input or output but if
> this is not known, you should add `memory'.
>   

Yes, you're right.  The pertinent part of the manual is:

    The `volatile' keyword indicates that the instruction has important
    side-effects.  GCC will not delete a volatile `asm' if it is reachable.
    (The instruction can still be deleted if GCC can prove that
    control-flow will never reach the location of the instruction.)  Note
    that even a volatile `asm' instruction can be moved relative to other
    code, including across jump instructions.
      

I normally do my "asm volatile" rant when people try to use it to
enforce ordering, but in this case we just want gcc to not elide the
second use.

So, yes, I think your patch is fine as-is, but it would be worth adding
a comment on the asm (its not necessarily obvious that the
cpuid-capability of a cpu can change).

    J
