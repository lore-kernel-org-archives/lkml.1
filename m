Return-Path: <linux-kernel-owner+w=401wt.eu-S935031AbYETPsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935031AbYETPsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbYETPru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:47:50 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64031 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933695AbYETPrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:47:49 -0400
Date: Tue, 20 May 2008 16:46:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Kevin Hao <kexin.hao@windriver.com>
cc: Clemens Ladisch <clemens@ladisch.de>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Get irq for hpet timer
In-Reply-To: <1211274219.8718.7.camel@kevin-desktop>
Message-ID: <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
References: <1210917912.10881.1.camel@kevin-desktop>  <482D49CF.4030902@ladisch.de>
 <1210929270.11912.3.camel@kevin-desktop>  <4831A678.5070208@ladisch.de>
 <1211274219.8718.7.camel@kevin-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Kevin Hao wrote:

> We can simply skip these special IRQ. :-)
> Does anyone has a better solution?

 Hmm, you probably want to skip all lines that are edge-triggered.  
Otherwise you may have problems with sharing.  Drivers for devices used
with these edge-triggered lines may have special provisions to permit
sharing in a crafted way in special arrangements (cf. the 8250 serial or
the IDE driver), but that may not work in a generic way with a different
driver in the scenario.  And the polarity may be wrong too --
edge-triggered lines are often active-high, because it's fine with them.

 This driver is quite platform-specific -- how about instead of blindly
probing for interrupt lines, you actually allocate one somehow in platform
code?  For example the x86 platform could select an otherwise unused
interrupt line for you -- having routed all the legacy and PCI devices,
these systems quite frequently are left with a couple of otherwise unused
I/O APIC inputs.  If not, sharing with a PCI interrupt line would be a
good choice.  AFAIK, except from 8254 and RTC emulation the HPET cannot be
used with the legacy 8259A interrupt controllers, so that is a non issue
(but platform will know to disable your driver then).

  Maciej
