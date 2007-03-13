Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXCMMzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXCMMzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933304AbXCMMzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:55:53 -0400
Received: from mx-b.polytechnique.fr ([129.104.30.15]:57093 "EHLO
	mx-b.polytechnique.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbXCMMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:55:51 -0400
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 08:55:50 EDT
Message-ID: <45F69989.70702@crans.org>
Date: Tue, 13 Mar 2007 13:31:05 +0100
From: =?UTF-8?B?TWF0aGlldSBCw6lyYXJk?= <Mathieu.Berard@crans.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org,
       Michal Jaegermann <michal@ellpspace.math.ualberta.ca>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Janosch Machowinski <jmachowinski@gmx.de>,
       Lukas Hejtmanek <xhejtman@fi.muni.cz>, Meelis Roos <mroos@linux.ee>,
       Olivier Mondoloni <darkcore71@yahoo.fr>,
       Thomas Renninger <trenn@suse.de>, Robert Moore <robert.moore@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [3/6] 2.6.21-rc2: known regressions
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015036.GH3441@stusta.de> <45EE9E39.3010800@garzik.org> <45F20541.9090208@crans.org> <45F53B60.8020908@gmail.com>
In-Reply-To: <45F53B60.8020908@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo a écrit :
> > Mathieu Bérard wrote:
>> >> Jeff Garzik a écrit :
>>> >>> Adrian Bunk wrote:
>>>> >>>> Subject    : NCQ problem with ahci and Hitachi drive
>>>> >>>> References : http://lkml.org/lkml/2007/3/4/178
>>>> >>>> Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
>>>> >>>> Status     : unknown
>>> >>> according to the last message in that thread, it sounds like
ACPI and
>>> >>> interrupt problems
>>> >>>
>> >> Hi,
>> >> after more testing with a 2.6.21-rc3, it appears that after
several ata
>> >> errors the boot process
>> >> somehow continued as normal, after a "NCQ disabled due to excessive
>> >> errors" message.
>> >> "pci=noacpi" or "noacpi" parameters workarounds the problem "irqpoll"
>> >> does nothing.
> >
> > I was mistaken.  It can't be IRQ routing problem.  I somehow thought the
> > port was a ata_piix one.  Considering the reported broken NCQ feature on
> > the device GTF might be mangling with the drive to disable NCQ or
> > something.  Does giving "libata.noacpi=1" make any difference?
> >

Hi,
libata.noacpi=1 worked. The drive is up and running with NCQ on.
Here is the PATA/SATA related part of my DSDT table with the _GTF methods:

Device (PATA)
{
    Name (_ADR, 0x001F0001)
    OperationRegion (PACS, PCI_Config, 0x40, 0xC0)
    Field (PACS, DWordAcc, NoLock, Preserve)
    {
        PRIT,   16,
        Offset (0x04),
        PSIT,   4,
        Offset (0x08),
        SYNC,   4,
        Offset (0x0A),
        SDT0,   2,
            ,   2,
        SDT1,   2,
        Offset (0x14),
        ICR0,   4,
        ICR1,   4,
        ICR2,   4,
        ICR3,   4,
        ICR4,   4,
        ICR5,   4
    }

    Device (PRID)
    {
        Name (_ADR, 0x00)
        Method (_GTM, 0, NotSerialized)
        {
            Name (PBUF, Buffer (0x14)
            {
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                0x00, 0x00, 0x00, 0x00
            })
            CreateDWordField (PBUF, 0x00, PIO0)
            CreateDWordField (PBUF, 0x04, DMA0)
            CreateDWordField (PBUF, 0x08, PIO1)
            CreateDWordField (PBUF, 0x0C, DMA1)
            CreateDWordField (PBUF, 0x10, FLAG)
            Store (GETP (PRIT), PIO0)
            Store (GDMA (And (SYNC, 0x01), And (ICR3, 0x01), And (ICR0,
0x01), SDT0, And (ICR1, 0x01)), DMA0)
            If (LEqual (DMA0, 0xFFFFFFFF))
            {
                Store (PIO0, DMA0)
            }

            If (And (PRIT, 0x4000))
            {
                If (LEqual (And (PRIT, 0x90), 0x80))
                {
                    Store (0x0384, PIO1)
                }
                Else
                {
                    Store (GETT (PSIT), PIO1)
                }
            }
            Else
            {
                Store (0xFFFFFFFF, PIO1)
            }

            Store (GDMA (And (SYNC, 0x02), And (ICR3, 0x02), And (ICR0,
0x02), SDT1, And (ICR1, 0x02)), DMA1)
            If (LEqual (DMA1, 0xFFFFFFFF))
            {
                Store (PIO1, DMA1)
            }

            Store (GETF (And (SYNC, 0x01), And (SYNC, 0x02), PRIT), FLAG)
            If (And (LEqual (PIO0, 0xFFFFFFFF), LEqual (DMA0, 0xFFFFFFFF)))
            {
                Store (0x78, PIO0)
                Store (0x14, DMA0)
                Store (0x03, FLAG)
            }

            Return (PBUF)
        }

        Method (_STM, 3, NotSerialized)
        {
            CreateDWordField (Arg0, 0x00, PIO0)
            CreateDWordField (Arg0, 0x04, DMA0)
            CreateDWordField (Arg0, 0x08, PIO1)
            CreateDWordField (Arg0, 0x0C, DMA1)
            CreateDWordField (Arg0, 0x10, FLAG)
            If (LEqual (SizeOf (Arg1), 0x0200))
            {
                And (PRIT, 0x40F0, PRIT)
                And (SYNC, 0x02, SYNC)
                Store (0x00, SDT0)
                And (ICR0, 0x02, ICR0)
                And (ICR1, 0x02, ICR1)
                And (ICR3, 0x02, ICR3)
                And (ICR5, 0x02, ICR5)
                CreateWordField (Arg1, 0x62, W490)
                CreateWordField (Arg1, 0x6A, W530)
                CreateWordField (Arg1, 0x7E, W630)
                CreateWordField (Arg1, 0x80, W640)
                CreateWordField (Arg1, 0xB0, W880)
                CreateWordField (Arg1, 0xBA, W930)
                Or (PRIT, 0x8004, PRIT)
                If (LAnd (And (FLAG, 0x02), And (W490, 0x0800)))
                {
                    Or (PRIT, 0x02, PRIT)
                }

                Or (PRIT, SETP (PIO0, W530, W640), PRIT)
                If (And (FLAG, 0x01))
                {
                    Or (SYNC, 0x01, SYNC)
                    Store (SDMA (DMA0), SDT0)
                    If (LLess (DMA0, 0x1E))
                    {
                        Or (ICR3, 0x01, ICR3)
                    }

                    If (LLess (DMA0, 0x3C))
                    {
                        Or (ICR0, 0x01, ICR0)
                    }

                    If (And (W930, 0x2000))
                    {
                        Or (ICR1, 0x01, ICR1)
                    }
                }
            }

            If (LEqual (SizeOf (Arg2), 0x0200))
            {
                And (PRIT, 0x3F0F, PRIT)
                Store (0x00, PSIT)
                And (SYNC, 0x01, SYNC)
                Store (0x00, SDT1)
                And (ICR0, 0x01, ICR0)
                And (ICR1, 0x01, ICR1)
                And (ICR3, 0x01, ICR3)
                And (ICR5, 0x01, ICR5)
                CreateWordField (Arg2, 0x62, W491)
                CreateWordField (Arg2, 0x6A, W531)
                CreateWordField (Arg2, 0x7E, W631)
                CreateWordField (Arg2, 0x80, W641)
                CreateWordField (Arg2, 0xB0, W881)
                CreateWordField (Arg2, 0xBA, W931)
                Or (PRIT, 0x8040, PRIT)
                If (LAnd (And (FLAG, 0x08), And (W491, 0x0800)))
                {
                    Or (PRIT, 0x20, PRIT)
                }

                If (And (FLAG, 0x10))
                {
                    Or (PRIT, 0x4000, PRIT)
                    If (LGreater (PIO1, 0xF0))
                    {
                        Or (PRIT, 0x80, PRIT)
                    }
                    Else
                    {
                        Or (PRIT, 0x10, PRIT)
                        Store (SETT (PIO1, W531, W641), PSIT)
                    }
                }

                If (And (FLAG, 0x04))
                {
                    Or (SYNC, 0x02, SYNC)
                    Store (SDMA (DMA1), SDT1)
                    If (LLess (DMA1, 0x1E))
                    {
                        Or (ICR3, 0x02, ICR3)
                    }

                    If (LLess (DMA1, 0x3C))
                    {
                        Or (ICR0, 0x02, ICR0)
                    }

                    If (And (W931, 0x2000))
                    {
                        Or (ICR1, 0x02, ICR1)
                    }
                }
            }
        }

        Device (P_D0)
        {
            Name (_ADR, 0x00)
            Method (_GTF, 0, NotSerialized)
            {
                Name (PIB0, Buffer (0x0E)
                {
                    0x03, 0x00, 0x00, 0x00, 0x00, 0xA0, 0xEF, 0x03,
                    0x00, 0x00, 0x00, 0x00, 0xA0, 0xEF
                })
                CreateByteField (PIB0, 0x01, PMD0)
                CreateByteField (PIB0, 0x08, DMD0)
                If (And (PRIT, 0x02))
                {
                    If (LEqual (And (PRIT, 0x09), 0x08))
                    {
                        Store (0x08, PMD0)
                    }
                    Else
                    {
                        Store (0x0A, PMD0)
                        ShiftRight (And (PRIT, 0x0300), 0x08, Local0)
                        ShiftRight (And (PRIT, 0x3000), 0x0C, Local1)
                        Add (Local0, Local1, Local2)
                        If (LEqual (0x03, Local2))
                        {
                            Store (0x0B, PMD0)
                        }

                        If (LEqual (0x05, Local2))
                        {
                            Store (0x0C, PMD0)
                        }
                    }
                }
                Else
                {
                    Store (0x01, PMD0)
                }

                If (And (SYNC, 0x01))
                {
                    Store (Or (SDT0, 0x40), DMD0)
                    If (And (ICR1, 0x01))
                    {
                        If (And (ICR0, 0x01))
                        {
                            Add (DMD0, 0x02, DMD0)
                        }

                        If (And (ICR3, 0x01))
                        {
                            Store (0x45, DMD0)
                        }
                    }
                }
                Else
                {
                    Or (Subtract (And (PMD0, 0x07), 0x02), 0x20, DMD0)
                }

                Return (PIB0)
            }
        }

        Device (P_D1)
        {
            Name (_ADR, 0x01)
            Method (_GTF, 0, NotSerialized)
            {
                Name (PIB1, Buffer (0x0E)
                {
                    0x03, 0x00, 0x00, 0x00, 0x00, 0xB0, 0xEF, 0x03,
                    0x00, 0x00, 0x00, 0x00, 0xB0, 0xEF
                })
                CreateByteField (PIB1, 0x01, PMD1)
                CreateByteField (PIB1, 0x08, DMD1)
                If (And (PRIT, 0x20))
                {
                    If (LEqual (And (PRIT, 0x90), 0x80))
                    {
                        Store (0x08, PMD1)
                    }
                    Else
                    {
                        Add (And (PSIT, 0x03), ShiftRight (And (PSIT,
0x0C), 0x02), Local0)
                        If (LEqual (0x05, Local0))
                        {
                            Store (0x0C, PMD1)
                        }
                        Else
                        {
                            If (LEqual (0x03, Local0))
                            {
                                Store (0x0B, PMD1)
                            }
                            Else
                            {
                                Store (0x0A, PMD1)
                            }
                        }
                    }
                }
                Else
                {
                    Store (0x01, PMD1)
                }

                If (And (SYNC, 0x02))
                {
                    Store (Or (SDT1, 0x40), DMD1)
                    If (And (ICR1, 0x02))
                    {
                        If (And (ICR0, 0x02))
                        {
                            Add (DMD1, 0x02, DMD1)
                        }

                        If (And (ICR3, 0x02))
                        {
                            Store (0x45, DMD1)
                        }
                    }
                }
                Else
                {
                    Or (Subtract (And (PMD1, 0x07), 0x02), 0x20, DMD1)
                }

                Return (PIB1)
            }
        }
    }
}

Device (SATA)
{
    Name (_ADR, 0x001F0002)
    OperationRegion (SACS, PCI_Config, 0x40, 0xC0)
    Field (SACS, DWordAcc, NoLock, Preserve)
    {
        PRIT,   16,
        SECT,   16,
        PSIT,   4,
        SSIT,   4,
        Offset (0x08),
        SYNC,   4,
        Offset (0x0A),
        SDT0,   2,
            ,   2,
        SDT1,   2,
        Offset (0x0B),
        SDT2,   2,
            ,   2,
        SDT3,   2,
        Offset (0x14),
        ICR0,   4,
        ICR1,   4,
        ICR2,   4,
        ICR3,   4,
        ICR4,   4,
        ICR5,   4,
        Offset (0x50),
        MAPV,   2,
            ,   5,
        USCC,   1,
        Offset (0x52),
        PCSR,   8
    }
}

-- 
Mathieu
