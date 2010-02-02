Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0BBHWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:22:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:41817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab0BBHWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o+PNDue8OlDsz+IVz9+RnJlgi12H1Q4ie1RuWXpkCkBCWHMZVjnFIFVhyaZO8e27a4
         ZPGN1/BQLToBsi0RpNjNWiJKrzrL6O1dBKnBUjLJepx39Dl6vetPcRk88mzk4MY9awPK
         bYybKRclqfBUmOSK3dGsBAVG6u2+8Yw2bZwdU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002020048110.12989@localhost.localdomain>
References: <20100201032554.GZ28972@buzzloop.caiaq.de>
	 <cone.1265022400.369355.2380.1000@eeekiste>
	 <alpine.LFD.2.00.1002020048110.12989@localhost.localdomain>
Date: Tue, 2 Feb 2010 08:22:40 +0100
Message-ID: <71cd59b01002012322s7658dc8evc6ce46b2406f4d3f@mail.gmail.com>
Subject: Re: [Acpi4asus-user] ACPI device for ASUS EEEPC 1101HA not added
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: andrej.gelenberg@udo.edu, Daniel Mack <daniel@caiaq.de>,
       linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o127OfmE006064

On Tue, Feb 2, 2010 at 7:02 AM, Len Brown <lenb@kernel.org> wrote:> On Mon, 1 Feb 2010, andrej.gelenberg@udo.edu wrote:>>> Hi,>>>> you need to whitelist your eee pc for OSI(Linux) in drivers/acpi/blacklist.c>> like this:>>>> +        /*>> +        * On newer Eeepc, the interface used by eeepc-laptop (ASUS010)>> +        * is disabled without _OSI(Linux)>> +        */>> +       {>> +       .callback = dmi_enable_osi_linux,>> +       .ident = "Asus Eeepc-1101HA",>> +       .matches = {>> +                    DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),>> +                    DMI_MATCH(DMI_PRODUCT_NAME, "1101HA"),>> +               },>> +       },>> Not necessarily the right fix.  We have gone to a lot of trouble> to discourage BIOS vendors from depending on the ill-defined OSI(Linux),> so I hesitate to invoke it -- even for a workaround.>> The problem at hand is that ASUS010 is not enabled for an OS> that claims compatibility with Win7 (MSOS() == MSW7) below.>>                Scope (\_SB)>                {>                    Name (ATKP, Zero)>                    Device (ATKD)>                    {>                        Name (_HID, "ASUS010")>                        Name (_UID, 0x01010100)>                        Method (_STA, 0, NotSerialized)>                        {>                            If (LEqual (MSOS (), MSW7))>                            {>                                Return (Zero)>                            }>                            Else>                            {>                                Return (0x0F)>                            }>>                            Return (Zero)>                            Return (0x0F)>                        }>> (heh, see any indication of lack of quality in this code?:-)>> MSOS() does this:>>                    Scope (\)>                    {>                        Name (OSLX, 0x10)>                        Name (OSMS, 0x20)>                        Name (MS98, 0x21)>                        Name (MSME, 0x22)>                        Name (MS2K, 0x23)>                        Name (MSXP, 0x24)>                        Name (MSVT, 0x25)>                        Name (MSW7, 0x26)>                        Name (OSFG, Ones)>                        Method (MSOS, 0, NotSerialized)>                        {>                            If (LNotEqual (OSFG, Ones))>                            {>                                Return (OSFG)>                            }>>                            Store (Zero, OSFG)>                            If (CondRefOf (_OSI, Local0))>                            {>                                If (_OSI ("Windows 2001"))>                                {>                                    Store (MSXP, OSFG)>                                }>>                                If (_OSI ("Windows 2001 SP1"))>                                {>                                    Store (MSXP, OSFG)>                                }>>                                If (_OSI ("Windows 2001 SP2"))>                                {>                                    Store (MSXP, OSFG)>                                }>>                                If (_OSI ("Windows 2006"))>                                {>                                    Store (MSVT, OSFG)>                                }>>                                If (_OSI ("Windows 2009"))>                                {>                                    Store (MSW7, OSFG)>                                }>>                                If (_OSI ("Linux"))>                                {>                                    Store (OSLX, OSFG)>                                }>>                                Return (OSFG)>                            }>                            Else>>> So I expect if you apply no patch, but boot with 'acpi_osi="!Windows 2009"'> then that would also work properly, as OSFG above will be set> to "MSVT" instead of "OSLX".>> Looking through the DSDT, there are no references to OSLX or MSVT,> or MSXP, for that matter.  However, there is an additional reference> to MSV7 in the temperature reading part of thermal zone TZ00,> that looks like some sort of OS-specific initialization, perhaps> a workaround.  So also check that /proc/acpi/thermal_zone/*/temperature> still work before and after.>> thanks,> -Len Brown, Intel Open Source Technology Center>
This kind of things is present on all newer eeepc.I tried to contact asus about that, without real success and it islikely that the xandros distribributionshipped with some eeepc include an acpi blacklisiting patch.
The thing is that on win7 ASUS010 is disabled, but an equivalent wmiinterface is enable, and it couldbe possible to write a driver for it. Now, someone need to write it,or send me a free 1005HA so I can do it :).
If nothing is done for 2.6.34, we may need to envisage some blacklisting :/.Thanks-- Corentin Charyhttp://xf.iksaif.netÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
