Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYLKBvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYLKBvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYLKBu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:50:57 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52216 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbYLKBu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:50:56 -0500
X-Sasl-enc: 22q0U9FTGL9W5SnnkWjJJDBAT1QFfUYmz8DXyZKutMec 1228960254
Date: Wed, 10 Dec 2008 23:50:52 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <abelay@mit.edu>,
       rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Support
Message-ID: <20081211015052.GA18925@khazad-dum.debian.net>
References: <493D8A1F.2090907@gmx.net> <20081210095315.GA20627@khazad-dum.debian.net> <494018E9.2060507@gmx.net> <20081210232137.GB7589@khazad-dum.debian.net> <20081211012838.GA18065@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211012838.GA18065@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Henrique de Moraes Holschuh wrote:
> Bah, never mind.  Major issue between the keyboard and the chair, on my
> end...  Got PR# and PS# confused.  The ThinkPad ACPI DSDT in question has
> the standard crap for wake device control, and PR# methods, but no PS#
> methods.
> 
> The PR0..PR2 nodes for the UHCI and EHCI USB ports on the ThinkPad T43
> mention a power resource object, and that power resource CAN power on/off
> the USB ports (and that freaks out the UHCI and EHCI kernel drivers causing
> over-current reports, but that was to be expected).  The AML code tells the
> EC to do some magic that probably tells a MOSFET somewhere in the mainboard
> to stop supplying power to the ports.
> 
> And Windows XP (this is not a Vista BIOS and I never tried running Vista in
> it...) is noticing that power resource (even without PS3 or PR3 nodes) and
> calling that power resource _OFF handler to power down USB ports when it
> doesn't need these devices for wakeup reasons, before entering STR.
> 
> Anyone has any clue on what part of the ACPI spec could result on that
> behaviour?  Because otherwise I will just bloody special-case it into
> thinkpad-acpi's suspend and resume stuff.  It will piss the USB subsystem
> off if I can't arrange to do it on early resume and late suspend, however.

Found it.  ACPI 3.0b, page 238, 7.2 Device Power Management Objects.

"For OSPM to put the device in the D3 state, the following must occur:

All Power Resources no longer referenced by any device in the system must
be in the OFF state"

If you want to put *any* particular ACPI device into D3, you turn off
*every* unused power resource, be them related or not to that device...

Windows XP seems to do it, and powers down the USB ports. None of them are
set for wake-from-S3, they all go to D3 and no references to the power
resources are left.  We probably should be doing the same.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
