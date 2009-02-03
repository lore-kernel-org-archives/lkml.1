Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZBCBNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZBCBNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBCBNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:13:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:36944 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbZBCBNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:13:21 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902030045.19416.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>
	 <200902030115.32659.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 12:12:05 +1100
Message-Id: <1233623525.18767.151.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 16:28 -0800, Linus Torvalds wrote:
> 
> On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > BTW, on the PMAC the problematic driver appears to be the radeon driver,
> > according to Ben, and the breakage is not related to USB.

> Hmm. atyfb_base.c has the same kind of things with magic PMAC code, but it 
> doesn't follow the USB pattern - it just replaces "pci_set_power_state()" 
> _entirely_. 

radeonfb_pm.c is the culprit here, I haven't looked at atyfb (mach64)
yet, but it has similar issues yes. I just attached a patch to the BZ
cleaning up radeonfb. I can have a look at doing a similar cleanup to
atyfb and aty128fb next.

> It seems a very interesting suspend routine, btw. It doesn't seem to do 
> any of the pci_save_state() at all, just re-initializes from scratch. 
> Maybe it is unhappy with the PM layer deciding to try to restore state 
> since it clearly didn't..

Well, I wrote that so ... :-) bear in mind that this code was mostly
written way before the PCI layer knew how to save and restore state.
Also, atyfb has some cases of chips that don't support PCI D states but
use private MMIO register to control suspend/resume.

Anyway, my proposed radeonfb patch is at:

 http://bugzilla.kernel.org/attachment.cgi?id=20085

I'll look at cleaning up atyfb and aty128fb later today if needed.

Cheers,
Ben.


