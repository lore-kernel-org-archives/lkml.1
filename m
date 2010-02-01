Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab0BAKWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:22:53 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:48416 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011Ab0BAKWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:22:51 -0500
Message-ID: <4B66AB7F.7050908@suse.de>
Date: Mon, 01 Feb 2010 13:22:55 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][RFT][PATCH] ACPI: Protection from suspending in the middle
  of EC transaction
References: <201001310029.48717.rjw@sisk.pl> <9b2b86521001310611m339862afw73410dc7eb5692c8@mail.gmail.com> <1264957760.7264.3.camel@maxim-laptop> <20100201094643.GB8740@khazad-dum.debian.net>
In-Reply-To: <20100201094643.GB8740@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh пишет:
> On Sun, 31 Jan 2010, Maxim Levitsky wrote:
>> Unfortunately, this patch even causes regressions on my notebook (it
>> survive 63 hibernate cycles), but now I battery driver reports 'battery
>> absent', backlight driver reports 0 brightness, but reload helped.
> 
> ...
> 
>> I think that not only _PTS ans _WAK are problematic. What about other
>> ACPI drivers that start accessing the EC before it is resumed?
>> I think that these cause the problems I observe.
> 
> ACPI drivers might access the EC (even indirectly, through the DSDT).  And
> platform drivers do often access the EC both at suspend and resume time.
Actually, only SBS and thinkpad-acpi access EC directly. All others go through
DSDT for access. Still, stopping EC in .suspend is too early, IMHO...
> 
> This needs some sort of strong ordering, the EC must suspend last, and
> resume first (as seen by any ACPI and ACPI-aware drivers such as libata,
> some platform drivers, etc).  If EC interrupts are a problem, maybe it can
> be kicked to poll mode for the suspend/resume transition?
It's this way already for about a year now... The problem is that EC driver might be 
stopped in middle of the transaction, thus leaving EC in unknown state for BIOS or 
switch-over kernel.

