Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbXHGEab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbXHGEab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 00:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXHGEaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 00:30:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:23875 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbXHGEaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 00:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iR5daI/jYNU3GpI7NS0rWRajxTHDZDwtf23ASER9oKiLTX62JIMZnJs0/PLas11W4YLQ83mz8brigJVmIM6KNboKfmaVHmmYcNDXX3RxeWQyyiSbQwolNNrcF0/IT00hgHgMjX2Hw+ON/gAVhISJBBad3tT+U0CFeRhDxFgfChs=
Message-ID: <b25c3fa70708062130v5176fa9fu4b9300e6a313cf2f@mail.gmail.com>
Date: Tue, 7 Aug 2007 13:30:20 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] kexec: fix pci device initialization fail after kexec (2.6.23-rc2). (Related to e1000 doesn't resume properly from standby)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Simon Arlott" <simon@fire.lp0.eu>, "Pavel Machek" <pavel@ucw.cz>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       linux-pm@lists.linux-foundation.org, linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <200708062048.37160.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com>
	 <200708061650.16555.rjw@sisk.pl>
	 <b25c3fa70708060850p26b7b3e6yb8a523a479c714c0@mail.gmail.com>
	 <200708062048.37160.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/7, Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, 6 August 2007 17:50, Joonwoo Park wrote:
> > 2007/8/6, Rafael J. Wysocki <rjw@sisk.pl>:
> > > On Monday, 6 August 2007 15:42, Joonwoo Park wrote:
> > > > Hi.
> > > > I think that the pci_set_power_state() has bug.
> > > > The specification says that some delays is required.
> > >
> > > And they are in place, AFAICS (from drivers/pci/pci.c):
> > >
> > >        /* Mandatory power management transition delays */
> > >        /* see PCI PM 1.1 5.6.1 table 18 */
> > >        if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
> > >                msleep(pci_pm_d3_delay);
> > >        else if (state == PCI_D2 || dev->current_state == PCI_D2)
> > >                udelay(200);
> > >
> >
> > The problem is occurred when state is 'PCI_D0', so those codes can't cover it.
> > But pci pm specification 5.4.1 says that when programmed to D0 the
> > equivalent of a warm reset, delay for the duration of the D3hot to D0
> > Uninitialized state
> > transition (10ms) to pci signal drivers remain disabled is required.
>
> Section 5.4.1 of PCI PM 1.1. spec is about D3_hot.  Specifically, it says
> that if a device in D3_hot is programmed to D0, it performs the equivalent of
> a warm reset.  IOW, this is supposed to happen if the current state is D3_hot
> and the targed state is D0, which is covered by the code snippet above.

IMHO, it is seems to the spec says just *programmed  to D0* not
*programmed from D3hot to D0*.
Actually, I got current_state UNKNOWN and state PCI_D0 after kexec's
start new kernel with dual port 82546EB fiber ethernet card.

>
> Greetings,
> Rafael
>
>
> --
> "Premature optimization is the root of all evil." - Donald Knuth
>

Simon, this patch was checked with checkpatch.pl and fixed some fault.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

---
 drivers/pci/pci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 37c00f6..0f086d9 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -467,7 +467,8 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)

 	/* Mandatory power management transition delays */
 	/* see PCI PM 1.1 5.6.1 table 18 */
-	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
+	if (state == PCI_D3hot || dev->current_state == PCI_D3hot ||
+	    state == PCI_D0)
 		msleep(pci_pm_d3_delay);
 	else if (state == PCI_D2 || dev->current_state == PCI_D2)
 		udelay(200);
-


Best regards,
Joonwoo Park.
