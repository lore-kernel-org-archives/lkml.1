Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZCMJFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZCMJFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZCMJFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:05:10 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:27995 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZCMJFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:05:07 -0400
X-BigFish: VPS-26(z6cekz1418M1432R98dR1805M936fK19c2kzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KGFT83-02-E9U-01
Date: Fri, 13 Mar 2009 10:04:50 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       trenn@suse.de, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090313090450.GK20716@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com> <20090312163937.GH20716@alberich.amd.com> <20090313015856.GA18760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090313015856.GA18760@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Mar 2009 09:04:52.0560 (UTC) FILETIME=[C5444500:01C9A3BA]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 02:58:56AM +0100, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Impact: bug fix + BIOS workaround
> 
> > Change to previous version:
> > I slightly modified the log message (e.g. addition of FW_WARN).
> > 
> > Please consider to apply this patch for .29.
> 
> i've applied it to tip:x86/mtrr, thanks Andreas.
> 
> I've add a -stable backport tag - so if it's problem-free it 
> should show up in .29.1.

That should suffice.

> It is not completely clear what the impact of this fix is. What 
> types of problems are such incoherent MTRR settings causing in 
> practice?

I admit the commit message is not that explanatory ...

(1) The patch modifies an old fix from Bernhard Kaindl to get
    suspend/resume working on some Acer Laptops. Bernhard's patch
    tried to sync RdMem/WrMem bits of fixed MTRR registers and that
    helped on those old Laptops. (Don't ask me why -- can't test it
    myself). But this old problem was not the motivation for the
    patch. (See http://lkml.org/lkml/2007/4/3/110)

(2) The more important effect is to fix issues on some more current systems.

    On those systems Linux panics or just freezes, see

    http://bugzilla.kernel.org/show_bug.cgi?id=11541
    (and also duplicates of this bug:
    http://bugzilla.kernel.org/show_bug.cgi?id=11737
    http://bugzilla.kernel.org/show_bug.cgi?id=11714)

    The affected systems boot only using acpi=ht, acpi=off or
    when the kernel is built with CONFIG_MTRR=n.

    The acpi options prevent full enablement of ACPI.  Obviously when
    ACPI is enabled the BIOS/SMM modfies RdMem/WrMem bits.  When
    CONFIG_MTRR=y Linux also accesses and modifies those bits when it
    needs to sync fixed-MTRRs across cores (Bernhard's fix, see (1)).
    How do you synchronize that? You can't. As a consequence Linux
    shouldn't touch those bits at all (Rationale are AMD's BKDGs which
    recommend to clear the bit that makes RdMem/WrMem accessible).
    This is the purpose of this patch. And (so far) this suffices to
    fix (1) and (2).

> Boot hang? S2RAM failures? Performance problems?

for (1) S2RAM and S2DISK failures.
for (2) boot hang

> Without knowing the exact impact we cannot apply it this late in 
> the .29.0 cycle - and MTRR code change are dangerous in any case 
> so even if we knew the exact scope and impact we'd probably not 
> do it in .29.

Fine with me (although I think that it's safest not to touch the two
bits at all from the OS as we don't know what the BIOS wants to do
with them).


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


