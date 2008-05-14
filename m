Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYENGAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYENGAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYENGAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:00:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:45088 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYENGAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:00:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w8+bM0lJQOKHaocuf1XmP/2ozU48sEiyCrINpYnnTIjhqk2Umi3NCQpDZcUcI9H/v0gPscUYlImSwupDAdGZVYfUMIcWX/N+bYIIJN0EJ7/bkLWHjOJbQJ6kSn3IA7v8smzRwDgpfU2b4WwHBlXA1UuViGgQPlyuAlqwFItl8fA=
Message-ID: <19f34abd0805132300p65527be7v46ee206d8b2b57d3@mail.gmail.com>
Date: Wed, 14 May 2008 08:00:06 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "=?UTF-8?Q?\"S.=C3=87a=C4=9Flar_Onur\"?=" <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, "Matt Mackall" <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org
In-Reply-To: <482A05F3.7020408@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513204206.GA17781@damson.getinternet.no>
	 <873aol9b73.fsf@basil.nowhere.org>
	 <19f34abd0805131409w2914fbedgb608c7b87c234e2e@mail.gmail.com>
	 <482A05F3.7020408@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 11:19 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>  > The desktop is a P4:
>  >
>  > processor       : 0
>  > vendor_id       : GenuineIntel
>  > cpu family      : 15
>  > model           : 6
>  > model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
>  > stepping        : 5
>  > cpu MHz         : 2992.624
>  > cache size      : 2048 KB
>
>
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
>  > mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
>  > lm constant_tsc pebs bts pni monitor ds_cpl est tm2 cid cx16 xtpr
>  > lahf_lm
>  > bogomips        : 5990.81
>  > clflush size    : 64
>  >
>  > (similar for processor 1)
>  >
>  > # msr
>  > 0
>
>  Ok the CPU reports it doesn't support any C states in MWAIT. If that is
>  correct then it would be correct to not use MWAIT idle and might
>  actually save more power to not use it.
>
>  I don't know if that's true or not. Do you have a power meter perhaps?
>  If yes can you measure if there's a difference between mwait=idle /
>  default on your box when it is idle?
>
>  [cc Arjan he might now if that CPU is supposed to support C1 in MWAIT]

No, sorry, no power meter :-/

>  > The laptop is a Pentium Dual-Core:
>  >
>  > processor       : 0
>  > vendor_id       : GenuineIntel
>  > cpu family      : 6
>  > model           : 15
>  > model name      : Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
>  > stepping        : 13
>  > cpu MHz         : 800.000
>  > cache size      : 1024 KB
>  ...
>
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
>  > cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
>  > constant_tsc arch_perfmon pebs bts pni monitor ds_cpl est tm2 ssse3
>  > cx16 xtpr lahf_lm
>  > bogomips        : 2930.23
>  > clflush size    : 64
>  >
>  > (similar for processor 1)
>  >
>  > # ./msr
>  > 1110
>
>  CPU reports it supports C1/C2/C3. Are you sure there is a difference on
>  that box? The code should have kept using MWAIT because it checks C1.
>  Please double check.

Yes, sorry, you are correct. I tested the idle=mwait only on the
desktop machine (P4, msr = 0), and it improved the IPI problem. (I
even rechecked right now, and it really does.)

Now I tested it on the laptop as well, and here it makes no difference.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
