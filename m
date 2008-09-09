Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYIIRlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYIIRlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYIIRlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:41:00 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:37801 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYIIRk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:40:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Tue, 9 Sep 2008 11:40:25 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200809091250.08620.elendil@planet.nl> <200809090930.27583.bjorn.helgaas@hp.com> <200809091826.18876.elendil@planet.nl>
In-Reply-To: <200809091826.18876.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091140.25597.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 10:26:17 am Frans Pop wrote:
> > What do "lspci -vv" and /proc/ioports and /proc/iomem show for you?
> 
> Thanks for the background info and data for comparison.
> Here's what I have (full info attached). AFAICT it looks equally sane and 
> consistent.
> 
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
> (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller [8086:24c5] (rev 03)
>         Region 0: I/O ports at 1000 [size=256]
>         Region 1: I/O ports at 1880 [size=64]
>         Region 2: Memory at 28080800 (32-bit, non-prefetchable) [size=512]
>         Region 3: Memory at 28080a00 (32-bit, non-prefetchable) [size=256]
> 
> 00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
> AC'97 Modem Controller [8086:24c6] (rev 03)
>         Region 0: I/O ports at 1400 [size=256]
>         Region 1: I/O ports at 1800 [size=128]

Yup, this all looks reasonable to me, too.  But these regions must be
different than they were when the PNP quirk ran.  I wonder if the BIOS
left them unprogrammed, we ran the PNP quirk and discovered all these
"conflicts," then PCI came along and assigned resources.

Your dmesg shows power state changes for the PCI devices.  Maybe
the BIOS left them in D3 and unprogrammed:

  Intel ICH Modem 0000:00:1f.6: power state changed by ACPI to D0
  Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
  Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)

If the PCI device isn't fully initialized, it doesn't seem right to
check it for resource conflicts.  But I don't know how to tell that.

Can you figure out where the 1f.5 and 1f.6 resources get assigned?

> /proc/ioports:
> 1000-10ff : 0000:00:1f.5
>   1000-10ff : Intel 82801DB-ICH4
> 1400-14ff : 0000:00:1f.6
>   1400-14ff : Intel 82801DB-ICH4 Modem
> 1800-187f : 0000:00:1f.6
>   1800-187f : Intel 82801DB-ICH4 Modem
> 1880-18bf : 0000:00:1f.5
>   1880-18bf : Intel 82801DB-ICH4
> 
> /proc/iomem:
> 28080800-280809ff : 0000:00:1f.5
>   28080800-280809ff : Intel 82801DB-ICH4
> 28080a00-28080aff : 0000:00:1f.5
>   28080a00-28080aff : Intel 82801DB-ICH4
