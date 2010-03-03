Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0CCMuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:50:05 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:55086 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab0CCMuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Cx+dkJlyACC6nbE229CHOXN2lE0BaGETaG0uqOVuDHDkwpadh7Z6iKqybgtriD9m4C
         NyffY6uVMnTIS+5zImC5ZJw6QJsjN2FT/IS6PhhLAnCkueLhblCRXZomaJsyb/2tNMHD
         RA7lP7YH5ptBtGQ3XQMhib+KPyMf/Z7lRiR4M=
MIME-Version: 1.0
Date: Wed, 3 Mar 2010 13:50:00 +0100
Message-ID: <bc11cfae1003030450q46d05932w58253f232e4916e0@mail.gmail.com>
Subject: 2.6.33: tpm_tis + iTPM still broken
From: Martin Pirker <lkml.collector@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list...

Short version:
Last summer a few patches floatet on LKML which enabled the Intel TPM
(iTPM) to work with the tpm_tis driver. However, now, more than half a
year later vanilla 2.6.33 is still unusable with iTPMs.


Long version:
iTPM do not play as nice with tpm_tis. There was a patch set published
which can be applied to .30 and .31 which enables the iTPM to work
flawlessly. I tested the patches on mobile and desktop iTPM boards
and reported back:
http://lkml.indiana.edu/hypermail/linux/kernel/0907.1/01737.html

Today I upgraded to a fresh 2.6.33 and iTPM support does (still) not
work and the old patches no longer apply...


In more detail:

GM45 based system:
==================

2.6.33 vanilla:

modprobe tpm_tis -> module loaded, but no result

modprobe tpm_tis itpm -> module loaded, but no result

modprobe tpm_tis force
returns immediately with:
[  273.490874] tpm_tis tpm_tis: 1.2 TPM (device-id 0x1020, rev-id 6)
[  273.500554] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[  273.500585] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[  273.500608] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[  273.500633] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5

a /dev/tpm0 is created, but does not work


compare with 2.6.31 with patches:

autodetected without problems at boot:
[    3.982236] tpm_tis INTC0102:00: found 0xfed40000(0x5000)
[    3.982249] tpm_tis INTC0102:00: no IRQ found in _CRS, polling mode
[    3.982327] tpm_tis INTC0102:00: 1.2 TPM (8086:1020 rev 6)
[    3.982329] tpm_tis INTC0102:00: Intel iTPM workaround enabled


/dev/tpm0 available and works without problems:

TPM Version Info:
           version: 1.2 rev: 4.0
         specLevel: 2
         errataRev: 2
       tpmVendorID: Intel Corporation ("INTC")
vendorSpecificSize: 8
vendorSpecificData: 00 04 00 00 00 04 04 66


ACPI DSDT dump:
  Device (_SB.PCI0.SBRG.TPM)
    {
        Name (_HID, EisaId ("PNP0C31"))
        Name (_CID, EisaId ("PNP0C31"))
        Name (_UID, One)
        Name (_CRS, ResourceTemplate ()
        {
            Memory32Fixed (ReadWrite,
                0xFED40000,         // Address Base
                0x00005000,         // Address Length
                )
        })
[...]
   Device (_SB.PCI0.ITPM)
    {
        Name (_HID, "INTC0102")
        Name (_CID, EisaId ("PNP0C31"))
        Name (_UID, One)
        Name (_CRS, ResourceTemplate ()
        {
            Memory32Fixed (ReadWrite,
                0xFED40000,         // Address Base
                0x00005000,         // Address Length
                )
        })




Q45 based system:
=================

2.6.33:

modprobe tpm_tis -> module loaded, but no result

modprobe tpm_tis itpm -> module loaded, but no result


using:
# time modprobe tpm_tis force
real    2m0.060s


/dev/tpm0 appears and works:

TPM Version Info:
           version: 1.2 rev: 5.2
         specLevel: 2
         errataRev: 2
       tpmVendorID: Intel Corporation ("INTC")
vendorSpecificSize: 8
vendorSpecificData: 00 05 00 02 00 00 03 f1


ACPI DSDT dump:

    Device (_SB.PCI0.SBRG.TPM)
    {
        Name (_HID, EisaId ("PNP0C31"))
        Name (_STR, Unicode ("TPM 1.2 Device"))
        Name (_UID, One)
        Name (_CRS, ResourceTemplate ()
        {
            Memory32Fixed (ReadOnly,
                0xFED40000,         // Address Base
                0x00005000,         // Address Length
                )
        })
        OperationRegion (TMMB, SystemMemory, 0xFED40000, 0x1000)


    Device (_SB.PCI0.ITPM)
    {
        Name (_HID, "INTC0102")
        Name (_CID, EisaId ("PNP0C31"))
        Name (_STR, Unicode ("TPM 1.2 Device"))
        Name (_CRS, ResourceTemplate ()
        {
            Memory32Fixed (ReadOnly,
                0xFED40000,         // Address Base
                0x00005000,         // Address Length
                )
        })
        OperationRegion (CMSR, SystemIO, 0x72, 0x02)



compared with 2.6.31 with patches:

autodetected at boot and works without problems:
[    8.024210] tpm_tis INTC0102:00: found 0xfed40000(0x5000)
[    8.024216] tpm_tis INTC0102:00: no IRQ found in _CRS, polling mode
[    8.024275] tpm_tis INTC0102:00: 1.2 TPM (8086:1040 rev 4)





So....
anybody knows which part of the old patch set does the magic
and enables the iTPM to "just work"?


Thanks,
Martin
