Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbYEUI3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbYEUI3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYEUI2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:28:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51629 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbYEUI2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:28:44 -0400
X-Sasl-enc: ObKEptMW4yZ82QiX9VGXO8p23XhZQ3c7wVJUlt96Bnpk 1211358522
Message-ID: <4833DD38.2010702@ladisch.de>
Date: Wed, 21 May 2008 10:28:40 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Kevin Hao <kexin.hao@windriver.com>, venkatesh.pallipadi@intel.com,
       bob.picco@hp.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>
Subject: Re: [PATCH] x86: Get irq for hpet timer
References: <1210917912.10881.1.camel@kevin-desktop>  <482D49CF.4030902@ladisch.de> <1210929270.11912.3.camel@kevin-desktop>  <4831A678.5070208@ladisch.de> <1211274219.8718.7.camel@kevin-desktop> <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805201631010.31790@cliff.in.clinika.pl>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Tue, 20 May 2008, Kevin Hao wrote:
> > We can simply skip these special IRQ. :-)
> > Does anyone has a better solution?
>
>  Hmm, you probably want to skip all lines that are edge-triggered.
> Otherwise you may have problems with sharing.

HPET interrupts can be either edge or level triggered.  Probably we
should modify it according to the type of the interrupt line we're
trying to grab.

> Drivers for devices used with these edge-triggered lines may have
> special provisions to permit sharing ...

An edge-triggered HPET interrupt line is not shared (we set IRQF_SHARED
only if the register says that it's level triggered).

>  This driver is quite platform-specific -- how about instead of blindly
> probing for interrupt lines, you actually allocate one somehow in platform
> code?

I don't have much of a clue about that "somehow", but this sound like a
good idea.  ;-)

I think hpet_reserve_platform_timers() might be the place for this.

It gets called from hpet_late_init(), which is a fs_initcall, so I think
we should be careful not to grab some unsharable interrupt that might be
needed by some ISA device whose driver is initialized later.
(This was a bug in 2.6.25-rc5: <http://bugzilla.kernel.org/show_bug.cgi?id=10382>)


Regards,
Clemens
