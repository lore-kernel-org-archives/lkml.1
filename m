Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZCLLmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZCLLmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZCLLmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:42:38 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34535 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753196AbZCLLmg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:42:36 -0400
X-BigFish: VPS-32(z6cekz1432R98dR1805M936fK9371Pzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KGE5SW-01-3L0-01
Date: Thu, 12 Mar 2009 12:41:21 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       trenn@suse.de
Subject: Re: [PATCH] x86: mtrr: don't modify RdDram/WrDram bits of fixed
	MTRRs
Message-ID: <20090312114121.GF20716@alberich.amd.com>
References: <20090311150027.GK10490@alberich.amd.com> <86802c440903120101o2a0c1ad0iec395c45f782078a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <86802c440903120101o2a0c1ad0iec395c45f782078a@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Mar 2009 11:41:22.0366 (UTC) FILETIME=[779D35E0:01C9A307]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 01:01:26AM -0700, Yinghai Lu wrote:
> On Wed, Mar 11, 2009 at 8:00 AM, Andreas Herrmann
> <andreas.herrmann3@amd.com> wrote:
> > BIOS is expected to clear the SYSCFG[MtrrFixDramModEn] on AMD CPUs after
> > fixed MTRRs are configured.
> >
> > Some BIOSes do not clear SYSCFG[MtrrFixDramModEn] on BP (and on APs).
> >
> > This can lead to obfuscation in Linux when this bit is not cleared on
> > BP but cleared on APs. A consequence of this is that the saved
> > fixed-MTRR state (from BP) differs from the fixed-MTRRs of APs --
> > because RdDram/WrDram bits are read as zero when
> > SYSCFG[MtrrFixDramModEn] is cleared -- and Linux tries to sync
> > fixed-MTRR state from BP to AP. This implies that Linux sets
> > SYSCFG[MtrrFixDramEn] and activates those bits.
> >
> > More important is that (some) systems change these bits in SMM when
> > ACPI is enabled. Hence it is racy if Linux modifies RdMem/WrMem bits,
> > too.
> >
> > I suggest not to touch RdDram/WrDram bits of fixed-MTRRs and
> > SYSCFG[MtrrFixDramEn] and to clear SYSCFG[MtrrFixDramModEn] as
> > suggested by AMD K8, and AMD family 10h/11h BKDGs.
> > BIOS is expected to do this anyway. This should avoid that
> > Linux and SMM tread on each other's toes ...
> >
> 
> wonder if you could add one dmi check to tell the user that bios is
> buggy, ask vendor fixed BIOS
> and skip fixed mtrr sync.

There seem to be several systems affected that do not hide
RdMem/WrMem bits from OS. 

 (Causing Suspend/resume problem:)
- Acer Ferrari 1000
- Acer Ferrari 5000
 (Causing kernel freeze:)
- Asus M51TR-AP003C notebook
- Asus M51Ta notebook
- Asus M3A-H/HDMI mobo

- maybe some more systems

That is why I prefer to have a general solution for this.
(Which is to hide those bits whenever Linux reads or modifies
fixed-MTRR state.)

> instead of covering bios problem quietly.

It's not quietly, an error message will be printed.

Thomas R. suggested to use "KERN_ERR FW_BUG" but I'd prefer to add a
FW_WARN which should be used "for not that clear (e.g. could the
kernel messed up things already?) and medium priority BIOS bugs."

Note that if Linux does not try to sync fixed-MTRRs the affected
systems do not panic. But as a fact Linux is syncing (and needs to)
MTRR values across CPUs due to other buggy BIOSes ...


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


