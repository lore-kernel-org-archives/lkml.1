Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab0BAJqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:46:50 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45699 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab0BAJqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:46:47 -0500
X-Sasl-enc: 02t9Erjvi3n123fS0AyBW3DD+PbreHtsdgIn+byRBstC 1265017605
Date: Mon, 1 Feb 2010 07:46:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the
 middle  of EC transaction
Message-ID: <20100201094643.GB8740@khazad-dum.debian.net>
References: <201001310029.48717.rjw@sisk.pl>
 <9b2b86521001310611m339862afw73410dc7eb5692c8@mail.gmail.com>
 <1264957760.7264.3.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264957760.7264.3.camel@maxim-laptop>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jan 2010, Maxim Levitsky wrote:
> Unfortunately, this patch even causes regressions on my notebook (it
> survive 63 hibernate cycles), but now I battery driver reports 'battery
> absent', backlight driver reports 0 brightness, but reload helped.

...

> I think that not only _PTS ans _WAK are problematic. What about other
> ACPI drivers that start accessing the EC before it is resumed?
> I think that these cause the problems I observe.

ACPI drivers might access the EC (even indirectly, through the DSDT).  And
platform drivers do often access the EC both at suspend and resume time.

This needs some sort of strong ordering, the EC must suspend last, and
resume first (as seen by any ACPI and ACPI-aware drivers such as libata,
some platform drivers, etc).  If EC interrupts are a problem, maybe it can
be kicked to poll mode for the suspend/resume transition?

Some platform drivers (like thinkpad-acpi) might need some changes to access
the EC syncronized with their ACPI devices (often they have all sort of
devices, e.g.  backlight, ALSA, hwmon...) if the ordering is based on logic
in the ACPi bus driver.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
