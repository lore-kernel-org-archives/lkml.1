Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0BBGCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:02:36 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:35155 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0BBGCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:02:33 -0500
Date: Tue, 02 Feb 2010 01:02:10 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: andrej.gelenberg@udo.edu
Cc: Daniel Mack <daniel@caiaq.de>, linux-acpi@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Acpi4asus-user] ACPI device for ASUS EEEPC 1101HA not added
In-reply-to: <cone.1265022400.369355.2380.1000@eeekiste>
Message-id: <alpine.LFD.2.00.1002020048110.12989@localhost.localdomain>
References: <20100201032554.GZ28972@buzzloop.caiaq.de>
 <cone.1265022400.369355.2380.1000@eeekiste>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, andrej.gelenberg@udo.edu wrote:

> Hi,
> 
> you need to whitelist your eee pc for OSI(Linux) in drivers/acpi/blacklist.c
> like this:
> 
> +        /*
> +        * On newer Eeepc, the interface used by eeepc-laptop (ASUS010)
> +        * is disabled without _OSI(Linux)
> +        */
> +       {
> +       .callback = dmi_enable_osi_linux,
> +       .ident = "Asus Eeepc-1101HA",
> +       .matches = {
> +                    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
> +                    DMI_MATCH(DMI_PRODUCT_NAME, "1101HA"),
> +               },
> +       },

Not necessarily the right fix.  We have gone to a lot of trouble
to discourage BIOS vendors from depending on the ill-defined OSI(Linux),
so I hesitate to invoke it -- even for a workaround.

The problem at hand is that ASUS010 is not enabled for an OS
that claims compatibility with Win7 (MSOS() == MSW7) below.

                Scope (\_SB)
                {
                    Name (ATKP, Zero)
                    Device (ATKD)
                    {
                        Name (_HID, "ASUS010")
                        Name (_UID, 0x01010100)
                        Method (_STA, 0, NotSerialized)
                        {
                            If (LEqual (MSOS (), MSW7))
                            {
                                Return (Zero)
                            }
                            Else
                            {
                                Return (0x0F)
                            }

                            Return (Zero)
                            Return (0x0F)
                        }

(heh, see any indication of lack of quality in this code?:-)

MSOS() does this:

                    Scope (\)
                    {
                        Name (OSLX, 0x10)
                        Name (OSMS, 0x20)
                        Name (MS98, 0x21)
                        Name (MSME, 0x22)
                        Name (MS2K, 0x23)
                        Name (MSXP, 0x24)
                        Name (MSVT, 0x25)
                        Name (MSW7, 0x26)
                        Name (OSFG, Ones)
                        Method (MSOS, 0, NotSerialized)
                        {
                            If (LNotEqual (OSFG, Ones))
                            {
                                Return (OSFG)
                            }

                            Store (Zero, OSFG)
                            If (CondRefOf (_OSI, Local0))
                            {
                                If (_OSI ("Windows 2001"))
                                {
                                    Store (MSXP, OSFG)
                                }

                                If (_OSI ("Windows 2001 SP1"))
                                {
                                    Store (MSXP, OSFG)
                                }

                                If (_OSI ("Windows 2001 SP2"))
                                {
                                    Store (MSXP, OSFG)
                                }

                                If (_OSI ("Windows 2006"))
                                {
                                    Store (MSVT, OSFG)
                                }

                                If (_OSI ("Windows 2009"))
                                {
                                    Store (MSW7, OSFG)
                                }

                                If (_OSI ("Linux"))
                                {
                                    Store (OSLX, OSFG)
                                }

                                Return (OSFG)
                            }
                            Else


So I expect if you apply no patch, but boot with 'acpi_osi="!Windows 2009"'
then that would also work properly, as OSFG above will be set
to "MSVT" instead of "OSLX".

Looking through the DSDT, there are no references to OSLX or MSVT,
or MSXP, for that matter.  However, there is an additional reference
to MSV7 in the temperature reading part of thermal zone TZ00,
that looks like some sort of OS-specific initialization, perhaps
a workaround.  So also check that /proc/acpi/thermal_zone/*/temperature
still work before and after.

thanks,
-Len Brown, Intel Open Source Technology Center
 

