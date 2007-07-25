Return-Path: <linux-kernel-owner+w=401wt.eu-S1765704AbXGYNSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765704AbXGYNSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbXGYNSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:18:23 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:52137 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760879AbXGYNSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:18:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: =?iso-8859-15?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Wed, 25 Jul 2007 07:16:44 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr, shaohua.li@intel.com
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707240948.45916.bjorn.helgaas@hp.com> <20070725094554.55c46d8b@frecb000686.frec.bull.fr>
In-Reply-To: <20070725094554.55c46d8b@frecb000686.frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707250716.44609.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 01:45:54 am Sébastien Dugué wrote:
>   looks like the commit was dropped, nevertheless here is some more info
> to try and understand what may be going on so it may benefit the posterity ;-)

Thank you very much.

Your machine does indeed describe both UARTs in ACPI, and the PNP probe
finds them correctly.  The only wrinkle is that the PNP probe names the
ports in the order they appear in the ACPI namespace, and your firmware
has them "backwards":

                    Device (COMB)
                    {
                        Name (_HID, EisaId ("PNP0501"))
                        Name (_DDN, "COM2")
                        Name (_UID, 0x02)

                    Device (COMA)
                    {
                        Name (_HID, EisaId ("PNP0501"))
                        Name (_DDN, "COM1")
                        Name (_UID, 0x01)

There's nothing illegal about this, but with the current PNPACPI,
it causes the names to be reversed.  The blind probe tries 0x3f8
first, and names that ttyS0.  But the PNP probe, using the namespace
order, finds the "COM2" port at 0x2f8 first:

  00:0b: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
  00:0c: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A

So I think your serial console would work without "legacy_serial.force"
if you used "console=ttyS1" instead of "console=ttyS0".  But you
shouldn't have to do that, of course.

The _DDN is a "DOS device name", and the _UID is a "logical device ID
that does not change across reboots."  Both are optional, and PNPACPI
ignores them.  But maybe we could change PNPACPI to sort by them if
they are present.  I'll think about this a bit.

Thanks again,
  Bjorn
