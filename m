Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYAAQAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYAAQAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYAAQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:00:43 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:51462 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYAAQAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:00:35 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/WbtaDzor/Ju/eYjC6RNkh
Message-ID: <477A634C.8040000@reed.com>
Date: Tue, 01 Jan 2008 10:59:08 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu>	<20071215080831.404cdb32@tux.DEF.witbe.net>	<47638C8C.2090604@gmail.com>	<476438B4.2020600@zytor.com>	<476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<4765D95C.4010404@zytor.com>	<4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu>
In-Reply-To: <20071217212509.5edaa372@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------070206070301040404010109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070206070301040404010109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[attached the DSDT.dsl file fyi]

Alan Cox wrote:
>> responds to reads differently than "unused" ports.  In particular, an 
>> inb takes 1/2 the elapsed time compared to a read to "known" unused port 
>> 0xed - 792 tsc ticks for port 80 compared to about 1450 tsc ticks for 
>> port 0xed and other unused ports (tsc at 800 MHz).
>>     
>
> Well at least we know where the port is now - thats too fast for an LPC
> bus device, so it must be an SMI trap.
>
> Only easy way to find out is to use the debugging event counters and see
> how many instruction cycles are issued as part of the 0x80 port. If its
> suprisingly high then you've got a firmware bug and can go spank HP.
>
>   
Alan, thank you for the pointers.  I have been doing variations on this
testing theme for a while - I get intrigued by a good debugging
challenge, and after all it's my machine...

Two relevant new data points, and then some more suggestions:

1. It appears to be a real port.  SMI traps are not happening in the
normal outb to 80.  Hundreds of them execute perfectly with the expected
instruction counts.  If I can trace the particular event that creates
the hard freeze (getting really creative, here) and stop before the
freeze disables the entire computer, I will.  That may be an SMI, or
perhaps any other kind of interrupt or exception.  Maybe someone knows
how to safely trace through an impending SMI while doing printk's or
something?

2. It appears to be the standard POST diagnostic port.  On a whim, I
disassembled my DSDT code, and studied it more closely.   It turns out
that there are a bunch of "Store(..., DBUG)" instructions scattered
throughout, and when you look at what DBUG is defined as, it is defined
as an IO Port at IO address DBGP, which is a 1-byte value = 0x80.  So
the ACPI BIOS thinks it has something to do with debugging.   There's a
little strangeness here, however, because the value sent to the port
occasionally has something to do with arguments to the ACPI operations
relating to sleep and wakeup ...  could just be that those arguments are
distinctive.

In thinking about this, I recognize a couple of things.  ACPI is telling
us something when it declares a reference to port 80 in its code.  It's
not telling us the function of this port on this machine, but it is
telling us that it is being used by the BIOS.   This could be a reason
to put out a printk warning message...   'warning: port 80 is used by
ACPI BIOS - if you are experiencing problems, you might try an alternate
means of iodelay.'

Second, it seems likely that there are one of two possible reasons that
the port 80 writes cause hang/freezes:

1. buffer overflow in such a device.

2. there is some "meaning" to certain byte values being written (the
_PTS and _WAK use of arguments that come from callers to store into port
80 makes me suspicious.)   That might mean that the freeze happens only
when certain values are written, or when they are written closely in
time to some other action - being used to communicate something to the
SMM code).   If there is some race in when Linux's port 80 writes happen
that happen to change the meaning of a request to the hardware or to
SMM, then we could be rarely stepping on





--------------070206070301040404010109
Content-Type: text/x-dsl;
 name="DSDT.dsl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="DSDT.dsl"

/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20061109
 *
 * Disassembly of DSDT.dat, Wed Nov 21 17:02:51 2007
 *
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x00008FB0 (36784)
 *     Revision         0x01
 *     OEM ID           "HP    "
 *     OEM Table ID     "MCP51M"
 *     OEM Revision     0x06040000 (100925440)
 *     Creator ID       "MSFT"
 *     Creator Revision 0x03000000 (50331648)
 */
