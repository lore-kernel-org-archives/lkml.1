Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbZFIIT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbZFIIT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbZFIITN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:19:13 -0400
Received: from www.tglx.de ([62.245.132.106]:45033 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbZFIITL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:19:11 -0400
Date: Tue, 9 Jun 2009 10:18:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "Tang, Feng" <feng.tang@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>
Subject: RE: [PATCH] tick: add check for the existence of broadcast clock
 event device
In-Reply-To: <43F901BD926A4E43B106BF17856F07556340868E@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0906091014110.3351@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop> <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain> <20090606204736.00700bd0@feng-desktop> <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain> <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop> <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain> <20090608141250.6a5735fa@feng-desktop> <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain> <20090608144740.62f2ed95@feng-desktop>
 <alpine.LFD.2.00.0906080857260.3419@localhost.localdomain> <EADF0A36011179459010BDF5142A457501C9CD39CC@pdsmsx502.ccr.corp.intel.com> <alpine.LFD.2.00.0906081109080.3419@localhost.localdomain>
 <43F901BD926A4E43B106BF17856F07556340868E@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Pan, Jacob jun wrote:
> >I understand that, but HPET does not rely on some magic events
> >happening. That's what I'm worried about. The boot code is fragile and
> >I prefer some explicit setup call over a fragile solution which
> >happens to work.
> >
> >There is not much to complain about a platform specific function call
> >to set up special devices if there is a requirement for a call order.
> >
> >In fact you can avoid setting up the local APIC timer at all. So what
> >you want is something like the patch below. You can set the
> >setup_secondary_clock pointer in the quirks structure when you detect
> >that you are running on such a system.
> >

> [[JPAN]] Hi Thomas, I have been developing the APB timer driver as
> Feng mentioned, thank you for the suggestions.  I agree with you
> that direct setting up secondary clockevent is a better solution.
> But maybe I misunderstand the HPET code, isn't it true that per CPU
> HPET timer also rely on IPI? In hpet_cpuhp_notify().

Well the difference is, that the HPET setup always has a functional
clock event device (local APIC + the broadcast fallback) and it does
not depend on that IPI to make progress.
 
> Also for using x86_quirks, I think the default quirks are more
> generic in the sense of x86 platform, but here we are really
> choosing timer device, so can we switch based on availability of the
> timer devices instead of quirks? Otherwise, if more platforms share
> the same setup_secondary_clock() quirk, we would have to check for
> timer devices anyway.

The quirks mechanism is exactly the right thing. It provides platforms
and I consider your system a platform which has neither PIT nor HPET a
mechanism to override the default implementation. And overriding the
default local APIC timer setup is exaclty what you want to do.

Thanks,

	tglx
