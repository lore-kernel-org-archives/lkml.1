Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbZHVMsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbZHVMsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 08:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZHVMsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 08:48:37 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:41774 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZHVMsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 08:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=X4dlc6jCkJDSSWR0eJsH74WIJi+R/vLyv20BJwMSzGSqOECdEueo1kSIxxZWkCqHs1
         HA1KQBtaVNKwwMso//sOq3G6//dVuGl4DMGJLvfazUmsNOcH+arwl4MjBqSXJIYn7sYH
         VS/Gh+QNJuqaH5xqRP9wEWrDElTMoC5QSkWoA=
Subject: ACPI locks hardware devices when it doesn't detect vista
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Mairo <rety@poczta.onet.pl>
Content-Type: text/plain
Date: Sat, 22 Aug 2009 15:48:30 +0300
Message-Id: <1250945310.14167.150.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

<joke>
This should be brought to a Microsoft antitrust case...
</joke>


Today many notebooks ship with a embedded infrared receiver.
In Vista there is new subsystem that decodes these signals.
(of course it works only with Microsoft Certificated Remotes (TM)...)

The receiver is usually presented to system as a pnp device 
(using acpi tables)

It turns out that some bioses actually use the OSI, ACPI feature of the
operation system to detect if running inside Vista. If not they disable
the infrared receiver.

On my system this it is still tolerable:

            Device (MIR)
            {
                Name (_HID, EisaId ("ENE0100"))
                Method (_STA, 0, NotSerialized)
                {
                    If (LGreaterEqual (OSYS, 0x07D6))
                    {
                        If (LOr (And (OTHR, 0x02), And (OTHR, 0x40)))
                        {
                            Return (0x00)
                        }
                        Else
                        {
                            Return (0x0F)
                        }
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }

But not so, on Mairo's system:

            Device (MIR)
            {
                Name (_HID, EisaId ("ENE0100"))
                Method (_STA, 0, NotSerialized)
                {
                    If (LAnd (MCIR, LEqual (OSYS, 0x07D6)))
                    {
                        Return (0x0F)
                    }
                    Else
                    {
                        Store (Zero, ^^LPCB.IOR2)
                        Return (Zero)
                    }
                }

	.......

    Method (_WAK, 1, NotSerialized)
    {
    .......
        If (Not (LAnd (MCIR, LEqual (OSYS, 0x07D6))))
        {
            Store (Zero, \_SB.PCI0.LPCB.IOR2)
        }


.....

    Scope (_SB)
    {
        Method (_INI, 0, NotSerialized)
        {
            If (DTSE)
            {
                TRAP (0x47)
            }

            Store (0x07D0, OSYS)
            If (CondRefOf (_OSI, Local0))
            {
                If (_OSI ("Linux"))
                {
                    Store (One, LINX)
                    Store (Zero, ECDY)
                }

                If (_OSI ("Windows 2001"))
                {
                    Store (0x07D1, OSYS)
                }

                If (_OSI ("Windows 2001 SP1"))
                {
                    Store (0x07D1, OSYS)
                }

                If (_OSI ("Windows 2001 SP2"))
                {
                    Store (0x07D2, OSYS)
                }

                If (_OSI ("Windows 2006"))
                {
                    Store (0x07D6, OSYS)
                }

                If (LEqual (TPMV, One))
                {
                    If (LLessEqual (OSYS, 0x07D2))
                    {
                        TRAP (0x49)
                    }
                }
            }

            If (LAnd (MPEN, LEqual (OSYS, 0x07D1)))
            {
                TRAP (0x3D)
            }

            TRAP (0x2B)
        }
    }

We have tried to boot the system with acpi_osi="Windows 2006", but it
didn't help (kernel log confirmed that this parameter was set)

The only explanation I think of is ether his laptop is whitelisted on
osi=Linux, or that _SB._INI is called by linux _after_ MIR._STA
or that acpi_osi isn't yet in charge when _SB._INI is called.


The kernel in question is quite recent kernel, (2.6.30.5 from debian
unstable).


The only way I managed to 'enable' this device is to 
do 'sudo setpci -s 00:1f.0 0x88.W=0x701'

Or in other words undo the damage done by these ACPI commands.

Mairo, can you boot the system with acpi=off, and then poke the cir IO
range (0x700-0x703) ?



Best regards,
	Maxim Levitsky