DefinitionBlock ("DSDT.aml", "DSDT", 1, "HP    ", "MCP51M", 0x06040000)
{
    External (\_PR_.CPU0._PPC)

    Name (\_S0, Package (0x04)
    {
        0x00, 
        0x00, 
        0x00, 
        0x00
    })
    Name (\_S3, Package (0x04)
    {
        0x05, 
        0x05, 
        0x00, 
        0x00
    })
    Name (\_S4, Package (0x04)
    {
        0x06, 
        0x06, 
        0x00, 
        0x00
    })
    Name (\_S5, Package (0x04)
    {
        0x07, 
        0x07, 
        0x00, 
        0x00
    })
    Name (SX, 0x00)
    Method (\_PTS, 1, NotSerialized)
    {
        Store (Arg0, DBUG)
        If (LEqual (Arg0, 0x03))
        {
            Store (0x04, GP23)
            Store (0x04, GP24)
        }

        If (LEqual (Arg0, 0x04))
        {
            Store (0x04, GP23)
            Store (0x04, GP24)
            If (LEqual (OSYS, 0x07D6))
            {
                Or (PSMI, 0x01, PSMI)
            }
            Else
            {
                And (PSMI, 0xFE, PSMI)
            }
        }

        If (LEqual (Arg0, 0x05))
        {
            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
            Store (0x8F, \_SB.PCI0.SMIC)
            Store (\_SB.PCI0.SMIS, Local0)
            Release (\_SB.PCI0.PSMX)
        }

        If (LGreater (Arg0, 0x01))
        {
            Store (Zero, LDTC)
            Store (0x04, Z000)
            Store (0x04, Z001)
            Store (0x04, Z002)
        }
    }

    Method (\_WAK, 1, NotSerialized)
    {
        Store (Arg0, DBUG)
        If (LEqual (Arg0, 0x03))
        {
            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
            Store (0x84, \_SB.PCI0.SMIC)
            Store (\_SB.PCI0.SMIS, Local0)
            Release (\_SB.PCI0.PSMX)
            And (GP23, 0x0F, GP26)
            If (LEqual (GP26, 0x05))
            {
                Store (0x01, GP26)
            }
            Else
            {
                Store (0x00, GP26)
            }

            And (GP24, 0x0F, GP25)
            If (LEqual (GP25, 0x05))
            {
                Store (0x01, GP25)
            }
            Else
            {
                Store (0x00, GP25)
            }

            Notify (\_SB.PWRB, 0x02)
            Z003 ()
        }

        If (LEqual (Arg0, 0x04))
        {
            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
            Store (0x85, \_SB.PCI0.SMIC)
            Store (\_SB.PCI0.SMIS, Local0)
            Release (\_SB.PCI0.PSMX)
            And (GP23, 0x0F, GP26)
            If (LEqual (GP26, 0x05))
            {
                Store (0x01, GP26)
            }
            Else
            {
                Store (0x00, GP26)
            }

            And (GP24, 0x0F, GP25)
            If (LEqual (GP25, 0x05))
            {
                Store (0x01, GP25)
            }
            Else
            {
                Store (0x00, GP25)
            }

            Store (Zero, S4FL)
            Store (Zero, S4RT)
            Notify (\_SB.PWRB, 0x02)
            Z003 ()
        }
    }

    Method (Z003, 0, NotSerialized)
    {
        If (LEqual (HOTB, 0x04))
        {
            Notify (\_SB.QBTN, 0x02)
        }

        If (LEqual (HOTB, 0x05))
        {
            Notify (\_SB.DBTN, 0x02)
        }

        If (LEqual (HOTB, 0x03))
        {
            Notify (\_SB.MUBN, 0x02)
        }

        If (LEqual (HOTB, 0x06))
        {
            Notify (\_SB.PIBN, 0x02)
        }

        If (LEqual (HOTB, 0x10))
        {
            Notify (\_SB.WEBN, 0x02)
        }

        If (LEqual (HOTB, 0x11))
        {
            Notify (\_SB.LVBN, 0x02)
        }

        If (LEqual (HOTB, 0x12))
        {
            Notify (\_SB.VOBN, 0x02)
        }

        Store (0x00, HOTB)
    }

    Scope (\_PR)
    {
        Processor (CPU0, 0x00, 0x00001010, 0x06) {}
        Processor (CPU1, 0x01, 0x00001010, 0x06) {}
    }

    Scope (\_SI)
    {
        Method (_SST, 1, NotSerialized)
        {
            Store ("==== SST Working ====", Debug)
        }

        Method (_MSG, 1, NotSerialized)
        {
        }
    }

    Scope (\_GPE)
    {
        Method (_L14, 0, NotSerialized)
        {
            If (PEWS)
            {
                Store (0x01, PEWS)
            }

            Notify (\_SB.PCI0.XVR1, 0x00)
            Notify (\_SB.PCI0.XVR2, 0x01)
        }

        Method (_L0B, 0, NotSerialized)
        {
            Store (0x0B, DBUG)
            Notify (\_SB.PCI0.MAC0, 0x02)
        }
    }

    Scope (\_SB)
    {
        Device (MCFG)
        {
            Name (_HID, EisaId ("PNP0C02"))
            Name (_CRS, ResourceTemplate ()
            {
                DWordMemory (ResourceConsumer, PosDecode, MinFixed, MaxFixed, NonCacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0xE0000000,         // Range Minimum
                    0xEFFFFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x10000000,         // Length
                    ,, , AddressRangeMemory, TypeStatic)
            })
        }

        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C"))
            Method (_STA, 0, NotSerialized)
            {
                Return (0x0B)
            }
        }

        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E"))
        }

        Device (ACAD)
        {
            Name (_HID, "ACPI0003")
            Name (_PCL, Package (0x01)
            {
                \_SB
            })
            Method (_PSR, 0, NotSerialized)
            {
                If (ECON)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    Store (\_SB.PCI0.EC0.ACIN, Local0)
                    Release (\_SB.PCI0.EC0.MUT0)
                    If (RBRF)
                    {
                        \_SB.PCI0.EC0.RSBR ()
                        Store (0x00, RBRF)
                    }

                    If (Local0)
                    {
                        Return (0x01)
                    }
                    Else
                    {
                        Return (0x00)
                    }
                }
                Else
                {
                    Return (0x01)
                }
            }
        }

        Method (VTOB, 1, NotSerialized)
        {
            Store (0x01, Local0)
            ShiftLeft (Local0, Arg0, Local0)
            Return (Local0)
        }

        Method (BTOV, 1, NotSerialized)
        {
            ShiftRight (Arg0, 0x01, Local0)
            Store (0x00, Local1)
            While (Local0)
            {
                Increment (Local1)
                ShiftRight (Local0, 0x01, Local0)
            }

            Return (Local1)
        }

        Method (MKWD, 2, NotSerialized)
        {
            If (And (Arg1, 0x80))
            {
                Store (0xFFFF0000, Local0)
            }
            Else
            {
                Store (Zero, Local0)
            }

            Or (Local0, Arg0, Local0)
            Or (Local0, ShiftLeft (Arg1, 0x08), Local0)
            Return (Local0)
        }

        Method (POSW, 1, NotSerialized)
        {
            If (And (Arg0, 0x8000))
            {
                If (LEqual (Arg0, 0xFFFF))
                {
                    Return (0xFFFFFFFF)
                }
                Else
                {
                    Not (Arg0, Local0)
                    Increment (Local0)
                    And (Local0, 0xFFFF, Local0)
                    Return (Local0)
                }
            }
            Else
            {
                Return (Arg0)
            }
        }

        Method (GBFE, 3, NotSerialized)
        {
            CreateByteField (Arg0, Arg1, TIDX)
            Store (TIDX, Arg2)
        }

        Method (PBFE, 3, NotSerialized)
        {
            CreateByteField (Arg0, Arg1, TIDX)
            Store (Arg2, TIDX)
        }

        Method (ITOS, 1, NotSerialized)
        {
            Store (Buffer (0x05)
                {
                    0x20, 0x20, 0x20, 0x20, 0x20
                }, Local0)
            Store (Buffer (0x11)
                {
                    "0123456789ABCDEF"
                }, Local7)
            Store (0x05, Local1)
            Store (0x00, Local2)
            Store (0x00, Local3)
            While (Local1)
            {
                Decrement (Local1)
                And (ShiftRight (Arg0, ShiftLeft (Local1, 0x02)), 0x0F, Local4)
                GBFE (Local7, Local4, RefOf (Local5))
                PBFE (Local0, Local2, Local5)
                Increment (Local2)
            }

            Return (Local0)
        }

        Device (BAT0)
        {
            Name (_HID, EisaId ("PNP0C0A"))
            Name (_PCL, Package (0x01)
            {
                \_SB
            })
            Name (PBIF, Package (0x0D)
            {
                0x01, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0x01, 
                0xFFFFFFFF, 
                0xFA, 
                0x96, 
                0x0A, 
                0x19, 
                "BAT1", 
                " ", 
                " ", 
                " "
            })
            Name (PBST, Package (0x04)
            {
                0x00, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0x2710
            })
            Name (BAST, 0x00)
            Name (B1ST, 0x0F)
            Name (B1WT, 0x00)
            Method (_STA, 0, NotSerialized)
            {
                If (ECON)
                {
                    If (\_SB.PCI0.EC0.MBTS)
                    {
                        Store (0x1F, B1ST)
                    }
                    Else
                    {
                        Store (0x0F, B1ST)
                    }
                }
                Else
                {
                    Store (0x0F, B1ST)
                }

                Return (B1ST)
            }

            Method (_BIF, 0, NotSerialized)
            {
                If (LEqual (B1ST, 0x1F))
                {
                    UPBI ()
                }
                Else
                {
                    IVBI ()
                }

                Return (PBIF)
            }

            Method (_BST, 0, NotSerialized)
            {
                If (LEqual (B1ST, 0x1F))
                {
                    UPBS ()
                }
                Else
                {
                    IVBS ()
                }

                Return (PBST)
            }

            Method (UPBI, 0, NotSerialized)
            {
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                If (LNot (\_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x10, RefOf (Local5))))
                {
                    If (LAnd (Local5, LNot (And (Local5, 0x8000))))
                    {
                        ShiftRight (Local5, 0x05, Local5)
                        ShiftLeft (Local5, 0x05, Local5)
                        Store (Local5, Index (PBIF, 0x02))
                        Divide (Local5, 0x64, , Local2)
                        Add (Local2, 0x01, Local2)
                        Multiply (Local2, 0x05, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x05))
                        Multiply (Local2, 0x03, Local4)
                        Add (Local4, 0x02, Index (PBIF, 0x06))
                    }
                }

                Store (0x1770, Index (PBIF, 0x01))
                Store (0x39D0, Index (PBIF, 0x04))
                Store ("Primary", Index (PBIF, 0x09))
                Store ("LION", Index (PBIF, 0x0B))
                Store ("Hewlett-Packard", Index (PBIF, 0x0C))
                Store (0x01, Index (PBIF, 0x00))
                Release (\_SB.PCI0.EC0.MUT0)
            }

            Method (UPUM, 0, NotSerialized)
            {
                Store (Buffer (0x0B)
                    {
                        /* 0000 */    0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 
                        /* 0008 */    0x00, 0x00, 0x00
                    }, Local0)
                Store (Buffer (0x05)
                    {
                        0x36, 0x35, 0x35, 0x33, 0x35
                    }, Local6)
                Store (Buffer (0x05)
                    {
                        0x31, 0x32, 0x33, 0x32, 0x31
                    }, Local7)
                If (LNot (\_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1B, RefOf (Local5))))
                {
                    Divide (Local5, 0x0200, , Local1)
                    Subtract (Local5, Multiply (Local1, 0x0200, Local2), Local5)
                    Multiply (Subtract (Local1, 0x0A, Local1), 0x03E8, Local1)
                    Divide (Local5, 0x20, , Local2)
                    Subtract (Local5, Multiply (Local2, 0x20, Local3), Local3)
                    Add (Multiply (Decrement (Local2), 0x1E, Local5), Local3, Local5)
                    Add (Local1, Local5, Local5)
                    Store (ITOS (ToBCD (Local5)), Local7)
                }

                If (LNot (\_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1C, RefOf (Local5))))
                {
                    Store (ITOS (ToBCD (Local5)), Local6)
                }

                Store (0x05, Local1)
                Store (0x00, Local2)
                Store (0x00, Local3)
                While (Local1)
                {
                    Decrement (Local1)
                    GBFE (Local6, Local2, RefOf (Local5))
                    PBFE (Local0, Local3, Local5)
                    Increment (Local2)
                    Increment (Local3)
                }

                Increment (Local3)
                Store (0x00, Local2)
                Store (0x05, Local1)
                While (Local1)
                {
                    Decrement (Local1)
                    GBFE (Local7, Local2, RefOf (Local5))
                    PBFE (Local0, Local3, Local5)
                    Increment (Local2)
                    Increment (Local3)
                }

                Store (Local0, Index (PBIF, 0x0A))
                Store ("Hewlett-Packard", Index (PBIF, 0x0C))
            }

            Method (UPBS, 0, NotSerialized)
            {
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (\_SB.PCI0.EC0.MBRM, Local5)
                If (LNot (And (Local5, 0x8000)))
                {
                    ShiftRight (Local5, 0x05, Local5)
                    ShiftLeft (Local5, 0x05, Local5)
                    If (LNotEqual (Local5, DerefOf (Index (PBST, 0x02))))
                    {
                        Store (Local5, Index (PBST, 0x02))
                    }
                }

                Store (\_SB.PCI0.EC0.MBCV, Index (PBST, 0x03))
                Sleep (0xFA)
                Store (\_SB.PCI0.EC0.MBST, Local0)
                Release (\_SB.PCI0.EC0.MUT0)
                Store (Local0, Index (PBST, 0x00))
            }

            Method (IVBI, 0, NotSerialized)
            {
                Store (0xFFFFFFFF, Index (PBIF, 0x01))
                Store (0xFFFFFFFF, Index (PBIF, 0x02))
                Store (0xFFFFFFFF, Index (PBIF, 0x04))
                Store ("Bad", Index (PBIF, 0x09))
                Store ("      ", Index (PBIF, 0x0A))
                Store ("Bad", Index (PBIF, 0x0B))
                Store ("Bad", Index (PBIF, 0x0C))
            }

            Method (IVBS, 0, NotSerialized)
            {
                Store (0x00, Index (PBST, 0x00))
                Store (0xFFFFFFFF, Index (PBST, 0x01))
                Store (0xFFFFFFFF, Index (PBST, 0x02))
                Store (0x2710, Index (PBST, 0x03))
            }
        }

        Device (LID)
        {
            Name (_HID, EisaId ("PNP0C0D"))
            Method (_LID, 0, NotSerialized)
            {
                If (ECON)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    Store (\_SB.PCI0.EC0.LIDS, Local0)
                    Release (\_SB.PCI0.EC0.MUT0)
                    If (Local0)
                    {
                        Return (0x00)
                    }
                    Else
                    {
                        Return (0x01)
                    }
                }
                Else
                {
                    Return (0x01)
                }
            }
        }

        Device (MEM0)
        {
            Name (_HID, EisaId ("PNP0C01"))
            Method (_CRS, 0, Serialized)
            {
                Name (MEMR, ResourceTemplate ()
                {
                    Memory32Fixed (ReadOnly,
                        0xFFC00000,         // Address Base
                        0x00400000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFEC00000,         // Address Base
                        0x00001000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0xFEE00000,         // Address Base
                        0x00100000,         // Address Length
                        )
                    Memory32Fixed (ReadWrite,
                        0x00000000,         // Address Base
                        0x00000000,         // Address Length
                        _Y00)
                })
                CreateDWordField (MEMR, \_SB.MEM0._CRS._Y00._BAS, MBAS)
                CreateDWordField (MEMR, \_SB.MEM0._CRS._Y00._LEN, MBLE)
                If (\_SB.PCI0.LPC0.MTBA)
                {
                    Store (\_SB.PCI0.LPC0.MTBA, MBAS)
                    Store (0x1000, MBLE)
                }

                Return (MEMR)
            }
        }

        Device (QLBD)
        {
            Name (_HID, "HPQ0006")
            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }
        }

        Device (WMID)
        {
            Name (Z004, Package (0x0E)
            {
                0x04, 
                0x04, 
                0x04, 
                0x00, 
                0x04, 
                0x04, 
                0x00, 
                0x00, 
                0x04, 
                0x04, 
                0x0C, 
                0x00, 
                0x00, 
                0x00
            })
            Method (Z005, 2, NotSerialized)
            {
                CreateDWordField (Arg1, 0x00, Z006)
                CreateDWordField (Arg1, 0x04, Z007)
                CreateDWordField (Arg1, 0x08, Z008)
                CreateDWordField (Arg1, 0x0C, Z009)
                If (LEqual (Arg0, 0x01))
                {
                    Store (0x00, Local0)
                }

                If (LEqual (Arg0, 0x02))
                {
                    Store (0x04, Local0)
                }

                If (LEqual (Arg0, 0x03))
                {
                    Store (0x80, Local0)
                }

                If (LEqual (Arg0, 0x04))
                {
                    Store (0x0400, Local0)
                }

                If (LEqual (Arg0, 0x05))
                {
                    Store (0x1000, Local0)
                }

                Store (Buffer (Add (0x08, Local0)) {}, Local1)
                CreateDWordField (Local1, 0x00, Z00A)
                CreateDWordField (Local1, 0x04, Z00B)
                Store (0x4C494146, Z00A)
                Store (0x02, Z00B)
                If (LEqual (Z006, 0x55434553))
                {
                    Store (0x03, Z00B)
                    If (LEqual (Z007, 0x01))
                    {
                        Store (0x04, Z00B)
                        If (LEqual (Z008, 0x05))
                        {
                            Store (^Z00C (), Local2)
                            Store (0x00, Z00B)
                        }

                        If (LEqual (Z008, 0x0E))
                        {
                            Store (^Z00D (), Local2)
                            Store (0x00, Z00B)
                        }

                        If (LEqual (Z008, 0x07))
                        {
                            If (Z009)
                            {
                                Store (DerefOf (Index (Arg1, 0x10)), Local3)
                                Store (^Z00E (Local3), Local2)
                                Store (0x00, Z00B)
                            }
                            Else
                            {
                                Store (0x05, Z00B)
                            }
                        }

                        If (LEqual (Z008, 0x01))
                        {
                            Store (^Z00F (), Local2)
                            Store (0x00, Z00B)
                        }

                        If (LEqual (Z008, 0x08))
                        {
                            Store (^Z00G (), Local2)
                            Store (0x00, Z00B)
                        }

                        If (LEqual (Z008, 0x09))
                        {
                            Store (^Z00H (), Local2)
                            Store (0x00, Z00B)
                        }

                        If (LEqual (Z008, 0x0A))
                        {
                            Store (^Z00I (), Local2)
                            Store (0x00, Z00B)
                        }

                        If (LEqual (Z008, 0x0C))
                        {
                            Store (^Z00J (), Local2)
                            Store (0x00, Z00B)
                        }
                    }

                    If (LEqual (Z007, 0x02))
                    {
                        Store (0x04, Z00B)
                        If (LAnd (LGreater (Z008, 0x00), LLessEqual (Z008, 0x0C)))
                        {
                            If (LLess (Z009, DerefOf (Index (Z004, Subtract (Z008, 0x01)
                                ))))
                            {
                                Store (0x05, Z00B)
                            }
                            Else
                            {
                                CreateDWordField (Arg1, 0x10, Z00K)
                                If (LEqual (Z008, 0x05))
                                {
                                    Store (^Z00L (Z00K), Local2)
                                    Store (0x00, Z00B)
                                }

                                If (LEqual (Z008, 0x01))
                                {
                                    Store (^Z00M (Z00K), Local2)
                                    Store (0x00, Z00B)
                                }

                                If (LEqual (Z008, 0x09))
                                {
                                    Store (^Z00N (Z00K), Local2)
                                    Store (0x00, Z00B)
                                }

                                If (LEqual (Z008, 0x0A))
                                {
                                    Store (^Z00O (Z00K), Local2)
                                    Store (0x00, Z00B)
                                }
                            }
                        }
                    }
                }

                If (LEqual (Z00B, 0x00))
                {
                    Store (DerefOf (Index (Local2, 0x00)), Z00B)
                    If (LEqual (Z00B, 0x00))
                    {
                        If (LLessEqual (DerefOf (Index (Local2, 0x01)), Local0))
                        {
                            Store (0x00, Local0)
                            While (LLess (Local0, DerefOf (Index (Local2, 0x01))))
                            {
                                Store (DerefOf (Index (DerefOf (Index (Local2, 0x02)), Local0)), 
                                    Index (Local1, Add (Local0, 0x08)))
                                Increment (Local0)
                            }

                            Store (0x53534150, Z00A)
                        }
                        Else
                        {
                            Store (0x05, Z00B)
                        }
                    }
                }

                Return (Local1)
            }

            Name (_HID, "PNP0C14")
            Name (_UID, 0x00)
            Name (Z00P, 0x00)
            Name (Z00Q, 0x00)
            Name (BUFF, Buffer (0x04)
            {
                0x00, 0x00, 0x00, 0x00
            })
            CreateByteField (BUFF, 0x00, OB0)
            CreateByteField (BUFF, 0x01, OB1)
            CreateByteField (BUFF, 0x02, OB2)
            CreateByteField (BUFF, 0x03, OB3)
            Name (_WDG, Buffer (0x50)
            {
                /* 0000 */    0x34, 0xF0, 0xB7, 0x5F, 0x63, 0x2C, 0xE9, 0x45, 
                /* 0008 */    0xBE, 0x91, 0x3D, 0x44, 0xE2, 0xC7, 0x07, 0xE4, 
                /* 0010 */    0x41, 0x44, 0x01, 0x02, 0x79, 0x42, 0xF2, 0x95, 
                /* 0018 */    0x7B, 0x4D, 0x34, 0x43, 0x93, 0x87, 0xAC, 0xCD, 
                /* 0020 */    0xC6, 0x7E, 0xF6, 0x1C, 0x80, 0x00, 0x01, 0x08, 
                /* 0028 */    0x21, 0x12, 0x90, 0x05, 0x66, 0xD5, 0xD1, 0x11, 
                /* 0030 */    0xB2, 0xF0, 0x00, 0xA0, 0xC9, 0x06, 0x29, 0x10, 
                /* 0038 */    0x41, 0x45, 0x01, 0x00, 0xD4, 0x2B, 0x99, 0xD0, 
                /* 0040 */    0x7C, 0xA4, 0xFE, 0x4E, 0xB0, 0x72, 0x32, 0x4A, 
                /* 0048 */    0xEC, 0x92, 0x29, 0x6C, 0x42, 0x43, 0x01, 0x00
            })
            Method (WQBC, 1, NotSerialized)
            {
                Store ("HP WMI WQBC)", Debug)
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x88, \_SB.PCI0.SMIC)
                Store (\_SB.PCI0.SMIS, Local0)
                Release (\_SB.PCI0.PSMX)
                Store (Local0, CADL)
                If (ECON)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    If (LEqual (\_SB.PCI0.EC0.LIDS, 0x01))
                    {
                        And (Local0, 0xFE, Local0)
                    }

                    Release (\_SB.PCI0.EC0.MUT0)
                }

                Return (Local0)
            }

            Method (WSBC, 2, NotSerialized)
            {
                Store ("HP WMI WSBC)", Debug)
                CreateByteField (Arg1, 0x00, ADA0)
                Store (ADA0, Local0)
                If (LOr (LEqual (\_SB.PCI0.XVR0.VGA.SWIT, 0x00), LEqual (\_SB.PCI0.UVGA.SWIT, 0x00)))
                {
                    Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                    Store (0x87, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Local1)
                    Release (\_SB.PCI0.PSMX)
                    If (LEqual (Local0, Local1))
                    {
                        Return (0x02)
                    }
                    Else
                    {
                        Store (0x00, NSTE)
                        If (LEqual (Local0, 0x01))
                        {
                            Store ("LCD", Debug)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                            Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            Store (Zero, \_SB.PCI0.UVGA.CRTA)
                            Store (One, \_SB.PCI0.UVGA.LCDA)
                            Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            Store (Zero, \_SB.PCI0.UVGA.HDTV)
                        }

                        If (LEqual (Local0, 0x02))
                        {
                            Store ("CRT", Debug)
                            Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            Store (One, \_SB.PCI0.UVGA.CRTA)
                            Store (Zero, \_SB.PCI0.UVGA.LCDA)
                            Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            Store (Zero, \_SB.PCI0.UVGA.HDTV)
                        }

                        If (LEqual (Local0, 0x03))
                        {
                            Store ("Both", Debug)
                            Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                            Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            Store (One, \_SB.PCI0.UVGA.CRTA)
                            Store (One, \_SB.PCI0.UVGA.LCDA)
                            Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            Store (Zero, \_SB.PCI0.UVGA.HDTV)
                        }

                        If (LEqual (Local0, 0x04))
                        {
                            Store ("TV", Debug)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                            Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            Store (Zero, \_SB.PCI0.UVGA.CRTA)
                            Store (Zero, \_SB.PCI0.UVGA.LCDA)
                            Store (One, \_SB.PCI0.UVGA.TVAF)
                            Store (Zero, \_SB.PCI0.UVGA.HDTV)
                        }

                        If (LEqual (Local0, 0x05))
                        {
                            Store ("TV+LCD", Debug)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                            Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                            Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            Store (Zero, \_SB.PCI0.UVGA.CRTA)
                            Store (One, \_SB.PCI0.UVGA.LCDA)
                            Store (One, \_SB.PCI0.UVGA.TVAF)
                            Store (Zero, \_SB.PCI0.UVGA.HDTV)
                        }

                        If (LEqual (Local0, 0x06))
                        {
                            Store ("TV+CRT", Debug)
                        }

                        If (LEqual (Local0, 0x08))
                        {
                            Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            Store (One, \_SB.PCI0.XVR0.VGA.HDTV)
                            Store (Zero, \_SB.PCI0.UVGA.CRTA)
                            Store (Zero, \_SB.PCI0.UVGA.LCDA)
                            Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            Store (One, \_SB.PCI0.UVGA.HDTV)
                        }

                        If (LEqual (Local0, 0x09))
                        {
                            Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                            Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                            Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                            Store (One, \_SB.PCI0.XVR0.VGA.HDTV)
                            Store (Zero, \_SB.PCI0.UVGA.CRTA)
                            Store (One, \_SB.PCI0.UVGA.LCDA)
                            Store (Zero, \_SB.PCI0.UVGA.TVAF)
                            Store (One, \_SB.PCI0.UVGA.HDTV)
                        }

                        Store (CADL, PADL)
                        If (LGreaterEqual (OSYS, 0x07D1))
                        {
                            Notify (\_SB.PCI0, 0x00)
                        }
                        Else
                        {
                            If (VGAT)
                            {
                                Notify (\_SB.PCI0.XVR0.VGA, 0x00)
                            }
                            Else
                            {
                                Notify (\_SB.PCI0.UVGA, 0x00)
                            }
                        }

                        Sleep (0x02EE)
                        If (VGAT)
                        {
                            Notify (\_SB.PCI0.XVR0.VGA, 0x80)
                        }
                        Else
                        {
                            Notify (\_SB.PCI0.UVGA, 0x80)
                        }

                        Return (0x00)
                    }
                }
                Else
                {
                    Return (0x01)
                }
            }

            Method (WMAD, 3, NotSerialized)
            {
                Return (Z005 (Arg1, Arg2))
            }

            Method (Z00C, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x5 (BIOS Read)", Debug)
                Store (0x01, WIRE)
                And (BTWL, 0x03, Local0)
                Or (Local0, 0x20, OB0)
                Store (WWLS, Local1)
                ShiftLeft (Local1, 0x01, Local1)
                Store (BWLS, Local2)
                ShiftLeft (Local2, 0x01, Local2)
                Store (BTLS, Local3)
                ShiftLeft (Local3, 0x03, Local3)
                Or (Local1, Local3, Local1)
                Or (Local2, Local3, Local2)
                And (GP24, 0x0F, GP25)
                If (LEqual (GP25, 0x05))
                {
                    Store (0x01, GP25)
                }
                Else
                {
                    Store (0x00, GP25)
                }

                And (GP23, 0x0F, GP26)
                If (LEqual (GP26, 0x05))
                {
                    Store (0x01, GP26)
                }
                Else
                {
                    Store (0x00, GP26)
                }

                If (GP26)
                {
                    If (LNot (WWLS))
                    {
                        Store (0x00, GP26)
                        Store (0x04, GP23)
                    }

                    If (LNot (BTLS))
                    {
                        Store (0x00, GP26)
                        Store (0x04, GP23)
                    }
                }

                If (GP25)
                {
                    If (LNot (BWLS))
                    {
                        Store (0x00, GP25)
                        Store (0x04, GP24)
                    }

                    If (LNot (BTLS))
                    {
                        Store (0x00, GP25)
                        Store (0x04, GP24)
                    }
                }

                Or (GP26, Local1, Local1)
                Or (GP25, Local2, Local2)
                Store (0x00, OB2)
                Store (0x00, OB1)
                If (WLSU)
                {
                    Or (Local1, 0x04, Local1)
                }

                If (BTSU)
                {
                    Or (Local2, 0x04, Local2)
                }

                If (GP26)
                {
                    Or (Local1, 0x10, Local1)
                }
                Else
                {
                    And (Local1, 0xEF, Local1)
                }

                If (And (BTWL, 0x01))
                {
                    Store (Local1, OB1)
                }

                If (And (BTWL, 0x02))
                {
                    Store (Local2, OB2)
                }

                Store (0x00, OB3)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04)
                        {
                            0x01, 0x02, 0x03, 0x04
                        }
                    }, Local0)
                Store (OB0, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Store (OB1, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                Store (OB2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                Store (OB3, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                Return (Local0)
            }

            Method (Z00L, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x5 (BIOS Write)", Debug)
                And (GP24, 0x0F, GP25)
                If (LEqual (GP25, 0x05))
                {
                    Store (0x01, GP25)
                }
                Else
                {
                    Store (0x00, GP25)
                }

                And (GP23, 0x0F, GP26)
                If (LEqual (GP26, 0x05))
                {
                    Store (0x01, GP26)
                }
                Else
                {
                    Store (0x00, GP26)
                }

                If (And (BTWL, 0x03))
                {
                    If (And (Arg0, 0x0800))
                    {
                        If (And (Arg0, 0x08))
                        {
                            Store (0x01, WWLS)
                            Store (0x01, BWLS)
                            If (WLSU)
                            {
                                If (BTLS)
                                {
                                    Store (0x01, GP26)
                                    Store (0x05, GP23)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP26)
                                Store (0x04, GP23)
                            }

                            If (BTSU)
                            {
                                If (BTLS)
                                {
                                    Store (0x01, GP25)
                                    Store (0x05, GP24)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP25)
                                Store (0x04, GP24)
                            }
                        }
                        Else
                        {
                            Store (0x00, WWLS)
                            Store (0x00, GP26)
                            Store (0x04, GP23)
                            Store (0x00, BWLS)
                            Store (0x00, GP25)
                            Store (0x04, GP24)
                        }
                    }

                    If (And (Arg0, 0x0100))
                    {
                        If (And (Arg0, 0x01))
                        {
                            Store (0x01, WWLS)
                            If (WLSU)
                            {
                                If (BTLS)
                                {
                                    Store (0x01, GP26)
                                    Store (0x05, GP23)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP26)
                                Store (0x04, GP23)
                            }
                        }
                        Else
                        {
                            Store (0x00, WWLS)
                            Store (0x00, GP26)
                            Store (0x04, GP23)
                        }
                    }

                    If (And (Arg0, 0x0200))
                    {
                        If (And (Arg0, 0x02))
                        {
                            Store (0x01, BWLS)
                            If (BTSU)
                            {
                                If (BTLS)
                                {
                                    Store (0x01, GP25)
                                    Store (0x05, GP24)
                                }
                            }
                            Else
                            {
                                Store (0x00, GP25)
                                Store (0x04, GP24)
                            }
                        }
                        Else
                        {
                            Store (0x00, BWLS)
                            Store (0x00, GP25)
                            Store (0x04, GP24)
                        }
                    }

                    Return (Package (0x02)
                    {
                        0x00, 
                        0x00
                    })
                }
                Else
                {
                    Return (Package (0x02)
                    {
                        0x0D, 
                        0x00
                    })
                }
            }

            Method (Z00D, 0, NotSerialized)
            {
                Store ("HP WMI Command 0xE (BIOS Read)", Debug)
                Store (0x00, Local0)
                Store (Buffer (0x0A)
                    {
                        /* 0000 */    0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
                        /* 0008 */    0x00, 0x00
                    }, Local2)
                Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                Store (0x00, \_SB.PCI0.SMIS)
                Store (0x89, \_SB.PCI0.SMIC)
                Store (\_SB.PCI0.SMIS, WLID)
                Release (\_SB.PCI0.PSMX)
                If (LNotEqual (WLID, 0xFF))
                {
                    Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                    Store (0x02, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x02))
                    Store (0x03, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x03))
                    Store (0x04, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x04))
                    Store (0x05, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x05))
                    Store (0x06, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x06))
                    Store (0x07, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x07))
                    Store (0x08, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x08))
                    Store (0x09, \_SB.PCI0.SMIS)
                    Store (0x89, \_SB.PCI0.SMIC)
                    Store (\_SB.PCI0.SMIS, Index (Local2, 0x09))
                    Release (\_SB.PCI0.PSMX)
                    Store (Local2, Local1)
                    Add (Local0, 0x0A, Local0)
                }

                Store (Package (0x03) {}, Local2)
                Store (0x00, Index (Local2, 0x00))
                Store (Local0, Index (Local2, 0x01))
                Store (Local1, Index (Local2, 0x02))
                Return (Local2)
            }

            Method (Z00E, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x7 (BIOS Read)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                If (LNot (ECON))
                {
                    Store (Package (0x02)
                        {
                            0x0D, 
                            0x00
                        }, Local0)
                    Sleep (0x96)
                    Release (\_SB.PCI0.EC0.MUT0)
                    Return (Local0)
                }

                If (Arg0)
                {
                    Store (Package (0x02)
                        {
                            0x06, 
                            0x00
                        }, Local0)
                    Sleep (0x96)
                    Release (\_SB.PCI0.EC0.MUT0)
                    Return (Local0)
                }

                If (LNot (\_SB.PCI0.EC0.MBTS))
                {
                    Store (Package (0x02)
                        {
                            0x06, 
                            0x00
                        }, Local0)
                    Sleep (0x96)
                    Release (\_SB.PCI0.EC0.MUT0)
                    Return (Local0)
                }

                Release (\_SB.PCI0.EC0.MUT0)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x80, 
                        Buffer (0x80) {}
                    }, Local0)
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x18, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x01))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x10, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x03))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x0F, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x05))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x04))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x0C, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x07))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x06))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x17, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x09))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x08))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x08, RefOf (Local1))
                Subtract (Local1, 0x0AAA, Local1)
                Divide (Local1, 0x0A, Local2, Local1)
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x0B))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0A))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x09, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x0D))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0C))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x0A, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x0F))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x0E))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x19, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x11))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x10))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x16, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x13))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x12))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3F, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x15))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x14))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3E, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x17))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x16))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3D, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x19))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x18))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x3C, RefOf (Local1))
                Divide (Local1, 0x0100, Local2, Index (DerefOf (Index (Local0, 0x02)), 
                    0x1B))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x1A))
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1C, RefOf (Local1))
                Store (ITOS (ToBCD (Local1)), Local3)
                Store (0x1C, Local2)
                Store (0x00, Local4)
                Store (SizeOf (Local3), Local1)
                While (Local1)
                {
                    GBFE (Local3, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local4)
                }

                Store (0x20, Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                \_SB.PCI0.EC0.SMRD (0x09, 0x16, 0x1B, RefOf (Local1))
                And (Local1, 0x1F, Local7)
                Store (ITOS (ToBCD (Local7)), Local6)
                And (Local1, 0x01E0, Local7)
                ShiftRight (Local7, 0x05, Local7)
                Store (ITOS (ToBCD (Local7)), Local5)
                ShiftRight (Local1, 0x09, Local7)
                Add (Local7, 0x07BC, Local7)
                Store (ITOS (ToBCD (Local7)), Local4)
                Store (0x02, Local1)
                Store (0x03, Local7)
                While (Local1)
                {
                    GBFE (Local5, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store ("/", Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                Store (0x02, Local1)
                Store (0x03, Local7)
                While (Local1)
                {
                    GBFE (Local6, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store ("/", Index (DerefOf (Index (Local0, 0x02)), Local2))
                Increment (Local2)
                Store (0x04, Local1)
                Store (0x01, Local7)
                While (Local1)
                {
                    GBFE (Local4, Local7, RefOf (Local3))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local3)
                    Decrement (Local1)
                    Increment (Local2)
                    Increment (Local7)
                }

                Store (0x00, Index (DerefOf (Index (Local0, 0x02)), Local2))
                \_SB.PCI0.EC0.SMRD (0x0B, 0x16, 0x20, RefOf (Local1))
                Store (SizeOf (Local1), Local3)
                Store (0x2C, Local2)
                Store (0x00, Local4)
                While (Local3)
                {
                    GBFE (Local1, Local4, RefOf (Local5))
                    PBFE (DerefOf (Index (Local0, 0x02)), Local2, Local5)
                    Decrement (Local3)
                    Increment (Local2)
                    Increment (Local4)
                }

                Store (0x00, Index (DerefOf (Index (Local0, 0x02)), Local2))
                Sleep (0x96)
                Return (Local0)
            }

            Method (Z00F, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x1 (BIOS Read)", Debug)
                Store (WQBC (0x00), OB0)
                Or (OB0, 0x01, OB0)
                Store (0x00, OB1)
                Store (0x00, OB2)
                Store (0x00, OB3)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04)
                        {
                            0x01, 0x02, 0x03, 0x04
                        }
                    }, Local0)
                Store (OB0, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Store (OB1, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                Store (OB2, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                Store (OB3, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                Return (Local0)
            }

            Method (Z00M, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x1 (BIOS Write)", Debug)
                And (Arg0, 0x0F, Local0)
                If (VGAT)
                {
                    If (LEqual (\_SB.PCI0.XVR0.VGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x87, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local1)
                        Release (\_SB.PCI0.PSMX)
                        If (LEqual (Local0, Local1))
                        {
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                        Else
                        {
                            Store (0x00, NSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store ("TV+LCD", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x06))
                            {
                                Store ("TV+CRT", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            If (LEqual (Local0, 0x07))
                            {
                                Store ("TV+CRT+LCD", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            If (LEqual (Local0, 0x08))
                            {
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (One, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x09))
                            {
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (One, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LGreaterEqual (Local0, 0x0A))
                            {
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            Store (CADL, PADL)
                            Notify (\_SB.PCI0.XVR0.VGA, 0x80)
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                    }
                    Else
                    {
                        Return (Package (0x02)
                        {
                            0x00, 
                            0x00
                        })
                    }
                }
                Else
                {
                    If (LEqual (\_SB.PCI0.UVGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x87, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local1)
                        Release (\_SB.PCI0.PSMX)
                        If (LEqual (Local0, Local1))
                        {
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                        Else
                        {
                            Store (0x00, NSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store ("TV+LCD", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x06))
                            {
                                Store ("TV+CRT", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            If (LEqual (Local0, 0x07))
                            {
                                Store ("TV+CRT+LCD", Debug)
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            If (LEqual (Local0, 0x08))
                            {
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (One, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x09))
                            {
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (One, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LGreaterEqual (Local0, 0x0A))
                            {
                                Return (Package (0x02)
                                {
                                    0x06, 
                                    0x00
                                })
                            }

                            Store (CADL, PADL)
                            Notify (\_SB.PCI0.UVGA, 0x80)
                            Return (Package (0x02)
                            {
                                0x00, 
                                0x00
                            })
                        }
                    }
                    Else
                    {
                        Return (Package (0x02)
                        {
                            0x00, 
                            0x00
                        })
                    }
                }
            }

            Method (Z00G, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x8 (BIOS Read)", Debug)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x80, 
                        Buffer (0x80)
                        {
                            /* 0000 */    0x31, 0x01, 0x9B, 0x01, 0xFF, 0x01, 0x63, 0x02, 
                            /* 0008 */    0xAE, 0x01, 0x64, 0x02, 0x9D, 0x01, 0xB6, 0x01, 
                            /* 0010 */    0xB7, 0x01, 0x65, 0x02, 0x66, 0x02, 0x67, 0x02, 
                            /* 0018 */    0x68, 0x02, 0xFF, 0xFF, 0xE4, 0x20, 0xE6, 0x20, 
                            /* 0020 */    0x42, 0x21, 0x70, 0x21, 0x00, 0x00
                        }
                    }, Local0)
                Return (Local0)
            }

            Method (Z00H, 0, NotSerialized)
            {
                Store ("HP WMI Command 0x9 (BIOS Read)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                Store (\_SB.PCI0.EC0.Z00R (), Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Release (\_SB.PCI0.EC0.MUT0)
                Return (Local0)
            }

            Method (Z00N, 1, NotSerialized)
            {
                Store ("HP WMI Command 0x9 (BIOS Write)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                \_SB.PCI0.EC0.Z00S (Arg0)
                Release (\_SB.PCI0.EC0.MUT0)
                Return (Package (0x02)
                {
                    0x00, 
                    0x00
                })
            }

            Method (Z00T, 0, NotSerialized)
            {
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                If (ECON)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    Store (\_SB.PCI0.EC0.QBHK, Local1)
                    Store (0x00, \_SB.PCI0.EC0.QBHK)
                    Release (\_SB.PCI0.EC0.MUT0)
                }

                If (LEqual (Local1, 0x0D))
                {
                    Store ("Fn+ESC Pressed", Debug)
                    Store (0x31, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x01))
                {
                    Store ("Fn+F1 Pressed", Debug)
                    Store (0x9B, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x04))
                {
                    \_SB.PCI0.EC0._Q0D ()
                    Store (0x00, Local3)
                    Store (0x00, Local4)
                    Store (0x00, Local5)
                    Store (0xAE, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                    ShiftLeft (And (NSTE, 0x01), 0x01, Local3)
                    ShiftLeft (And (NSTE, 0x02), 0x01, Local4)
                    ShiftRight (And (NSTE, 0x08), 0x03, Local5)
                    Or (Local3, Local4, Local3)
                    Or (Local3, Local5, Local3)
                    Store (CSTE, Local3)
                    Store (Local3, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                    ShiftLeft (And (CADL, 0x01), 0x01, Local3)
                    ShiftLeft (And (CADL, 0x02), 0x01, Local4)
                    ShiftRight (And (CADL, 0x08), 0x03, Local5)
                    Or (Local3, Local4, Local3)
                    Or (Local3, Local5, Local3)
                    Store (PSTE, Local3)
                    Store (Local3, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                }

                If (LEqual (Local1, 0x06))
                {
                    Store ("Fn+F6 Pressed", Debug)
                    Store (0x9D, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x07))
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        If (LEqual (VGAT, 0x01))
                        {
                            Notify (\_SB.PCI0.XVR0.VGA.LCD, 0x87)
                        }
                        Else
                        {
                            Notify (\_SB.PCI0.UVGA.LCD, 0x87)
                        }
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8D, \_SB.PCI0.SMIC)
                        Release (\_SB.PCI0.PSMX)
                    }

                    Sleep (0x32)
                    Store (0xB6, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x08))
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        If (LEqual (VGAT, 0x01))
                        {
                            Notify (\_SB.PCI0.XVR0.VGA.LCD, 0x86)
                        }
                        Else
                        {
                            Notify (\_SB.PCI0.UVGA.LCD, 0x86)
                        }
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8C, \_SB.PCI0.SMIC)
                        Release (\_SB.PCI0.PSMX)
                    }

                    Sleep (0x32)
                    Store (0xB7, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x01, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                Return (Local0)
            }

            Method (Z00I, 0, NotSerialized)
            {
                Store ("HP WMI Command 0xA (BIOS Read)", Debug)
                Return (Z00T ())
            }

            Method (Z00O, 1, NotSerialized)
            {
                Store ("HP WMI Command 0xA (BIOS Write)", Debug)
                And (Arg0, 0xFF, Local1)
                And (Arg0, 0xFF00, Local3)
                ShiftRight (Local3, 0x08, Local2)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                Store (Local1, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                Store (Local2, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                If (LEqual (Arg0, 0x01AE))
                {
                    \_SB.PCI0.EC0._Q0D ()
                    Store (CSTE, Index (DerefOf (Index (Local0, 0x02)), 0x02))
                    Store (PSTE, Index (DerefOf (Index (Local0, 0x02)), 0x03))
                }

                Return (Local0)
            }

            Method (Z00J, 0, NotSerialized)
            {
                Store ("HP WMI Command 0xC (BIOS Read)", Debug)
                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                Store (Package (0x03)
                    {
                        0x00, 
                        0x04, 
                        Buffer (0x04) {}
                    }, Local0)
                If (ECON)
                {
                    Store (\_SB.PCI0.EC0.QBBB, Local1)
                    Store (0x00, \_SB.PCI0.EC0.QBBB)
                }

                If (LEqual (Local1, 0x03))
                {
                    Store (0xE4, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x20, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x04))
                {
                    Store (0x42, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x05))
                {
                    Store (0xE6, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x20, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                If (LEqual (Local1, 0x10))
                {
                    Store (0x70, Index (DerefOf (Index (Local0, 0x02)), 0x00))
                    Store (0x21, Index (DerefOf (Index (Local0, 0x02)), 0x01))
                }

                Release (\_SB.PCI0.EC0.MUT0)
                Return (Local0)
            }

            Method (_WED, 1, NotSerialized)
            {
                Concatenate (Z00P, Z00Q, Local0)
                Return (Local0)
            }

            Name (WQAE, Buffer (0x08A9)
            {
                /* 0000 */    0x46, 0x4F, 0x4D, 0x42, 0x01, 0x00, 0x00, 0x00, 
                /* 0008 */    0x99, 0x08, 0x00, 0x00, 0x8A, 0x3A, 0x00, 0x00, 
                /* 0010 */    0x44, 0x53, 0x00, 0x01, 0x1A, 0x7D, 0xDA, 0x54, 
                /* 0018 */    0x98, 0x4B, 0x9C, 0x00, 0x01, 0x06, 0x18, 0x42, 
                /* 0020 */    0x10, 0x13, 0x10, 0x22, 0x21, 0x04, 0x12, 0x01, 
                /* 0028 */    0xA1, 0xC8, 0x2C, 0x0C, 0x86, 0x10, 0x38, 0x2E, 
                /* 0030 */    0x84, 0x1C, 0x40, 0x88, 0x59, 0x50, 0x08, 0x21, 
                /* 0038 */    0x10, 0xEA, 0x4F, 0x20, 0xBF, 0x02, 0x10, 0x3A, 
                /* 0040 */    0x14, 0x20, 0x53, 0x80, 0x41, 0x01, 0x4E, 0x11, 
                /* 0048 */    0x44, 0xD0, 0xAB, 0x00, 0x9B, 0x02, 0x4C, 0x0A, 
                /* 0050 */    0xB0, 0x28, 0x40, 0xBB, 0x00, 0xCB, 0x02, 0x74, 
                /* 0058 */    0x0B, 0x90, 0x0E, 0x4B, 0x44, 0x82, 0xA3, 0xC4, 
                /* 0060 */    0x80, 0xA3, 0x74, 0x62, 0x0B, 0x37, 0x6C, 0xF0, 
                /* 0068 */    0x42, 0x51, 0x34, 0x83, 0x28, 0x09, 0x2A, 0x17, 
                /* 0070 */    0xE0, 0x1B, 0x41, 0xE0, 0xE5, 0x0A, 0x90, 0x3C, 
                /* 0078 */    0x01, 0x69, 0x16, 0x60, 0x58, 0x80, 0x75, 0x01, 
                /* 0080 */    0xB2, 0x87, 0x40, 0xA5, 0x0E, 0x01, 0x25, 0x67, 
                /* 0088 */    0x08, 0xA8, 0x01, 0xB4, 0x3A, 0x01, 0xE1, 0x57, 
                /* 0090 */    0x3A, 0x25, 0x24, 0x41, 0x38, 0x63, 0x15, 0x8F, 
                /* 0098 */    0xAF, 0x59, 0x34, 0x3D, 0x27, 0x39, 0xC7, 0x90, 
                /* 00A0 */    0xE3, 0x71, 0xA1, 0x07, 0xC1, 0x05, 0x78, 0x18, 
                /* 00A8 */    0x06, 0x1D, 0xB2, 0x22, 0x6B, 0x80, 0xC1, 0x58, 
                /* 00B0 */    0x18, 0x0B, 0x75, 0x31, 0x6A, 0xD4, 0x48, 0xD9, 
                /* 00B8 */    0x80, 0x0C, 0x51, 0x12, 0x1C, 0x6A, 0xD4, 0x96, 
                /* 00C0 */    0x28, 0xC0, 0xFC, 0x38, 0x34, 0xBB, 0xB6, 0xC7, 
                /* 00C8 */    0x42, 0x20, 0x99, 0xB4, 0xA1, 0xA0, 0xA4, 0x40, 
                /* 00D0 */    0x68, 0x6C, 0x67, 0xEA, 0x19, 0x45, 0x3C, 0x52, 
                /* 00D8 */    0xC3, 0x24, 0xF0, 0x28, 0x22, 0x1B, 0x8D, 0x43, 
                /* 00E0 */    0x63, 0x87, 0xE1, 0x61, 0x06, 0x3B, 0x88, 0xC3, 
                /* 00E8 */    0x38, 0xE6, 0xC8, 0x09, 0x3C, 0xA1, 0x23, 0x3D, 
                /* 00F0 */    0xF2, 0xC2, 0xE6, 0x29, 0xD4, 0x18, 0xCD, 0x41, 
                /* 00F8 */    0x11, 0xB8, 0xD0, 0x18, 0x19, 0x10, 0xF2, 0x3C, 
                /* 0100 */    0x7E, 0x8D, 0xC4, 0x04, 0x76, 0x2F, 0xC0, 0x1A, 
                /* 0108 */    0xA6, 0x60, 0x1B, 0x9B, 0x98, 0xFE, 0xFF, 0x10, 
                /* 0110 */    0x47, 0x1E, 0xA3, 0xAD, 0xB9, 0x0B, 0x29, 0x4C, 
                /* 0118 */    0x8C, 0x28, 0xC1, 0xE2, 0x55, 0x3C, 0x0D, 0xA1, 
                /* 0120 */    0x3C, 0x29, 0x84, 0x8A, 0x54, 0x19, 0x8A, 0x86, 
                /* 0128 */    0x1E, 0xA5, 0x42, 0x01, 0xCE, 0xE6, 0x21, 0xDC, 
                /* 0130 */    0x1A, 0x41, 0x85, 0x10, 0x2B, 0x52, 0xAC, 0xF6, 
                /* 0138 */    0x07, 0x41, 0x42, 0x2E, 0x5B, 0xC7, 0x07, 0x47, 
                /* 0140 */    0x1A, 0x0D, 0xEA, 0x50, 0xE0, 0xB1, 0x7B, 0xDC, 
                /* 0148 */    0xCF, 0x02, 0x3E, 0x08, 0x9C, 0x5B, 0x90, 0xA3, 
                /* 0150 */    0x3B, 0x8B, 0x47, 0x85, 0x83, 0xF6, 0xF0, 0xD8, 
                /* 0158 */    0x6D, 0xC0, 0x67, 0x08, 0x9F, 0x02, 0xF0, 0xAE, 
                /* 0160 */    0x01, 0x35, 0xFD, 0x83, 0x67, 0x82, 0xE0, 0x50, 
                /* 0168 */    0x43, 0xF4, 0xA8, 0xC3, 0x9D, 0xC0, 0x21, 0x32, 
                /* 0170 */    0x40, 0x4F, 0xEA, 0xB8, 0xB1, 0x83, 0x3B, 0x99, 
                /* 0178 */    0x83, 0x7E, 0x6F, 0x68, 0xF6, 0xC6, 0x40, 0x08, 
                /* 0180 */    0x8E, 0xC7, 0x97, 0x05, 0x36, 0xE1, 0x04, 0x96, 
                /* 0188 */    0x3F, 0x08, 0xD4, 0xC8, 0x0C, 0xED, 0x51, 0x9E, 
                /* 0190 */    0x56, 0xCC, 0x90, 0xCF, 0x0C, 0x26, 0xB0, 0x58, 
                /* 0198 */    0x08, 0x29, 0x80, 0xD0, 0x78, 0xC0, 0x7F, 0x03, 
                /* 01A0 */    0x78, 0xC0, 0xF0, 0xCD, 0xC0, 0xF3, 0x35, 0xC1, 
                /* 01A8 */    0xB0, 0x10, 0x32, 0xB2, 0x0A, 0x8F, 0x87, 0x8E, 
                /* 01B0 */    0xC2, 0xD7, 0x83, 0xC3, 0x39, 0xAD, 0x78, 0x26, 
                /* 01B8 */    0x18, 0x0E, 0x42, 0x27, 0x09, 0x8B, 0x1A, 0x36, 
                /* 01C0 */    0x3D, 0x39, 0xF0, 0x43, 0x03, 0xBB, 0x19, 0x9C, 
                /* 01C8 */    0xC1, 0x23, 0x80, 0x47, 0x72, 0x42, 0xFE, 0x98, 
                /* 01D0 */    0x78, 0x60, 0xF0, 0x01, 0xF1, 0xDE, 0xA7, 0x4C, 
                /* 01D8 */    0x46, 0x70, 0xA6, 0x06, 0xF4, 0x71, 0xC0, 0xFF, 
                /* 01E0 */    0xFF, 0xA1, 0xF0, 0x21, 0x7A, 0x7C, 0xA7, 0x7C, 
                /* 01E8 */    0xBC, 0x96, 0x00, 0x21, 0x59, 0xE3, 0x84, 0x7E, 
                /* 01F0 */    0x87, 0xF0, 0xF1, 0xC3, 0x47, 0x16, 0x47, 0x84, 
                /* 01F8 */    0x90, 0x93, 0x53, 0x00, 0x1A, 0xF8, 0x74, 0xCF, 
                /* 0200 */    0x2E, 0xC2, 0xE9, 0x7A, 0x52, 0x0E, 0x34, 0x0C, 
                /* 0208 */    0x3A, 0x4E, 0x70, 0x9C, 0x07, 0xC0, 0x31, 0x4E, 
                /* 0210 */    0xF8, 0xE7, 0x02, 0xF8, 0x03, 0xE4, 0xA7, 0x8C, 
                /* 0218 */    0x57, 0x8C, 0x04, 0x8E, 0x39, 0x42, 0xF4, 0xB9, 
                /* 0220 */    0xC6, 0x23, 0xC4, 0xC2, 0x3F, 0x55, 0x14, 0x3E, 
                /* 0228 */    0x10, 0x32, 0x46, 0x70, 0x01, 0x7A, 0x8C, 0xC0, 
                /* 0230 */    0x37, 0xE0, 0x18, 0xD1, 0x47, 0x09, 0xAE, 0xFE, 
                /* 0238 */    0xA0, 0x41, 0x07, 0x88, 0xFB, 0xFF, 0x0F, 0x10, 
                /* 0240 */    0x3E, 0xA8, 0x07, 0x08, 0x7C, 0xA3, 0x1F, 0x3D, 
                /* 0248 */    0xD0, 0xE3, 0xB2, 0xE8, 0xF3, 0x80, 0x8C, 0x9F, 
                /* 0250 */    0x68, 0x34, 0x2F, 0x7E, 0x3A, 0xE0, 0x87, 0x0F, 
                /* 0258 */    0xF0, 0x80, 0x7A, 0x48, 0x38, 0x50, 0xCC, 0xB4, 
                /* 0260 */    0x39, 0xE8, 0xB3, 0xCB, 0xA1, 0x63, 0x87, 0x0B, 
                /* 0268 */    0xFE, 0x13, 0x08, 0xB8, 0xE4, 0x1D, 0xC2, 0x40, 
                /* 0270 */    0x31, 0x62, 0xFC, 0x39, 0xC8, 0xA7, 0x30, 0xF0, 
                /* 0278 */    0xFF, 0xFF, 0x4F, 0x61, 0xB8, 0x11, 0xF0, 0x20, 
                /* 0280 */    0xAF, 0x05, 0x9F, 0xB6, 0xA8, 0x74, 0x18, 0xD4, 
                /* 0288 */    0x81, 0x0B, 0x30, 0x09, 0x1A, 0xE1, 0x59, 0xA2, 
                /* 0290 */    0x36, 0x08, 0x01, 0xBF, 0x4D, 0xBC, 0x6D, 0xF9, 
                /* 0298 */    0x16, 0x10, 0xE7, 0xC8, 0x7B, 0x3B, 0x70, 0x11, 
                /* 02A0 */    0x8C, 0x08, 0xA7, 0x1D, 0xCA, 0x63, 0x88, 0x18, 
                /* 02A8 */    0x23, 0xCA, 0xE3, 0x96, 0x51, 0xDE, 0xB6, 0x5E, 
                /* 02B0 */    0x00, 0xE2, 0x9D, 0xE5, 0xF3, 0x96, 0x31, 0x82, 
                /* 02B8 */    0x47, 0x7E, 0xE0, 0x62, 0x62, 0xDF, 0x13, 0xFA, 
                /* 02C0 */    0xB9, 0xF9, 0xC0, 0x05, 0x38, 0xFB, 0xFF, 0x1F, 
                /* 02C8 */    0xB8, 0x00, 0x0E, 0x05, 0x3D, 0x0C, 0xA1, 0x87, 
                /* 02D0 */    0xE1, 0xA9, 0x9C, 0xCB, 0x13, 0xE5, 0xA9, 0x44, 
                /* 02D8 */    0x8C, 0x1A, 0x26, 0xEA, 0x33, 0x94, 0x2F, 0x1A, 
                /* 02E0 */    0x3E, 0x10, 0x81, 0xEF, 0xCC, 0x05, 0xFC, 0xFE, 
                /* 02E8 */    0xFF, 0x07, 0x22, 0x38, 0x02, 0xCF, 0x34, 0xA0, 
                /* 02F0 */    0xF4, 0x39, 0x03, 0x81, 0x9C, 0x8A, 0x0F, 0x35, 
                /* 02F8 */    0xC0, 0x48, 0xF4, 0xAB, 0xC1, 0x27, 0x1A, 0x2A, 
                /* 0300 */    0x13, 0x06, 0x75, 0xA8, 0x01, 0x4C, 0x5E, 0x61, 
                /* 0308 */    0x9E, 0x46, 0xCF, 0xF9, 0x59, 0xC6, 0xA7, 0x1A, 
                /* 0310 */    0x1F, 0x4A, 0x8D, 0x63, 0x88, 0x97, 0x99, 0x87, 
                /* 0318 */    0x1A, 0x1F, 0x0B, 0x5E, 0x49, 0x7D, 0xA8, 0x31, 
                /* 0320 */    0x54, 0x9C, 0x87, 0x1A, 0x9F, 0x48, 0x03, 0x45, 
                /* 0328 */    0x7D, 0xB3, 0x79, 0xB6, 0x31, 0x7A, 0x7C, 0xDF, 
                /* 0330 */    0x50, 0x0D, 0xF1, 0x50, 0xC3, 0x84, 0xBD, 0x23, 
                /* 0338 */    0xF4, 0xC1, 0xF5, 0xA1, 0x06, 0x1C, 0xFF, 0xFF, 
                /* 0340 */    0x43, 0x0D, 0xC0, 0xFF, 0xFF, 0xFF, 0xA1, 0x06, 
                /* 0348 */    0x70, 0x74, 0x34, 0x80, 0x73, 0x64, 0xC4, 0x1D, 
                /* 0350 */    0x0D, 0xC0, 0x75, 0x28, 0x05, 0x0E, 0x47, 0x03, 
                /* 0358 */    0xE0, 0x71, 0x14, 0x02, 0xF3, 0x85, 0xC6, 0x47, 
                /* 0360 */    0x21, 0x60, 0xF1, 0xFF, 0x3F, 0x0A, 0xE1, 0x64, 
                /* 0368 */    0x9F, 0x83, 0x50, 0x42, 0x8F, 0x42, 0x80, 0x54, 
                /* 0370 */    0xC8, 0xA7, 0x88, 0x67, 0x1F, 0x5F, 0x7E, 0x1E, 
                /* 0378 */    0x08, 0x22, 0xBC, 0xE6, 0xFB, 0x14, 0xE4, 0x43, 
                /* 0380 */    0xBE, 0x8F, 0x42, 0x0C, 0xC6, 0x50, 0xBE, 0x06, 
                /* 0388 */    0xF9, 0x28, 0xC4, 0xA0, 0x5E, 0x83, 0x7C, 0xDF, 
                /* 0390 */    0x37, 0xC8, 0x91, 0x18, 0xFB, 0x99, 0xC0, 0x47, 
                /* 0398 */    0x21, 0x26, 0xED, 0x28, 0x04, 0x28, 0xFC, 0xFF, 
                /* 03A0 */    0x1F, 0x85, 0x00, 0xFE, 0xFF, 0xFF, 0x8F, 0x42, 
                /* 03A8 */    0x80, 0xB3, 0x00, 0x47, 0x03, 0xD0, 0x4D, 0xEB, 
                /* 03B0 */    0x51, 0x08, 0xBC, 0x77, 0x96, 0xD3, 0x3E, 0x01, 
                /* 03B8 */    0x9F, 0x85, 0x00, 0xB3, 0xFF, 0xFF, 0xB3, 0x10, 
                /* 03C0 */    0x30, 0x3B, 0x0A, 0x45, 0x3D, 0xE8, 0x57, 0xA1, 
                /* 03C8 */    0x27, 0x80, 0x17, 0x80, 0x18, 0x61, 0xDE, 0x81, 
                /* 03D0 */    0x5E, 0x32, 0xD9, 0x5D, 0xDC, 0x38, 0x4F, 0x2E, 
                /* 03D8 */    0xA7, 0x6D, 0x94, 0x97, 0x20, 0x1F, 0x28, 0x9E, 
                /* 03E0 */    0x85, 0x0C, 0xF5, 0x2E, 0x14, 0xF4, 0x8D, 0xDC, 
                /* 03E8 */    0xA3, 0x8C, 0x19, 0x3F, 0xC4, 0xF3, 0x90, 0x21, 
                /* 03F0 */    0x9E, 0x85, 0x00, 0x76, 0xFD, 0xFF, 0xCF, 0x42, 
                /* 03F8 */    0x00, 0xFF, 0xFF, 0xFF, 0x47, 0x03, 0xF8, 0x2F, 
                /* 0400 */    0x00, 0x9F, 0x85, 0x80, 0xE7, 0x09, 0xE0, 0x41, 
                /* 0408 */    0xDB, 0x67, 0x21, 0x80, 0x33, 0x87, 0xCB, 0xF3, 
                /* 0410 */    0x0F, 0x7A, 0x60, 0xEF, 0x11, 0x9E, 0xF5, 0x71, 
                /* 0418 */    0xBF, 0x5E, 0x7A, 0xE0, 0x0F, 0x05, 0xCF, 0x42, 
                /* 0420 */    0x0C, 0xEB, 0x98, 0x7C, 0x16, 0x62, 0x10, 0x2F, 
                /* 0428 */    0x9A, 0x86, 0x78, 0xE1, 0xF4, 0x61, 0xC0, 0xFF, 
                /* 0430 */    0x7F, 0xBC, 0xC0, 0xAF, 0x9C, 0x06, 0x0A, 0x12, 
                /* 0438 */    0xE8, 0x59, 0x08, 0x60, 0xFC, 0xFF, 0xFF, 0x2C, 
                /* 0440 */    0x04, 0x90, 0x71, 0x8D, 0x3A, 0x0B, 0x01, 0xCB, 
                /* 0448 */    0x63, 0x0C, 0x3B, 0xAD, 0x24, 0xF8, 0xFF, 0x3F, 
                /* 0450 */    0x0B, 0x01, 0x9F, 0x5C, 0x46, 0x0E, 0x42, 0x98, 
                /* 0458 */    0x88, 0x6F, 0x05, 0x1F, 0x33, 0x01, 0xA5, 0xE7, 
                /* 0460 */    0xA0, 0x17, 0x77, 0x63, 0x04, 0x7E, 0x91, 0x78, 
                /* 0468 */    0xCC, 0x64, 0x47, 0x4D, 0xC3, 0x3C, 0x0B, 0x19, 
                /* 0470 */    0xEF, 0x30, 0xCE, 0xE0, 0x09, 0xDE, 0x93, 0x7F, 
                /* 0478 */    0x16, 0x62, 0x60, 0xC7, 0x18, 0xEC, 0x51, 0xC8, 
                /* 0480 */    0xA0, 0x06, 0x8F, 0x1D, 0x22, 0x4C, 0xA0, 0x67, 
                /* 0488 */    0x21, 0x16, 0x6A, 0xDC, 0x3A, 0x7F, 0xF8, 0x2C, 
                /* 0490 */    0x04, 0xBC, 0xFF, 0xFF, 0x67, 0x21, 0xC0, 0xD3, 
                /* 0498 */    0x61, 0xC3, 0x67, 0x0D, 0xF0, 0x0C, 0xDF, 0xA3, 
                /* 04A0 */    0x3A, 0x87, 0xC7, 0x63, 0xE0, 0x92, 0x55, 0xC7, 
                /* 04A8 */    0x09, 0x83, 0xE5, 0x5E, 0xA7, 0x6C, 0x9C, 0x61, 
                /* 04B0 */    0xE8, 0x20, 0xAC, 0x0E, 0x48, 0xC3, 0xC1, 0xDC, 
                /* 04B8 */    0x43, 0x0E, 0xE2, 0x7C, 0xD8, 0x40, 0xAD, 0x08, 
                /* 04C0 */    0x4E, 0xC7, 0x24, 0x0F, 0xDA, 0x5A, 0x28, 0xA4, 
                /* 04C8 */    0x80, 0x46, 0x03, 0x32, 0xBC, 0x33, 0x9F, 0x96, 
                /* 04D0 */    0x28, 0x88, 0x01, 0x7D, 0x02, 0xB2, 0x8D, 0x73, 
                /* 04D8 */    0x00, 0x6A, 0x2F, 0x9A, 0x02, 0x39, 0xDA, 0x60, 
                /* 04E0 */    0xF4, 0x5F, 0x16, 0xE8, 0x6C, 0x7C, 0x0D, 0xE0, 
                /* 04E8 */    0x1A, 0x20, 0x74, 0x30, 0x30, 0xB4, 0xD5, 0xDC, 
                /* 04F0 */    0x62, 0x50, 0x60, 0xC6, 0x7F, 0x70, 0x31, 0x81, 
                /* 04F8 */    0x8F, 0x2E, 0xF8, 0xB3, 0x00, 0xEE, 0xFF, 0x3F, 
                /* 0500 */    0x5C, 0x8F, 0xF6, 0x5D, 0xA0, 0xEA, 0xC9, 0xEA, 
                /* 0508 */    0x8A, 0x60, 0x75, 0x97, 0x17, 0x08, 0x33, 0x32, 
                /* 0510 */    0x41, 0x7D, 0x07, 0x02, 0x50, 0x00, 0xF9, 0x0E, 
                /* 0518 */    0xE0, 0xA3, 0xD3, 0x73, 0x00, 0x9B, 0x48, 0x88, 
                /* 0520 */    0x30, 0xD1, 0x8C, 0x8E, 0x98, 0x30, 0x2A, 0xFA, 
                /* 0528 */    0x84, 0x29, 0x88, 0x27, 0xEC, 0x58, 0x13, 0x46, 
                /* 0530 */    0xCF, 0xC4, 0x77, 0x1B, 0x36, 0x62, 0x4C, 0x88, 
                /* 0538 */    0xDB, 0x06, 0xB4, 0x09, 0x06, 0xF5, 0x3D, 0x08, 
                /* 0540 */    0xD6, 0x90, 0xF9, 0x58, 0x7C, 0x67, 0xC0, 0x4D, 
                /* 0548 */    0x19, 0x8C, 0x73, 0x62, 0xD7, 0x04, 0x0B, 0x9C, 
                /* 0550 */    0x33, 0xC8, 0xE1, 0x31, 0xD7, 0x2F, 0x7E, 0x5B, 
                /* 0558 */    0xF2, 0xE8, 0xF8, 0x41, 0xC1, 0x37, 0x1C, 0x86, 
                /* 0560 */    0xFD, 0x30, 0xE6, 0x19, 0xBD, 0x8A, 0xF9, 0xE6, 
                /* 0568 */    0x86, 0x81, 0xF5, 0x78, 0x39, 0xAC, 0xD1, 0xC2, 
                /* 0570 */    0x1E, 0xDA, 0xAB, 0x87, 0xCF, 0x2D, 0x3E, 0x4F, 
                /* 0578 */    0x18, 0x23, 0xAC, 0x2F, 0x2C, 0xE0, 0x00, 0xFC, 
                /* 0580 */    0xFF, 0xBF, 0x5A, 0xC1, 0xBE, 0x6B, 0x80, 0xE7, 
                /* 0588 */    0x26, 0xE4, 0xBB, 0x06, 0xC0, 0xDA, 0xFF, 0xFF, 
                /* 0590 */    0x5D, 0x03, 0xFE, 0x35, 0xC1, 0x77, 0x0D, 0xE0, 
                /* 0598 */    0x3D, 0x74, 0xDF, 0x35, 0x80, 0x6B, 0xF6, 0xBB, 
                /* 05A0 */    0x06, 0xEA, 0x18, 0x60, 0x85, 0x77, 0x0D, 0x68, 
                /* 05A8 */    0xB7, 0xB4, 0x57, 0xB4, 0x87, 0x2A, 0x6B, 0xBA, 
                /* 05B0 */    0x6C, 0xA0, 0xD4, 0x5C, 0x36, 0x00, 0x6D, 0xFF, 
                /* 05B8 */    0xFF, 0xCB, 0x06, 0xB0, 0x91, 0x32, 0x61, 0x54, 
                /* 05C0 */    0xF8, 0x09, 0x53, 0x10, 0x4F, 0xD8, 0xC1, 0x2E, 
                /* 05C8 */    0x1B, 0xA0, 0x88, 0x71, 0xD9, 0x00, 0xFD, 0xD8, 
                /* 05D0 */    0x5E, 0x36, 0x80, 0xC1, 0x3D, 0x81, 0xDF, 0x36, 
                /* 05D8 */    0x80, 0x37, 0xA4, 0x6F, 0x1B, 0xC0, 0xF4, 0xFF, 
                /* 05E0 */    0x0F, 0x31, 0xFF, 0x6D, 0x03, 0xC5, 0x61, 0x95, 
                /* 05E8 */    0xB7, 0x0D, 0x88, 0x87, 0x77, 0x46, 0x60, 0x55, 
                /* 05F0 */    0xD7, 0x0D, 0x94, 0x9E, 0xEB, 0x06, 0x40, 0x02, 
                /* 05F8 */    0x31, 0x13, 0x46, 0xC5, 0x9F, 0x30, 0x05, 0xF1, 
                /* 0600 */    0x84, 0x1D, 0xED, 0xBA, 0x01, 0x8A, 0x20, 0xD7, 
                /* 0608 */    0x0D, 0xD0, 0xCF, 0xEB, 0x94, 0xC1, 0xFA, 0xFF, 
                /* 0610 */    0xBF, 0x6E, 0x60, 0x2F, 0x0A, 0x98, 0xFB, 0x06, 
                /* 0618 */    0xF0, 0x86, 0xE5, 0xF7, 0x0D, 0xC0, 0xC7, 0xE5, 
                /* 0620 */    0x1B, 0x73, 0xDF, 0x00, 0x6C, 0xFE, 0xFF, 0xEF, 
                /* 0628 */    0x1B, 0x00, 0x13, 0x2E, 0x0A, 0xB8, 0xFB, 0x06, 
                /* 0630 */    0xF0, 0xBE, 0x48, 0xFB, 0xBE, 0x01, 0x5C, 0x83, 
                /* 0638 */    0x49, 0xF8, 0xFF, 0xDF, 0xF5, 0xE8, 0x0B, 0x40, 
                /* 0640 */    0x51, 0x60, 0x50, 0x43, 0xF2, 0x99, 0x00, 0x3F, 
                /* 0648 */    0xBA, 0x83, 0x3B, 0xA6, 0xE0, 0x4C, 0x12, 0x1C, 
                /* 0650 */    0x6A, 0xE0, 0xBE, 0x02, 0x3C, 0xCD, 0x9F, 0xD6, 
                /* 0658 */    0x7B, 0xBD, 0xE7, 0xF1, 0x24, 0x10, 0x92, 0x1D, 
                /* 0660 */    0x61, 0x7C, 0x6C, 0x43, 0x9C, 0x0C, 0xC8, 0x41, 
                /* 0668 */    0xDC, 0x47, 0xF7, 0x88, 0xEF, 0xE1, 0x86, 0x49, 
                /* 0670 */    0xE0, 0x21, 0x33, 0x34, 0x0E, 0x8D, 0x1D, 0x86, 
                /* 0678 */    0xEF, 0x02, 0xC1, 0x0E, 0xE2, 0x30, 0xCE, 0xD7, 
                /* 0680 */    0x04, 0x9E, 0xD0, 0x83, 0xC0, 0x7B, 0xF9, 0xA3, 
                /* 0688 */    0x41, 0xF1, 0x77, 0x03, 0x4A, 0x60, 0xB8, 0xD0, 
                /* 0690 */    0x98, 0x91, 0xFA, 0x6C, 0xFF, 0x8E, 0x70, 0x24, 
                /* 0698 */    0x26, 0xB0, 0x7B, 0x48, 0x59, 0x13, 0xA0, 0xF1, 
                /* 06A0 */    0x96, 0x43, 0x20, 0x7A, 0xC3, 0x91, 0x2D, 0x14, 
                /* 06A8 */    0xCD, 0x2D, 0xCA, 0xFB, 0x42, 0x14, 0x3B, 0x43, 
                /* 06B0 */    0x10, 0x46, 0x94, 0x60, 0x41, 0x9E, 0xD6, 0x62, 
                /* 06B8 */    0x45, 0x79, 0x66, 0x37, 0x42, 0xC4, 0x10, 0xAF, 
                /* 06C0 */    0x0C, 0x81, 0x5E, 0x12, 0xC2, 0x07, 0x79, 0xEC, 
                /* 06C8 */    0x89, 0xD3, 0xFE, 0x20, 0x88, 0xF8, 0x17, 0x82, 
                /* 06D0 */    0x3C, 0x80, 0x28, 0xD2, 0x68, 0x50, 0xE7, 0x06, 
                /* 06D8 */    0x8F, 0xDD, 0x87, 0x10, 0x5F, 0xFE, 0x7D, 0xB8, 
                /* 06E0 */    0xF7, 0xE8, 0x0E, 0xEE, 0x45, 0xFE, 0xA0, 0x3D, 
                /* 06E8 */    0x3C, 0x76, 0xC2, 0xF0, 0x41, 0x03, 0x8E, 0x6B, 
                /* 06F0 */    0x40, 0x4D, 0xFF, 0x19, 0x01, 0x2C, 0x97, 0x7F, 
                /* 06F8 */    0xF8, 0xE3, 0xF1, 0x3D, 0xC1, 0xF3, 0x39, 0xE1, 
                /* 0700 */    0x04, 0x96, 0x3F, 0x08, 0xD4, 0x71, 0x84, 0xCF, 
                /* 0708 */    0xF3, 0x85, 0xC3, 0x90, 0xCF, 0x02, 0x87, 0xC5, 
                /* 0710 */    0xC4, 0x0A, 0xF8, 0xFF, 0x9F, 0x4C, 0xD8, 0x78, 
                /* 0718 */    0xC0, 0x7F, 0x0F, 0x79, 0xFD, 0xF7, 0xCD, 0xC0, 
                /* 0720 */    0xF3, 0x35, 0xC1, 0x88, 0x10, 0x72, 0x32, 0x1E, 
                /* 0728 */    0x34, 0xE8, 0xD9, 0xF8, 0x80, 0xE1, 0xEB, 0x09, 
                /* 0730 */    0x3B, 0x77, 0x70, 0x51, 0xE7, 0x0E, 0xD4, 0xD1, 
                /* 0738 */    0xC1, 0xA7, 0x06, 0x76, 0xB3, 0xC1, 0x1C, 0xB7, 
                /* 0740 */    0xF9, 0x59, 0x03, 0xFC, 0x23, 0x84, 0x7F, 0x7B, 
                /* 0748 */    0xF0, 0xBC, 0x7C, 0x65, 0x78, 0x75, 0x48, 0xE0, 
                /* 0750 */    0x90, 0x23, 0x44, 0x8F, 0xCB, 0x23, 0xC4, 0x9C, 
                /* 0758 */    0x6F, 0x30, 0x43, 0x04, 0xD7, 0x59, 0x00, 0x1C, 
                /* 0760 */    0x43, 0x04, 0x3E, 0x67, 0x4C, 0x9F, 0x71, 0x60, 
                /* 0768 */    0xFE, 0xFF, 0xCF, 0x38, 0xEC, 0xD2, 0xC3, 0x07, 
                /* 0770 */    0x6A, 0x78, 0x13, 0xF8, 0xFE, 0x8C, 0x3B, 0xD2, 
                /* 0778 */    0x18, 0x9C, 0x1F, 0x33, 0x1E, 0x76, 0x18, 0xF8, 
                /* 0780 */    0xFB, 0x8E, 0x67, 0x70, 0x34, 0x3E, 0xA0, 0x18, 
                /* 0788 */    0x21, 0xF8, 0x73, 0xC9, 0x73, 0x8A, 0x35, 0x0F, 
                /* 0790 */    0x52, 0x33, 0x7A, 0x67, 0x38, 0x04, 0x76, 0xB3, 
                /* 0798 */    0xC2, 0x1D, 0x38, 0x3C, 0x04, 0x3E, 0x80, 0x56, 
                /* 07A0 */    0x27, 0x47, 0x4E, 0x3F, 0xA7, 0x84, 0x1B, 0x3E, 
                /* 07A8 */    0xBF, 0x0A, 0x60, 0x0E, 0x41, 0x38, 0x85, 0x36, 
                /* 07B0 */    0x7D, 0x6A, 0x34, 0x6A, 0xD5, 0xA0, 0x4C, 0x8D, 
                /* 07B8 */    0x32, 0x0D, 0x6A, 0xF5, 0xA9, 0xD4, 0x98, 0xB1, 
                /* 07C0 */    0x0B, 0x8B, 0x03, 0xBE, 0x02, 0x74, 0x1C, 0xB0, 
                /* 07C8 */    0x3C, 0x0A, 0x1D, 0xC1, 0xC8, 0x9B, 0x40, 0x20, 
                /* 07D0 */    0x0E, 0x0B, 0x42, 0x23, 0xBD, 0x71, 0x04, 0x62, 
                /* 07D8 */    0xC9, 0xEF, 0x2F, 0x81, 0x58, 0xEE, 0x03, 0x45, 
                /* 07E0 */    0x20, 0x0E, 0x68, 0x02, 0x9C, 0xAA, 0x00, 0xA7, 
                /* 07E8 */    0xAF, 0x01, 0x81, 0x38, 0x32, 0x08, 0x15, 0xFA, 
                /* 07F0 */    0x35, 0x13, 0x88, 0x63, 0x82, 0xD0, 0x50, 0x3E, 
                /* 07F8 */    0x40, 0x98, 0xF4, 0x17, 0x80, 0x00, 0x89, 0x11, 
                /* 0800 */    0x10, 0x16, 0xEE, 0xE5, 0x20, 0x10, 0x4B, 0x7B, 
                /* 0808 */    0x2D, 0x08, 0xC4, 0x42, 0xAC, 0x80, 0xB0, 0xB8, 
                /* 0810 */    0x20, 0x34, 0x9C, 0x16, 0x10, 0x26, 0xC9, 0x0C, 
                /* 0818 */    0x08, 0x0B, 0x04, 0x42, 0xE5, 0x3F, 0xD3, 0x04, 
                /* 0820 */    0x62, 0x91, 0x6E, 0x00, 0xE9, 0xBA, 0x05, 0xE2, 
                /* 0828 */    0x20, 0x7A, 0x40, 0x98, 0x0C, 0x3F, 0x20, 0x2C, 
                /* 0830 */    0x34, 0x08, 0x8D, 0xF6, 0x6C, 0x10, 0x20, 0x31, 
                /* 0838 */    0x04, 0xC2, 0xE2, 0x3B, 0x02, 0x61, 0xE2, 0xDF, 
                /* 0840 */    0x44, 0x02, 0x71, 0x4A, 0x4B, 0x10, 0x37, 0xA5, 
                /* 0848 */    0x01, 0x06, 0x11, 0x90, 0x93, 0x6A, 0x02, 0x62, 
                /* 0850 */    0xB9, 0x41, 0x34, 0x24, 0xF2, 0xB0, 0x10, 0x90, 
                /* 0858 */    0x93, 0x82, 0x68, 0xC0, 0xC4, 0x14, 0x90, 0xFF, 
                /* 0860 */    0xFF, 0x43, 0x13, 0x88, 0x80, 0x9C, 0xCA, 0x15, 
                /* 0868 */    0x10, 0x8B, 0x08, 0x22, 0x20, 0x27, 0x7B, 0x52, 
                /* 0870 */    0x09, 0xC8, 0x39, 0x41, 0x74, 0x04, 0x20, 0xBA, 
                /* 0878 */    0x80, 0x58, 0x3E, 0x10, 0x01, 0x39, 0x96, 0x2F, 
                /* 0880 */    0x20, 0x16, 0x12, 0x44, 0x40, 0x4E, 0xF4, 0xF3, 
                /* 0888 */    0x09, 0x44, 0xE2, 0x81, 0x68, 0x10, 0xE4, 0x3F, 
                /* 0890 */    0x21, 0x20, 0x67, 0x04, 0x11, 0x10, 0x79, 0x12, 
                /* 0898 */    0x05, 0x21, 0x9A, 0x3E, 0x62, 0x02, 0x71, 0x6A, 
                /* 08A0 */    0x10, 0x9A, 0xEC, 0x27, 0x14, 0x84, 0xFC, 0xFF, 
                /* 08A8 */    0x01
            })
        }

        Device (PCI0)
        {
            Name (_ADR, 0x00)
            Name (_HID, EisaId ("PNP0A03"))
            Name (_UID, 0x01)
            Method (_INI, 0, NotSerialized)
            {
                Store (0x07D0, OSYS)
                If (CondRefOf (_OSI, Local0))
                {
                    If (\_OSI ("Linux"))
                    {
                        Store (0x03E8, OSYS)
                    }

                    If (\_OSI ("Windows 2001"))
                    {
                        Store (0x07D1, OSYS)
                    }

                    If (\_OSI ("Windows 2001 SP1"))
                    {
                        Store (0x07D1, OSYS)
                    }

                    If (\_OSI ("Windows 2001 SP2"))
                    {
                        Store (0x07D2, OSYS)
                    }

                    If (\_OSI ("Windows 2006"))
                    {
                        Store (0x07D6, OSYS)
                    }
                }
            }

            Method (_STA, 0, NotSerialized)
            {
                Return (0x0F)
            }

            Scope (\_SB)
            {
                OperationRegion (ASLD, SystemMemory, 0x7FF15DBC, 0x00000100)
                Field (ASLD, AnyAcc, NoLock, Preserve)
                {
                    TOM,    32, 
                    R_ST,   1, 
                        ,   3, 
                    R_P0,   4, 
                    R_S0,   4, 
                    R_S1,   4, 
                    RSS0,   4, 
                    RSS1,   4, 
                    PSTN,   8, 
                    DUAL,   8, 
                    IVIM,   8, 
                    ACBR,   8, 
                    DCBR,   8, 
                    WC01,   8, 
                    SID0,   8, 
                    SID1,   8, 
                    SID2,   8, 
                    SID3,   8, 
                    SID4,   8, 
                    EAX0,   32, 
                    EBX0,   32, 
                    CCBR,   8, 
                    ACST,   8
                }
            }

            Method (_CRS, 0, NotSerialized)
            {
                Name (CBUF, ResourceTemplate ()
                {
                    WordBusNumber (ResourceProducer, MinFixed, MaxFixed, PosDecode,
                        0x0000,             // Granularity
                        0x0000,             // Range Minimum
                        0x00FF,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0100,             // Length
                        ,, )
                    IO (Decode16,
                        0x0CF8,             // Range Minimum
                        0x0CF8,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                        0x0000,             // Granularity
                        0x0000,             // Range Minimum
                        0x0CF7,             // Range Maximum
                        0x0000,             // Translation Offset
                        0x0CF8,             // Length
                        ,, , TypeStatic)
                    WordIO (ResourceProducer, MinFixed, MaxFixed, PosDecode, EntireRange,
                        0x0000,             // Granularity
                        0x0D00,             // Range Minimum
                        0xFFFF,             // Range Maximum
                        0x0000,             // Translation Offset
                        0xF300,             // Length
                        ,, , TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000A0000,         // Range Minimum
                        0x000BFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00020000,         // Length
                        ,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C0000,         // Range Minimum
                        0x000C3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C4000,         // Range Minimum
                        0x000C7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000C8000,         // Range Minimum
                        0x000CBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000CC000,         // Range Minimum
                        0x000CFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D0000,         // Range Minimum
                        0x000D3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D4000,         // Range Minimum
                        0x000D7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000D8000,         // Range Minimum
                        0x000DBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000DC000,         // Range Minimum
                        0x000DFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E0000,         // Range Minimum
                        0x000E3FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E4000,         // Range Minimum
                        0x000E7FFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000E8000,         // Range Minimum
                        0x000EBFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000EC000,         // Range Minimum
                        0x000EFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00004000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x000F0000,         // Range Minimum
                        0x000FFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0x00010000,         // Length
                        0x00,, , AddressRangeMemory, TypeStatic)
                    DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                        0x00000000,         // Granularity
                        0x00100000,         // Range Minimum
                        0xFEBFFFFF,         // Range Maximum
                        0x00000000,         // Translation Offset
                        0xFFF00000,         // Length
                        ,, _Y01, AddressRangeMemory, TypeStatic)
                })
                CreateDWordField (CBUF, \_SB.PCI0._CRS._Y01._MIN, PMMN)
                CreateDWordField (CBUF, \_SB.PCI0._CRS._Y01._LEN, PMLN)
                Multiply (\_SB.TOM, 0x00100000, PMMN)
                Subtract (0xFEC00000, PMMN, PMLN)
                Return (CBUF)
            }

            Name (_PRT, Package (0x0D)
            {
                Package (0x04)
                {
                    0x000AFFFF, 
                    0x00, 
                    \_SB.PCI0.LSMB, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000AFFFF, 
                    0x01, 
                    \_SB.PCI0.LPMU, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000BFFFF, 
                    0x00, 
                    \_SB.PCI0.LUS0, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000BFFFF, 
                    0x01, 
                    \_SB.PCI0.LUS2, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0014FFFF, 
                    0x00, 
                    \_SB.PCI0.LMAC, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0010FFFF, 
                    0x01, 
                    \_SB.PCI0.LAZA, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000DFFFF, 
                    0x00, 
                    \_SB.PCI0.LPID, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000EFFFF, 
                    0x00, 
                    \_SB.PCI0.LTID, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x000FFFFF, 
                    0x00, 
                    \_SB.PCI0.LSI1, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x00, 
                    \_SB.PCI0.LK3E, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x01, 
                    \_SB.PCI0.LK4E, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x02, 
                    \_SB.PCI0.LK1E, 
                    0x00
                }, 

                Package (0x04)
                {
                    0x0005FFFF, 
                    0x03, 
                    \_SB.PCI0.LK2E, 
                    0x00
                }
            })
            Device (LPC0)
            {
                Name (_ADR, 0x000A0000)
                OperationRegion (P44, PCI_Config, 0x44, 0x04)
                Field (P44, AnyAcc, NoLock, Preserve)
                {
                    MTBA,   32
                }

                OperationRegion (P74, PCI_Config, 0x74, 0x04)
                Field (P74, AnyAcc, NoLock, Preserve)
                {
                    HPTF,   16
                }

                Device (MBRD)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x1F)
                    Name (RSRC, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadWrite,
                            0xE0000000,         // Address Base
                            0x10000000,         // Address Length
                            )
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        Return (RSRC)
                    }
                }

                Device (PMIO)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x03)
                    Method (_CRS, 0, NotSerialized)
                    {
                        Name (IODM, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x00,               // Alignment
                                0x00,               // Length
                                )
                        })
                        Name (IORT, ResourceTemplate ()
                        {
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y02)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y03)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y04)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y05)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y06)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x80,               // Length
                                _Y07)
                            IO (Decode16,
                                0x0000,             // Range Minimum
                                0x0000,             // Range Maximum
                                0x01,               // Alignment
                                0x40,               // Length
                                _Y08)
                        })
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y02._MIN, I1MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y02._MAX, I1MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y03._MIN, I2MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y03._MAX, I2MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y04._MIN, I3MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y04._MAX, I3MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y05._MIN, I4MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y05._MAX, I4MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y06._MIN, I5MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y06._MAX, I5MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y07._MIN, I6MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y07._MAX, I6MX)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y08._MIN, I9MN)
                        CreateWordField (IORT, \_SB.PCI0.LPC0.PMIO._CRS._Y08._MAX, I9MX)
                        And (\_SB.PCI0.SMB0.PMBR, 0xFFFC, I1MN)
                        Store (I1MN, I1MX)
                        Add (I1MN, 0x80, Local0)
                        Store (Local0, I2MN)
                        Store (Local0, I2MX)
                        And (\_SB.PCI0.SMB0.NVSB, 0xFFFC, I3MN)
                        Store (I3MN, I3MX)
                        Add (I3MN, 0x80, Local0)
                        Store (Local0, I4MN)
                        Store (Local0, I4MX)
                        And (\_SB.PCI0.SMB0.ANLG, 0xFFFC, I5MN)
                        Store (I5MN, I5MX)
                        Add (I5MN, 0x80, Local0)
                        Store (Local0, I6MN)
                        Store (Local0, I6MX)
                        And (\_SB.PCI0.SMB0.SB7C, 0xFFFC, I9MN)
                        Store (I9MN, I9MX)
                        If (I1MN)
                        {
                            Store (IORT, Local0)
                        }
                        Else
                        {
                            Store (IODM, Local0)
                        }

                        Return (Local0)
                    }
                }
            }

            OperationRegion (SSMI, SystemIO, 0x142E, 0x02)
            Field (SSMI, ByteAcc, NoLock, Preserve)
            {
                SMIC,   8, 
                SMIS,   8
            }

            Mutex (PSMX, 0x00)
            Method (PHSR, 2, NotSerialized)
            {
                Acquire (PSMX, 0xFFFF)
                Store (Arg1, SMIS)
                Store (Arg0, SMIC)
                Store (SMIS, Local0)
                Release (PSMX)
                Return (Local0)
            }

            Device (SYS0)
            {
                Name (_HID, EisaId ("PNP0C02"))
                Name (_UID, 0x01)
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0010,             // Range Minimum
                        0x0010,             // Range Maximum
                        0x01,               // Alignment
                        0x10,               // Length
                        )
                    IO (Decode16,
                        0x0022,             // Range Minimum
                        0x0022,             // Range Maximum
                        0x01,               // Alignment
                        0x1E,               // Length
                        )
                    IO (Decode16,
                        0x0044,             // Range Minimum
                        0x0044,             // Range Maximum
                        0x01,               // Alignment
                        0x1C,               // Length
                        )
                    IO (Decode16,
                        0x0068,             // Range Minimum
                        0x0068,             // Range Maximum
                        0x01,               // Alignment
                        0x08,               // Length
                        )
                    IO (Decode16,
                        0x0080,             // Range Minimum
                        0x0080,             // Range Maximum
                        0x00,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0091,             // Range Minimum
                        0x0091,             // Range Maximum
                        0x01,               // Alignment
                        0x03,               // Length
                        )
                    IO (Decode16,
                        0x0097,             // Range Minimum
                        0x0097,             // Range Maximum
                        0x01,               // Alignment
                        0x09,               // Length
                        )
                    IO (Decode16,
                        0x00A2,             // Range Minimum
                        0x00A2,             // Range Maximum
                        0x01,               // Alignment
                        0x1E,               // Length
                        )
                    IO (Decode16,
                        0x00E0,             // Range Minimum
                        0x00E0,             // Range Maximum
                        0x01,               // Alignment
                        0x10,               // Length
                        )
                    IO (Decode16,
                        0x0360,             // Range Minimum
                        0x0360,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x0380,             // Range Minimum
                        0x0380,             // Range Maximum
                        0x01,               // Alignment
                        0x04,               // Length
                        )
                    IO (Decode16,
                        0x04D0,             // Range Minimum
                        0x04D0,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                })
            }

            Device (PIC0)
            {
                Name (_HID, EisaId ("PNP0000"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0020,             // Range Minimum
                        0x0020,             // Range Maximum
                        0x04,               // Alignment
                        0x02,               // Length
                        )
                    IO (Decode16,
                        0x00A0,             // Range Minimum
                        0x00A0,             // Range Maximum
                        0x04,               // Alignment
                        0x02,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {2}
                })
            }

            Device (DMA0)
            {
                Name (_HID, EisaId ("PNP0200"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0000,             // Range Minimum
                        0x0000,             // Range Maximum
                        0x01,               // Alignment
                        0x09,               // Length
                        )
                    IO (Decode16,
                        0x000A,             // Range Minimum
                        0x000A,             // Range Maximum
                        0x01,               // Alignment
                        0x06,               // Length
                        )
                    IO (Decode16,
                        0x0081,             // Range Minimum
                        0x0081,             // Range Maximum
                        0x01,               // Alignment
                        0x03,               // Length
                        )
                    IO (Decode16,
                        0x0087,             // Range Minimum
                        0x0087,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0089,             // Range Minimum
                        0x0089,             // Range Maximum
                        0x01,               // Alignment
                        0x03,               // Length
                        )
                    IO (Decode16,
                        0x008F,             // Range Minimum
                        0x008F,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x00C0,             // Range Minimum
                        0x00C0,             // Range Maximum
                        0x01,               // Alignment
                        0x12,               // Length
                        )
                    IO (Decode16,
                        0x00D4,             // Range Minimum
                        0x00D4,             // Range Maximum
                        0x01,               // Alignment
                        0x0C,               // Length
                        )
                    DMA (Compatibility, BusMaster, Transfer8, )
                        {4}
                })
            }

            Device (SPK0)
            {
                Name (_HID, EisaId ("PNP0800"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0061,             // Range Minimum
                        0x0061,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                })
            }

            Device (MTH0)
            {
                Name (_HID, EisaId ("PNP0C04"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x00F0,             // Range Minimum
                        0x00F0,             // Range Maximum
                        0x01,               // Alignment
                        0x02,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {13}
                })
            }

            Device (PIT0)
            {
                Name (_HID, EisaId ("PNP0100"))
                Name (BUF0, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0040,             // Range Minimum
                        0x0040,             // Range Maximum
                        0x00,               // Alignment
                        0x04,               // Length
                        )
                })
                Name (BUF1, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0040,             // Range Minimum
                        0x0040,             // Range Maximum
                        0x00,               // Alignment
                        0x04,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {0}
                })
                Method (_CRS, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Return (BUF0)
                    }
                    Else
                    {
                        Return (BUF1)
                    }
                }
            }

            Device (RTC0)
            {
                Name (_HID, EisaId ("PNP0B00"))
                Name (BUF2, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0070,             // Range Minimum
                        0x0070,             // Range Maximum
                        0x00,               // Alignment
                        0x02,               // Length
                        )
                })
                Name (BUF3, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0070,             // Range Minimum
                        0x0070,             // Range Maximum
                        0x00,               // Alignment
                        0x02,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {8}
                })
                Method (_CRS, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Return (BUF2)
                    }
                    Else
                    {
                        Return (BUF3)
                    }
                }
            }

            Device (MMTM)
            {
                Name (_HID, EisaId ("PNP0103"))
                Name (BUF4, ResourceTemplate ()
                {
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {0}
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {8}
                    Memory32Fixed (ReadOnly,
                        0x00000000,         // Address Base
                        0x00000400,         // Address Length
                        _Y09)
                })
                Name (BUF5, ResourceTemplate ()
                {
                })
                Method (_STA, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Return (0x0F)
                    }

                    Return (0x00)
                }

                CreateDWordField (BUF4, \_SB.PCI0.MMTM._Y09._BAS, MMBB)
                Method (_CRS, 0, NotSerialized)
                {
                    If (And (\_SB.PCI0.LPC0.HPTF, 0x04))
                    {
                        Store (\_SB.PCI0.LPC0.MTBA, MMBB)
                        Return (BUF4)
                    }
                    Else
                    {
                        Return (BUF5)
                    }
                }
            }

            Device (KBC0)
            {
                Name (_HID, EisaId ("PNP0303"))
                Name (_CRS, ResourceTemplate ()
                {
                    IO (Decode16,
                        0x0060,             // Range Minimum
                        0x0060,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IO (Decode16,
                        0x0064,             // Range Minimum
                        0x0064,             // Range Maximum
                        0x01,               // Alignment
                        0x01,               // Length
                        )
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {1}
                })
            }

            Device (MSE0)
            {
                Method (_HID, 0, NotSerialized)
                {
                    If (LEqual (HPBD, 0x01))
                    {
                        Return ("*SYN012A")
                    }
                    Else
                    {
                        Return ("*SYN0129")
                    }
                }

                Name (_CID, Package (0x03)
                {
                    0x00012E4F, 
                    0x02002E4F, 
                    0x130FD041
                })
                Name (_CRS, ResourceTemplate ()
                {
                    IRQ (Edge, ActiveHigh, Exclusive, )
                        {12}
                })
            }

            Device (EC0)
            {
                Name (_HID, EisaId ("PNP0C09"))
                Name (_UID, 0x01)
                Name (_GPE, 0x10)
                Method (_CRS, 0, NotSerialized)
                {
                    Name (BFFR, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0062,             // Range Minimum
                            0x0062,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0066,             // Range Minimum
                            0x0066,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                    })
                    Return (BFFR)
                }

                OperationRegion (ERAM, EmbeddedControl, 0x00, 0xFF)
                Field (ERAM, ByteAcc, Lock, Preserve)
                {
                    SMPR,   8, 
                    SMST,   8, 
                    SMAD,   8, 
                    SMCM,   8, 
                    SMD0,   256, 
                    BCNT,   8, 
                    SMAA,   8, 
                    BATD,   16, 
                            Offset (0x40), 
                    ACIN,   1, 
                            Offset (0x41), 
                        ,   4, 
                    FANC,   1, 
                    BLED,   1, 
                    AADA,   1, 
                            Offset (0x42), 
                        ,   7, 
                    Q8EO,   1, 
                        ,   4, 
                    BANK,   4, 
                            Offset (0x45), 
                    VFAN,   1, 
                    ISEN,   1, 
                    KBEP,   1, 
                    ASCN,   1, 
                    ALIN,   1, 
                            Offset (0x4E), 
                    LIDP,   1, 
                    DT1P,   1, 
                    ODDW,   1, 
                    PRPP,   1, 
                        ,   1, 
                        ,   1, 
                        ,   1, 
                            Offset (0x4F), 
                            Offset (0x52), 
                    LIDS,   1, 
                    DT1I,   1, 
                        ,   1, 
                    PREP,   1, 
                    RBAT,   1, 
                    CRTS,   1, 
                    ABTN,   1, 
                    DBAY,   1, 
                            Offset (0x58), 
                    RTMP,   8, 
                    ECT1,   8, 
                    ECT2,   8, 
                    RG5B,   8, 
                    FSPD,   16, 
                            Offset (0x61), 
                    QPDD,   8, 
                            Offset (0x72), 
                    BFCC,   16, 
                            Offset (0x82), 
                    MBST,   8, 
                    MCUR,   16, 
                    MBRM,   16, 
                    MBCV,   16, 
                            Offset (0xA0), 
                    QBHK,   8, 
                            Offset (0xA2), 
                    QBBB,   8, 
                            Offset (0xA4), 
                    MBTS,   1, 
                    MBTF,   1, 
                    BDES,   1, 
                    BTRK,   1, 
                    BARM,   1, 
                    BLOW,   1, 
                    BDIS,   1, 
                    BDED,   1, 
                        ,   3, 
                    NIMH,   1, 
                            Offset (0xAF), 
                    BATT,   8, 
                            Offset (0xB3), 
                    BACU,   8, 
                            Offset (0xC0), 
                    BRID,   8, 
                            Offset (0xE0), 
                    DTMC,   8, 
                            Offset (0xE2), 
                    BRIC,   8, 
                            Offset (0xE6), 
                    SFHK,   8, 
                    GQKS,   7
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    SMW0,   16
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    SMB0,   8
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD0,   64
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD1,   128
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD2,   192
                }

                Field (ERAM, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                    FLD3,   256
                }

                Name (BATO, 0x00)
                Name (BATN, 0x00)
                Name (BATF, 0xC0)
                Mutex (MUT0, 0x00)
                Mutex (MUT1, 0x00)
                Method (_REG, 2, NotSerialized)
                {
                    If (LAnd (LEqual (Arg0, 0x03), LEqual (Arg1, 0x01)))
                    {
                        Store (0x01, ECON)
                    }
                }

                Method (_Q20, 0, NotSerialized)
                {
                    Store (0x20, \DBUG)
                    If (LEqual (OSYS, 0x07D6))
                    {
                        Notify (\_SB.BAT0, 0x81)
                    }

                    Notify (\_SB.ACAD, 0x80)
                    Notify (\_SB.BAT0, 0x80)
                }

                Method (_Q21, 0, NotSerialized)
                {
                    Store (0x21, \DBUG)
                    Notify (\_SB.ACAD, 0x80)
                    Notify (\_SB.BAT0, 0x80)
                    RSBR ()
                }

                Method (_Q09, 0, NotSerialized)
                {
                    If (LEqual (DTCN, 0x02))
                    {
                        Store (0x00, DTCN)
                    }
                    Else
                    {
                        Add (DTCN, 0x01, DTCN)
                        Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                        Store (0x96, \_SB.PCI0.EC0.DTMC)
                        Release (\_SB.PCI0.EC0.MUT0)
                    }

                    Store (0x09, \DBUG)
                    Store (0x05, \_SB.WMID.Z00P)
                    Store (0x00, \_SB.WMID.Z00Q)
                    Notify (\_SB.WMID, 0x80)
                }

                Method (_Q0D, 0, NotSerialized)
                {
                    Store (0x0D, \DBUG)
                    If (VGAT)
                    {
                        VSWT ()
                    }
                    Else
                    {
                        VSWU ()
                    }
                }

                Method (_Q10, 0, NotSerialized)
                {
                    Store (0x10, \DBUG)
                    If (LEqual (OSYS, 0x07D6))
                    {
                        If (LEqual (VGAT, 0x01))
                        {
                            Notify (\_SB.PCI0.XVR0.VGA.LCD, 0x87)
                        }
                        Else
                        {
                            Notify (\_SB.PCI0.UVGA.LCD, 0x87)
                        }
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8D, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Release (\_SB.PCI0.PSMX)
                    }
                }

                Method (_Q11, 0, NotSerialized)
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        If (LEqual (VGAT, 0x01))
                        {
                            Notify (\_SB.PCI0.XVR0.VGA.LCD, 0x86)
                        }
                        Else
                        {
                            Notify (\_SB.PCI0.UVGA.LCD, 0x86)
                        }
                    }
                    Else
                    {
                        Store (0x11, \DBUG)
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x8C, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Release (\_SB.PCI0.PSMX)
                    }
                }

                Method (_Q15, 0, NotSerialized)
                {
                    Store (0x15, \DBUG)
                    Store ("!!! Wireless Button pressed !!!", Debug)
                    Acquire (M723, 0xFFFF)
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    If (\_SB.PCI0.EC0.DT1I)
                    {
                        Store (0x00, BTLS)
                    }
                    Else
                    {
                        Store (0x01, BTLS)
                    }

                    Release (\_SB.PCI0.EC0.MUT0)
                    If (LOr (BTSU, WLSU))
                    {
                        If (BTLS)
                        {
                            Store (0x00, BTLS)
                            Store (0x00, GP25)
                            Store (0x04, GP24)
                            Store (0x00, GP26)
                            Store (0x04, GP23)
                        }
                        Else
                        {
                            Store (0x01, BTLS)
                            If (WLSU)
                            {
                                If (WIRE)
                                {
                                    If (WWLS)
                                    {
                                        Store (0x01, GP26)
                                        Store (0x05, GP23)
                                    }
                                }
                                Else
                                {
                                    Store (0x01, GP26)
                                    Store (0x05, GP23)
                                }
                            }

                            If (BTSU)
                            {
                                If (WIRE)
                                {
                                    If (BWLS)
                                    {
                                        Store (0x01, GP25)
                                        Store (0x05, GP24)
                                    }
                                }
                                Else
                                {
                                    Store (0x01, GP25)
                                    Store (0x05, GP24)
                                }
                            }
                        }
                    }
                    Else
                    {
                        Store (0x00, BTLS)
                        Store (0x00, GP25)
                        Store (0x04, GP24)
                        Store (0x00, GP26)
                        Store (0x04, GP23)
                    }

                    Release (M723)
                    Store (0x05, \_SB.WMID.Z00P)
                    Store (0x00, \_SB.WMID.Z00Q)
                    Notify (\_SB.WMID, 0x80)
                }

                Method (_Q16, 0, NotSerialized)
                {
                    Store (QBBB, Local0)
                    If (LEqual (Local0, 0x00))
                    {
                        Store (QPDD, Local0)
                        ShiftRight (Local0, 0x02, Local0)
                        Add (Local0, 0x02, Local0)
                        If (LEqual (Local0, 0x01))
                        {
                            Notify (\_SB.QBTN, 0x80)
                        }

                        If (LEqual (Local0, 0x02))
                        {
                            Notify (\_SB.DBTN, 0x80)
                        }
                    }
                    Else
                    {
                        If (LEqual (OSYS, 0x07D6))
                        {
                            If (LEqual (Local0, 0x04))
                            {
                                Store (0x04, \_SB.WMID.Z00P)
                                Store (0x00, \_SB.WMID.Z00Q)
                                Notify (\_SB.WMID, 0x80)
                                Return (0x00)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store (0x04, \_SB.WMID.Z00P)
                                Store (0x00, \_SB.WMID.Z00Q)
                                Notify (\_SB.WMID, 0x80)
                                Return (0x00)
                            }

                            If (LEqual (Local0, 0x07))
                            {
                                Store (0x04, \_SB.WMID.Z00P)
                                Store (0x00, \_SB.WMID.Z00Q)
                                Notify (\_SB.WMID, 0x80)
                                Return (0x00)
                            }

                            If (LEqual (Local0, 0x08))
                            {
                                Store (0x04, \_SB.WMID.Z00P)
                                Store (0x00, \_SB.WMID.Z00Q)
                                Notify (\_SB.WMID, 0x80)
                                Return (0x00)
                            }

                            If (LEqual (Local0, 0x10))
                            {
                                Store (0x04, \_SB.WMID.Z00P)
                                Store (0x00, \_SB.WMID.Z00Q)
                                Notify (\_SB.WMID, 0x80)
                                Return (0x00)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store (0x04, \_SB.WMID.Z00P)
                                Store (0x00, \_SB.WMID.Z00Q)
                                Notify (\_SB.WMID, 0x80)
                                Return (0x00)
                            }
                        }

                        Store (0x04, \_SB.WMID.Z00P)
                        Store (0x00, \_SB.WMID.Z00Q)
                        Notify (\_SB.WMID, 0x80)
                    }
                }

                Method (_Q80, 0, NotSerialized)
                {
                    Store ("_Q80 : Temperature Up", Debug)
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    Store (\_SB.PCI0.EC0.RTMP, Local0)
                    Release (\_SB.PCI0.EC0.MUT0)
                    If (LGreater (Local0, 0x57))
                    {
                        Store (\_SB.PSTN, DBUG)
                        Store (\_SB.PSTN, \_PR.CPU0._PPC)
                        Notify (\_PR.CPU0, 0x80)
                    }
                    Else
                    {
                        If (LLess (Local0, 0x4B))
                        {
                            If (LEqual (Q8EO, 0x00))
                            {
                                Store (0x00, \_PR.CPU0._PPC)
                                Notify (\_PR.CPU0, 0x80)
                            }
                        }
                    }
                }

                Method (_Q81, 0, NotSerialized)
                {
                    Store ("_Q81 : Temperature Down", Debug)
                }

                Name (ARG9, 0x00)
                Name (ARG8, 0x00)
                Method (_Q8E, 0, NotSerialized)
                {
                    If (LLess (\_PR.CPU0._PPC, \_SB.PSTN))
                    {
                        Add (\_PR.CPU0._PPC, 0x01, \_PR.CPU0._PPC)
                        If (LGreater (\_PR.CPU0._PPC, \_SB.PSTN))
                        {
                            Store (\_SB.PSTN, \_PR.CPU0._PPC)
                            Notify (\_PR.CPU0, 0x80)
                        }
                        Else
                        {
                            If (LEqual (BACU, 0x01))
                            {
                                If (LGreaterEqual (BATT, 0x3A))
                                {
                                    Subtract (BATT, 0x3A, ARG9)
                                    Divide (ARG9, 0x02, ARG8, ARG9)
                                    Add (ARG9, 0x01, ARG9)
                                    If (LLessEqual (ARG9, \_SB.PSTN))
                                    {
                                        Store (ARG9, \_PR.CPU0._PPC)
                                    }
                                    Else
                                    {
                                        Store (\_SB.PSTN, \_PR.CPU0._PPC)
                                    }
                                }
                            }

                            Notify (\_PR.CPU0, 0x80)
                        }
                    }
                }

                Method (_Q8F, 0, NotSerialized)
                {
                    If (LGreater (\_PR.CPU0._PPC, 0x00))
                    {
                        Subtract (\_PR.CPU0._PPC, 0x01, \_PR.CPU0._PPC)
                        Notify (\_PR.CPU0, 0x80)
                        If (LEqual (\_PR.CPU0._PPC, 0x00))
                        {
                            Store (0x00, Q8EO)
                        }
                        Else
                        {
                            Store (0x01, Q8EO)
                        }
                    }
                    Else
                    {
                        Store (0x00, Q8EO)
                    }
                }

                Method (_Q8A, 0, NotSerialized)
                {
                    If (LIDP)
                    {
                        Store ("_Q8A : Lid Event", Debug)
                        Store (0x00, LIDP)
                    }

                    Notify (\_SB.LID, 0x80)
                }

                Method (VSWT, 0, NotSerialized)
                {
                    Store ("Hot-Keys: ----- _Q0C", Debug)
                    If (LEqual (\_SB.PCI0.XVR0.VGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x88, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Release (\_SB.PCI0.PSMX)
                        Store (Local0, CADL)
                        If (LEqual (Local0, 0x10)) {}
                        Else
                        {
                            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                            Store (0x87, \_SB.PCI0.SMIC)
                            Store (\_SB.PCI0.SMIS, Local1)
                            Release (\_SB.PCI0.PSMX)
                            Store (Local1, PSTE)
                            If (LEqual (Local1, 0x09))
                            {
                                Store (Zero, Local1)
                            }

                            If (LEqual (Local1, 0x05))
                            {
                                Store (0x08, Local1)
                            }

                            Store (Local1, \_SB.PCI0.XVR0.VGA.TOGF)
                            Increment (\_SB.PCI0.XVR0.VGA.TOGF)
                            While (LNotEqual (And (Local0, \_SB.PCI0.XVR0.VGA.TOGF), \_SB.PCI0.XVR0.VGA.TOGF))
                            {
                                Increment (\_SB.PCI0.XVR0.VGA.TOGF)
                                If (LGreater (\_SB.PCI0.XVR0.VGA.TOGF, 0x09))
                                {
                                    Store (One, \_SB.PCI0.XVR0.VGA.TOGF)
                                }
                            }

                            If (LEqual (CADL, 0x0F))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x08, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x08, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x04, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x03, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x09, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x05, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x01, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x0D))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x08, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x04, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x09, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x05, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x01, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x08, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x0B))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x08, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x08, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x03, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x09, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x09))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x08, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x07))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x02, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x04, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x03, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x05, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x01, \_SB.PCI0.XVR0.VGA.TOGF)
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x03))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x05))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x04, NSTE)
                                }
                            }

                            Sleep (0x03E8)
                            Store (\_SB.PCI0.XVR0.VGA.TOGF, Local0)
                            Store (Local0, CSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (One, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x08))
                            {
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (One, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            If (LEqual (Local0, 0x09))
                            {
                                Store (Zero, \_SB.PCI0.XVR0.VGA.CRTA)
                                Store (One, \_SB.PCI0.XVR0.VGA.LCDA)
                                Store (Zero, \_SB.PCI0.XVR0.VGA.TVAF)
                                Store (One, \_SB.PCI0.XVR0.VGA.HDTV)
                            }

                            Notify (\_SB.PCI0.XVR0.VGA, 0x80)
                        }
                    }
                    Else
                    {
                    }
                }

                Method (VSWU, 0, NotSerialized)
                {
                    Store ("Hot-Keys: ----- _Q0C", Debug)
                    If (LEqual (\_SB.PCI0.UVGA.SWIT, 0x00))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (0x88, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Release (\_SB.PCI0.PSMX)
                        Store (Local0, CADL)
                        If (LEqual (Local0, 0x10)) {}
                        Else
                        {
                            Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                            Store (0x87, \_SB.PCI0.SMIC)
                            Store (\_SB.PCI0.SMIS, Local1)
                            Release (\_SB.PCI0.PSMX)
                            Store (Local1, PSTE)
                            If (LEqual (Local1, 0x09))
                            {
                                Store (Zero, Local1)
                            }

                            If (LEqual (Local1, 0x05))
                            {
                                Store (0x08, Local1)
                            }

                            Store (Local1, \_SB.PCI0.UVGA.TOGF)
                            Increment (\_SB.PCI0.UVGA.TOGF)
                            While (LNotEqual (And (Local0, \_SB.PCI0.UVGA.TOGF), \_SB.PCI0.UVGA.TOGF))
                            {
                                Increment (\_SB.PCI0.UVGA.TOGF)
                                If (LGreater (\_SB.PCI0.UVGA.TOGF, 0x09))
                                {
                                    Store (One, \_SB.PCI0.UVGA.TOGF)
                                }
                            }

                            If (LEqual (CADL, 0x0F))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x08, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x08, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x04, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x03, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x09, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x05, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x01, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x0D))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x08, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x04, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x09, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x05, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x01, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x08, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x0B))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x08, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x08, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x03, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x09, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x09))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x09, NSTE)
                                }

                                If (LEqual (CSTE, 0x08))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x09))
                                {
                                    Store (0x08, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x07))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x02, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x04, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x04, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x03, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x05, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x01, \_SB.PCI0.UVGA.TOGF)
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x03))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x03, NSTE)
                                }

                                If (LEqual (CSTE, 0x02))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x03))
                                {
                                    Store (0x02, NSTE)
                                }
                            }

                            If (LEqual (CADL, 0x05))
                            {
                                If (LEqual (CSTE, 0x01))
                                {
                                    Store (0x05, NSTE)
                                }

                                If (LEqual (CSTE, 0x04))
                                {
                                    Store (0x01, NSTE)
                                }

                                If (LEqual (CSTE, 0x05))
                                {
                                    Store (0x04, NSTE)
                                }
                            }

                            Sleep (0x03E8)
                            Store (\_SB.PCI0.UVGA.TOGF, Local0)
                            Store (Local0, CSTE)
                            If (LEqual (Local0, 0x01))
                            {
                                Store ("LCD", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x02))
                            {
                                Store ("CRT", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x03))
                            {
                                Store ("Both", Debug)
                                Store (One, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x04))
                            {
                                Store ("TV", Debug)
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x05))
                            {
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (One, \_SB.PCI0.UVGA.TVAF)
                                Store (Zero, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x08))
                            {
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (Zero, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (One, \_SB.PCI0.UVGA.HDTV)
                            }

                            If (LEqual (Local0, 0x09))
                            {
                                Store (Zero, \_SB.PCI0.UVGA.CRTA)
                                Store (One, \_SB.PCI0.UVGA.LCDA)
                                Store (Zero, \_SB.PCI0.UVGA.TVAF)
                                Store (One, \_SB.PCI0.UVGA.HDTV)
                            }

                            Notify (\_SB.PCI0.UVGA, 0x80)
                        }
                    }
                    Else
                    {
                    }
                }

                Method (RSBR, 0, NotSerialized)
                {
                    If (LEqual (OSYS, 0x07D6))
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (Zero, \_SB.PCI0.SMIS)
                        Store (0x8B, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Release (\_SB.PCI0.PSMX)
                    }
                    Else
                    {
                        Acquire (\_SB.PCI0.PSMX, 0xFFFF)
                        Store (One, \_SB.PCI0.SMIS)
                        Store (0x8B, \_SB.PCI0.SMIC)
                        Store (\_SB.PCI0.SMIS, Local0)
                        Release (\_SB.PCI0.PSMX)
                    }
                }

                Method (PRTH, 0, NotSerialized)
                {
                    Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                    If (\_SB.PCI0.EC0.ACIN)
                    {
                        Acquire (M723, 0xFFFF)
                        Store (ACBN, BRNS)
                        Release (M723)
                    }
                    Else
                    {
                        Acquire (M723, 0xFFFF)
                        Store (BABN, BRNS)
                        Release (M723)
                    }

                    Release (\_SB.PCI0.EC0.MUT0)
                }

                Method (SMRD, 4, NotSerialized)
                {
                    If (LNot (ECON))
                    {
                        Return (0xFF)
                    }

                    If (LNotEqual (Arg0, 0x07))
                    {
                        If (LNotEqual (Arg0, 0x09))
                        {
                            If (LNotEqual (Arg0, 0x0B))
                            {
                                Return (0x19)
                            }
                        }
                    }

                    Acquire (MUT0, 0xFFFF)
                    Store (0x04, Local0)
                    While (LGreater (Local0, 0x01))
                    {
                        And (SMST, 0x40, SMST)
                        Store (Arg2, SMCM)
                        Store (Arg1, SMAD)
                        Store (Arg0, SMPR)
                        Store (0x00, Local3)
                        While (LNot (And (SMST, 0xBF, Local1)))
                        {
                            Sleep (0x02)
                            Increment (Local3)
                            If (LEqual (Local3, 0x32))
                            {
                                And (SMST, 0x40, SMST)
                                Store (Arg2, SMCM)
                                Store (Arg1, SMAD)
                                Store (Arg0, SMPR)
                                Store (0x00, Local3)
                            }
                        }

                        If (LEqual (Local1, 0x80))
                        {
                            Store (0x00, Local0)
                        }
                        Else
                        {
                            Decrement (Local0)
                        }
                    }

                    If (Local0)
                    {
                        Store (And (Local1, 0x1F), Local0)
                    }
                    Else
                    {
                        If (LEqual (Arg0, 0x07))
                        {
                            Store (SMB0, Arg3)
                        }

                        If (LEqual (Arg0, 0x09))
                        {
                            Store (SMW0, Arg3)
                        }

                        If (LEqual (Arg0, 0x0B))
                        {
                            Store (BCNT, Local3)
                            ShiftRight (0x0100, 0x03, Local2)
                            If (LGreater (Local3, Local2))
                            {
                                Store (Local2, Local3)
                            }

                            If (LLess (Local3, 0x09))
                            {
                                Store (FLD0, Local2)
                            }
                            Else
                            {
                                If (LLess (Local3, 0x11))
                                {
                                    Store (FLD1, Local2)
                                }
                                Else
                                {
                                    If (LLess (Local3, 0x19))
                                    {
                                        Store (FLD2, Local2)
                                    }
                                    Else
                                    {
                                        Store (FLD3, Local2)
                                    }
                                }
                            }

                            Increment (Local3)
                            Store (Buffer (Local3) {}, Local4)
                            Decrement (Local3)
                            Store (Zero, Local5)
                            While (LGreater (Local3, Local5))
                            {
                                GBFE (Local2, Local5, RefOf (Local6))
                                PBFE (Local4, Local5, Local6)
                                Increment (Local5)
                            }

                            PBFE (Local4, Local5, 0x00)
                            Store (Local4, Arg3)
                        }
                    }

                    Release (MUT0)
                    Return (Local0)
                }

                Method (Z00R, 0, Serialized)
                {
                    If (ECON)
                    {
                        Store (SFHK, Local0)
                    }

                    Return (Local0)
                }

                Method (Z00S, 1, Serialized)
                {
                    If (ECON)
                    {
                        Store (Arg0, SFHK)
                    }
                }
            }

            Device (SMB0)
            {
                Name (_ADR, 0x000A0001)
                OperationRegion (SMCF, PCI_Config, 0x48, 0x04)
                Field (SMCF, AnyAcc, NoLock, Preserve)
                {
                    SB48,   4
                }

                OperationRegion (SBA0, PCI_Config, 0x20, 0x04)
                Field (SBA0, AnyAcc, NoLock, Preserve)
                {
                    SB20,   16
                }

                OperationRegion (SBA1, PCI_Config, 0x24, 0x04)
                Field (SBA1, AnyAcc, NoLock, Preserve)
                {
                    SB24,   16
                }

                OperationRegion (SBA2, PCI_Config, 0x7C, 0x04)
                Field (SBA2, AnyAcc, NoLock, Preserve)
                {
                    SB7C,   16
                }

                OperationRegion (P60, PCI_Config, 0x60, 0x02)
                Field (P60, AnyAcc, NoLock, Preserve)
                {
                    PMBR,   16
                }

                OperationRegion (P64, PCI_Config, 0x64, 0x02)
                Field (P64, AnyAcc, NoLock, Preserve)
                {
                    NVSB,   16
                }

                OperationRegion (P68, PCI_Config, 0x68, 0x02)
                Field (P68, AnyAcc, NoLock, Preserve)
                {
                    ANLG,   16
                }
            }

            Device (USB0)
            {
                Name (_ADR, 0x000B0000)
                Method (_S1D, 0, NotSerialized)
                {
                    Return (0x01)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    Return (0x02)
                }

                Device (RH00)
                {
                    Name (_ADR, 0x00)
                    Device (PRT0)
                    {
                        Name (_ADR, 0x00)
                    }

                    Device (PRT1)
                    {
                        Name (_ADR, 0x01)
                    }

                    Device (PRT2)
                    {
                        Name (_ADR, 0x02)
                    }

                    Device (PRT3)
                    {
                        Name (_ADR, 0x03)
                    }

                    Device (PRT4)
                    {
                        Name (_ADR, 0x04)
                    }

                    Device (PRT5)
                    {
                        Name (_ADR, 0x05)
                        Name (_EJD, "_SB.PCI0.XVR2.X2S0")
                    }

                    Device (PRT6)
                    {
                        Name (_ADR, 0x06)
                    }

                    Device (PRT7)
                    {
                        Name (_ADR, 0x07)
                    }
                }
            }

            Device (USB2)
            {
                Name (_ADR, 0x000B0001)
            }

            Device (MAC0)
            {
                Name (_ADR, 0x00140000)
                Name (_PRW, Package (0x02)
                {
                    0x0B, 
                    0x05
                })
            }

            Device (AZA0)
            {
                Name (_ADR, 0x00100001)
            }

            Device (P2P0)
            {
                Name (_ADR, 0x00100000)
                Name (_UID, 0x02)
                OperationRegion (A080, PCI_Config, 0x19, 0x01)
                Field (A080, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x02)
                {
                    Package (0x04)
                    {
                        0x0005FFFF, 
                        0x00, 
                        \_SB.PCI0.LNK1, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0x0005FFFF, 
                        0x01, 
                        \_SB.PCI0.LNK2, 
                        0x00
                    }
                })
            }

            Name (NATA, Package (0x01)
            {
                0x000D0000
            })
            Scope (\_SB.PCI0)
            {
                Device (NVRB)
                {
                    Name (_HID, "NVRAIDBUS")
                    Name (FNVR, 0xFF)
                    Method (_DIS, 0, NotSerialized)
                    {
                        Store (0x00, FNVR)
                    }

                    Method (_STA, 0, NotSerialized)
                    {
                        If (LEqual (\_SB.R_ST, 0x01))
                        {
                            If (LEqual (FNVR, 0xFF))
                            {
                                Return (0x0F)
                            }
                            Else
                            {
                                Return (0x0D)
                            }
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x04D2,             // Range Minimum
                            0x04D2,             // Range Maximum
                            0x01,               // Alignment
                            0x01,               // Length
                            )
                    })
                }
            }

            Device (IDE0)
            {
                Name (SID4, 0x00)
                Name (SID5, 0x00)
                Name (SFLG, 0x00)
                Name (SID0, 0x00)
                Name (SID1, 0x00)
                Name (SID2, 0x00)
                Name (SID3, 0x00)
                Name (_ADR, 0x000D0000)
                OperationRegion (A090, PCI_Config, 0x50, 0x18)
                Field (A090, DWordAcc, NoLock, Preserve)
                {
                    ID20,   16, 
                            Offset (0x08), 
                    IDTS,   16, 
                    IDTP,   16, 
                    ID22,   32, 
                    UMSS,   16, 
                    UMSP,   16
                }

                Name (IDEP, Buffer (0x14) {})
                Name (IDES, Buffer (0x14) {})
                Method (GTM, 1, NotSerialized)
                {
                    If (LEqual (Arg0, 0x00))
                    {
                        Store (IDTP, Local0)
                        Store (UMSP, Local1)
                        Store (IDEP, Local2)
                    }
                    Else
                    {
                        Store (IDTS, Local0)
                        Store (UMSS, Local1)
                        Store (IDES, Local2)
                    }

                    CreateDWordField (Local2, 0x00, PIO0)
                    CreateDWordField (Local2, 0x04, DMA0)
                    CreateDWordField (Local2, 0x08, PIO1)
                    CreateDWordField (Local2, 0x0C, DMA1)
                    CreateDWordField (Local2, 0x10, FLAG)
                    Store (0x10, FLAG)
                    And (Local0, 0x0F00, Local3)
                    And (Local0, 0xF000, Local4)
                    ShiftRight (Local3, 0x08, Local3)
                    ShiftRight (Local4, 0x0C, Local4)
                    Add (Local3, Local4, Local3)
                    Multiply (Add (Local3, 0x02), 0x1E, PIO0)
                    If (LLessEqual (PIO0, 0xB4))
                    {
                        Or (FLAG, 0x02, FLAG)
                    }

                    If (And (Local1, 0x4000))
                    {
                        Or (FLAG, 0x01, FLAG)
                        And (Local1, 0x0700, Local3)
                        ShiftRight (Local3, 0x08, Local3)
                        Store (U2T (Local3), DMA0)
                    }
                    Else
                    {
                        Store (PIO0, DMA0)
                    }

                    And (Local0, 0x0F, Local3)
                    And (Local0, 0xF0, Local4)
                    ShiftRight (Local4, 0x04, Local4)
                    Add (Local3, Local4, Local3)
                    Multiply (Add (Local3, 0x02), 0x1E, PIO1)
                    If (LLessEqual (PIO1, 0xB4))
                    {
                        Or (FLAG, 0x08, FLAG)
                    }

                    If (And (Local1, 0x40))
                    {
                        Or (FLAG, 0x04, FLAG)
                        And (Local1, 0x07, Local3)
                        Store (U2T (Local3), DMA1)
                    }
                    Else
                    {
                        Store (PIO1, DMA1)
                    }

                    If (LEqual (Arg0, 0x00))
                    {
                        Store (Local2, IDEP)
                        Return (IDEP)
                    }
                    Else
                    {
                        Store (Local2, IDES)
                        Return (IDES)
                    }
                }

                Method (U2T, 1, NotSerialized)
                {
                    If (LEqual (Arg0, 0x00))
                    {
                        Return (0x3C)
                    }

                    If (LEqual (Arg0, 0x01))
                    {
                        Return (0x5A)
                    }

                    If (LEqual (Arg0, 0x02))
                    {
                        Return (0x78)
                    }

                    If (LEqual (Arg0, 0x03))
                    {
                        Return (0x96)
                    }

                    If (LEqual (Arg0, 0x04))
                    {
                        Return (0x2D)
                    }

                    If (LEqual (Arg0, 0x05))
                    {
                        Return (0x1E)
                    }

                    If (LEqual (Arg0, 0x06))
                    {
                        Return (0x14)
                    }

                    Return (0x0F)
                }

                Method (T2U, 1, NotSerialized)
                {
                    If (LGreater (Arg0, 0x78))
                    {
                        Return (0x03)
                    }

                    If (LGreater (Arg0, 0x5A))
                    {
                        Return (0x02)
                    }

                    If (LGreater (Arg0, 0x3C))
                    {
                        Return (0x01)
                    }

                    If (LGreater (Arg0, 0x2D))
                    {
                        Return (0x00)
                    }

                    If (LGreater (Arg0, 0x1E))
                    {
                        Return (0x04)
                    }

                    If (LGreater (Arg0, 0x14))
                    {
                        Return (0x05)
                    }

                    If (LGreater (Arg0, 0x0F))
                    {
                        Return (0x06)
                    }

                    Return (0x07)
                }

                Method (T2D, 1, NotSerialized)
                {
                    If (LGreater (Arg0, 0x01E0))
                    {
                        Return (0xA8)
                    }

                    If (LGreater (Arg0, 0x0186))
                    {
                        Return (0x77)
                    }

                    If (LGreater (Arg0, 0xF0))
                    {
                        Return (0x47)
                    }

                    If (LGreater (Arg0, 0xB4))
                    {
                        Return (0x33)
                    }

                    If (LGreater (Arg0, 0x96))
                    {
                        Return (0x22)
                    }

                    If (LGreater (Arg0, 0x78))
                    {
                        Return (0x21)
                    }

                    Return (0x20)
                }

                Method (STM, 4, NotSerialized)
                {
                    If (SX)
                    {
                        Store (SID0, ID20)
                        Store (SID1, IDTS)
                        Store (SID2, IDTP)
                        Store (SID3, ID22)
                        Store (SID4, UMSS)
                        Store (SID5, UMSP)
                    }
                    Else
                    {
                        Store (ID20, SID0)
                        Store (IDTS, SID1)
                        Store (IDTP, SID2)
                        Store (ID22, SID3)
                        Store (UMSS, SID4)
                        Store (UMSP, SID5)
                    }

                    Store (0x00, SX)
                    CreateDWordField (Arg0, 0x00, PIO0)
                    CreateDWordField (Arg0, 0x04, DMA0)
                    CreateDWordField (Arg0, 0x08, PIO1)
                    CreateDWordField (Arg0, 0x0C, DMA1)
                    CreateDWordField (Arg0, 0x10, FLAG)
                    If (LEqual (Arg3, 0x00))
                    {
                        Store (SID2, Local0)
                        Store (SID5, Local1)
                    }
                    Else
                    {
                        Store (SID1, Local0)
                        Store (SID4, Local1)
                    }

                    If (LNotEqual (PIO0, 0xFFFFFFFF))
                    {
                        And (Local0, 0xFF, Local0)
                        ShiftLeft (T2D (PIO0), 0x08, Local2)
                        Or (Local0, Local2, Local0)
                    }

                    If (LNotEqual (PIO1, 0xFFFFFFFF))
                    {
                        And (Local0, 0xFF00, Local0)
                        Or (Local0, T2D (PIO1), Local0)
                    }

                    If (And (FLAG, 0x01))
                    {
                        And (Local1, 0xFF, Local1)
                        ShiftLeft (T2U (DMA0), 0x08, Local2)
                        Or (0xC000, Local2, Local2)
                        Or (Local2, Local1, Local1)
                    }
                    Else
                    {
                        If (LNotEqual (DMA0, 0xFFFFFFFF))
                        {
                            And (Local0, 0xFF, Local0)
                            ShiftLeft (T2D (DMA0), 0x08, Local2)
                            Or (Local0, Local2, Local0)
                        }
                    }

                    If (And (FLAG, 0x04))
                    {
                        And (Local1, 0xFF00, Local1)
                        Or (0xC0, T2U (DMA1), Local2)
                        Or (Local2, Local1, Local1)
                    }
                    Else
                    {
                        If (LNotEqual (DMA1, 0xFFFFFFFF))
                        {
                            And (Local0, 0xFF00, Local0)
                            Or (Local0, T2D (DMA1), Local0)
                        }
                    }

                    If (LEqual (Arg3, 0x00))
                    {
                        Store (Local0, IDTP)
                        Store (Local1, UMSP)
                    }
                    Else
                    {
                        Store (Local0, IDTS)
                        Store (Local1, UMSS)
                    }
                }

                Method (GTF, 2, NotSerialized)
                {
                    Store (Buffer (0x07)
                        {
                            0x03, 0x00, 0x00, 0x00, 0x00, 0xA0, 0xEF
                        }, Local0)
                    CreateByteField (Local0, 0x01, MODE)
                    CreateByteField (Local0, 0x05, DRIV)
                    Store (Arg1, DRIV)
                    If (LEqual (Arg0, 0x00))
                    {
                        Store (IDEP, Local1)
                    }
                    Else
                    {
                        Store (IDES, Local1)
                    }

                    CreateDWordField (Local1, 0x00, PIO0)
                    CreateDWordField (Local1, 0x04, DMA0)
                    CreateDWordField (Local1, 0x08, PIO1)
                    CreateDWordField (Local1, 0x0C, DMA1)
                    CreateDWordField (Local1, 0x10, FLGX)
                    If (LEqual (Arg1, 0xA0))
                    {
                        Store (PIO0, Local2)
                        Store (DMA0, Local3)
                        And (FLGX, 0x01, FLGX)
                    }
                    Else
                    {
                        Store (PIO1, Local2)
                        Store (DMA1, Local3)
                        And (FLGX, 0x04, FLGX)
                    }

                    Store (FLGX, Local1)
                    If (LGreater (Local2, 0x0186))
                    {
                        Store (0x00, Local2)
                    }
                    Else
                    {
                        If (LGreater (Local2, 0xF0))
                        {
                            Store (0x01, Local2)
                        }
                        Else
                        {
                            If (LGreater (Local2, 0xB4))
                            {
                                Store (0x02, Local2)
                            }
                            Else
                            {
                                If (LGreater (Local2, 0x78))
                                {
                                    Store (0x03, Local2)
                                }
                                Else
                                {
                                    Store (0x04, Local2)
                                }
                            }
                        }
                    }

                    Or (0x08, Local2, MODE)
                    Store (Local0, Local2)
                    If (FLGX)
                    {
                        If (LGreater (Local3, 0x5A))
                        {
                            Store (0x00, Local3)
                        }
                        Else
                        {
                            If (LGreater (Local3, 0x3C))
                            {
                                Store (0x01, Local3)
                            }
                            Else
                            {
                                If (LGreater (Local3, 0x2D))
                                {
                                    Store (0x02, Local3)
                                }
                                Else
                                {
                                    If (LGreater (Local3, 0x1E))
                                    {
                                        Store (0x03, Local3)
                                    }
                                    Else
                                    {
                                        If (LGreater (Local3, 0x14))
                                        {
                                            Store (0x04, Local3)
                                        }
                                        Else
                                        {
                                            If (LGreater (Local3, 0x0F))
                                            {
                                                Store (0x05, Local3)
                                            }
                                            Else
                                            {
                                                Store (0x06, Local3)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Or (0x40, Local3, MODE)
                    }
                    Else
                    {
                        If (LEqual (Local3, 0xFFFFFFFF))
                        {
                            Return (Local0)
                        }
                        Else
                        {
                            If (LGreater (Local3, 0x96))
                            {
                                Store (0x00, Local3)
                            }
                            Else
                            {
                                If (LGreater (Local3, 0x78))
                                {
                                    Store (0x01, Local3)
                                }
                                Else
                                {
                                    Store (0x02, Local3)
                                }
                            }

                            Or (0x20, Local3, MODE)
                        }
                    }

                    Concatenate (Local0, Local2, Local1)
                    Return (Local1)
                }

                Device (PRI0)
                {
                    Name (_ADR, 0x00)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (0x00))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        STM (Arg0, Arg1, Arg2, 0x00)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x00, 0xA0))
                        }
                    }

                    Device (SLAV)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x00, 0xB0))
                        }
                    }
                }

                Device (SEC0)
                {
                    Name (_ADR, 0x01)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (0x01))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        STM (Arg0, Arg1, Arg2, 0x01)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x01, 0xA0))
                        }
                    }

                    Device (SLAV)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (GTF (0x01, 0xB0))
                        }
                    }
                }

                Method (DRMP, 0, NotSerialized)
                {
                    Return (\_SB.R_P0)
                }
            }

            Device (SAT1)
            {
                Name (_ADR, 0x000F0000)
                Device (PRI0)
                {
                    Name (_ADR, 0x00)
                    Name (SPTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SPTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SPTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Device (SEC0)
                {
                    Name (_ADR, 0x01)
                    Name (SSTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SSTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SSTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Method (DRMP, 0, NotSerialized)
                {
                    Return (\_SB.R_S0)
                }
            }

            Device (SAT0)
            {
                Name (_ADR, 0x000E0000)
                Device (PRI0)
                {
                    Name (_ADR, 0x00)
                    Name (SPTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SPTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SPTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Device (SEC0)
                {
                    Name (_ADR, 0x01)
                    Name (SSTM, Buffer (0x14)
                    {
                        /* 0000 */    0x78, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 
                        /* 0008 */    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
                        /* 0010 */    0x13, 0x00, 0x00, 0x00
                    })
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (SSTM)
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, SSTM)
                    }

                    Device (MAST)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Store (Buffer (0x07)
                                {
                                    0x03, 0x46, 0x00, 0x00, 0x00, 0xA0, 0xEF
                                }, Local0)
                            Return (Local0)
                        }
                    }
                }

                Method (DRMP, 0, NotSerialized)
                {
                    Return (\_SB.R_S1)
                }
            }

            Device (UVGA)
            {
                Name (_ADR, 0x00050000)
                Name (SWIT, 0x01)
                Name (CRTA, 0x01)
                Name (LCDA, 0x01)
                Name (TVAF, 0x00)
                Name (HDTV, 0x00)
                Name (TOGF, 0x00)
                Name (BRIP, Package (0x0D)
                {
                    0x5C, 
                    0x2A, 
                    0x14, 
                    0x18, 
                    0x1C, 
                    0x21, 
                    0x26, 
                    0x2A, 
                    0x30, 
                    0x38, 
                    0x42, 
                    0x4E, 
                    0x5C
                })
                Name (Z00U, Package (0x0D)
                {
                    0x64, 
                    0x2A, 
                    0x14, 
                    0x18, 
                    0x1C, 
                    0x21, 
                    0x26, 
                    0x2A, 
                    0x34, 
                    0x3D, 
                    0x48, 
                    0x55, 
                    0x64
                })
                Method (_DOS, 1, NotSerialized)
                {
                    Store ("VGA --_DOS Arg0", Debug)
                    Store (Arg0, SWIT)
                }

                Method (_DOD, 0, NotSerialized)
                {
                    Store ("VGA --_DOD", Debug)
                    Return (Package (0x04)
                    {
                        0x00010100, 
                        0x00010118, 
                        0x00010200, 
                        0x00010121
                    })
                }

                Method (_PS0, 0, NotSerialized)
                {
                    Store ("VGA_PS0", Debug)
                }

                Method (_PS2, 0, NotSerialized)
                {
                    Store ("VGA_PS2", Debug)
                }

                Method (_PS3, 0, NotSerialized)
                {
                    Store ("VGA_PS3", Debug)
                }

                Device (CRT)
                {
                    Name (_ADR, 0x0100)
                    Method (_DCS, 0, NotSerialized)
                    {
                        Store ("CRT --_DCS", Debug)
                        If (CRTA)
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        Store ("CRT --_DGS", Debug)
                        Store (CRTA, Local0)
                        If (CRTA)
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        Store ("CRT --_DSS", Debug)
                        Store (Arg0, Debug)
                    }
                }

                Device (LCD)
                {
                    Name (_ADR, 0x0118)
                    Method (_DCS, 0, NotSerialized)
                    {
                        Store ("LCD --_DCS", Debug)
                        If (LCDA)
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        Store ("LCD --_DGS", Debug)
                        Store (LCDA, Local0)
                        If (LCDA)
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        Store ("LCD --_DSS", Debug)
                        Store (Arg0, Debug)
                    }

                    Method (_BCL, 0, NotSerialized)
                    {
                        If (LEqual (PTPE, 0x02))
                        {
                            Return (Z00U)
                        }
                        Else
                        {
                            Return (BRIP)
                        }
                    }

                    Method (_BCM, 1, NotSerialized)
                    {
                        Store (Arg0, Local0)
                        Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                        Store (Local0, \_SB.PCI0.EC0.BRIC)
                        Store (\_SB.PCI0.EC0.ACIN, Local1)
                        Release (\_SB.PCI0.EC0.MUT0)
                        Store (_BCL (), Local2)
                        Store (0x02, Local3)
                        While (LLess (Local3, 0x0D))
                        {
                            If (LEqual (Local0, DerefOf (Index (Local2, Local3))))
                            {
                                If (Local1)
                                {
                                    Subtract (Local3, 0x02, ACBR)
                                }
                                Else
                                {
                                    Subtract (Local3, 0x02, DCBR)
                                }

                                Subtract (Local3, 0x02, CCBR)
                                Store (0x0F, Local3)
                            }

                            Increment (Local3)
                        }
                    }

                    Method (_BQC, 0, NotSerialized)
                    {
                        If (ECON)
                        {
                            Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                            Store (\_SB.PCI0.EC0.BRIC, Local0)
                            Release (\_SB.PCI0.EC0.MUT0)
                            Return (Local0)
                        }
                        Else
                        {
                            Store (_BCL (), Local1)
                            Return (DerefOf (Index (Local1, CCBR)))
                        }
                    }
                }

                Device (TV)
                {
                    Name (_ADR, 0x0200)
                    Method (_DCS, 0, NotSerialized)
                    {
                        Store ("TV --_DCS", Debug)
                        If (TVAF)
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        Store ("TV --_DGS", Debug)
                        Store (TVAF, Local0)
                        If (TVAF)
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        Store ("TV --_DSS", Debug)
                        Store (Arg0, Debug)
                    }
                }

                Device (HDMI)
                {
                    Name (_ADR, 0x0121)
                    Method (_DCS, 0, NotSerialized)
                    {
                        Store ("HDMI TV --_DCS", Debug)
                        If (HDTV)
                        {
                            Return (0x1F)
                        }
                        Else
                        {
                            Return (0x1D)
                        }
                    }

                    Method (_DGS, 0, NotSerialized)
                    {
                        Store ("HDMI TV --_DGS", Debug)
                        Store (HDTV, Local0)
                        If (HDTV)
                        {
                            Return (0x01)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_DSS, 1, NotSerialized)
                    {
                        Store ("HDMI TV --_DSS", Debug)
                        Store (Arg0, Debug)
                    }
                }
            }

            Device (XVR0)
            {
                Name (_ADR, 0x00040000)
                Name (_UID, 0x03)
                OperationRegion (A1E0, PCI_Config, 0x19, 0x01)
                Field (A1E0, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        0x00, 
                        \_SB.PCI0.LK1E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x01, 
                        \_SB.PCI0.LK2E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        \_SB.PCI0.LK3E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        \_SB.PCI0.LK4E, 
                        0x00
                    }
                })
                Device (VGA)
                {
                    Name (_ADR, 0x00)
                    Name (SWIT, 0x01)
                    Name (CRTA, 0x01)
                    Name (LCDA, 0x01)
                    Name (TVAF, 0x00)
                    Name (HDTV, 0x00)
                    Name (TOGF, 0x00)
                    Name (BRIP, Package (0x0D)
                    {
                        0x5C, 
                        0x2A, 
                        0x14, 
                        0x18, 
                        0x1C, 
                        0x21, 
                        0x26, 
                        0x2A, 
                        0x30, 
                        0x38, 
                        0x42, 
                        0x4E, 
                        0x5C
                    })
                    Name (Z00U, Package (0x0D)
                    {
                        0x64, 
                        0x2A, 
                        0x14, 
                        0x18, 
                        0x1C, 
                        0x21, 
                        0x26, 
                        0x2A, 
                        0x34, 
                        0x3D, 
                        0x48, 
                        0x55, 
                        0x64
                    })
                    Method (_DOS, 1, NotSerialized)
                    {
                        Store ("VGA --_DOS Arg0", Debug)
                        Store (Arg0, SWIT)
                    }

                    Method (_DOD, 0, NotSerialized)
                    {
                        Store ("VGA --_DOD", Debug)
                        Return (Package (0x04)
                        {
                            0x00010100, 
                            0x00010118, 
                            0x00010200, 
                            0x00010121
                        })
                    }

                    Method (_PS0, 0, NotSerialized)
                    {
                        Store ("VGA_PS0", Debug)
                    }

                    Method (_PS2, 0, NotSerialized)
                    {
                        Store ("VGA_PS2", Debug)
                    }

                    Method (_PS3, 0, NotSerialized)
                    {
                        Store ("VGA_PS3", Debug)
                    }

                    Device (CRT)
                    {
                        Name (_ADR, 0x0100)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("CRT --_DCS", Debug)
                            If (CRTA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("CRT --_DGS", Debug)
                            Store (CRTA, Local0)
                            If (CRTA)
                            {
                                Return (0x01)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("CRT --_DSS", Debug)
                            Store (Arg0, Debug)
                        }
                    }

                    Device (LCD)
                    {
                        Name (_ADR, 0x0118)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("LCD --_DCS", Debug)
                            If (LCDA)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("LCD --_DGS", Debug)
                            Store (LCDA, Local0)
                            If (LCDA)
                            {
                                Return (0x01)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("LCD --_DSS", Debug)
                            Store (Arg0, Debug)
                        }

                        Method (_BCL, 0, NotSerialized)
                        {
                            If (LEqual (PTPE, 0x02))
                            {
                                Return (Z00U)
                            }
                            Else
                            {
                                Return (BRIP)
                            }
                        }

                        Method (_BCM, 1, NotSerialized)
                        {
                            Store (Arg0, Local0)
                            Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                            Store (Local0, \_SB.PCI0.EC0.BRIC)
                            Store (\_SB.PCI0.EC0.ACIN, Local1)
                            Release (\_SB.PCI0.EC0.MUT0)
                            Store (_BCL (), Local2)
                            Store (0x02, Local3)
                            While (LLess (Local3, 0x0D))
                            {
                                If (LEqual (Local0, DerefOf (Index (Local2, Local3))))
                                {
                                    If (Local1)
                                    {
                                        Subtract (Local3, 0x02, ACBR)
                                    }
                                    Else
                                    {
                                        Subtract (Local3, 0x02, DCBR)
                                    }

                                    Subtract (Local3, 0x02, CCBR)
                                    Store (0x0F, Local3)
                                }

                                Increment (Local3)
                            }
                        }

                        Method (_BQC, 0, NotSerialized)
                        {
                            If (ECON)
                            {
                                Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                                Store (\_SB.PCI0.EC0.BRIC, Local0)
                                Release (\_SB.PCI0.EC0.MUT0)
                                Return (Local0)
                            }
                            Else
                            {
                                Store (_BCL (), Local1)
                                Return (DerefOf (Index (Local1, CCBR)))
                            }
                        }
                    }

                    Device (TV)
                    {
                        Name (_ADR, 0x0200)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("TV --_DCS", Debug)
                            If (TVAF)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("TV --_DGS", Debug)
                            Store (TVAF, Local0)
                            If (TVAF)
                            {
                                Return (0x01)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("TV --_DSS", Debug)
                            Store (Arg0, Debug)
                        }
                    }

                    Device (HDMI)
                    {
                        Name (_ADR, 0x0121)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store ("HDMI TV --_DCS", Debug)
                            If (HDTV)
                            {
                                Return (0x1F)
                            }
                            Else
                            {
                                Return (0x1D)
                            }
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            Store ("HDMI TV --_DGS", Debug)
                            Store (HDTV, Local0)
                            If (HDTV)
                            {
                                Return (0x01)
                            }
                            Else
                            {
                                Return (0x00)
                            }
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            Store ("HDMI TV --_DSS", Debug)
                            Store (Arg0, Debug)
                        }
                    }
                }
            }

            Device (XVR1)
            {
                Name (_ADR, 0x00030000)
                Name (_UID, 0x04)
                OperationRegion (A1E1, PCI_Config, 0x19, 0x01)
                Field (A1E1, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        0x00, 
                        \_SB.PCI0.LK4E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x01, 
                        \_SB.PCI0.LK1E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        \_SB.PCI0.LK2E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        \_SB.PCI0.LK3E, 
                        0x00
                    }
                })
                Device (X1S0)
                {
                    Name (_ADR, 0x00)
                }
            }

            Device (XVR2)
            {
                Name (_ADR, 0x00020000)
                Name (_HPP, Package (0x04)
                {
                    0x10, 
                    0x40, 
                    0x01, 
                    0x00
                })
                Name (_UID, 0x05)
                OperationRegion (A1E2, PCI_Config, 0x19, 0x01)
                Field (A1E2, ByteAcc, NoLock, Preserve)
                {
                    SECB,   8
                }

                Method (_BBN, 0, NotSerialized)
                {
                    Return (SECB)
                }

                Method (_STA, 0, NotSerialized)
                {
                    Return (0x0F)
                }

                Name (_PRT, Package (0x04)
                {
                    Package (0x04)
                    {
                        0xFFFF, 
                        0x00, 
                        \_SB.PCI0.LK2E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x01, 
                        \_SB.PCI0.LK3E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x02, 
                        \_SB.PCI0.LK4E, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0xFFFF, 
                        0x03, 
                        \_SB.PCI0.LK1E, 
                        0x00
                    }
                })
                OperationRegion (PCE1, PCI_Config, 0x90, 0x70)
                Field (PCE1, DWordAcc, Lock, Preserve)
                {
                            Offset (0x08), 
                        ,   3, 
                    BS03,   1, 
                        ,   1, 
                    BS05,   1, 
                        ,   13, 
                    BS19,   1, 
                        ,   2, 
                    EPDS,   1
                }

                Device (X2S0)
                {
                    Name (_ADR, 0x00)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (\_SB.PCI0.XVR2.EPDS)
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (_RMV, 0, NotSerialized)
                    {
                        Return (0x01)
                    }

                    Name (_EJD, "_SB.PCI0.USB0.RH00.Prt5")
                }
            }
        }

        Device (QBTN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x01)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x04))
                {
                    Notify (QBTN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x01
                })
            }
        }

        Device (DBTN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x02)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x05))
                {
                    Notify (DBTN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x02
                })
            }
        }

        Device (MUBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x03)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x03))
                {
                    Notify (MUBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x03
                })
            }
        }

        Device (PIBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x06)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x06))
                {
                    Notify (PIBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x06
                })
            }
        }

        Device (WEBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x04)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x10))
                {
                    Notify (WEBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x04
                })
            }
        }

        Device (LVBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x08)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x11))
                {
                    Notify (LVBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x08
                })
            }
        }

        Device (VOBN)
        {
            Name (_HID, EisaId ("PNP0C32"))
            Name (_UID, 0x07)
            Method (_STA, 0, NotSerialized)
            {
                If (LEqual (OSYS, 0x07D6))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Method (GHID, 0, NotSerialized)
            {
                If (LEqual (HOTB, 0x12))
                {
                    Notify (VOBN, 0x02)
                    Store (0x00, HOTB)
                }

                Return (Buffer (0x01)
                {
                    0x07
                })
            }
        }

        Scope (\)
        {
            Name (PICF, 0x00)
            Method (_PIC, 1, NotSerialized)
            {
                Store (Arg0, PICF)
            }

            OperationRegion (\_SB.PCI0.LPC0.PIRQ, PCI_Config, 0x7C, 0x0C)
            Field (\_SB.PCI0.LPC0.PIRQ, AnyAcc, NoLock, Preserve)
            {
                INTW,   4, 
                INTX,   4, 
                INTY,   4, 
                INTZ,   4, 
                INTA,   4, 
                INTB,   4, 
                INTC,   4, 
                INTD,   4, 
                ISCI,   4, 
                ITCO,   4, 
                ISMB,   4, 
                IUS2,   4, 
                INTU,   4, 
                INTS,   4, 
                PSI1,   4, 
                PSI0,   4, 
                IUS0,   4, 
                IUS1,   4, 
                IMAC,   4, 
                IAZA,   4, 
                IACI,   4, 
                IMCI,   4, 
                IPID,   4, 
                ISID,   4
            }
        }

        Scope (\_SB.PCI0)
        {
            Name (BUFA, ResourceTemplate ()
            {
                IRQ (Level, ActiveLow, Shared, )
                    {5,7,9,10,11,14,15}
            })
            Name (BUFB, ResourceTemplate ()
            {
                IRQ (Level, ActiveLow, Shared, _Y0A)
                    {}
            })
            CreateWordField (BUFB, \_SB.PCI0._Y0A._INT, IRQV)
            Method (CRS, 1, Serialized)
            {
                If (Arg0)
                {
                    ShiftLeft (0x01, Arg0, IRQV)
                }
                Else
                {
                    Store (Zero, IRQV)
                }

                Return (BUFB)
            }

            Method (SRS, 1, Serialized)
            {
                CreateWordField (Arg0, 0x01, IRQ0)
                FindSetRightBit (IRQ0, Local0)
                Decrement (Local0)
                Return (Local0)
            }

            Name (BUFM, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000014,
                }
            })
            Name (BUFI, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000015,
                }
            })
            Name (BUFU, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000016,
                }
            })
            Name (BUFS, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000017,
                }
            })
            Name (BUF1, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000010,
                }
            })
            Name (BUF2, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000011,
                }
            })
            Name (BUF3, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000012,
                }
            })
            Name (BUF4, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000013,
                }
            })
            Name (BUFF, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000005,
                    0x00000007,
                    0x0000000A,
                    0x0000000B,
                    0x0000000E,
                    0x0000000F,
                }
            })
            Name (BUP1, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000005,
                }
            })
            Name (BUP2, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x00000007,
                }
            })
            Name (BUFQ, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x0000000A,
                }
            })
            Name (BUFR, ResourceTemplate ()
            {
                Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
                {
                    0x0000000B,
                }
            })
            Method (CRSI, 1, Serialized)
            {
                Name (IRZ5, ResourceTemplate ()
                {
                    Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, _Y0B)
                    {
                        0x00000007,
                    }
                })
                CreateWordField (IRZ5, \_SB.PCI0.CRSI._Y0B._INT, INZ5)
                Store (Arg0, Local0)
                If (LEqual (Arg0, 0x03))
                {
                    Store (0x10, Local0)
                }

                If (LEqual (Arg0, 0x04))
                {
                    Store (0x11, Local0)
                }

                If (LEqual (Arg0, 0x06))
                {
                    Store (0x12, Local0)
                }

                If (LEqual (Arg0, 0x0C))
                {
                    Store (0x13, Local0)
                }

                If (LEqual (Arg0, 0x08))
                {
                    Store (0x14, Local0)
                }

                If (LEqual (Arg0, 0x0D))
                {
                    Store (0x15, Local0)
                }

                If (LEqual (Arg0, 0x02))
                {
                    Store (0x16, Local0)
                }

                If (LEqual (Arg0, 0x01))
                {
                    Store (0x17, Local0)
                }

                Store (Local0, INZ5)
                Return (IRZ5)
            }

            Method (SRSI, 1, Serialized)
            {
                CreateWordField (Arg0, 0x05, IRZ6)
                Store (IRZ6, Local0)
                If (LEqual (IRZ6, 0x10))
                {
                    Store (0x03, Local0)
                }

                If (LEqual (IRZ6, 0x11))
                {
                    Store (0x04, Local0)
                }

                If (LEqual (IRZ6, 0x12))
                {
                    Store (0x06, Local0)
                }

                If (LEqual (IRZ6, 0x13))
                {
                    Store (0x0C, Local0)
                }

                If (LEqual (IRZ6, 0x14))
                {
                    Store (0x08, Local0)
                }

                If (LEqual (IRZ6, 0x15))
                {
                    Store (0x0D, Local0)
                }

                If (LEqual (IRZ6, 0x16))
                {
                    Store (0x02, Local0)
                }

                If (LEqual (IRZ6, 0x17))
                {
                    Store (0x01, Local0)
                }

                Return (Local0)
            }

            Device (LNK1)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x01)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTW)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTW)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUP1)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTW))
                    }
                    Else
                    {
                        Return (CRSI (INTW))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTW)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTW)
                    }
                }
            }

            Device (LNK2)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x02)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTX)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTX)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUP2)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTX))
                    }
                    Else
                    {
                        Return (CRSI (INTX))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTX)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTX)
                    }
                }
            }

            Device (LNK3)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x03)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTY)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTY)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFQ)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTY))
                    }
                    Else
                    {
                        Return (CRSI (INTY))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTY)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTY)
                    }
                }
            }

            Device (LNK4)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x04)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTZ)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTZ)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFR)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTZ))
                    }
                    Else
                    {
                        Return (CRSI (INTZ))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTZ)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTZ)
                    }
                }
            }

            Device (LK1E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x05)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTA)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTA)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUF1)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTA))
                    }
                    Else
                    {
                        Return (CRSI (INTA))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTA)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTA)
                    }
                }
            }

            Device (LK2E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x06)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTB)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTB)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUF2)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTB))
                    }
                    Else
                    {
                        Return (CRSI (INTB))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTB)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTB)
                    }
                }
            }

            Device (LK3E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x07)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTC)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTC)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUF3)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTC))
                    }
                    Else
                    {
                        Return (CRSI (INTC))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTC)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTC)
                    }
                }
            }

            Device (LK4E)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x08)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTD)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTD)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUF4)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTD))
                    }
                    Else
                    {
                        Return (CRSI (INTD))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTD)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTD)
                    }
                }
            }

            Device (LSMB)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x09)
                Method (_STA, 0, NotSerialized)
                {
                    If (ISMB)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, ISMB)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFQ)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (ISMB))
                    }
                    Else
                    {
                        Return (CRSI (ISMB))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), ISMB)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), ISMB)
                    }
                }
            }

            Device (LPMU)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x14)
                Method (_STA, 0, NotSerialized)
                {
                    If (INTS)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, INTS)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFR)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (INTS))
                    }
                    Else
                    {
                        Return (CRSI (INTS))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), INTS)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), INTS)
                    }
                }
            }

            Device (LUS0)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0A)
                Method (_STA, 0, NotSerialized)
                {
                    If (IUS0)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IUS0)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFU)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IUS0))
                    }
                    Else
                    {
                        Return (CRSI (IUS0))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IUS0)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IUS0)
                    }
                }
            }

            Device (LUS2)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0C)
                Method (_STA, 0, NotSerialized)
                {
                    If (IUS2)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IUS2)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFU)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IUS2))
                    }
                    Else
                    {
                        Return (CRSI (IUS2))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IUS2)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IUS2)
                    }
                }
            }

            Device (LMAC)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0D)
                Method (_STA, 0, NotSerialized)
                {
                    If (IMAC)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IMAC)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFM)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IMAC))
                    }
                    Else
                    {
                        Return (CRSI (IMAC))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IMAC)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IMAC)
                    }
                }
            }

            Device (LAZA)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0E)
                Method (_STA, 0, NotSerialized)
                {
                    If (IAZA)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IAZA)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IAZA))
                    }
                    Else
                    {
                        Return (CRSI (IAZA))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IAZA)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IAZA)
                    }
                }
            }

            Device (LACI)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x0F)
                Method (_STA, 0, NotSerialized)
                {
                    If (IACI)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IACI)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IACI))
                    }
                    Else
                    {
                        Return (CRSI (IACI))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IACI)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IACI)
                    }
                }
            }

            Device (LMCI)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x10)
                Method (_STA, 0, NotSerialized)
                {
                    If (IMCI)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IMCI)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IMCI))
                    }
                    Else
                    {
                        Return (CRSI (IMCI))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IMCI)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IMCI)
                    }
                }
            }

            Device (LPID)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x11)
                Method (_STA, 0, NotSerialized)
                {
                    If (IPID)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, IPID)
                    Store (0x00, ISID)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFI)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (IPID))
                    }
                    Else
                    {
                        Return (CRSI (IPID))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), IPID)
                        Store (SRS (Arg0), ISID)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), IPID)
                        Store (SRSI (Arg0), ISID)
                    }
                }
            }

            Device (LTID)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x12)
                Method (_STA, 0, NotSerialized)
                {
                    If (PSI0)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, PSI0)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFS)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (PSI0))
                    }
                    Else
                    {
                        Return (CRSI (PSI0))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), PSI0)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), PSI0)
                    }
                }
            }

            Device (LSI1)
            {
                Name (_HID, EisaId ("PNP0C0F"))
                Name (_UID, 0x13)
                Method (_STA, 0, NotSerialized)
                {
                    If (PSI0)
                    {
                        Return (0x0B)
                    }
                    Else
                    {
                        Return (0x09)
                    }
                }

                Method (_DIS, 0, NotSerialized)
                {
                    Store (0x00, PSI1)
                }

                Method (_PRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (BUFA)
                    }
                    Else
                    {
                        Return (BUFM)
                    }
                }

                Method (_CRS, 0, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Return (CRS (PSI1))
                    }
                    Else
                    {
                        Return (CRSI (PSI1))
                    }
                }

                Method (_SRS, 1, NotSerialized)
                {
                    If (LNot (PICF))
                    {
                        Store (SRS (Arg0), PSI1)
                    }
                    Else
                    {
                        Store (SRSI (Arg0), PSI1)
                    }
                }
            }
        }

        Scope (\_TZ)
        {
            Name (TPAS, 0x58)
            Name (TPC, 0x5F)
            Name (TPTM, 0x4B)
            ThermalZone (THRM)
            {
                Method (_CRT, 0, Serialized)
                {
                    Return (Add (0x0AAC, Multiply (TPC, 0x0A)))
                }

                Method (_SCP, 1, Serialized)
                {
                    Store (0x00, CTYP)
                }

                Method (_TMP, 0, Serialized)
                {
                    If (ECON)
                    {
                        Acquire (\_SB.PCI0.EC0.MUT0, 0xFFFF)
                        Store (\_SB.PCI0.EC0.RTMP, Local0)
                        Release (\_SB.PCI0.EC0.MUT0)
                        Store ("Current temp is: ", Debug)
                        Return (Add (0x0AAC, Multiply (Local0, 0x0A)))
                    }
                    Else
                    {
                        Return (Add (0x0AAC, Multiply (TPTM, 0x0A)))
                    }
                }

                Method (_PSL, 0, Serialized)
                {
                    Return (Package (0x01)
                    {
                        \_PR.CPU0
                    })
                }

                Method (_PSV, 0, Serialized)
                {
                    Return (Add (0x0AAC, Multiply (TPAS, 0x0A)))
                }

                Method (_TC1, 0, Serialized)
                {
                    Return (0x02)
                }

                Method (_TC2, 0, Serialized)
                {
                    Return (0x03)
                }

                Method (_TSP, 0, Serialized)
                {
                    Return (0x64)
                }
            }
        }
    }

    Scope (\_SB.PCI0.LPC0)
    {
        OperationRegion (RGA0, PCI_Config, 0xA0, 0x04)
        Field (RGA0, AnyAcc, NoLock, Preserve)
        {
            COMP,   8, 
            ADIO,   4, 
            MIDS,   4, 
            MSSS,   4, 
            FDCP,   2, 
            ADLB,   1, 
                    Offset (0x03), 
            LPTP,   3, 
                ,   1, 
            DVR0,   1, 
            DVR1,   1, 
            DVR2,   1, 
            DVR3,   1
        }

        OperationRegion (RGA1, PCI_Config, 0xA4, 0x04)
        Field (RGA1, AnyAcc, NoLock, Preserve)
        {
            GMPS,   16, 
                    Offset (0x04)
        }
    }

    OperationRegion (CS72, SystemIO, 0x72, 0x02)
    Field (CS72, ByteAcc, NoLock, Preserve)
    {
        CI72,   8, 
        CO73,   8
    }

    IndexField (CI72, CO73, ByteAcc, NoLock, Preserve)
    {
                Offset (0x22), 
            ,   3, 
        HPBD,   3, 
                Offset (0x9A), 
        BRNS,   4, 
        ACBN,   4, 
        BABN,   4, 
        WLSU,   1, 
        BTSU,   1, 
        IVIK,   2, 
        BTWL,   2, 
        BTLS,   1, 
        BWLS,   1, 
        WWLS,   1, 
                Offset (0x9D), 
        S4FL,   1, 
        SETF,   1, 
        VGAT,   1, 
        LSHK,   1, 
        S4RT,   2, 
        PTPE,   2, 
        BTNS,   1, 
        BTS3,   1, 
                Offset (0xA2), 
        HOTB,   8
    }

    Mutex (M723, 0x00)
    OperationRegion (DBGP, SystemIO, 0x80, 0x01)
    Field (DBGP, ByteAcc, NoLock, Preserve)
    {
        DBUG,   8
    }

    OperationRegion (ENEP, SystemIO, 0x0380, 0x04)
    Field (ENEP, ByteAcc, NoLock, Preserve)
    {
        P380,   8, 
        P381,   8, 
        P382,   8, 
        P383,   8
    }

    Mutex (M380, 0x00)
    OperationRegion (PM1A, SystemIO, 0x1000, 0x04)
    Field (PM1A, ByteAcc, NoLock, Preserve)
    {
            ,   14, 
        PEWS,   1, 
                Offset (0x02)
    }

    OperationRegion (LDTR, SystemIO, 0x10A6, 0x01)
    Field (LDTR, ByteAcc, NoLock, Preserve)
    {
        LDTC,   1
    }

    OperationRegion (Z00V, SystemIO, 0x1407, 0x01)
    Field (Z00V, ByteAcc, NoLock, Preserve)
    {
        PSMI,   1, 
                Offset (0x01)
    }

    OperationRegion (NVGP, SystemIO, 0x14C4, 0x08)
    Field (NVGP, ByteAcc, NoLock, Preserve)
    {
        Z00W,   8, 
        Z00X,   8, 
        Z00Y,   8, 
        Z000,   8, 
        Z001,   8, 
        Z002,   8, 
        Z00Z,   8, 
        Z010,   8
    }

    OperationRegion (NVG1, SystemIO, 0x14D0, 0x08)
    Field (NVG1, ByteAcc, NoLock, Preserve)
    {
                Offset (0x06), 
        GP23,   8, 
        GP24,   8
    }

    Name (RBRF, 0x01)
    Name (L10F, 0x00)
    Name (SCIC, 0x00)
    Name (SCID, 0x00)
    Name (CADL, 0x01)
    Name (PADL, 0x01)
    Name (PSTE, 0x01)
    Name (CSTE, 0x01)
    Name (NSTE, 0x01)
    Name (SSTE, 0x01)
    Name (WMSF, 0x00)
    Name (JMPF, 0x00)
    Name (WIRE, 0x00)
    Name (WLID, 0xFF)
    Name (GP25, 0x01)
    Name (GP26, 0x01)
    Name (WLSS, 0x01)
    Name (WLS2, 0x00)
    Name (S34F, 0x00)
    Name (S34C, 0x00)
    Name (OSYS, 0x07D6)
    Name (CTYP, 0x00)
    Name (DTCN, 0x00)
    Name (\ECON, 0x00)
    Name (FWSO, "FWSO")
}


--------------070206070301040404010109--
