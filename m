Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0BAWmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:42:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab0BAWmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:42:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the middle of EC transaction
Date: Mon, 1 Feb 2010 23:42:49 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <201001310029.48717.rjw@sisk.pl> <20100201094643.GB8740@khazad-dum.debian.net> <4B66AB7F.7050908@suse.de>
In-Reply-To: <4B66AB7F.7050908@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002012342.50074.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Alexey Starikovskiy wrote:
> Henrique de Moraes Holschuh пишет:
> > On Sun, 31 Jan 2010, Maxim Levitsky wrote:
> >> Unfortunately, this patch even causes regressions on my notebook (it
> >> survive 63 hibernate cycles), but now I battery driver reports 'battery
> >> absent', backlight driver reports 0 brightness, but reload helped.
> > 
> > ...
> > 
> >> I think that not only _PTS ans _WAK are problematic. What about other
> >> ACPI drivers that start accessing the EC before it is resumed?
> >> I think that these cause the problems I observe.
> > 
> > ACPI drivers might access the EC (even indirectly, through the DSDT).  And
> > platform drivers do often access the EC both at suspend and resume time.
> Actually, only SBS and thinkpad-acpi access EC directly. All others go through
> DSDT for access. Still, stopping EC in .suspend is too early, IMHO...

That's very likely the case, although that's kind of the latest we can do that
without major modifications.

Is there a possibility to have more than one EC in a system in practice?

> > This needs some sort of strong ordering, the EC must suspend last, and
> > resume first (as seen by any ACPI and ACPI-aware drivers such as libata,
> > some platform drivers, etc).  If EC interrupts are a problem, maybe it can
> > be kicked to poll mode for the suspend/resume transition?
> It's this way already for about a year now... The problem is that EC driver might be 
> stopped in middle of the transaction, thus leaving EC in unknown state for BIOS or 
> switch-over kernel.

Exactly.

In theory I can try to disable EC transactions from the ACPI platform
suspend/resume callbacks, but then there still is a problem with the global
lock, since we shouldn't try to acquire it after disabling device interrupts,
because an SCI is waited for in case we don't acquire it immediately.

So, perhaps instead we should disable the GPEs and call _PTS before the late
suspend phase (and analogously, execute _WAK after the early resume phase)
and disable the EC transacations right after that?

This leaves the problem with PCI devices that may require ACPI support during
late suspend/early resume, but well.

Rafael
