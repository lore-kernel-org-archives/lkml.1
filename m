Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZHQIse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZHQIse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbZHQIsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:48:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:53205 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbZHQIsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,394,1246863600"; 
   d="dsl'?scan'208";a="541904310"
Subject: Re: acpi_ex_system_memory_space_handler oops
From: Lin Ming <ming.m.lin@intel.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090812201034.GA2983@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
Content-Type: multipart/mixed; boundary="=-VtJiQ9mPLKa7fIV+HaLu"
Date: Mon, 17 Aug 2009 16:43:32 +0800
Message-Id: <1250498613.28336.68.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VtJiQ9mPLKa7fIV+HaLu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2009-08-13 at 04:10 +0800, Sergey Senozhatsky wrote:
> [    0.205668] ACPI Error (dswload-0790): [PCFG] Namespace lookup failure, AE_ALREADY_EXISTS
> [    0.205899] ACPI Exception: AE_ALREADY_EXISTS, During name lookup/catalog 20090521 psloop-227
> [    0.206124] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
> [    0.206417] ACPI: Marking method RBPE as Serialized because of AE_ALREADY_EXISTS error
> [    0.206773] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
> [    0.207070] ACPI: Marking method _STA as Serialized because of AE_ALREADY_EXISTS error
> [    0.207326] ACPI Error (uteval-0256): Method execution failed [\_SB_.PCI0.P0P4.XCRD._STA] (Node f7015648), AE_ALREADY_EXISTS
> [    0.213503] ACPI Error: Could not map memory at 0000000000000000, size 0 20090521 exregion-173
> [    0.213734] ACPI Exception: AE_NO_MEMORY, Returned by Handler for [SystemMemory] 20090521 evregion-424
> [    0.213963] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.RBPE] (Node f7017678), AE_NO_MEMORY
> [    0.214286] ACPI Error (psparse-0537): Method parse/execution failed [\_GPE._L01] (Node f701d198), AE_NO_MEMORY
> [    0.214616] ACPI Exception: AE_NO_MEMORY, while evaluating GPE method [_L01] 20090521 evgpe-568
> [    0.216428] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> [    0.216523] PCI: updated MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
> [    0.216627] PCI: Using MMCONFIG for extended config space

Hi, Sergey

I have 2 debug patches here, one is a DSDT patch and the other is a
debug kernel patch.

1. DSDT patch

There are many AE_ALREADY_EXISTS error, as above.
It is caused by same region/field name defined in different methods.
PCFG/XCFG are defined in method RBPE/RWPE/RDPE/WBPE/WWPE/WDPE/RWDP.
Actually, these definition are valid, but we don't handle this case well
now, so it may cause problem.

The attched DSDT.dsl is the custom DSDT, and you can find how to use it
at linux-2.6/Documentation/acpi/dsdt-override.txt.
See the DSDT.patch to find what I changed for the custom DSDT.

2. Debug kernel patch

Currently, we exit the interpreter when setup region, because it may
execute control methods, such as _REG.

The attached debug kernel patch (region-debug.patch) don't exit the
interpreter if the region is temporary, namely, it is defined inside a
method.


Would you please try the DSDT patch and the debug kernel patch to see if
any of them fixes the oops?

(Test one patch each time, not both)

Thanks,
Lin Ming









 


--=-VtJiQ9mPLKa7fIV+HaLu
Content-Disposition: attachment; filename="DSDT.dsl"
Content-Type: text/x-dsl; name="DSDT.dsl"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * Intel ACPI Component Architecture
 * AML Disassembler version 20090625
 *
 * Disassembly of DSDT.dat, Fri Aug 14 10:15:28 2009
 *
 *
 * Original Table Header:
 *     Signature        "DSDT"
 *     Length           0x00008918 (35096)
 *     Revision         0x01 **** ACPI 1.0, no 64-bit math support
 *     Checksum         0x15
 *     OEM ID           "F3J00"
 *     OEM Table ID     "F3J00001"
 *     OEM Revision     0x00000001 (1)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x02002026 (33562662)
 */
DefinitionBlock ("DSDT.aml", "DSDT", 1, "F3J00", "F3J00001", 0x00000001)
{
    External (CPUN)

    Name (_T01, 0x00)
    Name (_T00, 0x00)
    Scope (\_SB)
    {
        Name (ATKP, Zero)
        Device (ATKD)
        {
            Name (_HID, "ATK0100")
            Name (_UID, 0x01010100)
            Method (INIT, 1, NotSerialized)
            {
                Store (One, ATKP)
                Return (\MNAM)
            }

            Method (BSTS, 0, NotSerialized)
            {
                Store (\IKFG, Local0)
                If (\ACPF)
                {
                    And (Local0, 0x7F, Local0)
                }

                Return (Local0)
            }

            Method (TMPR, 0, NotSerialized)
            {
                Store (\_TZ.RTMP (), Local0)
                Store (\_TZ.RFAN (), Local1)
                If (LEqual (Local1, 0x01))
                {
                    Store (0x00, Local1)
                }

                ShiftLeft (Local1, 0x10, Local1)
                Add (\_TZ.KELV (Local0), Local1, Local0)
                Store (Zero, Local2)
                If (\TENA)
                {
                    Store (\TDTY, Local2)
                }
                Else
                {
                    Store (HKTH (), Local3)
                    If (LNotEqual (Local3, 0xFFFF))
                    {
                        Store (Local3, Local2)
                    }
                }

                ShiftLeft (Local2, 0x18, Local2)
                Add (Local0, Local2, Local0)
                Return (Local0)
            }

            Method (SFUN, 0, NotSerialized)
            {
                Store (0x37, Local0)
                Or (Local0, 0x40, Local0)
                Or (Local0, 0x80, Local0)
                Or (Local0, 0x0800, Local0)
                Or (Local0, 0x1000, Local0)
                Or (Local0, 0x00020000, Local0)
                Or (Local0, 0x00080000, Local0)
                Return (Local0)
            }

            Method (OSVR, 1, NotSerialized)
            {
                Store (Arg0, \OSFG)
            }

            Method (GPLV, 0, NotSerialized)
            {
                Return (\LBTN)
            }

            Method (SPLV, 1, NotSerialized)
            {
                Store (Arg0, \LBTN)
                \_SB.PCI0.SBRG.EC0.STBR ()
            }

            Method (WLED, 1, NotSerialized)
            {
                OWLD (Arg0)
            }

            Method (BLED, 1, NotSerialized)
            {
                OBTD (Arg0)
            }

            Method (TLED, 1, NotSerialized)
            {
                OTLD (Arg0)
            }

            Method (RSTS, 0, NotSerialized)
            {
                Return (ORST ())
            }

            Method (SDSP, 1, NotSerialized)
            {
                If (\NATK ())
                {
                    \SWHG (Arg0)
                }
            }

            Method (GPID, 0, NotSerialized)
            {
                Return (LCDR)
            }

            Method (HWRS, 0, NotSerialized)
            {
                Return (OHWR ())
            }

            Method (GLCD, 0, NotSerialized)
            {
                Return (OLCD ())
            }

            Name (WAPF, 0x00)
            Method (CWAP, 1, NotSerialized)
            {
                Or (Arg0, WAPF, WAPF)
                Return (0x01)
            }

            Name (PCDV, 0x00)
            Method (WDOG, 1, NotSerialized)
            {
                If (LEqual (Arg0, 0x00))
                {
                    Store (PTIM, \_SB.ATKD.PCDV)
                    Return (0x3C)
                }

                If (LEqual (Arg0, 0x01))
                {
                    If (\_SB.LID._LID ())
                    {
                        Store (PTIM, \_SB.ATKD.PCDV)
                        Return (One)
                    }

                    If (LLess (\_TZ.RLTM (), PTMP))
                    {
                        Store (PTIM, \_SB.ATKD.PCDV)
                        Return (One)
                    }

                    Decrement (\_SB.ATKD.PCDV)
                    If (LEqual (\_SB.ATKD.PCDV, 0x00))
                    {
                        Store (PTIM, \_SB.ATKD.PCDV)
                        Notify (\_SB.ATKD, 0x6D)
                    }

                    Return (One)
                }

                Return (Zero)
            }

            Method (ANVI, 1, Serialized)
            {
                Store (ASMI (Arg0), Local0)
                Return (Local0)
            }

            Method (PSTC, 1, Serialized)
            {
                If (LEqual (Arg0, 0x00))
                {
                    Return (PSTN)
                }

                If (\ACPF)
                {
                    ShiftRight (PSTN, 0x08, Local0)
                }
                Else
                {
                    And (PSTN, 0xFF, Local0)
                }

                If (LGreater (Arg0, Local0))
                {
                    Return (Ones)
                }

                Store (Arg0, SLMT)
                Notify (\_PR.CPU1, 0x80)
                If (LGreaterEqual (CPUN, 0x02))
                {
                    Notify (\_PR.CPU2, 0x80)
                }

                Return (0x00)
            }

            Method (SMBB, 1, Serialized)
            {
                ShiftRight (Arg0, 0x10, Local0)
                And (Local0, 0xFF, Local0)
                ShiftRight (Arg0, 0x18, Local1)
                And (Arg0, 0xFF, Local2)
                If (And (Local1, 0x01))
                {
                    Return (\RBYT (Local1, Local0))
                }
                Else
                {
                    Return (\WBYT (Local1, Local0, Local2))
                }
            }

            Method (SMBW, 1, Serialized)
            {
                ShiftRight (Arg0, 0x10, Local0)
                And (Local0, 0xFF, Local0)
                ShiftRight (Arg0, 0x18, Local1)
                And (Arg0, 0xFF, Local2)
                If (And (Local1, 0x01))
                {
                    Return (\RWRD (Local1, Local0))
                }
                Else
                {
                    Return (\WWRD (Local1, Local0, Local2))
                }
            }

            Method (SMBK, 1, Serialized)
            {
                ShiftRight (Arg0, 0x08, Local0)
                And (Local0, 0xFF, Local0)
                If (Local0)
                {
                    ShiftRight (Arg0, 0x10, Local0)
                    And (Local0, 0xFF, Local0)
                    ShiftRight (Arg0, 0x18, Local1)
                    And (Local1, 0xFF, Local1)
                    And (Arg0, 0x0F, Local3)
                    If (And (Local1, 0x01))
                    {
                        RBLK (Local1, Local0, Local3)
                    }
                    Else
                    {
                        WBLK (Local1, Local0, Local3)
                    }

                    Return (0x00)
                }
                Else
                {
                    ShiftRight (Arg0, 0x10, Local2)
                    And (Local2, 0xFF, Local2)
                    ShiftRight (Arg0, 0x18, Local1)
                    If (And (Local1, 0x01))
                    {
                        Return (DerefOf (Index (RBUF, Local2)))
                    }
                    Else
                    {
                        And (Arg0, 0xFF, Local1)
                        Store (Local1, Index (RBUF, Local2))
                        Return (0x00)
                    }
                }
            }

            Method (ECRW, 1, Serialized)
            {
                ShiftRight (Arg0, 0x18, Local0)
                And (Local0, 0xFF, Local0)
                ShiftRight (Arg0, 0x10, Local1)
                And (Local1, 0xFF, Local1)
                ShiftRight (Arg0, 0x08, Local2)
                And (Local2, 0xFF, Local2)
                And (Arg0, 0xFF, Local3)
                If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
                {
                    Return (Ones)
                }

                Store (Local0, \_SB.PCI0.SBRG.EC0.CDT3)
                Store (Local1, \_SB.PCI0.SBRG.EC0.CDT2)
                Store (Local2, \_SB.PCI0.SBRG.EC0.CDT1)
                Store (Local3, \_SB.PCI0.SBRG.EC0.CMD1)
                Store (0x05, Local0)
                While (LAnd (Local0, \_SB.PCI0.SBRG.EC0.CMD1))
                {
                    Sleep (0x01)
                    Decrement (Local0)
                }

                Store (\_SB.PCI0.SBRG.EC0.CDT3, Local0)
                Store (\_SB.PCI0.SBRG.EC0.CDT2, Local1)
                Store (\_SB.PCI0.SBRG.EC0.CDT1, Local2)
                Store (\_SB.PCI0.SBRG.EC0.CMD1, Local3)
                Release (\P4SM)
                ShiftLeft (Local0, 0x08, Local0)
                Or (Local0, Local1, Local0)
                ShiftLeft (Local0, 0x08, Local0)
                Or (Local0, Local2, Local0)
                ShiftLeft (Local0, 0x08, Local0)
                Or (Local0, Local3, Local0)
                Return (Local0)
            }
        }
    }

    Scope (\_PR)
    {
        Processor (CPU1, 0x01, 0x00000810, 0x06)
        {
            OperationRegion (STBL, SystemMemory, 0x3FFB8F40, 0x0D24)
            Name (NCPU, 0x02)
            Name (PDC1, 0x80000000)
            Name (HNDL, 0x80000000)
            Name (CFGD, 0x01007DF1)
            Name (TBLD, 0x00)
            Method (_PDC, 1, NotSerialized)
            {
                CreateDWordField (Arg0, 0x08, DAT0)
                Store (DAT0, PDC1)
                If (LEqual (TBLD, 0x00))
                {
                    If (LAnd (LGreaterEqual (NCPU, 0x02), LEqual (And (PDC1, 0x0A
                        ), 0x0A)))
                    {
                        Load (STBL, HNDL)
                        Store (0x01, TBLD)
                    }
                }
            }
        }
    }

    Scope (\_PR)
    {
        Processor (CPU2, 0x02, 0x00000810, 0x06)
        {
            OperationRegion (STBL, SystemMemory, 0x3FFB9C70, 0x0D24)
            Name (NCPU, 0x02)
            Name (PDC2, 0x80000000)
            Name (HNDL, 0x80000000)
            Name (CFGD, 0x01007DF1)
            Name (TBLD, 0x00)
            Method (_PDC, 1, NotSerialized)
            {
                CreateDWordField (Arg0, 0x08, DAT0)
                Store (DAT0, PDC2)
                If (LEqual (TBLD, 0x00))
                {
                    If (LAnd (LGreaterEqual (NCPU, 0x02), LEqual (And (PDC2, 0x01
                        ), 0x01)))
                    {
                        Load (STBL, HNDL)
                        Store (0x02, TBLD)
                    }

                    If (LAnd (LEqual (NCPU, 0x01), LEqual (And (PDC2, 0x01), 
                        0x01)))
                    {
                        If (LNot (And (PDC2, 0x10)))
                        {
                            Load (STBL, HNDL)
                            Store (0x01, TBLD)
                        }
                    }
                }
            }
        }
    }

    Method (\_PR.CPU2._INI, 0, NotSerialized)
    {
        If (\DTSE)
        {
            TRAP (0x46)
        }
    }

    Method (WDTS, 1, NotSerialized)
    {
        If (LAnd (\DTSE, \MPEN))
        {
            TRAP (0x46)
        }
    }

    Method (TRAP, 1, NotSerialized)
    {
        OperationRegion (SSMI, SystemIO, SMIP, 0x01)
        Field (SSMI, ByteAcc, NoLock, Preserve)
        {
            SMIC,   8
        }

        Store (Arg0, \SMIF)
        Store (DTSS, SMIC)
    }

    Scope (\_GPE)
    {
        Method (_L02, 0, NotSerialized)
        {
            Store (0x00, GPEC)
            Notify (\_TZ.THRM, 0x80)
        }
    }

    Name (DTSS, 0x5A)
    Name (PMBS, 0x0800)
    Name (PMLN, 0x80)
    Name (GPBS, 0x0480)
    Name (GPLN, 0x40)
    Name (PM30, 0x0830)
    Name (SUSW, 0xFF)
    Name (APIC, 0x01)
    Name (PCIB, 0xE0000000)
    Name (PCIL, 0x04000000)
    Name (APCB, 0xFEC00000)
    Name (APCL, 0x00100000)
    Name (MBLF, 0x0A)
    Name (SMIP, 0xB2)
    Name (SMBS, 0x0400)
    Name (SMBL, 0x20)
    OperationRegion (BIOS, SystemMemory, 0x3FFBE064, 0xFF)
    Field (BIOS, ByteAcc, NoLock, Preserve)
    {
        SS1,    1, 
        SS2,    1, 
        SS3,    1, 
        SS4,    1, 
                Offset (0x01), 
        IOST,   16, 
        TOPM,   32, 
        ROMS,   32, 
        MG1B,   32, 
        MG1L,   32, 
        MG2B,   32, 
        MG2L,   32, 
                Offset (0x1C), 
        ASSB,   8, 
        AOTB,   8, 
        AAXB,   32
    }

    Method (RRIO, 4, NotSerialized)
    {
        Store ("RRIO", Debug)
    }

    Method (RDMA, 3, NotSerialized)
    {
        Store ("rDMA", Debug)
    }

    Name (PICM, 0x00)
    Method (_PIC, 1, NotSerialized)
    {
        If (Arg0)
        {
            Store (0xAA, DBG8)
        }
        Else
        {
            Store (0xAC, DBG8)
        }

        Store (Arg0, PICM)
    }

    Name (OSVR, Ones)
    Method (OSFL, 0, NotSerialized)
    {
        If (LNotEqual (OSVR, Ones))
        {
            Return (OSVR)
        }

        If (LEqual (PICM, 0x00))
        {
            Store (0xAC, DBG8)
        }

        Store (0x01, OSVR)
        If (MCTH (\_OS, "Microsoft Windows NT"))
        {
            Store (0x00, OSVR)
        }
        Else
        {
            If (MCTH (\_OS, "Microsoft WindowsME: Millennium Edition"))
            {
                Store (0x02, OSVR)
            }

            If (MCTH (\_OS, "Linux"))
            {
                Store (0x03, OSVR)
            }
        }

        Return (OSVR)
    }

    Method (MCTH, 2, NotSerialized)
    {
        If (LLess (SizeOf (Arg0), SizeOf (Arg1)))
        {
            Return (Zero)
        }

        Add (SizeOf (Arg0), 0x01, Local0)
        Name (BUF0, Buffer (Local0) {})
        Name (BUF1, Buffer (Local0) {})
        Store (Arg0, BUF0)
        Store (Arg1, BUF1)
        While (Local0)
        {
            Decrement (Local0)
            If (LNotEqual (DerefOf (Index (BUF0, Local0)), DerefOf (Index (
                BUF1, Local0))))
            {
                Return (Zero)
            }
        }

        Return (One)
    }

    Name (PRWP, Package (0x02)
    {
        Zero, 
        Zero
    })
    Method (GPRW, 2, NotSerialized)
    {
        Store (Arg0, Index (PRWP, 0x00))
        Store (ShiftLeft (SS1, 0x01), Local0)
        Or (Local0, ShiftLeft (SS2, 0x02), Local0)
        Or (Local0, ShiftLeft (SS3, 0x03), Local0)
        Or (Local0, ShiftLeft (SS4, 0x04), Local0)
        If (And (ShiftLeft (0x01, Arg1), Local0))
        {
            Store (Arg1, Index (PRWP, 0x01))
        }
        Else
        {
            ShiftRight (Local0, 0x01, Local0)
            If (LOr (LEqual (OSFL (), 0x01), LEqual (OSFL (), 0x02)))
            {
                FindSetLeftBit (Local0, Index (PRWP, 0x01))
            }
            Else
            {
                FindSetRightBit (Local0, Index (PRWP, 0x01))
            }
        }

        Return (PRWP)
    }

    Name (WAKP, Package (0x02)
    {
        Zero, 
        Zero
    })
    OperationRegion (DEB0, SystemIO, 0x80, 0x01)
    Field (DEB0, ByteAcc, NoLock, Preserve)
    {
        DBG8,   8
    }

    OperationRegion (DEB1, SystemIO, 0x90, 0x02)
    Field (DEB1, WordAcc, NoLock, Preserve)
    {
        DBG9,   16
    }

    Scope (\_SB)
    {
        Name (PR00, Package (0x11)
        {
            Package (0x04)
            {
                0x001FFFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x00, 
                LNKH, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x03, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                0x00, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                0x01, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR00, Package (0x11)
        {
            Package (0x04)
            {
                0x001FFFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x00, 
                0x00, 
                0x17
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001DFFFF, 
                0x03, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001FFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                0x00, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x001EFFFF, 
                0x01, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0x001BFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x03, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0x001CFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR02, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKD, 
                0x00
            }
        })
        Name (AR02, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x13
            }
        })
        Name (PR01, Package (0x02)
        {
            Package (0x04)
            {
                0x0008FFFF, 
                0x00, 
                LNKE, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKA, 
                0x00
            }
        })
        Name (AR01, Package (0x02)
        {
            Package (0x04)
            {
                0x0008FFFF, 
                0x00, 
                0x00, 
                0x14
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x10
            }
        })
        Name (PR06, Package (0x02)
        {
            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                LNKB, 
                0x00
            }
        })
        Name (AR06, Package (0x02)
        {
            Package (0x04)
            {
                0x0001FFFF, 
                0x00, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0x0001FFFF, 
                0x01, 
                0x00, 
                0x11
            }
        })
        Name (PR03, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKB, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKA, 
                0x00
            }
        })
        Name (AR03, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x11
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x10
            }
        })
        Name (PR04, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                LNKC, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                LNKD, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                LNKA, 
                0x00
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                LNKB, 
                0x00
            }
        })
        Name (AR04, Package (0x04)
        {
            Package (0x04)
            {
                0xFFFF, 
                0x00, 
                0x00, 
                0x12
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x01, 
                0x00, 
                0x13
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x02, 
                0x00, 
                0x10
            }, 

            Package (0x04)
            {
                0xFFFF, 
                0x03, 
                0x00, 
                0x11
            }
        })
        Name (PRSA, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, )
                {3,4,5,6,7,11,12}
        })
        Name (PRSB, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, )
                {3,4,5,6,7,12}
        })
        Alias (PRSB, PRSC)
        Alias (PRSB, PRSD)
        Alias (PRSB, PRSE)
        Alias (PRSB, PRSF)
        Alias (PRSB, PRSG)
        Alias (PRSB, PRSH)
        Device (PCI0)
        {
            Name (_HID, EisaId ("PNP0A08"))
            Name (_ADR, 0x00)
            Method (^BN00, 0, NotSerialized)
            {
                Return (0x00)
            }

            Method (_BBN, 0, NotSerialized)
            {
                Return (BN00 ())
            }

            Name (_UID, 0x00)
            Method (_PRT, 0, NotSerialized)
            {
                If (PICM)
                {
                    Return (AR00)
                }

                Return (PR00)
            }

            Method (_S3D, 0, NotSerialized)
            {
                If (LOr (LEqual (OSFL (), 0x01), LEqual (OSFL (), 0x02)))
                {
                    Return (0x02)
                }
                Else
                {
                    Return (0x03)
                }
            }

            Name (_CID, EisaId ("PNP0A03"))
            Device (MCH)
            {
                Name (_HID, EisaId ("PNP0C01"))
                Name (_UID, 0x0A)
                Name (_CRS, ResourceTemplate ()
                {
                    Memory32Fixed (ReadWrite,
                        0xFED13000,         // Address Base
                        0x00007000,         // Address Length
                        )
                })
            }

            Method (NPTS, 1, NotSerialized)
            {
            }

            Method (NWAK, 1, NotSerialized)
            {
            }

            Device (SBRG)
            {
                Name (_ADR, 0x001F0000)
                Device (IELK)
                {
                    Name (_HID, "AWY0001")
                    OperationRegion (RXA0, PCI_Config, 0xA0, 0x20)
                    Field (RXA0, ByteAcc, NoLock, Preserve)
                    {
                            ,   9, 
                        PBLV,   1, 
                        BCPE,   1, 
                                Offset (0x10), 
                            ,   1, 
                        PBMS,   1, 
                            ,   1, 
                        PMCS,   1, 
                        ECNS,   1, 
                                Offset (0x11), 
                        ECT1,   16, 
                        ELEN,   1, 
                                Offset (0x14)
                    }

                    Method (\_GPE._L0A, 0, NotSerialized)
                    {
                        Notify (\_SB.PCI0.SBRG.IELK, 0x81)
                        Store (0x01, \_SB.PCI0.SBRG.IELK.PMCS)
                    }

                    Method (_STA, 0, NotSerialized)
                    {
                        If (ELEN)
                        {
                            Return (0x0F)
                        }
                        Else
                        {
                            Return (0x00)
                        }
                    }

                    Method (SMOD, 1, NotSerialized)
                    {
                    }

                    Method (GPBS, 0, NotSerialized)
                    {
                        Return (XOr (PBLV, 0x01))
                    }
                }

                Method (SPTS, 1, NotSerialized)
                {
                    Store (One, PS1S)
                    Store (One, PS1E)
                    Store (One, \_SB.SLPS)
                }

                Method (SWAK, 1, NotSerialized)
                {
                    Store (Zero, \_SB.SLPS)
                    Store (Zero, PS1E)
                }

                OperationRegion (APMP, SystemIO, SMIP, 0x02)
                Field (APMP, ByteAcc, NoLock, Preserve)
                {
                    APMC,   8, 
                    APMS,   8
                }

                Field (APMP, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x01), 
                        ,   1, 
                    BRTC,   1
                }

                OperationRegion (PMS0, SystemIO, PMBS, 0x04)
                Field (PMS0, ByteAcc, NoLock, Preserve)
                {
                        ,   10, 
                    RTCS,   1, 
                        ,   4, 
                    WAKS,   1, 
                            Offset (0x03), 
                    PWBT,   1, 
                            Offset (0x04)
                }

                OperationRegion (SMIE, SystemIO, PM30, 0x08)
                Field (SMIE, ByteAcc, NoLock, Preserve)
                {
                        ,   4, 
                    PS1E,   1, 
                        ,   31, 
                    PS1S,   1, 
                            Offset (0x08)
                }

                Scope (\_SB)
                {
                    Name (SLPS, 0x00)
                }

                Device (PIC)
                {
                    Name (_HID, EisaId ("PNP0000"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0020,             // Range Minimum
                            0x0020,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x00A0,             // Range Minimum
                            0x00A0,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                        IRQNoFlags ()
                            {2}
                    })
                }

                Device (DMAD)
                {
                    Name (_HID, EisaId ("PNP0200"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        DMA (Compatibility, BusMaster, Transfer8, )
                            {4}
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0081,             // Range Minimum
                            0x0081,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0087,             // Range Minimum
                            0x0087,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0089,             // Range Minimum
                            0x0089,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x008F,             // Range Minimum
                            0x008F,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x00C0,             // Range Minimum
                            0x00C0,             // Range Maximum
                            0x00,               // Alignment
                            0x20,               // Length
                            )
                    })
                }

                Device (TMR)
                {
                    Name (_HID, EisaId ("PNP0100"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0040,             // Range Minimum
                            0x0040,             // Range Maximum
                            0x00,               // Alignment
                            0x04,               // Length
                            )
                        IRQNoFlags ()
                            {0}
                    })
                }

                Device (RTC0)
                {
                    Name (_HID, EisaId ("PNP0B00"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0070,             // Range Minimum
                            0x0070,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                        IRQNoFlags ()
                            {8}
                    })
                }

                Device (PS2K)
                {
                    Name (_HID, EisaId ("PNP0303"))
                    Name (_CID, EisaId ("PNP030B"))
                    Method (_STA, 0, NotSerialized)
                    {
                        ShiftLeft (0x01, 0x0A, Local0)
                        If (And (IOST, Local0))
                        {
                            Return (0x0F)
                        }

                        Return (0x00)
                    }

                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {1}
                    })
                }

                Device (PS2M)
                {
                    Method (_HID, 0, NotSerialized)
                    {
                        If (ALPS)
                        {
                            Return (0x0313A906)
                        }
                        Else
                        {
                            Return (0x060A2E4F)
                        }
                    }

                    Name (_CID, Package (0x05)
                    {
                        EisaId ("SYN0A00"), 
                        EisaId ("SYN0002"), 
                        EisaId ("PNP0F03"), 
                        EisaId ("PNP0F13"), 
                        EisaId ("PNP0F12")
                    })
                    Method (_STA, 0, NotSerialized)
                    {
                        ShiftLeft (0x01, 0x0C, Local0)
                        If (And (IOST, Local0))
                        {
                            Return (0x0F)
                        }

                        Return (0x00)
                    }

                    Name (CRS1, ResourceTemplate ()
                    {
                        IRQNoFlags ()
                            {12}
                    })
                    Name (CRS2, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0060,             // Range Minimum
                            0x0060,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0064,             // Range Minimum
                            0x0064,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IRQNoFlags ()
                            {12}
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        ShiftLeft (0x01, 0x0A, Local0)
                        If (And (IOST, Local0))
                        {
                            Return (CRS1)
                        }
                        Else
                        {
                            Return (CRS2)
                        }
                    }
                }

                Device (SPKR)
                {
                    Name (_HID, EisaId ("PNP0800"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0061,             // Range Minimum
                            0x0061,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                    })
                }

                Device (COPR)
                {
                    Name (_HID, EisaId ("PNP0C04"))
                    Name (_CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x00F0,             // Range Minimum
                            0x00F0,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IRQNoFlags ()
                            {13}
                    })
                }

                Device (RMSC)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x10)
                    Name (CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0010,             // Range Minimum
                            0x0010,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x0022,             // Range Minimum
                            0x0022,             // Range Maximum
                            0x00,               // Alignment
                            0x1E,               // Length
                            )
                        IO (Decode16,
                            0x0044,             // Range Minimum
                            0x0044,             // Range Maximum
                            0x00,               // Alignment
                            0x1C,               // Length
                            )
                        IO (Decode16,
                            0x0063,             // Range Minimum
                            0x0063,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0065,             // Range Minimum
                            0x0065,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0067,             // Range Minimum
                            0x0067,             // Range Maximum
                            0x00,               // Alignment
                            0x09,               // Length
                            )
                        IO (Decode16,
                            0x0072,             // Range Minimum
                            0x0072,             // Range Maximum
                            0x00,               // Alignment
                            0x0E,               // Length
                            )
                        IO (Decode16,
                            0x0080,             // Range Minimum
                            0x0080,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x0084,             // Range Minimum
                            0x0084,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0088,             // Range Minimum
                            0x0088,             // Range Maximum
                            0x00,               // Alignment
                            0x01,               // Length
                            )
                        IO (Decode16,
                            0x008C,             // Range Minimum
                            0x008C,             // Range Maximum
                            0x00,               // Alignment
                            0x03,               // Length
                            )
                        IO (Decode16,
                            0x0090,             // Range Minimum
                            0x0090,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x00A2,             // Range Minimum
                            0x00A2,             // Range Maximum
                            0x00,               // Alignment
                            0x1E,               // Length
                            )
                        IO (Decode16,
                            0x00E0,             // Range Minimum
                            0x00E0,             // Range Maximum
                            0x00,               // Alignment
                            0x10,               // Length
                            )
                        IO (Decode16,
                            0x04D0,             // Range Minimum
                            0x04D0,             // Range Maximum
                            0x00,               // Alignment
                            0x02,               // Length
                            )
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x00,               // Length
                            _Y00)
                        IO (Decode16,
                            0x0000,             // Range Minimum
                            0x0000,             // Range Maximum
                            0x00,               // Alignment
                            0x00,               // Length
                            _Y01)
                        Memory32Fixed (ReadWrite,
                            0xFED1C000,         // Address Base
                            0x00004000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFED20000,         // Address Base
                            0x00020000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFED45000,         // Address Base
                            0x00045000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFED45000,         // Address Base
                            0x00045000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFFB00000,         // Address Base
                            0x00100000,         // Address Length
                            )
                        Memory32Fixed (ReadWrite,
                            0xFFF00000,         // Address Base
                            0x00100000,         // Address Length
                            )
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        CreateWordField (CRS, \_SB.PCI0.SBRG.RMSC._Y00._MIN, GP00)
                        CreateWordField (CRS, \_SB.PCI0.SBRG.RMSC._Y00._MAX, GP01)
                        CreateByteField (CRS, \_SB.PCI0.SBRG.RMSC._Y00._LEN, GP0L)
                        Store (PMBS, GP00)
                        Store (PMBS, GP01)
                        Store (PMLN, GP0L)
                        If (GPBS)
                        {
                            CreateWordField (CRS, \_SB.PCI0.SBRG.RMSC._Y01._MIN, GP20)
                            CreateWordField (CRS, \_SB.PCI0.SBRG.RMSC._Y01._MAX, GP21)
                            CreateByteField (CRS, \_SB.PCI0.SBRG.RMSC._Y01._LEN, GP2L)
                            Store (GPBS, GP20)
                            Store (GPBS, GP21)
                            Store (GPLN, GP2L)
                        }

                        Return (CRS)
                    }
                }

                Device (HPET)
                {
                    Name (_HID, EisaId ("PNP0103"))
                    Name (CRS, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadOnly,
                            0xFED00000,         // Address Base
                            0x00000400,         // Address Length
                            _Y02)
                    })
                    OperationRegion (^LPCR, SystemMemory, 0xFED1F404, 0x04)
                    Field (^LPCR, AnyAcc, NoLock, Preserve)
                    {
                        HPTS,   2, 
                            ,   5, 
                        HPTE,   1, 
                                Offset (0x04)
                    }

                    Method (_STA, 0, NotSerialized)
                    {
                        Return (0x0F)
                    }

                    Method (_CRS, 0, NotSerialized)
                    {
                        CreateDWordField (CRS, \_SB.PCI0.SBRG.HPET._Y02._BAS, HPT)
                        Multiply (HPTS, 0x1000, Local0)
                        Add (Local0, 0xFED00000, HPT)
                        Return (CRS)
                    }
                }

                OperationRegion (RX80, PCI_Config, 0x00, 0xFF)
                Field (RX80, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x80), 
                    LPCD,   16, 
                    LPCE,   16
                }

                Name (DBPT, Package (0x04)
                {
                    Package (0x08)
                    {
                        0x03F8, 
                        0x02F8, 
                        0x0220, 
                        0x0228, 
                        0x0238, 
                        0x02E8, 
                        0x0338, 
                        0x03E8
                    }, 

                    Package (0x08)
                    {
                        0x03F8, 
                        0x02F8, 
                        0x0220, 
                        0x0228, 
                        0x0238, 
                        0x02E8, 
                        0x0338, 
                        0x03E8
                    }, 

                    Package (0x03)
                    {
                        0x0378, 
                        0x0278, 
                        0x03BC
                    }, 

                    Package (0x02)
                    {
                        0x03F0, 
                        0x0370
                    }
                })
                Name (DDLT, Package (0x04)
                {
                    Package (0x02)
                    {
                        0x00, 
                        0xFFF8
                    }, 

                    Package (0x02)
                    {
                        0x04, 
                        0xFF8F
                    }, 

                    Package (0x02)
                    {
                        0x08, 
                        0xFCFF
                    }, 

                    Package (0x02)
                    {
                        0x0C, 
                        0xEFFF
                    }
                })
                Method (RRIO, 4, NotSerialized)
                {
                    If (LAnd (LLessEqual (Arg0, 0x03), LGreaterEqual (Arg0, 0x00)))
                    {
                        Store (Match (DerefOf (Index (DBPT, Arg0)), MEQ, Arg2, MTR, 
                            0x00, 0x00), Local0)
                        If (LNotEqual (Local0, Ones))
                        {
                            Store (DerefOf (Index (DerefOf (Index (DDLT, Arg0)), 0x00)), 
                                Local1)
                            Store (DerefOf (Index (DerefOf (Index (DDLT, Arg0)), 0x01)), 
                                Local2)
                            ShiftLeft (Local0, Local1, Local0)
                            And (LPCD, Local2, LPCD)
                            Or (LPCD, Local0, LPCD)
                            WX82 (Arg0, Arg1)
                        }
                    }

                    If (LEqual (Arg0, 0x08))
                    {
                        If (LEqual (Arg2, 0x0200))
                        {
                            WX82 (0x08, Arg0)
                        }
                        Else
                        {
                            If (LEqual (Arg2, 0x0208))
                            {
                                WX82 (0x09, Arg0)
                            }
                        }
                    }

                    If (LAnd (LLessEqual (Arg0, 0x0D), LGreaterEqual (Arg0, 0x0A)))
                    {
                        WX82 (Arg0, Arg1)
                    }
                }

                Method (WX82, 2, NotSerialized)
                {
                    ShiftLeft (0x01, Arg0, Local0)
                    If (Arg1)
                    {
                        Or (LPCE, Local0, LPCE)
                    }
                    Else
                    {
                        Not (Local0, Local0)
                        And (LPCE, Local0, LPCE)
                    }
                }

                Method (RDMA, 3, NotSerialized)
                {
                }

                Device (\_SB.PCI0.PCIE)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x11)
                    Name (CRS, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadOnly,
                            0xE0000000,         // Address Base
                            0x10000000,         // Address Length
                            _Y03)
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        CreateDWordField (CRS, \_SB.PCI0.PCIE._Y03._BAS, BAS1)
                        CreateDWordField (CRS, \_SB.PCI0.PCIE._Y03._LEN, LEN1)
                        Store (\PCIB, BAS1)
                        Store (\PCIL, LEN1)
                        Return (CRS)
                    }
                }

                Device (OMSC)
                {
                    Name (_HID, EisaId ("PNP0C02"))
                    Name (_UID, 0x00)
                    Name (CRS, ResourceTemplate ()
                    {
                        IO (Decode16,
                            0x0250,             // Range Minimum
                            0x0253,             // Range Maximum
                            0x01,               // Alignment
                            0x04,               // Length
                            )
                        IO (Decode16,
                            0x0256,             // Range Minimum
                            0x025F,             // Range Maximum
                            0x01,               // Alignment
                            0x0A,               // Length
                            )
                        Memory32Fixed (ReadOnly,
                            0x00000000,         // Address Base
                            0x00000000,         // Address Length
                            _Y04)
                        Memory32Fixed (ReadOnly,
                            0x00000000,         // Address Base
                            0x00000000,         // Address Length
                            _Y05)
                        Memory32Fixed (ReadOnly,
                            0xFEC10000,         // Address Base
                            0x00008000,         // Address Length
                            )
                        Memory32Fixed (ReadOnly,
                            0xFEC18000,         // Address Base
                            0x00008000,         // Address Length
                            )
                        Memory32Fixed (ReadOnly,
                            0xFEC20000,         // Address Base
                            0x00008000,         // Address Length
                            )
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        If (APIC)
                        {
                            CreateDWordField (CRS, \_SB.PCI0.SBRG.OMSC._Y04._LEN, ML01)
                            CreateDWordField (CRS, \_SB.PCI0.SBRG.OMSC._Y04._BAS, MB01)
                            CreateDWordField (CRS, \_SB.PCI0.SBRG.OMSC._Y05._LEN, ML02)
                            CreateDWordField (CRS, \_SB.PCI0.SBRG.OMSC._Y05._BAS, MB02)
                            Store (0xFEC00000, MB01)
                            Store (0x1000, ML01)
                            Store (0xFEE00000, MB02)
                            Store (0x1000, ML02)
                        }

                        Return (CRS)
                    }
                }

                Device (\_SB.RMEM)
                {
                    Name (_HID, EisaId ("PNP0C01"))
                    Name (_UID, 0x01)
                    Name (CRS, ResourceTemplate ()
                    {
                        Memory32Fixed (ReadWrite,
                            0x00000000,         // Address Base
                            0x000A0000,         // Address Length
                            )
                        Memory32Fixed (ReadOnly,
                            0x00000000,         // Address Base
                            0x00000000,         // Address Length
                            _Y06)
                        Memory32Fixed (ReadOnly,
                            0x000E0000,         // Address Base
                            0x00020000,         // Address Length
                            _Y07)
                        Memory32Fixed (ReadWrite,
                            0x00100000,         // Address Base
                            0x00000000,         // Address Length
                            _Y08)
                        Memory32Fixed (ReadOnly,
                            0x00000000,         // Address Base
                            0x00000000,         // Address Length
                            _Y09)
                    })
                    Method (_CRS, 0, NotSerialized)
                    {
                        CreateDWordField (CRS, \_SB.RMEM._Y06._BAS, BAS1)
                        CreateDWordField (CRS, \_SB.RMEM._Y06._LEN, LEN1)
                        CreateDWordField (CRS, \_SB.RMEM._Y07._BAS, BAS2)
                        CreateDWordField (CRS, \_SB.RMEM._Y07._LEN, LEN2)
                        CreateDWordField (CRS, \_SB.RMEM._Y08._LEN, LEN3)
                        CreateDWordField (CRS, \_SB.RMEM._Y09._BAS, BAS4)
                        CreateDWordField (CRS, \_SB.RMEM._Y09._LEN, LEN4)
                        If (OSFL ()) {}
                        Else
                        {
                            If (MG1B)
                            {
                                If (LGreater (MG1B, 0x000C0000))
                                {
                                    Store (0x000C0000, BAS1)
                                    Subtract (MG1B, BAS1, LEN1)
                                }
                            }
                            Else
                            {
                                Store (0x000C0000, BAS1)
                                Store (0x00020000, LEN1)
                            }

                            If (Add (MG1B, MG1L, Local0))
                            {
                                Store (Local0, BAS2)
                                Subtract (0x00100000, BAS2, LEN2)
                            }
                        }

                        Subtract (MG2B, 0x00100000, LEN3)
                        Add (MG2B, MG2L, BAS4)
                        Subtract (0x00, BAS4, LEN4)
                        Return (CRS)
                    }
                }
            }

            Device (IDE0)
            {
                Name (_ADR, 0x001F0002)
                Name (REGF, 0x01)
                Method (_REG, 2, NotSerialized)
                {
                    If (LEqual (Arg0, 0x02))
                    {
                        Store (Arg1, REGF)
                    }
                }

                OperationRegion (BAR0, PCI_Config, 0x00, 0x0100)
                Field (BAR0, DWordAcc, NoLock, Preserve)
                {
                    VDID,   32, 
                            Offset (0x40), 
                    TIMP,   16, 
                    TIMS,   16, 
                    STMP,   4, 
                    STMS,   4, 
                            Offset (0x48), 
                    UDMP,   2, 
                    UDMS,   2, 
                            Offset (0x4A), 
                    UDTP,   6, 
                            Offset (0x4B), 
                    UDTS,   6, 
                            Offset (0x54), 
                    PCB0,   2, 
                    SCB0,   2, 
                    PCA0,   2, 
                    SCA0,   2, 
                        ,   4, 
                    FPB0,   2, 
                    FSB0,   2, 
                    PSIG,   2, 
                    SSIG,   2
                }

                Name (TIM0, Package (0x09)
                {
                    Package (0x04)
                    {
                        0x78, 
                        0xB4, 
                        0xF0, 
                        0x0384
                    }, 

                    Package (0x04)
                    {
                        0x23, 
                        0x21, 
                        0x10, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0x0B, 
                        0x09, 
                        0x04, 
                        0x00
                    }, 

                    Package (0x06)
                    {
                        0x70, 
                        0x49, 
                        0x36, 
                        0x27, 
                        0x19, 
                        0x0F
                    }, 

                    Package (0x06)
                    {
                        0x00, 
                        0x01, 
                        0x02, 
                        0x01, 
                        0x02, 
                        0x01
                    }, 

                    Package (0x06)
                    {
                        0x00, 
                        0x00, 
                        0x00, 
                        0x01, 
                        0x01, 
                        0x01
                    }, 

                    Package (0x06)
                    {
                        0x00, 
                        0x00, 
                        0x00, 
                        0x00, 
                        0x00, 
                        0x01
                    }, 

                    Package (0x04)
                    {
                        0x04, 
                        0x03, 
                        0x02, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0x02, 
                        0x01, 
                        0x00, 
                        0x00
                    }
                })
                Name (TMD0, Buffer (0x14) {})
                CreateDWordField (TMD0, 0x00, PIO0)
                CreateDWordField (TMD0, 0x04, DMA0)
                CreateDWordField (TMD0, 0x08, PIO1)
                CreateDWordField (TMD0, 0x0C, DMA1)
                CreateDWordField (TMD0, 0x10, CHNF)
                Name (GTIM, 0x00)
                Name (GSTM, 0x00)
                Name (GUDM, 0x00)
                Name (GUDT, 0x00)
                Name (GCB0, 0x00)
                Name (GFB0, 0x00)
                Device (CHN0)
                {
                    Name (_ADR, 0x00)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (TIMP, STMP, UDMP, UDTP, PCB0, FPB0))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, Debug)
                        Store (Arg0, TMD0)
                        Store (TIMP, GTIM)
                        Store (UDTP, GUDT)
                        If (STM ())
                        {
                            Store (GTIM, TIMP)
                            Store (GSTM, STMP)
                            Store (GUDM, UDMP)
                            Store (GUDT, UDTP)
                            Store (GCB0, PCB0)
                            Store (GFB0, FPB0)
                        }

                        Store (GTF (0x00, Arg1), ATA0)
                        Store (GTF (0x01, Arg2), ATA1)
                    }

                    Device (DRV0)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA0))
                        }
                    }

                    Device (DRV1)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA1))
                        }
                    }
                }

                Device (CHN1)
                {
                    Name (_ADR, 0x01)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (TIMS, STMS, UDMS, UDTS, SCB0, FSB0))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, Debug)
                        Store (Arg0, TMD0)
                        Store (TIMS, GTIM)
                        Store (UDTS, GUDT)
                        If (STM ())
                        {
                            Store (GTIM, TIMS)
                            Store (GSTM, STMS)
                            Store (GUDM, UDMS)
                            Store (GUDT, UDTS)
                            Store (GCB0, SCB0)
                            Store (GFB0, FSB0)
                        }

                        Store (GTF (0x00, Arg1), ATA2)
                        Store (GTF (0x01, Arg2), ATA3)
                    }

                    Device (DRV0)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA2))
                        }
                    }

                    Device (DRV1)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA3))
                        }
                    }
                }

                Method (GTM, 6, Serialized)
                {
                    Store (Ones, PIO0)
                    Store (PIO0, PIO1)
                    Store (PIO0, DMA0)
                    Store (PIO0, DMA1)
                    Store (Zero, CHNF)
                    If (REGF) {}
                    Else
                    {
                        Return (TMD0)
                    }

                    If (And (Arg0, 0x02))
                    {
                        Or (CHNF, 0x02, CHNF)
                    }

                    ShiftRight (And (Arg0, 0x3300), 0x08, Local5)
                    Store (Match (DerefOf (Index (TIM0, 0x01)), MLE, Local5, MTR, 
                        0x00, 0x00), Local6)
                    Store (DerefOf (Index (DerefOf (Index (TIM0, 0x00)), Local6)), 
                        Local7)
                    Store (Local7, DMA0)
                    If (And (Arg0, 0x08))
                    {
                        Store (0x0384, PIO0)
                    }
                    Else
                    {
                        Store (Local7, PIO0)
                    }

                    If (And (Arg0, 0x20))
                    {
                        Or (CHNF, 0x08, CHNF)
                    }

                    If (And (Arg0, 0x4000))
                    {
                        Or (CHNF, 0x10, CHNF)
                        Store (Match (DerefOf (Index (TIM0, 0x02)), MLE, Arg1, MTR, 
                            0x00, 0x00), Local5)
                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x00)), Local5)), 
                            Local6)
                        Store (Local6, DMA1)
                        If (And (Arg0, 0x80))
                        {
                            Store (0x0384, PIO1)
                        }
                        Else
                        {
                            Store (Local6, PIO1)
                        }
                    }

                    If (And (Arg2, 0x01))
                    {
                        And (Arg3, 0x03, Local5)
                        If (LAnd (And (Arg5, 0x01), LEqual (Local5, 0x01)))
                        {
                            Add (Local5, 0x04, Local5)
                        }
                        Else
                        {
                            If (And (Arg4, 0x01))
                            {
                                Add (Local5, 0x02, Local5)
                            }
                        }

                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5)), 
                            DMA0)
                        Or (CHNF, 0x01, CHNF)
                    }

                    If (And (Arg2, 0x02))
                    {
                        And (ShiftRight (Arg3, 0x04), 0x03, Local5)
                        If (LAnd (And (Arg5, 0x02), LEqual (Local5, 0x01)))
                        {
                            Add (Local5, 0x04, Local5)
                        }
                        Else
                        {
                            If (And (Arg4, 0x02))
                            {
                                Add (Local5, 0x02, Local5)
                            }
                        }

                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5)), 
                            DMA1)
                        Or (CHNF, 0x04, CHNF)
                    }

                    Store (TMD0, Debug)
                    Return (TMD0)
                }

                Method (STM, 0, Serialized)
                {
                    If (REGF) {}
                    Else
                    {
                        Return (0x00)
                    }

                    And (GTIM, 0x8044, GTIM)
                    Store (0x00, GSTM)
                    Store (0x00, GUDM)
                    Store (0x00, GCB0)
                    And (GUDT, 0xCC, GUDT)
                    Store (0x00, GFB0)
                    If (And (CHNF, 0x01))
                    {
                        Store (Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA0, MTR, 
                            0x00, 0x00), Local0)
                        If (LGreater (Local0, 0x05))
                        {
                            Store (0x05, Local0)
                        }

                        Or (GUDT, DerefOf (Index (DerefOf (Index (TIM0, 0x04)), Local0
                            )), GUDT)
                        Or (GCB0, DerefOf (Index (DerefOf (Index (TIM0, 0x05)), Local0
                            )), GCB0)
                        Or (GFB0, DerefOf (Index (DerefOf (Index (TIM0, 0x06)), Local0
                            )), GFB0)
                        Or (GUDM, 0x01, GUDM)
                    }
                    Else
                    {
                        If (Or (LEqual (PIO0, Ones), LEqual (PIO0, 0x00)))
                        {
                            If (And (LLess (DMA0, Ones), LGreater (DMA0, 0x00)))
                            {
                                Store (DMA0, PIO0)
                                Or (GTIM, 0x08, GTIM)
                            }
                        }
                    }

                    If (And (CHNF, 0x04))
                    {
                        Store (Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA1, MTR, 
                            0x00, 0x00), Local0)
                        If (LGreater (Local0, 0x05))
                        {
                            Store (0x05, Local0)
                        }

                        Or (GUDT, ShiftLeft (DerefOf (Index (DerefOf (Index (TIM0, 0x04)), 
                            Local0)), 0x04), GUDT)
                        Or (GCB0, ShiftLeft (DerefOf (Index (DerefOf (Index (TIM0, 0x05)), 
                            Local0)), 0x01), GCB0)
                        Or (GFB0, ShiftLeft (DerefOf (Index (DerefOf (Index (TIM0, 0x06)), 
                            Local0)), 0x01), GFB0)
                        Or (GUDM, 0x02, GUDM)
                    }
                    Else
                    {
                        If (Or (LEqual (PIO1, Ones), LEqual (PIO1, 0x00)))
                        {
                            If (And (LLess (DMA1, Ones), LGreater (DMA1, 0x00)))
                            {
                                Store (DMA1, PIO1)
                                Or (GTIM, 0x80, GTIM)
                            }
                        }
                    }

                    If (And (CHNF, 0x02))
                    {
                        Or (GTIM, 0x03, GTIM)
                    }

                    If (And (CHNF, 0x08))
                    {
                        Or (GTIM, 0x30, GTIM)
                    }

                    And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIO0, MTR, 
                        0x00, 0x00), 0x03, Local0)
                    Store (DerefOf (Index (DerefOf (Index (TIM0, 0x01)), Local0)), 
                        Local1)
                    ShiftLeft (Local1, 0x08, Local2)
                    Or (GTIM, Local2, GTIM)
                    If (And (CHNF, 0x10))
                    {
                        Or (GTIM, 0x4000, GTIM)
                        And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIO1, MTR, 
                            0x00, 0x00), 0x03, Local0)
                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x02)), Local0)), 
                            GSTM)
                    }

                    Return (0x01)
                }

                Name (AT01, Buffer (0x07)
                {
                    0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0xEF
                })
                Name (AT02, Buffer (0x07)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90
                })
                Name (AT03, Buffer (0x07)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC6
                })
                Name (AT04, Buffer (0x07)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x91
                })
                Name (ATA0, Buffer (0x1D) {})
                Name (ATA1, Buffer (0x1D) {})
                Name (ATA2, Buffer (0x1D) {})
                Name (ATA3, Buffer (0x1D) {})
                Name (ATAB, Buffer (0x1D) {})
                CreateByteField (ATAB, 0x00, CMDC)
                Method (GTFB, 3, Serialized)
                {
                    Multiply (CMDC, 0x38, Local0)
                    Add (Local0, 0x08, Local1)
                    CreateField (ATAB, Local1, 0x38, CMDX)
                    Multiply (CMDC, 0x07, Local0)
                    CreateByteField (ATAB, Add (Local0, 0x02), A001)
                    CreateByteField (ATAB, Add (Local0, 0x06), A005)
                    Store (Arg0, CMDX)
                    Store (Arg1, A001)
                    Store (Arg2, A005)
                    Increment (CMDC)
                }

                Method (GTF, 2, Serialized)
                {
                    Store (Arg1, Debug)
                    Store (0x00, CMDC)
                    Name (ID49, 0x0C00)
                    Name (ID59, 0x00)
                    Name (ID53, 0x04)
                    Name (ID63, 0x0F00)
                    Name (ID88, 0x0F00)
                    Name (IRDY, 0x01)
                    Name (PIOT, 0x00)
                    Name (DMAT, 0x00)
                    If (LEqual (SizeOf (Arg1), 0x0200))
                    {
                        CreateWordField (Arg1, 0x62, IW49)
                        Store (IW49, ID49)
                        CreateWordField (Arg1, 0x6A, IW53)
                        Store (IW53, ID53)
                        CreateWordField (Arg1, 0x7E, IW63)
                        Store (IW63, ID63)
                        CreateWordField (Arg1, 0x76, IW59)
                        Store (IW59, ID59)
                        CreateWordField (Arg1, 0xB0, IW88)
                        Store (IW88, ID88)
                    }

                    Store (0xA0, Local7)
                    If (Arg0)
                    {
                        Store (0xB0, Local7)
                        And (CHNF, 0x08, IRDY)
                        If (And (CHNF, 0x10))
                        {
                            Store (PIO1, PIOT)
                        }
                        Else
                        {
                            Store (PIO0, PIOT)
                        }

                        If (And (CHNF, 0x04))
                        {
                            If (And (CHNF, 0x10))
                            {
                                Store (DMA1, DMAT)
                            }
                            Else
                            {
                                Store (DMA0, DMAT)
                            }
                        }
                    }
                    Else
                    {
                        And (CHNF, 0x02, IRDY)
                        Store (PIO0, PIOT)
                        If (And (CHNF, 0x01))
                        {
                            Store (DMA0, DMAT)
                        }
                    }

                    If (LAnd (LAnd (And (ID53, 0x04), And (ID88, 0xFF00
                        )), DMAT))
                    {
                        Store (Match (DerefOf (Index (TIM0, 0x03)), MLE, DMAT, MTR, 
                            0x00, 0x00), Local1)
                        If (LGreater (Local1, 0x05))
                        {
                            Store (0x05, Local1)
                        }

                        GTFB (AT01, Or (0x40, Local1), Local7)
                    }
                    Else
                    {
                        If (LAnd (And (ID63, 0xFF00), PIOT))
                        {
                            And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIOT, MTR, 
                                0x00, 0x00), 0x03, Local0)
                            Or (0x20, DerefOf (Index (DerefOf (Index (TIM0, 0x08)), Local0
                                )), Local1)
                            GTFB (AT01, Local1, Local7)
                        }
                    }

                    If (IRDY)
                    {
                        And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIOT, MTR, 
                            0x00, 0x00), 0x03, Local0)
                        Or (0x08, DerefOf (Index (DerefOf (Index (TIM0, 0x07)), Local0
                            )), Local1)
                        GTFB (AT01, Local1, Local7)
                    }
                    Else
                    {
                        If (And (ID49, 0x0400))
                        {
                            GTFB (AT01, 0x01, Local7)
                        }
                    }

                    If (LAnd (And (ID59, 0x0100), And (ID59, 0xFF)))
                    {
                        GTFB (AT03, And (ID59, 0xFF), Local7)
                    }

                    Store (ATAB, Debug)
                    Return (ATAB)
                }

                Method (RATA, 1, NotSerialized)
                {
                    CreateByteField (Arg0, 0x00, CMDN)
                    Multiply (CMDN, 0x38, Local0)
                    CreateField (Arg0, 0x08, Local0, RETB)
                    Store (RETB, Debug)
                    Return (RETB)
                }
            }

            Device (USB0)
            {
                Name (_ADR, 0x001D0000)
                OperationRegion (BAR0, PCI_Config, 0xC0, 0x05)
                Field (BAR0, ByteAcc, NoLock, Preserve)
                {
                    UBL1,   16, 
                            Offset (0x04), 
                    P0WE,   1, 
                    P1WE,   1, 
                            Offset (0x05)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    If (LOr (LEqual (OSFL (), 0x01), LEqual (OSFL (), 0x02)))
                    {
                        Return (0x02)
                    }
                    Else
                    {
                        Return (0x03)
                    }
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, P0WE)
                        Store (0x01, P1WE)
                    }
                    Else
                    {
                        Store (0x00, P0WE)
                        Store (0x00, P1WE)
                    }
                }

                Method (UPAC, 1, NotSerialized)
                {
                    Store (Zero, Local0)
                    If (LEqual (OSFG, OS9X))
                    {
                        Store (One, Local0)
                    }
                    Else
                    {
                        If (LEqual (OSFG, OS98))
                        {
                            Store (One, Local0)
                        }
                    }

                    If (Local0)
                    {
                        If (LEqual (Arg0, 0x03))
                        {
                            Return (One)
                        }
                    }

                    Return (Zero)
                }

                OperationRegion (UPCI, PCI_Config, 0x20, 0x04)
                Field (UPCI, ByteAcc, NoLock, Preserve)
                {
                    UBAS,   32
                }

                Name (BASA, 0xB400)
                Name (P0ST, Zero)
                Name (P1ST, Zero)
                Method (SSTA, 0, NotSerialized)
                {
                    Store (UBAS, BASA)
                    And (BASA, 0xFFFFFFFE, BASA)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }

                    Store (CCS0, P0ST)
                    Store (CCS1, P1ST)
                }

                Method (RSTA, 0, NotSerialized)
                {
                    Store (BASA, UBAS)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }
                }

                Method (USBS, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        SSTA ()
                    }
                }

                Method (USBW, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        RSTA ()
                    }
                }

                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x03, 0x03))
                }
            }

            Device (USB1)
            {
                Name (_ADR, 0x001D0001)
                OperationRegion (BAR0, PCI_Config, 0xC0, 0x05)
                Field (BAR0, ByteAcc, NoLock, Preserve)
                {
                    UBL1,   16, 
                            Offset (0x04), 
                    P0WE,   1, 
                    P1WE,   1, 
                            Offset (0x05)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    If (LOr (LEqual (OSFL (), 0x01), LEqual (OSFL (), 0x02)))
                    {
                        Return (0x02)
                    }
                    Else
                    {
                        Return (0x03)
                    }
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, P0WE)
                        Store (0x01, P1WE)
                    }
                    Else
                    {
                        Store (0x00, P0WE)
                        Store (0x00, P1WE)
                    }
                }

                Method (UPAC, 1, NotSerialized)
                {
                    Store (Zero, Local0)
                    If (LEqual (OSFG, OS9X))
                    {
                        Store (One, Local0)
                    }
                    Else
                    {
                        If (LEqual (OSFG, OS98))
                        {
                            Store (One, Local0)
                        }
                    }

                    If (Local0)
                    {
                        If (LEqual (Arg0, 0x03))
                        {
                            Return (One)
                        }
                    }

                    Return (Zero)
                }

                OperationRegion (UPCI, PCI_Config, 0x20, 0x04)
                Field (UPCI, ByteAcc, NoLock, Preserve)
                {
                    UBAS,   32
                }

                Name (BASA, 0xB400)
                Name (P0ST, Zero)
                Name (P1ST, Zero)
                Method (SSTA, 0, NotSerialized)
                {
                    Store (UBAS, BASA)
                    And (BASA, 0xFFFFFFFE, BASA)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }

                    Store (CCS0, P0ST)
                    Store (CCS1, P1ST)
                }

                Method (RSTA, 0, NotSerialized)
                {
                    Store (BASA, UBAS)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }
                }

                Method (USBS, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        SSTA ()
                    }
                }

                Method (USBW, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        RSTA ()
                    }
                }

                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x04, 0x03))
                }
            }

            Device (USB2)
            {
                Name (_ADR, 0x001D0002)
                OperationRegion (BAR0, PCI_Config, 0xC0, 0x05)
                Field (BAR0, ByteAcc, NoLock, Preserve)
                {
                    UBL1,   16, 
                            Offset (0x04), 
                    P0WE,   1, 
                    P1WE,   1, 
                            Offset (0x05)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    If (LOr (LEqual (OSFL (), 0x01), LEqual (OSFL (), 0x02)))
                    {
                        Return (0x02)
                    }
                    Else
                    {
                        Return (0x03)
                    }
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, P0WE)
                        Store (0x01, P1WE)
                    }
                    Else
                    {
                        Store (0x00, P0WE)
                        Store (0x00, P1WE)
                    }
                }

                Method (UPAC, 1, NotSerialized)
                {
                    Store (Zero, Local0)
                    If (LEqual (OSFG, OS9X))
                    {
                        Store (One, Local0)
                    }
                    Else
                    {
                        If (LEqual (OSFG, OS98))
                        {
                            Store (One, Local0)
                        }
                    }

                    If (Local0)
                    {
                        If (LEqual (Arg0, 0x03))
                        {
                            Return (One)
                        }
                    }

                    Return (Zero)
                }

                OperationRegion (UPCI, PCI_Config, 0x20, 0x04)
                Field (UPCI, ByteAcc, NoLock, Preserve)
                {
                    UBAS,   32
                }

                Name (BASA, 0xB400)
                Name (P0ST, Zero)
                Name (P1ST, Zero)
                Method (SSTA, 0, NotSerialized)
                {
                    Store (UBAS, BASA)
                    And (BASA, 0xFFFFFFFE, BASA)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }

                    Store (CCS0, P0ST)
                    Store (CCS1, P1ST)
                }

                Method (RSTA, 0, NotSerialized)
                {
                    Store (BASA, UBAS)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }
                }

                Method (USBS, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        SSTA ()
                    }
                }

                Method (USBW, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        RSTA ()
                    }
                }

                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x0C, 0x03))
                }
            }

            Device (USB3)
            {
                Name (_ADR, 0x001D0003)
                OperationRegion (BAR0, PCI_Config, 0xC0, 0x05)
                Field (BAR0, ByteAcc, NoLock, Preserve)
                {
                    UBL1,   16, 
                            Offset (0x04), 
                    P0WE,   1, 
                    P1WE,   1, 
                            Offset (0x05)
                }

                Method (_S3D, 0, NotSerialized)
                {
                    If (LOr (LEqual (OSFL (), 0x01), LEqual (OSFL (), 0x02)))
                    {
                        Return (0x02)
                    }
                    Else
                    {
                        Return (0x03)
                    }
                }

                Method (_PSW, 1, NotSerialized)
                {
                    If (Arg0)
                    {
                        Store (0x01, P0WE)
                        Store (0x01, P1WE)
                    }
                    Else
                    {
                        Store (0x00, P0WE)
                        Store (0x00, P1WE)
                    }
                }

                Method (UPAC, 1, NotSerialized)
                {
                    Store (Zero, Local0)
                    If (LEqual (OSFG, OS9X))
                    {
                        Store (One, Local0)
                    }
                    Else
                    {
                        If (LEqual (OSFG, OS98))
                        {
                            Store (One, Local0)
                        }
                    }

                    If (Local0)
                    {
                        If (LEqual (Arg0, 0x03))
                        {
                            Return (One)
                        }
                    }

                    Return (Zero)
                }

                OperationRegion (UPCI, PCI_Config, 0x20, 0x04)
                Field (UPCI, ByteAcc, NoLock, Preserve)
                {
                    UBAS,   32
                }

                Name (BASA, 0xB400)
                Name (P0ST, Zero)
                Name (P1ST, Zero)
                Method (SSTA, 0, NotSerialized)
                {
                    Store (UBAS, BASA)
                    And (BASA, 0xFFFFFFFE, BASA)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }

                    Store (CCS0, P0ST)
                    Store (CCS1, P1ST)
                }

                Method (RSTA, 0, NotSerialized)
                {
                    Store (BASA, UBAS)
                    OperationRegion (UHCI, SystemIO, BASA, 0x20)
                    Field (UHCI, ByteAcc, NoLock, Preserve)
                    {
                        RSTP,   1, 
                        HRST,   1, 
                        GRST,   1, 
                                Offset (0x10), 
                        CCS0,   1, 
                        CSC0,   1, 
                        PED0,   1, 
                                Offset (0x12), 
                        CCS1,   1, 
                        CSC1,   1, 
                        PED1,   1
                    }
                }

                Method (USBS, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        SSTA ()
                    }
                }

                Method (USBW, 1, NotSerialized)
                {
                    If (UPAC (Arg0))
                    {
                        RSTA ()
                    }
                }

                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x0E, 0x03))
                }
            }

            Device (EUSB)
            {
                Name (_ADR, 0x001D0007)
                OperationRegion (U20P, PCI_Config, 0x00, 0x0100)
                Field (U20P, ByteAcc, NoLock, Preserve)
                {
                            Offset (0x04), 
                        ,   1, 
                    MSPE,   1, 
                            Offset (0x06), 
                            Offset (0x10), 
                    MBAS,   32, 
                            Offset (0x54), 
                    PSTA,   2, 
                            Offset (0x55), 
                    PMEE,   1, 
                        ,   6, 
                    PMES,   1
                }

                Method (_PSW, 1, NotSerialized)
                {
                    Store (MBAS, Local0)
                    And (Local0, 0xFFFFFFF0, Local0)
                    OperationRegion (MMIO, SystemMemory, Local0, 0x0100)
                    Field (MMIO, ByteAcc, NoLock, Preserve)
                    {
                                Offset (0x64), 
                        P0SC,   32, 
                        P1SC,   32, 
                        P2SC,   32, 
                        P3SC,   32, 
                        P4SC,   32, 
                        P5SC,   32
                    }

                    If (LNot (Local0))
                    {
                        Store (PSTA, Local2)
                        Store (Zero, PSTA)
                        Store (MSPE, Local3)
                        Store (One, MSPE)
                        If (Arg0)
                        {
                            Store (P0SC, Local4)
                            Or (Local4, 0x00300000, Local4)
                            Store (Local4, P0SC)
                            Store (P1SC, Local4)
                            Or (Local4, 0x00300000, Local4)
                            Store (Local4, P1SC)
                            Store (P2SC, Local4)
                            Or (Local4, 0x00300000, Local4)
                            Store (Local4, P2SC)
                            Store (P3SC, Local4)
                            Or (Local4, 0x00300000, Local4)
                            Store (Local4, P3SC)
                            Store (P4SC, Local4)
                            Or (Local4, 0x00300000, Local4)
                            Store (Local4, P4SC)
                            Store (P5SC, Local4)
                            Or (Local4, 0x00300000, Local4)
                            Store (Local4, P5SC)
                            Store (One, PMES)
                            Store (One, PMEE)
                        }
                        Else
                        {
                            Store (P0SC, Local4)
                            And (Local4, 0xFFCFFFFF, Local4)
                            Store (Local4, P0SC)
                            Store (P1SC, Local4)
                            And (Local4, 0xFFCFFFFF, Local4)
                            Store (Local4, P1SC)
                            Store (P2SC, Local4)
                            And (Local4, 0xFFCFFFFF, Local4)
                            Store (Local4, P2SC)
                            Store (P3SC, Local4)
                            And (Local4, 0xFFCFFFFF, Local4)
                            Store (Local4, P3SC)
                            Store (P4SC, Local4)
                            And (Local4, 0xFFCFFFFF, Local4)
                            Store (Local4, P4SC)
                            Store (P5SC, Local4)
                            And (Local4, 0xFFCFFFFF, Local4)
                            Store (Local4, P5SC)
                            Store (One, PMES)
                            Store (Zero, PMEE)
                        }

                        Store (Local3, MSPE)
                        Store (Local2, PSTA)
                    }
                }

                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x0D, 0x03))
                }
            }

            Device (MC97)
            {
                Name (_ADR, 0x001E0003)
                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x05, 0x04))
                }
            }

            Device (HDAC)
            {
                Name (_ADR, 0x001B0000)
                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x05, 0x04))
                }
            }

            Device (P0P1)
            {
                Name (_ADR, 0x00010000)
                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR01)
                    }

                    Return (PR01)
                }

                Device (VGA)
                {
                    Name (_ADR, 0x00)
                    OperationRegion (VSID, PCI_Config, 0x00, 0x04)
                    Field (VSID, ByteAcc, NoLock, Preserve)
                    {
                        REG0,   32
                    }

                    Method (PRST, 0, NotSerialized)
                    {
                        If (LEqual (REG0, 0xFFFFFFFF))
                        {
                            Return (Zero)
                        }
                        Else
                        {
                            Return (One)
                        }
                    }

                    Name (UPDN, One)
                    Name (NXTD, 0x01)
                    Name (LCDM, 0x01)
                    Name (CRTM, 0x02)
                    Name (TVOM, 0x04)
                    Name (DVIM, 0x08)
                    Name (DONE, Zero)
                    Name (DOSF, One)
                    Method (_INI, 0, NotSerialized)
                    {
                        GETD ()
                    }

                    Method (_DOS, 1, NotSerialized)
                    {
                        Store (Arg0, DOSF)
                    }

                    Method (_DOD, 0, NotSerialized)
                    {
                        Return (Package (0x04)
                        {
                            0x00010100, 
                            0x00010110, 
                            0x0200, 
                            0x0120
                        })
                    }

                    Device (CRTD)
                    {
                        Name (_ADR, 0x0100)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store (\AVLD, Local0)
                            If (Local0)
                            {
                                If (And (Local0, CRTM))
                                {
                                    Return (0x1F)
                                }
                            }

                            Return (0x1D)
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            And (NXTD, CRTM, Local0)
                            If (Local0)
                            {
                                Return (0x01)
                            }

                            Return (0x00)
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            If (And (Arg0, 0x40000000))
                            {
                                If (And (Arg0, 0x80000000))
                                {
                                    Store (One, DONE)
                                }
                            }
                        }
                    }

                    Device (TVOD)
                    {
                        Name (_ADR, 0x0200)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store (\AVLD, Local0)
                            If (Local0)
                            {
                                If (And (Local0, TVOM))
                                {
                                    Return (0x1F)
                                }
                            }

                            Return (0x1D)
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            And (NXTD, TVOM, Local0)
                            If (Local0)
                            {
                                Return (0x01)
                            }

                            Return (0x00)
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            If (And (Arg0, 0x40000000))
                            {
                                If (And (Arg0, 0x80000000))
                                {
                                    Store (One, DONE)
                                }
                            }
                        }
                    }

                    Device (DVID)
                    {
                        Name (_ADR, 0x0120)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store (\AVLD, Local0)
                            If (Local0)
                            {
                                If (And (Local0, DVIM))
                                {
                                    Return (0x1F)
                                }
                            }

                            Return (0x1D)
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            And (NXTD, DVIM, Local0)
                            If (Local0)
                            {
                                Return (0x01)
                            }

                            Return (0x00)
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            If (And (Arg0, 0x40000000))
                            {
                                If (And (Arg0, 0x80000000))
                                {
                                    Store (One, DONE)
                                }
                            }
                        }
                    }

                    Device (LCDD)
                    {
                        Name (_ADR, 0x0110)
                        Method (_DCS, 0, NotSerialized)
                        {
                            Store (\AVLD, Local0)
                            If (Local0)
                            {
                                If (And (Local0, LCDM))
                                {
                                    Return (0x1F)
                                }
                            }

                            Return (0x1D)
                        }

                        Method (_DGS, 0, NotSerialized)
                        {
                            And (NXTD, LCDM, Local0)
                            If (Local0)
                            {
                                Return (0x01)
                            }

                            Return (0x00)
                        }

                        Method (_DSS, 1, NotSerialized)
                        {
                            If (And (Arg0, 0x40000000))
                            {
                                If (And (Arg0, 0x80000000))
                                {
                                    Store (One, DONE)
                                }
                            }
                        }

                        Method (_BCL, 0, NotSerialized)
                        {
                            Return (Package (0x10)
                            {
                                0x0F, 
                                0x0E, 
                                0x0D, 
                                0x0C, 
                                0x0B, 
                                0x0A, 
                                0x09, 
                                0x08, 
                                0x07, 
                                0x06, 
                                0x05, 
                                0x04, 
                                0x03, 
                                0x02, 
                                0x01, 
                                0x00
                            })
                        }

                        Name (BCBH, 0x00)
                        Method (_BCM, 1, NotSerialized)
                        {
                            Store (Arg0, LBTN)
                            \_SB.PCI0.SBRG.EC0.STBR ()
                            If (\_SB.ATKP)
                            {
                                If (LEqual (BCBH, 0x01))
                                {
                                    Notify (\_SB.ATKD, Add (LBTN, 0x10))
                                }

                                If (LEqual (BCBH, 0x02))
                                {
                                    Notify (\_SB.ATKD, Add (LBTN, 0x20))
                                }
                            }

                            Store (0x00, BCBH)
                        }

                        Method (_BQC, 0, NotSerialized)
                        {
                            Return (LBTN)
                        }
                    }

                    Method (SWHD, 1, Serialized)
                    {
                        Store (One, UPDN)
                        If (And (DOSF, 0x03))
                        {
                            Store (Arg0, \SETD)
                            ISMI (0x94)
                        }
                        Else
                        {
                            Store (Zero, DONE)
                            Notify (VGA, 0x80)
                            Store (0x01F4, Local0)
                            While (Local0)
                            {
                                If (DONE)
                                {
                                    Store (Zero, Local0)
                                }
                                Else
                                {
                                    Sleep (0x0A)
                                    Decrement (Local0)
                                }
                            }
                        }
                    }

                    Method (GETD, 0, NotSerialized)
                    {
                        ISMI (0x95)
                        Return (\ACTD)
                    }

                    Method (ADVD, 0, NotSerialized)
                    {
                        If (UPDN)
                        {
                            GETD ()
                            Store (\ACTD, \SETD)
                            Store (Zero, UPDN)
                        }

                        ISMI (0xA0)
                        Store (\SETD, NXTD)
                        Return (\SETD)
                        Return (NXTD)
                    }

                    Method (NATK, 0, NotSerialized)
                    {
                        Return (One)
                    }
                }
            }

            Device (P0P6)
            {
                Name (_ADR, 0x001E0000)
                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x0B, 0x04))
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR06)
                    }

                    Return (PR06)
                }

                Device (P394)
                {
                    Name (_ADR, 0x00010000)
                    Method (_PRW, 0, NotSerialized)
                    {
                        Return (GPRW (0x0B, 0x03))
                    }
                }
            }

            Device (IDE1)
            {
                Name (_ADR, 0x001F0001)
                Name (REGF, 0x01)
                Method (_REG, 2, NotSerialized)
                {
                    If (LEqual (Arg0, 0x02))
                    {
                        Store (Arg1, REGF)
                    }
                }

                OperationRegion (BAR0, PCI_Config, 0x00, 0x0100)
                Field (BAR0, DWordAcc, NoLock, Preserve)
                {
                    VDID,   32, 
                            Offset (0x0A), 
                    SCCR,   8, 
                    BCCR,   8, 
                            Offset (0x40), 
                    TIMP,   16, 
                    TIMS,   16, 
                    STMP,   4, 
                    STMS,   4, 
                            Offset (0x48), 
                    UDMP,   2, 
                    UDMS,   2, 
                            Offset (0x4A), 
                    UDTP,   6, 
                            Offset (0x4B), 
                    UDTS,   6, 
                            Offset (0x54), 
                    PCB0,   2, 
                    SCB0,   2, 
                    PCA0,   2, 
                    SCA0,   2, 
                        ,   4, 
                    FPB0,   2, 
                    FSB0,   2, 
                    PSIG,   2, 
                    SSIG,   2, 
                            Offset (0x90), 
                    MAPV,   2, 
                        ,   5, 
                    SCCF,   1, 
                            Offset (0x92), 
                    P0EN,   1, 
                        ,   1, 
                    P2EN,   1, 
                        ,   1, 
                    P0PF,   1, 
                        ,   1, 
                    P2PF,   1, 
                            Offset (0x93)
                }

                Name (TIM0, Package (0x09)
                {
                    Package (0x04)
                    {
                        0x78, 
                        0xB4, 
                        0xF0, 
                        0x0384
                    }, 

                    Package (0x04)
                    {
                        0x23, 
                        0x21, 
                        0x10, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0x0B, 
                        0x09, 
                        0x04, 
                        0x00
                    }, 

                    Package (0x06)
                    {
                        0x70, 
                        0x49, 
                        0x36, 
                        0x27, 
                        0x19, 
                        0x0F
                    }, 

                    Package (0x06)
                    {
                        0x00, 
                        0x01, 
                        0x02, 
                        0x01, 
                        0x02, 
                        0x01
                    }, 

                    Package (0x06)
                    {
                        0x00, 
                        0x00, 
                        0x00, 
                        0x01, 
                        0x01, 
                        0x01
                    }, 

                    Package (0x06)
                    {
                        0x00, 
                        0x00, 
                        0x00, 
                        0x00, 
                        0x00, 
                        0x01
                    }, 

                    Package (0x04)
                    {
                        0x04, 
                        0x03, 
                        0x02, 
                        0x00
                    }, 

                    Package (0x04)
                    {
                        0x02, 
                        0x01, 
                        0x00, 
                        0x00
                    }
                })
                Name (TMD0, Buffer (0x14) {})
                CreateDWordField (TMD0, 0x00, PIO0)
                CreateDWordField (TMD0, 0x04, DMA0)
                CreateDWordField (TMD0, 0x08, PIO1)
                CreateDWordField (TMD0, 0x0C, DMA1)
                CreateDWordField (TMD0, 0x10, CHNF)
                Name (GTIM, 0x00)
                Name (GSTM, 0x00)
                Name (GUDM, 0x00)
                Name (GUDT, 0x00)
                Name (GCB0, 0x00)
                Name (GFB0, 0x00)
                Device (CHN0)
                {
                    Name (_ADR, 0x00)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (TIMP, STMP, UDMP, UDTP, PCB0, FPB0))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, Debug)
                        Store (Arg0, TMD0)
                        Store (TIMP, GTIM)
                        Store (UDTP, GUDT)
                        If (STM ())
                        {
                            Store (GTIM, TIMP)
                            Store (GSTM, STMP)
                            Store (GUDM, UDMP)
                            Store (GUDT, UDTP)
                            Store (GCB0, PCB0)
                            Store (GFB0, FPB0)
                        }

                        Store (GTF (0x00, Arg1), ATA0)
                        Store (GTF (0x01, Arg2), ATA1)
                    }

                    Device (DRV0)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA0))
                        }
                    }

                    Device (DRV1)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA1))
                        }
                    }
                }

                Device (CHN1)
                {
                    Name (_ADR, 0x01)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (TIMS, STMS, UDMS, UDTS, SCB0, FSB0))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, Debug)
                        Store (Arg0, TMD0)
                        Store (TIMS, GTIM)
                        Store (UDTS, GUDT)
                        If (STM ())
                        {
                            Store (GTIM, TIMS)
                            Store (GSTM, STMS)
                            Store (GUDM, UDMS)
                            Store (GUDT, UDTS)
                            Store (GCB0, SCB0)
                            Store (GFB0, FSB0)
                        }

                        Store (GTF (0x00, Arg1), ATA2)
                        Store (GTF (0x01, Arg2), ATA3)
                    }

                    Device (DRV0)
                    {
                        Name (_ADR, 0x00)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA2))
                        }
                    }

                    Device (DRV1)
                    {
                        Name (_ADR, 0x01)
                        Method (_GTF, 0, NotSerialized)
                        {
                            Return (RATA (ATA3))
                        }
                    }
                }

                Method (GTM, 6, Serialized)
                {
                    Store (Ones, PIO0)
                    Store (PIO0, PIO1)
                    Store (PIO0, DMA0)
                    Store (PIO0, DMA1)
                    Store (Zero, CHNF)
                    If (REGF) {}
                    Else
                    {
                        Return (TMD0)
                    }

                    If (And (Arg0, 0x02))
                    {
                        Or (CHNF, 0x02, CHNF)
                    }

                    ShiftRight (And (Arg0, 0x3300), 0x08, Local5)
                    Store (Match (DerefOf (Index (TIM0, 0x01)), MLE, Local5, MTR, 
                        0x00, 0x00), Local6)
                    Store (DerefOf (Index (DerefOf (Index (TIM0, 0x00)), Local6)), 
                        Local7)
                    Store (Local7, DMA0)
                    If (And (Arg0, 0x08))
                    {
                        Store (0x0384, PIO0)
                    }
                    Else
                    {
                        Store (Local7, PIO0)
                    }

                    If (And (Arg0, 0x20))
                    {
                        Or (CHNF, 0x08, CHNF)
                    }

                    If (And (Arg0, 0x4000))
                    {
                        Or (CHNF, 0x10, CHNF)
                        Store (Match (DerefOf (Index (TIM0, 0x02)), MLE, Arg1, MTR, 
                            0x00, 0x00), Local5)
                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x00)), Local5)), 
                            Local6)
                        Store (Local6, DMA1)
                        If (And (Arg0, 0x80))
                        {
                            Store (0x0384, PIO1)
                        }
                        Else
                        {
                            Store (Local6, PIO1)
                        }
                    }

                    If (And (Arg2, 0x01))
                    {
                        And (Arg3, 0x03, Local5)
                        If (LAnd (And (Arg5, 0x01), LEqual (Local5, 0x01)))
                        {
                            Add (Local5, 0x04, Local5)
                        }
                        Else
                        {
                            If (And (Arg4, 0x01))
                            {
                                Add (Local5, 0x02, Local5)
                            }
                        }

                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5)), 
                            DMA0)
                        Or (CHNF, 0x01, CHNF)
                    }

                    If (And (Arg2, 0x02))
                    {
                        And (ShiftRight (Arg3, 0x04), 0x03, Local5)
                        If (LAnd (And (Arg5, 0x02), LEqual (Local5, 0x01)))
                        {
                            Add (Local5, 0x04, Local5)
                        }
                        Else
                        {
                            If (And (Arg4, 0x02))
                            {
                                Add (Local5, 0x02, Local5)
                            }
                        }

                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x03)), Local5)), 
                            DMA1)
                        Or (CHNF, 0x04, CHNF)
                    }

                    Store (TMD0, Debug)
                    Return (TMD0)
                }

                Method (STM, 0, Serialized)
                {
                    If (REGF) {}
                    Else
                    {
                        Return (0x00)
                    }

                    And (GTIM, 0x8044, GTIM)
                    Store (0x00, GSTM)
                    Store (0x00, GUDM)
                    Store (0x00, GCB0)
                    And (GUDT, 0xCC, GUDT)
                    Store (0x00, GFB0)
                    If (And (CHNF, 0x01))
                    {
                        Store (Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA0, MTR, 
                            0x00, 0x00), Local0)
                        If (LGreater (Local0, 0x05))
                        {
                            Store (0x05, Local0)
                        }

                        Or (GUDT, DerefOf (Index (DerefOf (Index (TIM0, 0x04)), Local0
                            )), GUDT)
                        Or (GCB0, DerefOf (Index (DerefOf (Index (TIM0, 0x05)), Local0
                            )), GCB0)
                        Or (GFB0, DerefOf (Index (DerefOf (Index (TIM0, 0x06)), Local0
                            )), GFB0)
                        Or (GUDM, 0x01, GUDM)
                    }
                    Else
                    {
                        If (Or (LEqual (PIO0, Ones), LEqual (PIO0, 0x00)))
                        {
                            If (And (LLess (DMA0, Ones), LGreater (DMA0, 0x00)))
                            {
                                Store (DMA0, PIO0)
                                Or (GTIM, 0x08, GTIM)
                            }
                        }
                    }

                    If (And (CHNF, 0x04))
                    {
                        Store (Match (DerefOf (Index (TIM0, 0x03)), MLE, DMA1, MTR, 
                            0x00, 0x00), Local0)
                        If (LGreater (Local0, 0x05))
                        {
                            Store (0x05, Local0)
                        }

                        Or (GUDT, ShiftLeft (DerefOf (Index (DerefOf (Index (TIM0, 0x04)), 
                            Local0)), 0x04), GUDT)
                        Or (GCB0, ShiftLeft (DerefOf (Index (DerefOf (Index (TIM0, 0x05)), 
                            Local0)), 0x01), GCB0)
                        Or (GFB0, ShiftLeft (DerefOf (Index (DerefOf (Index (TIM0, 0x06)), 
                            Local0)), 0x01), GFB0)
                        Or (GUDM, 0x02, GUDM)
                    }
                    Else
                    {
                        If (Or (LEqual (PIO1, Ones), LEqual (PIO1, 0x00)))
                        {
                            If (And (LLess (DMA1, Ones), LGreater (DMA1, 0x00)))
                            {
                                Store (DMA1, PIO1)
                                Or (GTIM, 0x80, GTIM)
                            }
                        }
                    }

                    If (And (CHNF, 0x02))
                    {
                        Or (GTIM, 0x03, GTIM)
                    }

                    If (And (CHNF, 0x08))
                    {
                        Or (GTIM, 0x30, GTIM)
                    }

                    And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIO0, MTR, 
                        0x00, 0x00), 0x03, Local0)
                    Store (DerefOf (Index (DerefOf (Index (TIM0, 0x01)), Local0)), 
                        Local1)
                    ShiftLeft (Local1, 0x08, Local2)
                    Or (GTIM, Local2, GTIM)
                    If (And (CHNF, 0x10))
                    {
                        Or (GTIM, 0x4000, GTIM)
                        And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIO1, MTR, 
                            0x00, 0x00), 0x03, Local0)
                        Store (DerefOf (Index (DerefOf (Index (TIM0, 0x02)), Local0)), 
                            GSTM)
                    }

                    Return (0x01)
                }

                Name (AT01, Buffer (0x07)
                {
                    0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0xEF
                })
                Name (AT02, Buffer (0x07)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90
                })
                Name (AT03, Buffer (0x07)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC6
                })
                Name (AT04, Buffer (0x07)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x91
                })
                Name (ATA0, Buffer (0x1D) {})
                Name (ATA1, Buffer (0x1D) {})
                Name (ATA2, Buffer (0x1D) {})
                Name (ATA3, Buffer (0x1D) {})
                Name (ATAB, Buffer (0x1D) {})
                CreateByteField (ATAB, 0x00, CMDC)
                Method (GTFB, 3, Serialized)
                {
                    Multiply (CMDC, 0x38, Local0)
                    Add (Local0, 0x08, Local1)
                    CreateField (ATAB, Local1, 0x38, CMDX)
                    Multiply (CMDC, 0x07, Local0)
                    CreateByteField (ATAB, Add (Local0, 0x02), A001)
                    CreateByteField (ATAB, Add (Local0, 0x06), A005)
                    Store (Arg0, CMDX)
                    Store (Arg1, A001)
                    Store (Arg2, A005)
                    Increment (CMDC)
                }

                Method (GTF, 2, Serialized)
                {
                    Store (Arg1, Debug)
                    Store (0x00, CMDC)
                    Name (ID49, 0x0C00)
                    Name (ID59, 0x00)
                    Name (ID53, 0x04)
                    Name (ID63, 0x0F00)
                    Name (ID88, 0x0F00)
                    Name (IRDY, 0x01)
                    Name (PIOT, 0x00)
                    Name (DMAT, 0x00)
                    If (LEqual (SizeOf (Arg1), 0x0200))
                    {
                        CreateWordField (Arg1, 0x62, IW49)
                        Store (IW49, ID49)
                        CreateWordField (Arg1, 0x6A, IW53)
                        Store (IW53, ID53)
                        CreateWordField (Arg1, 0x7E, IW63)
                        Store (IW63, ID63)
                        CreateWordField (Arg1, 0x76, IW59)
                        Store (IW59, ID59)
                        CreateWordField (Arg1, 0xB0, IW88)
                        Store (IW88, ID88)
                    }

                    Store (0xA0, Local7)
                    If (Arg0)
                    {
                        Store (0xB0, Local7)
                        And (CHNF, 0x08, IRDY)
                        If (And (CHNF, 0x10))
                        {
                            Store (PIO1, PIOT)
                        }
                        Else
                        {
                            Store (PIO0, PIOT)
                        }

                        If (And (CHNF, 0x04))
                        {
                            If (And (CHNF, 0x10))
                            {
                                Store (DMA1, DMAT)
                            }
                            Else
                            {
                                Store (DMA0, DMAT)
                            }
                        }
                    }
                    Else
                    {
                        And (CHNF, 0x02, IRDY)
                        Store (PIO0, PIOT)
                        If (And (CHNF, 0x01))
                        {
                            Store (DMA0, DMAT)
                        }
                    }

                    If (LAnd (LAnd (And (ID53, 0x04), And (ID88, 0xFF00
                        )), DMAT))
                    {
                        Store (Match (DerefOf (Index (TIM0, 0x03)), MLE, DMAT, MTR, 
                            0x00, 0x00), Local1)
                        If (LGreater (Local1, 0x05))
                        {
                            Store (0x05, Local1)
                        }

                        GTFB (AT01, Or (0x40, Local1), Local7)
                    }
                    Else
                    {
                        If (LAnd (And (ID63, 0xFF00), PIOT))
                        {
                            And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIOT, MTR, 
                                0x00, 0x00), 0x03, Local0)
                            Or (0x20, DerefOf (Index (DerefOf (Index (TIM0, 0x08)), Local0
                                )), Local1)
                            GTFB (AT01, Local1, Local7)
                        }
                    }

                    If (IRDY)
                    {
                        And (Match (DerefOf (Index (TIM0, 0x00)), MGE, PIOT, MTR, 
                            0x00, 0x00), 0x03, Local0)
                        Or (0x08, DerefOf (Index (DerefOf (Index (TIM0, 0x07)), Local0
                            )), Local1)
                        GTFB (AT01, Local1, Local7)
                    }
                    Else
                    {
                        If (And (ID49, 0x0400))
                        {
                            GTFB (AT01, 0x01, Local7)
                        }
                    }

                    If (LAnd (And (ID59, 0x0100), And (ID59, 0xFF)))
                    {
                        GTFB (AT03, And (ID59, 0xFF), Local7)
                    }

                    Store (ATAB, Debug)
                    Return (ATAB)
                }

                Method (RATA, 1, NotSerialized)
                {
                    CreateByteField (Arg0, 0x00, CMDN)
                    Multiply (CMDN, 0x38, Local0)
                    CreateField (Arg0, 0x08, Local0, RETB)
                    Store (RETB, Debug)
                    Return (RETB)
                }
            }

            Device (P0P2)
            {
                Name (_ADR, 0x001C0000)
                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR02)
                    }

                    Return (PR02)
                }
            }

            Device (P0P3)
            {
                Name (_ADR, 0x001C0001)
                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR03)
                    }

                    Return (PR03)
                }

                Device (MPCI)
                {
                    Name (_ADR, 0x00)
                    OperationRegion (MINP, PCI_Config, 0x00, 0x68)
                    Field (MINP, ByteAcc, NoLock, Preserve)
                    {
                        VNUM,   32, 
                                Offset (0x09), 
                        PINF,   8, 
                        SBCC,   8, 
                        BSCC,   8, 
                                Offset (0x2C), 
                        SNUM,   32, 
                                Offset (0x34)
                    }

                    Method (MPDP, 0, NotSerialized)
                    {
                        If (LEqual (SNUM, 0xFFFFFFFF))
                        {
                            Return (0x00)
                        }

                        If (LNotEqual (BSCC, 0x02))
                        {
                            Return (0x00)
                        }

                        Return (One)
                    }
                }
            }

            Device (P0P4)
            {
                Name (_ADR, 0x001C0002)
                OperationRegion (LCTL, PCI_Config, 0x50, 0x04)
                Field (LCTL, ByteAcc, NoLock, Preserve)
                {
                        ,   4, 
                    PELD,   1, 
                    PERL,   1
                }

                OperationRegion (SLOT, PCI_Config, 0x54, 0x10)
                Field (SLOT, ByteAcc, NoLock, Preserve)
                {
                    SCAP,   32, 
                    SCTL,   16, 
                    ABP1,   1, 
                    PFD1,   1, 
                    MSC1,   1, 
                    PDC1,   1, 
                    CC10,   1, 
                    MS10,   1, 
                    PDS1,   1, 
                    RSV0,   1, 
                    LASC,   1, 
                    RSV1,   7
                }

                OperationRegion (RHUB, PCI_Config, 0x60, 0x10)
                Field (RHUB, ByteAcc, NoLock, Preserve)
                {
                    PMID,   16, 
                    PMES,   1, 
                    PMEP,   1, 
                    RSV2,   14
                }

                OperationRegion (MISC, PCI_Config, 0xD8, 0x08)
                Field (MISC, ByteAcc, NoLock, Preserve)
                {
                    RSV4,   30, 
                    HPCE,   1, 
                    PMCE,   1, 
                    PMMS,   1, 
                    HPPD,   1, 
                    HPAB,   1, 
                    HPCC,   1, 
                    HPLA,   1, 
                    RSV3,   25, 
                    HPCS,   1, 
                    PMCS,   1
                }

                Method (HPHK, 0, NotSerialized)
                {
                    Store (0x01, PDC1)
                    Store (0x01, HPCS)
                    Store (0x00, PELD)
                    Sleep (0xFA)
                }

                Name (_HPP, Package (0x04)
                {
                    0x08, 
                    0x40, 
                    0x01, 
                    0x00
                })
                Method (_PRW, 0, NotSerialized)
                {
                    Return (GPRW (0x09, 0x04))
                }

                Method (_PRT, 0, NotSerialized)
                {
                    If (PICM)
                    {
                        Return (AR04)
                    }

                    Return (PR04)
                }

                Device (XCRD)
                {
                    Name (_ADR, 0x00)
                    Method (_STA, 0, NotSerialized)
                    {
                        If (And (\FDRT, 0x00040000))
                        {
                            Return (0x00)
                        }

                        Store (\_SB.RBPE (0x000E205A), Local0)
                        If (And (Local0, 0x40))
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
                        Return (One)
                    }

                    Method (_PRW, 0, NotSerialized)
                    {
                        Return (GPRW (0x09, 0x03))
                    }
                }
            }
        }
    }

    Scope (\_SB.PCI0.SBRG)
    {
        Device (EC0)
        {
            Name (_HID, EisaId ("PNP0C09"))
            Name (_CRS, ResourceTemplate ()
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
            Name (_GPE, 0x1C)
            Mutex (MUEC, 0x00)
            Mutex (ASIO, 0x00)
            Name (ECFL, Zero)
            Method (ECAV, 0, NotSerialized)
            {
                If (LGreaterEqual (\SLPT, 0x04))
                {
                    Return (Zero)
                }

                Return (ECFL)
            }

            OperationRegion (ECOR, EmbeddedControl, 0x00, 0xFF)
            Field (ECOR, ByteAcc, Lock, Preserve)
            {
                        Offset (0x04), 
                CMD1,   8, 
                CDT1,   8, 
                CDT2,   8, 
                CDT3,   8, 
                        Offset (0x80), 
                EPWS,   8, 
                EB0S,   8, 
                EB1S,   8, 
                EB0R,   8, 
                EB1R,   8, 
                EPWF,   8, 
                        Offset (0x87), 
                EB0T,   8, 
                EB1T,   8, 
                        Offset (0x93), 
                TAH0,   16, 
                TAH1,   16, 
                TSTP,   8, 
                        Offset (0xA0), 
                ECPU,   8, 
                ECRT,   8, 
                EPSV,   8, 
                EACT,   8, 
                        Offset (0xB0), 
                B0PN,   16, 
                B0VL,   16, 
                B0RC,   16, 
                B0FC,   16, 
                B0MD,   16, 
                B0ST,   16, 
                B0CC,   16, 
                B0TM,   16, 
                B0C1,   16, 
                B0C2,   16, 
                B0C3,   16, 
                B0C4,   16, 
                        Offset (0xD0), 
                B1PN,   16, 
                B1VL,   16, 
                B1RC,   16, 
                B1FC,   16, 
                B1MD,   16, 
                B1ST,   16, 
                B1CC,   16, 
                B1TM,   16, 
                B1C1,   16, 
                B1C2,   16, 
                B1C3,   16, 
                B1C4,   16, 
                        Offset (0xF0), 
                B0DC,   16, 
                B0DV,   16, 
                B0SN,   16, 
                        Offset (0xF8), 
                B1DC,   16, 
                B1DV,   16, 
                B1SN,   16
            }

            Name (SMBF, 0x00)
            OperationRegion (SMBX, EmbeddedControl, 0x18, 0x28)
            Field (SMBX, ByteAcc, NoLock, Preserve)
            {
                PRTC,   8, 
                SSTS,   5, 
                    ,   1, 
                ALFG,   1, 
                CDFG,   1, 
                ADDR,   8, 
                CMDB,   8, 
                BDAT,   256, 
                BCNT,   8, 
                    ,   1, 
                ALAD,   7, 
                ALD0,   8, 
                ALD1,   8
            }

            Field (SMBX, ByteAcc, NoLock, Preserve)
            {
                        Offset (0x04), 
                DAT0,   8, 
                DAT1,   8
            }

            Field (SMBX, ByteAcc, NoLock, Preserve)
            {
                        Offset (0x04), 
                DT2B,   16
            }

            OperationRegion (NSBS, EmbeddedControl, 0x40, 0x04)
            Field (NSBS, ByteAcc, NoLock, Preserve)
            {
                A2AD,   8, 
                A2D0,   8, 
                A2D1,   8, 
                A3AD,   8
            }

            Method (_INI, 0, NotSerialized)
            {
                If (LLessEqual (\OSFG, \OSME))
                {
                    Store (One, ECFL)
                }
            }

            Method (_REG, 2, NotSerialized)
            {
                If (LEqual (Arg0, 0x03))
                {
                    Store (Arg1, ECFL)
                }
            }
        }
    }

    OperationRegion (\_SB.PCI0.SBRG.PIX0, PCI_Config, 0x60, 0x0C)
    Field (\_SB.PCI0.SBRG.PIX0, ByteAcc, NoLock, Preserve)
    {
        PIRA,   8, 
        PIRB,   8, 
        PIRC,   8, 
        PIRD,   8, 
                Offset (0x08), 
        PIRE,   8, 
        PIRF,   8, 
        PIRG,   8, 
        PIRH,   8
    }

    Scope (\_SB)
    {
        Name (BUFA, ResourceTemplate ()
        {
            IRQ (Level, ActiveLow, Shared, _Y0A)
                {15}
        })
        CreateWordField (BUFA, \_SB._Y0A._INT, IRA0)
        Device (LNKA)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x01)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRA, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSA)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRA, 0x80, PIRA)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRA, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRA)
            }
        }

        Device (LNKB)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x02)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRB, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSB)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRB, 0x80, PIRB)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRB, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRB)
            }
        }

        Device (LNKC)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x03)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRC, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSC)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRC, 0x80, PIRC)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRC, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRC)
            }
        }

        Device (LNKD)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x04)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRD, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSD)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRD, 0x80, PIRD)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRD, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRD)
            }
        }

        Device (LNKE)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x05)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRE, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSE)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRE, 0x80, PIRE)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRE, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRE)
            }
        }

        Device (LNKF)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x06)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRF, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSF)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRF, 0x80, PIRF)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRF, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRF)
            }
        }

        Device (LNKG)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x07)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRG, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSG)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRG, 0x80, PIRG)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRG, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRG)
            }
        }

        Device (LNKH)
        {
            Name (_HID, EisaId ("PNP0C0F"))
            Name (_UID, 0x08)
            Method (_STA, 0, NotSerialized)
            {
                And (PIRH, 0x80, Local0)
                If (Local0)
                {
                    Return (0x09)
                }
                Else
                {
                    Return (0x0B)
                }
            }

            Method (_PRS, 0, NotSerialized)
            {
                Return (PRSH)
            }

            Method (_DIS, 0, NotSerialized)
            {
                Or (PIRH, 0x80, PIRH)
            }

            Method (_CRS, 0, NotSerialized)
            {
                And (PIRH, 0x0F, Local0)
                ShiftLeft (0x01, Local0, IRA0)
                Return (BUFA)
            }

            Method (_SRS, 1, NotSerialized)
            {
                CreateWordField (Arg0, 0x01, IRA)
                FindSetRightBit (IRA, Local0)
                Decrement (Local0)
                Store (Local0, PIRH)
            }
        }
    }

    Scope (\_SB)
    {
        Name (XCPD, 0x00)
        Name (XNPT, 0x01)
        Name (XCAP, 0x02)
        Name (XDCP, 0x04)
        Name (XDCT, 0x08)
        Name (XDST, 0x0A)
        Name (XLCP, 0x0C)
        Name (XLCT, 0x10)
        Name (XLST, 0x12)
        Name (XSCP, 0x14)
        Name (XSCT, 0x18)
        Name (XSST, 0x1A)
        Name (XRCT, 0x1C)
        Mutex (MUTE, 0x00)
        Method (RBPE, 1, NotSerialized)
        {
            Acquire (MUTE, 0x03E8)
            Add (Arg0, \PCIB, Local0)
            OperationRegion (PCG1, SystemMemory, Local0, 0x01)
            Field (PCG1, ByteAcc, NoLock, Preserve)
            {
                XCG1,   8
            }

            Release (MUTE)
            Return (XCG1)
        }

        Method (RWPE, 1, NotSerialized)
        {
            Acquire (MUTE, 0x03E8)
            And (Arg0, 0xFFFFFFFE, Arg0)
            Add (Arg0, \PCIB, Local0)
            OperationRegion (PCG2, SystemMemory, Local0, 0x02)
            Field (PCG2, WordAcc, NoLock, Preserve)
            {
                XCG2,   16
            }

            Release (MUTE)
            Return (XCG2)
        }

        Method (RDPE, 1, NotSerialized)
        {
            Acquire (MUTE, 0x03E8)
            And (Arg0, 0xFFFFFFFC, Arg0)
            Add (Arg0, \PCIB, Local0)
            OperationRegion (PCG3, SystemMemory, Local0, 0x04)
            Field (PCG3, DWordAcc, NoLock, Preserve)
            {
                XCG3,   32
            }

            Release (MUTE)
            Return (XCG3)
        }

        Method (WBPE, 2, NotSerialized)
        {
            Acquire (MUTE, 0x0FFF)
            Add (Arg0, \PCIB, Local0)
            OperationRegion (PCG4, SystemMemory, Local0, 0x01)
            Field (PCG4, ByteAcc, NoLock, Preserve)
            {
                XCG4,   8
            }

            Store (Arg1, XCG4)
            Release (MUTE)
        }

        Method (WWPE, 2, NotSerialized)
        {
            Acquire (MUTE, 0x03E8)
            And (Arg0, 0xFFFFFFFE, Arg0)
            Add (Arg0, \PCIB, Local0)
            OperationRegion (PCG5, SystemMemory, Local0, 0x02)
            Field (PCG5, WordAcc, NoLock, Preserve)
            {
                XCG5,   16
            }

            Store (Arg1, XCG5)
            Release (MUTE)
        }

        Method (WDPE, 2, NotSerialized)
        {
            Acquire (MUTE, 0x03E8)
            And (Arg0, 0xFFFFFFFC, Arg0)
            Add (Arg0, \PCIB, Local0)
            OperationRegion (PCG6, SystemMemory, Local0, 0x04)
            Field (PCG6, DWordAcc, NoLock, Preserve)
            {
                XCG6,   32
            }

            Store (Arg1, XCG6)
            Release (MUTE)
        }

        Method (RWDP, 3, NotSerialized)
        {
            Acquire (MUTE, 0x03E8)
            And (Arg0, 0xFFFFFFFC, Arg0)
            Add (Arg0, \PCIB, Local0)
            OperationRegion (PCG7, SystemMemory, Local0, 0x04)
            Field (PCG7, DWordAcc, NoLock, Preserve)
            {
                XCG7,   32
            }

            And (XCG7, Arg2, Local1)
            Or (Local1, Arg1, XCG7)
            Release (MUTE)
        }

        Method (RPME, 1, NotSerialized)
        {
            Add (Arg0, 0x84, Local0)
            Store (\_SB.RDPE (Local0), Local1)
            If (LEqual (Local1, 0xFFFFFFFF))
            {
                Return (0x00)
            }
            Else
            {
                If (LAnd (Local1, 0x00010000))
                {
                    \_SB.WDPE (Local0, And (Local1, 0x00010000))
                    Return (0x01)
                }

                Return (0x00)
            }
        }
    }

    Scope (\_SB.PCI0.SBRG.EC0)
    {
        OperationRegion (ECIO, SystemIO, 0x025C, 0x10)
        Field (ECIO, ByteAcc, Lock, Preserve)
        {
            ECDT,   8, 
            ECCM,   8
        }

        Method (GBTT, 1, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Arg0, 0x00))
                {
                    Store (EB0T, Local0)
                }
                Else
                {
                    Store (EB1T, Local0)
                }
            }
            Else
            {
                Store (0xFF, Local0)
            }

            Return (Local0)
        }

        Method (WCMD, 1, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CMD1)
                    Release (MUEC)
                }
            }
        }

        Method (DLY0, 1, Serialized)
        {
            If (LNot (ECAV ()))
            {
                Return (Ones)
            }

            Store (Ones, Local0)
            If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
            {
                Store (Arg0, CDT1)
                Store (0x6B, CDT2)
                Store (0x00, CDT3)
                Store (0xBB, CMD1)
                Store (0x7F, Local1)
                While (LAnd (Local1, CMD1))
                {
                    Sleep (0x01)
                    Decrement (Local1)
                }

                If (LEqual (CMD1, Zero))
                {
                    Store (CDT1, Local0)
                }

                Release (MUEC)
            }

            Return (Local0)
        }

        Method (RRAM, 2, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CDT3)
                    Store (Arg1, CDT2)
                    Store (0xBA, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (0x01)
                        Decrement (Local0)
                    }

                    If (LEqual (CMD1, Zero))
                    {
                        Store (CDT1, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local0)
                    }

                    Release (MUEC)
                    Return (Local0)
                }
            }

            Return (Ones)
        }

        Method (WRAM, 3, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CDT3)
                    Store (Arg1, CDT2)
                    Store (Arg2, CDT1)
                    Store (0xBB, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (0x01)
                        Decrement (Local0)
                    }

                    If (LEqual (CMD1, Zero))
                    {
                        Store (One, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local0)
                    }

                    Release (MUEC)
                    Return (Local0)
                }
            }

            Return (Ones)
        }

        Name (PWAC, Buffer (0x10)
        {
            /* 0000 */    0x20, 0x27, 0x2E, 0x35, 0x3C, 0x42, 0x48, 0x4E, 
            /* 0008 */    0x54, 0x5A, 0x60, 0x66, 0x6C, 0x72, 0x78, 0x88
        })
        Name (PWDC, Buffer (0x10)
        {
            /* 0000 */    0x19, 0x20, 0x27, 0x2E, 0x35, 0x3C, 0x42, 0x48, 
            /* 0008 */    0x4E, 0x54, 0x5A, 0x60, 0x66, 0x6C, 0x72, 0x78
        })
        Method (STBR, 0, Serialized)
        {
            And (\VGAF, 0x01, Local0)
            If (Local0)
            {
                \ISMI (0x9A)
            }
            Else
            {
                If (ACAP ())
                {
                    Store (DerefOf (Index (PWAC, LBTN)), Local0)
                }
                Else
                {
                    Store (DerefOf (Index (PWDC, LBTN)), Local0)
                }

                WBOV (0x00, Local0)
            }
        }

        Method (SADC, 2, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CDT1)
                    Store (Arg1, CDT2)
                    Store (0xC4, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (0x01)
                        Decrement (Local0)
                    }

                    If (LEqual (CMD1, Zero))
                    {
                        Store (CDT1, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local0)
                    }

                    Release (MUEC)
                    Return (Local0)
                }
            }

            Return (Ones)
        }

        Method (SBQH, 3, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CDT1)
                    Store (Arg1, CDT2)
                    Store (Arg2, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (0x01)
                        Decrement (Local0)
                    }

                    If (LEqual (CMD1, Zero))
                    {
                        Store (CDT1, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local0)
                    }

                    Release (MUEC)
                    Return (Local0)
                }
            }

            Return (Ones)
        }

        Method (SPIN, 2, Serialized)
        {
            Store (Arg0, Local0)
            If (Arg1)
            {
                Or (Local0, 0x20, Local0)
            }
            Else
            {
                Or (Local0, 0x40, Local0)
            }

            STC5 (Local0)
            Return (One)
        }

        Method (RPIN, 1, Serialized)
        {
            And (Arg0, 0x1F, Local0)
            Store (STC5 (Local0), Local1)
            Return (Local1)
        }

        Method (ST87, 2, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CDT1)
                    Store (Arg1, CDT2)
                    Store (0x87, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (0x01)
                        Decrement (Local0)
                    }

                    If (LEqual (CMD1, Zero))
                    {
                        Store (CDT1, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local0)
                    }

                    Release (MUEC)
                    Return (Local0)
                }
            }

            Return (Ones)
        }

        Method (STC5, 1, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CDT1)
                    Store (0xC5, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (0x01)
                        Decrement (Local0)
                    }

                    If (LEqual (CMD1, Zero))
                    {
                        Store (CDT1, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local0)
                    }

                    Release (MUEC)
                    Return (Local0)
                }
            }

            Return (Ones)
        }

        Method (RBAT, 2, Serialized)
        {
            If (LNot (ECAV ()))
            {
                Return (Ones)
            }

            If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
            {
                Store (0x03, Local0)
                While (Local0)
                {
                    Store (Arg0, CDT2)
                    Store (Arg1, Local1)
                    ShiftLeft (Local1, 0x01, Local1)
                    Add (Local1, 0xDA, Local1)
                    Store (Local1, CMD1)
                    Store (0x7F, Local1)
                    While (LAnd (CMD1, Local1))
                    {
                        Decrement (Local1)
                        Sleep (0x01)
                    }

                    If (LEqual (CMD1, 0x00))
                    {
                        Store (CDT1, Local1)
                        Store (Zero, Local0)
                    }
                    Else
                    {
                        Store (Ones, Local1)
                        Decrement (Local0)
                    }
                }

                Release (MUEC)
                Return (Local1)
            }

            Return (Ones)
        }

        Method (WBAT, 3, Serialized)
        {
            Or (Arg0, 0x80, Local3)
            If (LNot (ECAV ()))
            {
                Return (Ones)
            }

            If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
            {
                Store (0x03, Local0)
                While (Local0)
                {
                    Store (Arg2, CDT1)
                    Store (Local3, CDT2)
                    Store (Arg1, Local1)
                    ShiftLeft (Local1, 0x01, Local1)
                    Add (Local1, 0xDA, Local1)
                    Store (Local1, CMD1)
                    Store (0x7F, Local1)
                    While (LAnd (CMD1, Local1))
                    {
                        Decrement (Local1)
                        Sleep (0x01)
                    }
                }

                Release (MUEC)
                Return (Local1)
            }

            Return (Ones)
        }

        Method (FNCT, 2, Serialized)
        {
            If (ECAV ())
            {
                If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
                {
                    Store (Arg0, CDT2)
                    Store (Arg1, CDT1)
                    Store (0xC4, CMD1)
                    Store (0x7F, Local0)
                    While (LAnd (Local0, CMD1))
                    {
                        Sleep (0x01)
                        Decrement (Local0)
                    }

                    Release (MUEC)
                }
            }
        }

        Name (WRQK, 0x02)
        Name (RDQK, 0x03)
        Name (SDBT, 0x04)
        Name (RCBT, 0x05)
        Name (WRBT, 0x06)
        Name (RDBT, 0x07)
        Name (WRWD, 0x08)
        Name (RDWD, 0x09)
        Name (WRBL, 0x0A)
        Name (RDBL, 0x0B)
        Name (PCLL, 0x0C)
        Name (GOOD, 0x00)
        Name (UKER, 0x07)
        Name (DAER, 0x10)
        Name (CMDN, 0x12)
        Name (UKE2, 0x13)
        Name (DADN, 0x17)
        Name (SBTO, 0x18)
        Name (USPT, 0x19)
        Name (SBBY, 0x1A)
        Method (SWTC, 1, Serialized)
        {
            Store (UKER, Local0)
            Store (0x03, Local1)
            While (LAnd (Local0, Local1))
            {
                Store (0x23, Local2)
                While (Local2)
                {
                    If (PRTC)
                    {
                        Sleep (0x01)
                        Decrement (Local2)
                    }
                    Else
                    {
                        Store (Zero, Local2)
                        Store (SSTS, Local0)
                    }
                }

                If (Local0)
                {
                    Store (Zero, PRTC)
                    Decrement (Local1)
                    If (Local1)
                    {
                        Sleep (0x01)
                        Store (Arg0, PRTC)
                    }
                }
            }

            Return (Local0)
        }

        Method (SMBR, 3, Serialized)
        {
            Store (Package (0x03)
                {
                    0x07, 
                    0x00, 
                    0x00
                }, Local0)
            If (LNot (ECAV ()))
            {
                Return (Local0)
            }

            If (LNotEqual (Arg0, RDBL))
            {
                If (LNotEqual (Arg0, RDWD))
                {
                    If (LNotEqual (Arg0, RDBT))
                    {
                        If (LNotEqual (Arg0, RCBT))
                        {
                            If (LNotEqual (Arg0, RDQK))
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
            {
                Store (PRTC, Local1)
                Store (Zero, Local2)
                While (LNotEqual (Local1, 0x00))
                {
                    Stall (0x0A)
                    Increment (Local2)
                    If (LGreater (Local2, 0x03E8))
                    {
                        Store (SBBY, Index (Local0, 0x00))
                        Store (Zero, Local1)
                    }
                    Else
                    {
                        Store (PRTC, Local1)
                    }
                }

                If (LLessEqual (Local2, 0x03E8))
                {
                    ShiftLeft (Arg1, 0x01, Local3)
                    Or (Local3, 0x01, Local3)
                    Store (Local3, ADDR)
                    If (LNotEqual (Arg0, RDQK))
                    {
                        If (LNotEqual (Arg0, RCBT))
                        {
                            Store (Arg2, CMDB)
                        }
                    }

                    Store (Arg0, PRTC)
                    Store (SWTC (Arg0), Index (Local0, 0x00))
                    If (LEqual (DerefOf (Index (Local0, 0x00)), 0x00))
                    {
                        If (LEqual (Arg0, RDBL))
                        {
                            Store (BCNT, Index (Local0, 0x01))
                            Store (BDAT, Index (Local0, 0x02))
                        }

                        If (LEqual (Arg0, RDWD))
                        {
                            Store (0x02, Index (Local0, 0x01))
                            Store (DT2B, Index (Local0, 0x02))
                        }

                        If (LEqual (Arg0, RDBT))
                        {
                            Store (0x01, Index (Local0, 0x01))
                            Store (DAT0, Index (Local0, 0x02))
                        }

                        If (LEqual (Arg0, RCBT))
                        {
                            Store (0x01, Index (Local0, 0x01))
                            Store (DAT0, Index (Local0, 0x02))
                        }
                    }
                }

                Release (MUEC)
            }

            Return (Local0)
        }

        Method (SMBW, 5, Serialized)
        {
            Store (Package (0x01)
                {
                    0x07
                }, Local0)
            If (LNot (ECAV ()))
            {
                Return (Local0)
            }

            If (LNotEqual (Arg0, WRBL))
            {
                If (LNotEqual (Arg0, WRWD))
                {
                    If (LNotEqual (Arg0, WRBT))
                    {
                        If (LNotEqual (Arg0, SDBT))
                        {
                            If (LNotEqual (Arg0, WRQK))
                            {
                                Return (Local0)
                            }
                        }
                    }
                }
            }

            If (LEqual (Acquire (MUEC, 0xFFFF), 0x00))
            {
                Store (PRTC, Local1)
                Store (Zero, Local2)
                While (LNotEqual (Local1, 0x00))
                {
                    Stall (0x0A)
                    Increment (Local2)
                    If (LGreater (Local2, 0x03E8))
                    {
                        Store (SBBY, Index (Local0, 0x00))
                        Store (Zero, Local1)
                    }
                    Else
                    {
                        Store (PRTC, Local1)
                    }
                }

                If (LLessEqual (Local2, 0x03E8))
                {
                    ShiftLeft (Arg1, 0x01, Local3)
                    Store (Local3, ADDR)
                    If (LNotEqual (Arg0, WRQK))
                    {
                        If (LNotEqual (Arg0, SDBT))
                        {
                            Store (Arg2, CMDB)
                        }
                    }

                    If (LEqual (Arg0, WRBL))
                    {
                        Store (Arg3, BCNT)
                        Store (Arg4, BDAT)
                    }

                    If (LEqual (Arg0, WRWD))
                    {
                        Store (Arg4, DT2B)
                    }

                    If (LEqual (Arg0, WRBT))
                    {
                        Store (Arg4, DAT0)
                    }

                    If (LEqual (Arg0, SDBT))
                    {
                        Store (Arg4, DAT0)
                    }

                    Store (Arg0, PRTC)
                    Store (SWTC (Arg0), Index (Local0, 0x00))
                }

                Release (MUEC)
            }

            Return (Local0)
        }

        OperationRegion (KAID, SystemIO, 0x025C, 0x01)
        Field (KAID, ByteAcc, NoLock, Preserve)
        {
            AEID,   8
        }

        OperationRegion (KAIC, SystemIO, 0x025D, 0x01)
        Field (KAIC, ByteAcc, NoLock, Preserve)
        {
            AEIC,   8
        }

        Method (WEIE, 0, Serialized)
        {
            Store (0x4000, Local0)
            And (AEIC, 0x02, Local1)
            While (LAnd (LNotEqual (Local0, Zero), LEqual (Local1, 0x02)))
            {
                And (AEIC, 0x02, Local1)
                Decrement (Local0)
            }
        }

        Method (WEOF, 0, Serialized)
        {
            Store (0x4000, Local0)
            And (AEIC, 0x01, Local1)
            While (LAnd (LNotEqual (Local0, Zero), LEqual (Local1, 0x00)))
            {
                And (AEIC, 0x01, Local1)
                Decrement (Local0)
            }
        }

        Method (RFOV, 1, Serialized)
        {
            Store (0x00, Local0)
            If (LEqual (Acquire (ASIO, 0xFFFF), 0x00))
            {
                WEIE ()
                Store (0x83, AEIC)
                WEIE ()
                Store (Arg0, AEID)
                WEOF ()
                Store (AEID, Local0)
                WEIE ()
                Release (ASIO)
            }

            Return (Local0)
        }

        Method (WFOV, 2, Serialized)
        {
            If (LEqual (Acquire (ASIO, 0xFFFF), 0x00))
            {
                WEIE ()
                Store (0x84, AEIC)
                WEIE ()
                Store (Arg0, AEID)
                WEIE ()
                Store (Arg1, AEID)
                Release (ASIO)
            }
        }

        Method (RBOV, 1, Serialized)
        {
            Store (0x00, Local0)
            If (LEqual (Acquire (ASIO, 0xFFFF), 0x00))
            {
                WEIE ()
                Store (0x85, AEIC)
                WEIE ()
                Store (Arg0, AEID)
                WEOF ()
                Store (AEID, Local0)
                WEIE ()
                Release (ASIO)
            }

            Return (Local0)
        }

        Method (WBOV, 2, Serialized)
        {
            If (LEqual (Acquire (ASIO, 0xFFFF), 0x00))
            {
                WEIE ()
                Store (0x86, AEIC)
                WEIE ()
                Store (Arg0, AEID)
                WEIE ()
                Store (Arg1, AEID)
                Release (ASIO)
            }
        }

        Method (WMFN, 1, Serialized)
        {
            If (LEqual (Acquire (ASIO, 0xFFFF), 0x00))
            {
                WEIE ()
                Store (0x98, AEIC)
                WEIE ()
                Store (Arg0, AEID)
                WEIE ()
                Release (ASIO)
            }
        }
    }

    Scope (\_SB.PCI0.SBRG.EC0)
    {
        Method (ACPS, 0, Serialized)
        {
            Return (And (GPWS (), 0x01))
        }

        Method (DCPS, 1, Serialized)
        {
            Store (GPWS (), Local0)
            If (Arg0)
            {
                And (Local0, 0x04, Local0)
            }
            Else
            {
                And (Local0, 0x02, Local0)
            }

            If (Local0)
            {
                Store (0x01, Local0)
            }
            Else
            {
                Store (0x00, Local0)
            }

            Return (Local0)
        }

        Method (GPWS, 0, Serialized)
        {
            If (ECAV ())
            {
                And (EPWS, 0x07, Local0)
            }
            Else
            {
                Store (0x00, Local0)
            }

            Return (Local0)
        }

        Method (BCHG, 1, Serialized)
        {
            If (Arg0)
            {
                If (ECAV ())
                {
                    Store (EB1S, Local0)
                    And (Local0, 0xFF, Local0)
                    If (LNotEqual (Local0, 0xFF))
                    {
                        And (Local0, 0x02, Local0)
                    }
                    Else
                    {
                        Store (Zero, Local0)
                    }
                }
                Else
                {
                    Store (Zero, Local0)
                }

                Return (Local0)
            }
            Else
            {
                If (ECAV ())
                {
                    Store (EB0S, Local0)
                    And (Local0, 0xFF, Local0)
                    If (LNotEqual (Local0, 0xFF))
                    {
                        And (Local0, 0x02, Local0)
                    }
                    Else
                    {
                        Store (Zero, Local0)
                    }
                }
                Else
                {
                    Store (Zero, Local0)
                }

                Return (Local0)
            }
        }

        Method (BCLE, 1, Serialized)
        {
            If (Arg0)
            {
                If (ECAV ())
                {
                    Store (EB1S, Local1)
                    And (Local1, 0xFFFF, Local1)
                    If (LNotEqual (Local1, 0xFFFF))
                    {
                        And (Local1, 0x16, Local1)
                        If (LEqual (Local1, 0x04))
                        {
                            Store (0x00, Local0)
                        }
                        Else
                        {
                            If (LEqual (Local1, 0x02))
                            {
                                Store (0x01, Local0)
                            }
                            Else
                            {
                                If (LEqual (Local1, 0x10))
                                {
                                    Store (0x01, Local0)
                                }
                            }
                        }
                    }
                }
                Else
                {
                    Store (Ones, Local0)
                }

                Return (Local0)
            }
            Else
            {
                If (ECAV ())
                {
                    Store (EB0S, Local1)
                    And (Local1, 0xFFFF, Local1)
                    If (LNotEqual (Local1, 0xFFFF))
                    {
                        And (Local1, 0x16, Local1)
                        If (LEqual (Local1, 0x04))
                        {
                            Store (0x00, Local0)
                        }
                        Else
                        {
                            If (LEqual (Local1, 0x02))
                            {
                                Store (0x01, Local0)
                            }
                            Else
                            {
                                If (LEqual (Local1, 0x10))
                                {
                                    Store (0x01, Local0)
                                }
                            }
                        }
                    }
                }
                Else
                {
                    Store (Ones, Local0)
                }

                Return (Local0)
            }
        }

        Method (CHBT, 1, Serialized)
        {
            If (ECAV ())
            {
                Store (GBTT (Arg0), Local1)
                If (LEqual (Local1, 0xFF))
                {
                    Store (Zero, Local0)
                }
                Else
                {
                    And (Local1, 0x10, Local0)
                    If (Local0)
                    {
                        Store (One, Local0)
                    }
                }
            }
            Else
            {
                Store (\DCTP, Local0)
            }

            Return (Local0)
        }

        Method (TACH, 1, NotSerialized)
        {
            If (Arg0)
            {
                If (ECAV ())
                {
                    Store (TAH1, Local0)
                    And (Local0, 0xFFFF, Local0)
                    If (LNotEqual (Local0, 0x00))
                    {
                        If (LEqual (Local0, 0xFFFF))
                        {
                            Store (Zero, Local0)
                        }
                        Else
                        {
                            Store (0x80, Local1)
                            Store (0x02, Local2)
                            Multiply (Local1, Local2, Local3)
                            Multiply (Local0, Local3, Local4)
                            Divide (0x03938700, Local4, Local5, Local6)
                            Multiply (Local6, 0x0A, Local6)
                            Store (Local6, Local0)
                        }
                    }
                    Else
                    {
                        Store (Zero, Local0)
                    }
                }
                Else
                {
                    Store (Ones, Local0)
                }

                Return (Local0)
            }
            Else
            {
                If (ECAV ())
                {
                    Store (TAH0, Local0)
                    And (Local0, 0xFFFF, Local0)
                    If (LNotEqual (Local0, 0x00))
                    {
                        If (LEqual (Local0, 0xFFFF))
                        {
                            Store (Zero, Local0)
                        }
                        Else
                        {
                            Store (0x80, Local1)
                            Store (0x02, Local2)
                            Multiply (Local1, Local2, Local3)
                            Multiply (Local0, Local3, Local4)
                            Divide (0x03938700, Local4, Local5, Local6)
                            Multiply (Local6, 0x0A, Local6)
                            Store (Local6, Local0)
                        }
                    }
                    Else
                    {
                        Store (Zero, Local0)
                    }
                }
                Else
                {
                    Store (Ones, Local0)
                }

                Return (Local0)
            }
        }

        Method (EC0S, 1, NotSerialized)
        {
            If (LEqual (Arg0, 0x03)) {}
        }

        Method (EC0W, 1, NotSerialized)
        {
            If (LEqual (Arg0, 0x03)) {}
            If (LLessEqual (Arg0, 0x04))
            {
                Store (ACPS (), \ACPF)
                Store (DCPS (0x00), \DCPF)
                Notify (\_PR.CPU1, 0x80)
            }
        }
    }

    Scope (\)
    {
        Name (TSP, 0x0A)
        Name (TC1, 0x02)
        Name (TC2, 0x0A)
    }

    Scope (\_TZ)
    {
        Method (KELV, 1, NotSerialized)
        {
            And (Arg0, 0xFF, Local0)
            If (LGreaterEqual (Local0, 0x80))
            {
                Subtract (0x0100, Local0, Local0)
                Multiply (Local0, 0x0A, Local0)
                Subtract (0x0AAC, Local0, Local0)
                Return (Local0)
            }

            Multiply (Local0, 0x0A, Local0)
            Add (Local0, 0x0AAC, Local0)
            Return (Local0)
        }

        Method (CELC, 1, NotSerialized)
        {
            Subtract (Arg0, 0x0AAC, Local0)
            Divide (Local0, 0x0A, Local1, Local0)
            Return (Local0)
        }

        Name (PLCY, 0x00)
        ThermalZone (THRM)
        {
            Method (_CRT, 0, NotSerialized)
            {
                RCRT ()
                Return (KELV (TCRT))
            }

            Method (_TMP, 0, NotSerialized)
            {
                Store (0x05, Local1)
                While (Local1)
                {
                    Store (RTMP (), Local0)
                    If (LGreater (Local0, TCRT))
                    {
                        Decrement (Local1)
                    }
                    Else
                    {
                        Store (0x00, Local1)
                    }
                }

                Return (KELV (Local0))
            }

            Name (_PSL, Package (0x01)
            {
                \_PR.CPU1
            })
            Method (_TSP, 0, NotSerialized)
            {
                Multiply (TSP, 0x0A, Local0)
                Return (Local0)
            }

            Method (_TC1, 0, NotSerialized)
            {
                Return (TC1)
            }

            Method (_TC2, 0, NotSerialized)
            {
                Return (TC2)
            }

            Method (_PSV, 0, NotSerialized)
            {
                RPSV ()
                If (PLCY)
                {
                    Return (KELV (PPSV))
                }
                Else
                {
                    Return (KELV (TPSV))
                }
            }

            Method (_SCP, 1, NotSerialized)
            {
                Store (Zero, PLCY)
                Notify (THRM, 0x81)
            }
        }
    }

    Scope (\_TZ)
    {
        Name (ATMP, 0x3C)
        Name (LTMP, 0x3C)
        Name (FANS, 0x00)
        Method (RTMP, 0, NotSerialized)
        {
            If (\_SB.PCI0.SBRG.EC0.ECAV ())
            {
                Store (\_SB.PCI0.SBRG.EC0.ECPU, Local0)
                If (LLess (Local0, 0x80))
                {
                    Store (Local0, LTMP)
                }
            }

            Return (LTMP)
        }

        Method (RLTM, 0, NotSerialized)
        {
            Return (ATMP)
        }

        Method (RCRT, 0, NotSerialized)
        {
            If (\_SB.PCI0.SBRG.EC0.ECAV ())
            {
                Store (\_SB.PCI0.SBRG.EC0.ECRT, Local0)
                If (LLess (Local0, 0x80))
                {
                    Store (Local0, TCRT)
                }
            }
        }

        Method (RPSV, 0, NotSerialized)
        {
            If (\_SB.PCI0.SBRG.EC0.ECAV ())
            {
                Store (\_SB.PCI0.SBRG.EC0.EPSV, Local0)
                If (LLess (Local0, 0x80))
                {
                    Store (Local0, TPSV)
                }
            }
        }

        Method (RFAN, 0, NotSerialized)
        {
            If (\_SB.PCI0.SBRG.EC0.ECAV ())
            {
                Store (\_SB.PCI0.SBRG.EC0.TACH (0x00), Local0)
                Divide (Local0, 0x64, Local1, Local0)
                Add (Local0, 0x01, Local0)
                If (LLessEqual (Local0, 0x3C))
                {
                    Store (Local0, FANS)
                }
                Else
                {
                    Store (FANS, Local0)
                }
            }
            Else
            {
                Store (Zero, Local0)
            }

            Return (Local0)
        }

        Method (TCHG, 0, NotSerialized)
        {
        }

        Method (THDL, 0, NotSerialized)
        {
        }

        Method (TMSS, 1, NotSerialized)
        {
        }

        Method (TMSW, 1, NotSerialized)
        {
        }
    }

    Scope (\)
    {
        OperationRegion (\PMIO, SystemIO, \PMBS, 0x50)
        Field (\PMIO, ByteAcc, NoLock, Preserve)
        {
                    Offset (0x08), 
            TMR0,   8, 
            TMR1,   8, 
            TMR2,   8, 
                    Offset (0x10), 
                ,   1, 
            TDTY,   3, 
            TENA,   1, 
            TTDT,   3, 
            FRCT,   1, 
                ,   8, 
            THLS,   1, 
                    Offset (0x13), 
                    Offset (0x28), 
                ,   1, 
            PEHS,   1, 
                ,   7, 
            PEPS,   1, 
            BLLS,   1, 
            SBPS,   1, 
                    Offset (0x2A), 
            G00S,   1, 
            G01S,   1, 
            G02S,   1, 
            G03S,   1, 
            G04S,   1, 
            G05S,   1, 
            G06S,   1, 
            G07S,   1, 
            G08S,   1, 
            G09S,   1, 
            G0AS,   1, 
            G0BS,   1, 
            G0CS,   1, 
            G0DS,   1, 
            G0ES,   1, 
            G0FS,   1, 
                ,   1, 
            PEHE,   1, 
            TPOL,   1, 
                ,   6, 
            PEPE,   1, 
            BLLE,   1, 
            SBPE,   1, 
                    Offset (0x2E), 
            G00E,   1, 
            G01E,   1, 
            G02E,   1, 
            G03E,   1, 
            G04E,   1, 
            G05E,   1, 
            G06E,   1, 
            G07E,   1, 
            G08E,   1, 
            G09E,   1, 
            G0AE,   1, 
            G0BE,   1, 
            G0CE,   1, 
            G0DE,   1, 
            G0EE,   1, 
            G0FE,   1, 
                ,   4, 
            SLPE,   1, 
            APME,   1, 
                ,   5, 
            MCSE,   1, 
                ,   1, 
            TCOE,   1, 
            PERE,   1, 
                    Offset (0x32), 
                    Offset (0x34), 
                ,   4, 
            SLPS,   1, 
            APMS,   1, 
                ,   5, 
            MCSS,   1, 
                ,   1, 
            TCOS,   1, 
            PERS,   1, 
                    Offset (0x36), 
                    Offset (0x42), 
                ,   1, 
            GPEC,   1
        }

        OperationRegion (\GPIO, SystemIO, \GPBS, 0x40)
        Field (\GPIO, ByteAcc, NoLock, Preserve)
        {
                    Offset (0x0C), 
            GL00,   16, 
            GL10,   16, 
                    Offset (0x18), 
            GB00,   32, 
                    Offset (0x2C), 
            GP00,   16, 
                    Offset (0x38), 
            GL20,   32
        }

        OperationRegion (RCBA, SystemMemory, 0xFED1C000, 0x4000)
        Field (RCBA, ByteAcc, NoLock, Preserve)
        {
                    Offset (0x3418), 
            FDRT,   32
        }

        Method (RGPL, 2, Serialized)
        {
            Store (Arg1, Local0)
            Store (Zero, Local1)
            While (Local0)
            {
                ShiftLeft (Local1, 0x01, Local1)
                Or (Local1, 0x01, Local1)
                Decrement (Local0)
            }

            If (LLess (Arg0, 0x10))
            {
                ShiftLeft (Local1, Arg0, Local1)
                Store (GL00, Local0)
                And (Local0, Local1, Local0)
                ShiftRight (Local0, Arg0, Local0)
            }
            Else
            {
                If (LLess (Arg0, 0x20))
                {
                    Store (GL10, Local0)
                    Subtract (Arg0, 0x10, Local2)
                }
                Else
                {
                    Store (GL20, Local0)
                    Subtract (Arg0, 0x20, Local2)
                }

                ShiftLeft (Local1, Local2, Local1)
                And (Local0, Local1, Local0)
                ShiftRight (Local0, Local2, Local0)
            }

            Return (Local0)
        }

        Method (SGPL, 3, Serialized)
        {
            Store (Arg1, Local0)
            Store (Zero, Local1)
            While (Local0)
            {
                ShiftLeft (Local1, 0x01, Local1)
                Or (Local1, 0x01, Local1)
                Decrement (Local0)
            }

            If (LGreaterEqual (Arg0, 0x10))
            {
                If (LLess (Arg0, 0x20))
                {
                    Store (GL10, Local0)
                    Subtract (Arg0, 0x10, Local2)
                }
                Else
                {
                    Store (GL20, Local0)
                    Subtract (Arg0, 0x20, Local2)
                }

                ShiftLeft (Local1, Local2, Local1)
                Not (Local1, Local3)
                And (Local0, Local3, Local0)
                ShiftLeft (Arg2, Local2, Local4)
                Or (Local0, Local4, Local0)
                If (LLess (Arg0, 0x20))
                {
                    Store (Local0, GL10)
                }
                Else
                {
                    Store (Local0, GL20)
                }
            }
            Else
            {
                ShiftLeft (Local1, Arg0, Local1)
                Not (Local1, Local3)
                And (GL00, Local3, Local0)
                ShiftLeft (Arg2, Arg0, Local4)
                Or (Local0, Local4, Local0)
                Store (Local0, GL00)
            }
        }

        Method (RGPP, 1, Serialized)
        {
            ShiftRight (GP00, Arg0, Local0)
            And (Local0, 0x01, Local0)
            Return (Local0)
        }

        Method (TGPP, 1, Serialized)
        {
            ShiftLeft (0x01, Arg0, Local0)
            XOr (GP00, Local0, GP00)
        }

        Method (SGPP, 2, Serialized)
        {
            ShiftLeft (0x01, Arg0, Local0)
            If (Arg1)
            {
                Or (GP00, Local0, GP00)
            }
            Else
            {
                Not (Local0, Local1)
                And (GP00, Local1, GP00)
            }
        }

        Name (PMEW, Zero)
        Method (SBRS, 1, NotSerialized)
        {
            \CPXS ()
            \_SB.PCI0.USB0.USBS (Arg0)
            \_SB.PCI0.USB1.USBS (Arg0)
            \_SB.PCI0.USB2.USBS (Arg0)
            \_SB.PCI0.USB3.USBS (Arg0)
        }

        Method (SBRW, 1, NotSerialized)
        {
            Store (\SBPS, \PMEW)
            \_SB.PCI0.USB0.USBW (Arg0)
            \_SB.PCI0.USB1.USBW (Arg0)
            \_SB.PCI0.USB2.USBW (Arg0)
            \_SB.PCI0.USB3.USBW (Arg0)
        }

        Method (STRP, 1, NotSerialized)
        {
            If (Arg0)
            {
                Store (One, \SLPS)
                Store (One, \SLPE)
            }
            Else
            {
                Store (Zero, \SLPE)
                Store (One, \SLPS)
            }
        }

        Method (HKTH, 0, Serialized)
        {
            If (THLS)
            {
                Return (TTDT)
            }
            Else
            {
                Return (0xFFFF)
            }
        }

        Method (CPXS, 0, NotSerialized)
        {
            Store (0x00, Local0)
            Store (0x00010000, Local1)
            Store (0x000E0060, Local2)
            Store (0x000E00DC, Local3)
            While (LLess (Local0, 0x04))
            {
                If (LNot (And (\FDRT, Local1)))
                {
                    While (And (\_SB.RDPE (Local2), 0x00010000))
                    {
                        Or (\_SB.RDPE (Local2), 0x00010000, Local4)
                        \_SB.WDPE (Local2, Local4)
                    }

                    While (And (\_SB.RDPE (Local3), 0x80000000))
                    {
                        Or (\_SB.RDPE (Local3), 0x80000000, Local4)
                        \_SB.WDPE (Local3, Local4)
                    }
                }

                Add (Local2, 0x1000, Local2)
                Add (Local3, 0x1000, Local3)
                ShiftLeft (Local1, 0x01, Local1)
                Increment (Local0)
            }

            While (And (\PEPS, 0x01))
            {
                Or (\PEPS, 0x01, \PEPS)
            }
        }
    }

    Scope (\)
    {
        OperationRegion (SMB0, SystemIO, SMBS, 0x10)
        Field (SMB0, ByteAcc, NoLock, Preserve)
        {
            HSTS,   8, 
            SSTS,   8, 
            HSTC,   8, 
            HCMD,   8, 
            HADR,   8, 
            HDT0,   8, 
            HDT1,   8, 
            BLKD,   8, 
            SLCT,   8, 
            SHCM,   8, 
            SLEV,   16, 
            SLDT,   16, 
            SCFG,   8, 
            SADR,   8
        }

        Name (RBUF, Package (0x20) {})
        Method (HBSY, 0, NotSerialized)
        {
            Store (0x00FFFFFF, Local0)
            While (Local0)
            {
                And (HSTS, 0x01, Local1)
                If (LNot (Local1))
                {
                    Return (Zero)
                }

                Decrement (Local0)
            }

            Return (One)
        }

        Method (WTSB, 0, NotSerialized)
        {
            Store (0x00FFFFFF, Local0)
            While (Local0)
            {
                Decrement (Local0)
                And (HSTS, 0x1E, Local1)
                If (LEqual (Local1, 0x02))
                {
                    Return (One)
                }

                If (Local1)
                {
                    Return (Zero)
                }
            }

            Return (Zero)
        }

        Mutex (\P4SM, 0x00)
        Method (SBYT, 2, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Store (Arg0, HADR)
                    Store (Arg1, HCMD)
                    Store (0xFF, HSTS)
                    Store (0x44, HSTC)
                    If (WTSB ())
                    {
                        Release (\P4SM)
                        Return (One)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }

        Method (WBYT, 3, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Store (Arg0, HADR)
                    Store (Arg1, HCMD)
                    Store (Arg2, HDT0)
                    Store (0xFF, HSTS)
                    Store (0x48, HSTC)
                    If (WTSB ())
                    {
                        Release (\P4SM)
                        Return (One)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }

        Method (WWRD, 3, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Store (Arg0, HADR)
                    Store (Arg1, HCMD)
                    And (Arg2, 0xFF, Local1)
                    ShiftRight (Arg2, 0x08, Local2)
                    And (Local2, 0xFF, Local2)
                    Store (Local2, HDT0)
                    Store (Local1, HDT1)
                    Store (0xFF, HSTS)
                    Store (0x4C, HSTC)
                    If (WTSB ())
                    {
                        Release (\P4SM)
                        Return (One)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }

        Method (WBLK, 3, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Store (Arg0, HADR)
                    Store (Arg1, HCMD)
                    Store (HSTC, Local1)
                    Store (Arg2, Local2)
                    Store (0x00, Local1)
                    While (Local2)
                    {
                        Store (DerefOf (Index (RBUF, Local1)), BLKD)
                        Decrement (Local2)
                        Increment (Local1)
                    }

                    Store (Arg2, HDT0)
                    Store (HSTC, Local1)
                    Store (0xFF, HSTS)
                    Store (0x54, HSTC)
                    If (WTSB ())
                    {
                        Release (\P4SM)
                        Return (One)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }

        Method (RSBT, 2, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Or (Arg0, 0x01, HADR)
                    Store (Arg1, HCMD)
                    Store (0xFF, HSTS)
                    Store (0x44, HSTC)
                    If (WTSB ())
                    {
                        Release (\P4SM)
                        Return (HDT0)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }

        Method (RBYT, 2, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Or (Arg0, 0x01, HADR)
                    Store (Arg1, HCMD)
                    Store (0xFF, HSTS)
                    Store (0x48, HSTC)
                    If (WTSB ())
                    {
                        Release (\P4SM)
                        Return (HDT0)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }

        Method (RWRD, 2, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Or (Arg0, 0x01, HADR)
                    Store (Arg1, HCMD)
                    Store (0xFF, HSTS)
                    Store (0x4C, HSTC)
                    If (WTSB ())
                    {
                        Store (HDT0, Local1)
                        ShiftLeft (Local1, 0x08, Local1)
                        Store (HDT1, Local2)
                        Add (Local1, Local2, Local1)
                        Release (\P4SM)
                        Return (Local1)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }

        Method (RBLK, 3, Serialized)
        {
            If (LNotEqual (Acquire (\P4SM, 0xFFFF), 0x00))
            {
                Return (Ones)
            }

            Store (0x05, Local0)
            While (Local0)
            {
                If (HBSY ())
                {
                    Decrement (Local0)
                }
                Else
                {
                    Or (Arg0, 0x01, HADR)
                    Store (Arg1, HCMD)
                    Store (0xFF, HSTS)
                    Store (0x54, HSTC)
                    If (WTSB ())
                    {
                        Store (HSTC, Local1)
                        Store (HDT0, Local2)
                        Store (Local2, Local3)
                        Store (0x00, RBUF)
                        Store (0x00, Local1)
                        While (Local2)
                        {
                            Store (BLKD, Index (RBUF, Local1))
                            Decrement (Local2)
                            Increment (Local1)
                        }

                        Release (\P4SM)
                        Return (Local3)
                    }
                    Else
                    {
                        Decrement (Local0)
                    }
                }
            }

            Release (\P4SM)
            Return (Ones)
        }
    }

    Scope (\_SB)
    {
        Device (LID)
        {
            Name (_HID, EisaId ("PNP0C0D"))
            Method (_LID, 0, NotSerialized)
            {
                Store (One, Local0)
                Store (\_SB.PCI0.SBRG.EC0.RPIN (0x06), Local0)
                If (LEqual (Local0, Ones))
                {
                    Store (One, Local0)
                }

                Return (Local0)
            }
        }
    }

    Scope (\_GPE)
    {
    }

    Scope (\_SB.PCI0.SBRG.EC0)
    {
        Method (_Q85, 0, NotSerialized)
        {
            Notify (\_SB.LID, 0x80)
        }
    }

    Scope (\)
    {
        Method (\DIAG, 1, NotSerialized)
        {
            Store (Arg0, DBG8)
        }

        OperationRegion (\GPSC, SystemIO, 0xB2, 0x02)
        Field (\GPSC, ByteAcc, NoLock, Preserve)
        {
            SMCM,   8, 
            SMST,   8
        }

        Method (\ISMI, 1, Serialized)
        {
            Store (Arg0, SMCM)
        }

        Method (\ASMI, 1, Serialized)
        {
            Store (Arg0, ALPR)
            Store (0xA2, SMCM)
            Return (ALPR)
        }

        OperationRegion (\ECMS, SystemIO, 0x72, 0x02)
        Field (\ECMS, ByteAcc, Lock, Preserve)
        {
            EIND,   8, 
            EDAT,   8
        }

        IndexField (EIND, EDAT, ByteAcc, NoLock, Preserve)
        {
                    Offset (0x40), 
            IKFG,   8, 
            FRPN,   16, 
            RAMB,   32, 
            AVOL,   8, 
            LBTN,   8, 
            ERRF,   8, 
            OCLK,   8, 
            WIDE,   1, 
            OVCK,   2, 
            SLPN,   3, 
                    Offset (0x4C), 
            CPUR,   6, 
            CPUF,   2, 
            LBT2,   8, 
            PCMS,   8, 
            CLKS,   8, 
            CLKL,   8, 
            CLKD,   128, 
            ALSL,   8, 
            ALAE,   1, 
            ALDE,   1, 
            ALSP,   1, 
                    Offset (0x63), 
            WLDP,   1, 
            BTDP,   1, 
            WRST,   1, 
            BRST,   1, 
                    Offset (0x64), 
            ALPS,   1, 
                    Offset (0x65), 
            OSPM,   8, 
            TCGF,   8, 
            PPIS,   8, 
            PPIR,   8, 
            BAOT,   1, 
                    Offset (0x6A)
        }

        OperationRegion (RAMW, SystemMemory, RAMB, 0x0100)
        Field (RAMW, AnyAcc, NoLock, Preserve)
        {
            TRTY,   8, 
            FSFN,   8, 
            FSTA,   16, 
            FADR,   32, 
            FSIZ,   16, 
            ACTD,   8, 
            AVLD,   8, 
            SETD,   8, 
            ACPF,   8, 
            DCPF,   8, 
            DCP2,   8, 
            DCTP,   8, 
            CTPY,   8, 
            PADL,   16, 
            CADL,   16, 
            CSTE,   16, 
            NSTE,   16, 
            SSTE,   16, 
            SFUN,   8, 
            TPSV,   8, 
            TAC0,   8, 
            TCRT,   8, 
            TDO1,   8, 
            TDO2,   8, 
            PPSV,   8, 
            PAC0,   8, 
            T0HL,   8, 
            T0LL,   8, 
            T0F1,   8, 
            T0F2,   8, 
            T1HL,   8, 
            T1LL,   8, 
            T1F1,   8, 
            T1F2,   8, 
            T2HL,   8, 
            T2LL,   8, 
            T2F1,   8, 
            T2F2,   8, 
            T3HL,   8, 
            T3LL,   8, 
            T3F1,   8, 
            T3F2,   8, 
            T4HL,   8, 
            T4LL,   8, 
            T4F1,   8, 
            T4F2,   8, 
            T5HL,   8, 
            T5LL,   8, 
            T5F1,   8, 
            T5F2,   8, 
            T6HL,   8, 
            T6LL,   8, 
            T6F1,   8, 
            T6F2,   8, 
            T7HL,   8, 
            T7LL,   8, 
            T7F1,   8, 
            T7F2,   8, 
            SLPT,   8, 
            AIBF,   8, 
            IDES,   8, 
            VGAF,   16, 
            C4CP,   8, 
            LUXS,   8, 
            LUXL,   8, 
            LUXH,   8, 
            LUXF,   8, 
            MNAM,   64, 
            DBR1,   32, 
            DBR2,   32, 
            DBR3,   32, 
            DBR4,   32, 
            LCDV,   32, 
            LCDR,   8, 
            PTIM,   8, 
            PTMP,   8, 
            SMIF,   8, 
            DTSE,   8, 
            DTS1,   8, 
            DTS2,   8, 
            MPEN,   8, 
            BIPA,   32, 
            ALPR,   32, 
            PSTN,   16, 
            GNBF,   32
        }

        OperationRegion (\DBGM, SystemMemory, 0x000D0000, 0x04)
        Field (\DBGM, DWordAcc, NoLock, Preserve)
        {
            DBGG,   32
        }

        Name (OSFG, 0x00)
        Name (OS9X, 0x01)
        Name (OS98, 0x02)
        Name (OSME, 0x04)
        Name (OS2K, 0x08)
        Name (OSXP, 0x10)
        Name (OSVT, 0x20)
        Name (SLMT, 0x00)
        Method (MSOS, 0, NotSerialized)
        {
            If (CondRefOf (\_OSI, Local0))
            {
                If (\_OSI ("Windows 2001"))
                {
                    Store (OSXP, OSFG)
                }

                If (\_OSI ("Windows 2001 SP1"))
                {
                    Store (OSXP, OSFG)
                }

                If (\_OSI ("Windows 2001 SP2"))
                {
                    Store (OSXP, OSFG)
                }

                If (\_OSI ("Windows 2006"))
                {
                    Store (OSVT, OSFG)
                }

                Return (OSFG)
            }
            Else
            {
                If (MCTH (\_OS, "Microsoft Windows"))
                {
                    Store (OS98, OSFG)
                }
                Else
                {
                    If (MCTH (\_OS, "Microsoft WindowsME: Millennium Edition"))
                    {
                        Store (OSME, OSFG)
                    }
                    Else
                    {
                        If (MCTH (\_OS, "Microsoft Windows NT"))
                        {
                            Store (OS2K, OSFG)
                        }
                        Else
                        {
                            Store (OSXP, OSFG)
                        }
                    }
                }
            }

            Return (OSFG)
        }

        Method (\DBGR, 4, NotSerialized)
        {
            Store (Arg0, DBR1)
            Store (Arg1, DBR2)
            Store (Arg2, DBR3)
            Store (Arg3, DBR4)
            \ISMI (0x96)
        }

        Name (ONAM, "ASUSTEK")
        Method (ADVG, 0, NotSerialized)
        {
            If (\_SB.PCI0.P0P1.VGA.PRST ())
            {
                Return (\_SB.PCI0.P0P1.VGA.ADVD ())
            }

            Return (0x03)
        }

        Method (SWHG, 1, Serialized)
        {
            If (\_SB.PCI0.P0P1.VGA.PRST ())
            {
                \_SB.PCI0.P0P1.VGA.SWHD (Arg0)
                Return (One)
            }

            Return (Zero)
        }

        Method (NATK, 0, NotSerialized)
        {
            If (\_SB.PCI0.P0P1.VGA.PRST ())
            {
                Return (\_SB.PCI0.P0P1.VGA.NATK ())
            }

            Return (One)
        }

        Name (PWAC, Buffer (0x10)
        {
            /* 0000 */    0x17, 0x2E, 0x3D, 0x49, 0x58, 0x60, 0x64, 0x68, 
            /* 0008 */    0x6C, 0x70, 0x73, 0x77, 0x7B, 0x7F, 0x83, 0x88
        })
        Name (PWDC, Buffer (0x10)
        {
            /* 0000 */    0x0F, 0x26, 0x36, 0x41, 0x51, 0x58, 0x5C, 0x60, 
            /* 0008 */    0x64, 0x68, 0x6C, 0x70, 0x73, 0x77, 0x7B, 0x7F
        })
    }

    Scope (\_SB.PCI0)
    {
        Method (_INI, 0, NotSerialized)
        {
            Store (\MSOS (), \OSPM)
            If (\ACPF)
            {
                ShiftRight (PSTN, 0x08, SLMT)
            }
            Else
            {
                And (PSTN, 0xFF, SLMT)
            }
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (AC0)
        {
            Name (_HID, "ACPI0003")
            Method (_PSR, 0, NotSerialized)
            {
                Return (\_SB.PCI0.SBRG.EC0.ACAP ())
            }

            Name (_PCL, Package (0x01)
            {
                \_SB.PCI0
            })
        }
    }

    Scope (\_SB.PCI0.SBRG.EC0)
    {
        Method (ACAP, 0, Serialized)
        {
            Return (\ACPF)
        }

        Method (_QA0, 0, NotSerialized)
        {
            If (ACPS ())
            {
                Store (One, \ACPF)
                Store (0x58, Local0)
                ShiftRight (PSTN, 0x08, SLMT)
            }
            Else
            {
                Store (Zero, \ACPF)
                Store (0x57, Local0)
                And (PSTN, 0xFF, SLMT)
            }

            If (LNotEqual (OSFG, OSVT))
            {
                STBR ()
            }

            Notify (\_SB.PCI0.AC0, 0x80)
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, Local0)
            }

            Sleep (0x64)
            Notify (\_PR.CPU1, 0x80)
            Notify (\_PR.CPU1, 0x81)
            If (LGreaterEqual (\_PR.CPU1.NCPU, 0x02))
            {
                Notify (\_PR.CPU2, 0x80)
                Notify (\_PR.CPU2, 0x81)
            }

            Sleep (0x0A)
            NBAT (0x80)
        }
    }

    Scope (\_SB.PCI0)
    {
        Device (BAT0)
        {
            Name (_HID, EisaId ("PNP0C0A"))
            Name (_UID, 0x00)
            Name (_PCL, Package (0x01)
            {
                \_SB.PCI0
            })
            Method (_STA, 0, NotSerialized)
            {
                If (\_SB.PCI0.SBRG.EC0.BATP (0x00))
                {
                    Return (0x1F)
                }
                Else
                {
                    Return (0x0F)
                }
            }

            Name (LOW2, 0x012C)
            Name (DVOT, 0x0E)
            Name (PUNT, One)
            Name (LFCC, 0x1770)
            Name (NBIF, Package (0x0D)
            {
                0x00, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0x01, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                "", 
                "", 
                "", 
                ""
            })
            Name (PBIF, Package (0x0D)
            {
                0x01, 
                0x1770, 
                0x1770, 
                0x01, 
                0x39D0, 
                0x0258, 
                0x012C, 
                0x3C, 
                0x3C, 
                "M3N", 
                " ", 
                "LIon", 
                "ASUSTek"
            })
            Name (PBST, Package (0x04)
            {
                0x00, 
                0xFFFFFFFF, 
                0xFFFFFFFF, 
                0xFFFFFFFF
            })
            Method (FBIF, 5, NotSerialized)
            {
                Store (Arg0, PUNT)
                Store (Arg1, Local1)
                Store (Arg2, Local2)
                If (LEqual (PUNT, 0x00))
                {
                    Multiply (Local1, 0x0A, Local1)
                    Multiply (Local2, 0x0A, Local2)
                }

                Store (Arg0, Index (PBIF, 0x00))
                Store (Local1, Index (PBIF, 0x01))
                Store (Local2, Index (PBIF, 0x02))
                Store (Local2, LFCC)
                Store (Arg3, Index (PBIF, 0x03))
                Store (Arg4, Index (PBIF, 0x04))
                Divide (Local1, 0x0A, Local3, Local5)
                Store (Local5, Index (PBIF, 0x05))
                ShiftRight (Local5, 0x01, Local6)
                Store (Local6, Index (PBIF, 0x06))
                Store (Local6, LOW2)
                Divide (Local1, 0x64, Local3, Local7)
                Store (Local7, Index (PBIF, 0x07))
                Store (Local7, Index (PBIF, 0x08))
            }

            Method (CBIF, 0, NotSerialized)
            {
                If (PUNT)
                {
                    Store (DerefOf (Index (PBIF, 0x04)), Local0)
                    Add (Local0, 0x01F4, Local0)
                    Divide (Local0, 0x03E8, Local1, DVOT)
                    Store (Zero, Index (PBIF, 0x00))
                    Multiply (DerefOf (Index (PBIF, 0x01)), DVOT, Index (PBIF, 0x01
                        ))
                    Multiply (DerefOf (Index (PBIF, 0x02)), DVOT, Index (PBIF, 0x02
                        ))
                    Multiply (DerefOf (Index (PBIF, 0x05)), DVOT, Index (PBIF, 0x05
                        ))
                    Multiply (DerefOf (Index (PBIF, 0x06)), DVOT, Index (PBIF, 0x06
                        ))
                    Multiply (DerefOf (Index (PBIF, 0x07)), DVOT, Index (PBIF, 0x07
                        ))
                    Multiply (DerefOf (Index (PBIF, 0x08)), DVOT, Index (PBIF, 0x08
                        ))
                }
            }

            Method (_BIF, 0, NotSerialized)
            {
                If (LNot (\_SB.PCI0.SBRG.EC0.BATP (0x00)))
                {
                    Return (NBIF)
                }

                If (LEqual (\_SB.PCI0.SBRG.EC0.GBTT (0x00), 0xFF))
                {
                    Return (NBIF)
                }

                BATS (0x00)
                Store (\_SB.PCI0.SBRG.EC0.BIF9 (), Index (PBIF, 0x09))
                Store (\ONAM, Index (PBIF, 0x0C))
                Store (\_SB.PCI0.SBRG.EC0.BIF0 (), Local0)
                Store (\_SB.PCI0.SBRG.EC0.BIF1 (), Local1)
                Store (\_SB.PCI0.SBRG.EC0.BIF2 (), Local2)
                Store (\_SB.PCI0.SBRG.EC0.BIF3 (), Local3)
                Store (\_SB.PCI0.SBRG.EC0.BIF4 (), Local4)
                BATR ()
                If (LNotEqual (Local0, Ones))
                {
                    If (LNotEqual (Local1, Ones))
                    {
                        If (LNotEqual (Local2, Ones))
                        {
                            If (LNotEqual (Local3, Ones))
                            {
                                If (LNotEqual (Local4, Ones))
                                {
                                    FBIF (Local0, Local1, Local2, Local3, Local4)
                                    CBIF ()
                                }
                            }
                        }
                    }
                }

                If (LEqual (PUNT, 0x00))
                {
                    Multiply (Local2, 0x0A, Local2)
                }

                Store (Local2, LFCC)
                Return (PBIF)
            }

            Method (FBST, 4, NotSerialized)
            {
                And (Arg1, 0xFFFF, Local1)
                Store (Zero, Local0)
                If (\_SB.PCI0.SBRG.EC0.ACAP ())
                {
                    Store (One, Local0)
                }

                If (Local0)
                {
                    If (CHGS (0x00))
                    {
                        Store (0x02, Local0)
                    }
                    Else
                    {
                        Store (Zero, Local0)
                    }
                }
                Else
                {
                    Store (0x01, Local0)
                }

                And (Arg0, 0x0300, Local2)
                If (Local2)
                {
                    ShiftLeft (One, 0x02, Local2)
                    Or (Local0, Local2, Local0)
                }

                If (LGreaterEqual (Local1, 0x8000))
                {
                    Subtract (0xFFFF, Local1, Local1)
                }

                Store (Arg2, Local2)
                If (LEqual (PUNT, 0x00))
                {
                    Multiply (Local1, DVOT, Local1)
                    Multiply (Local2, 0x0A, Local2)
                }

                And (Local0, 0x02, Local3)
                If (LNot (Local3))
                {
                    Subtract (LFCC, Local2, Local3)
                    Divide (LFCC, 0xC8, Local4, Local5)
                    If (LLess (Local3, Local5))
                    {
                        Store (LFCC, Local2)
                    }
                }
                Else
                {
                    Divide (LFCC, 0xC8, Local4, Local5)
                    Subtract (LFCC, Local5, Local4)
                    If (LGreater (Local2, Local4))
                    {
                        Store (Local4, Local2)
                    }
                }

                If (LNot (\_SB.PCI0.SBRG.EC0.ACAP ()))
                {
                    Divide (Local2, \MBLF, Local3, Local4)
                    If (LLess (Local1, Local4))
                    {
                        Store (Local4, Local1)
                    }
                }

                Store (Local0, Index (PBST, 0x00))
                Store (Local1, Index (PBST, 0x01))
                Store (Local2, Index (PBST, 0x02))
                Store (Arg3, Index (PBST, 0x03))
            }

            Method (CBST, 0, NotSerialized)
            {
                If (PUNT)
                {
                    Multiply (DerefOf (Index (PBST, 0x01)), DVOT, Index (PBST, 0x01
                        ))
                    Multiply (DerefOf (Index (PBST, 0x02)), DVOT, Index (PBST, 0x02
                        ))
                }
            }

            Method (_BST, 0, NotSerialized)
            {
                If (LNot (\_SB.PCI0.SBRG.EC0.BATP (0x00)))
                {
                    Store (Zero, Index (PBST, 0x00))
                    Store (Ones, Index (PBST, 0x01))
                    Store (Ones, Index (PBST, 0x02))
                    Store (Ones, Index (PBST, 0x03))
                    Return (PBST)
                }

                If (LEqual (\_SB.PCI0.SBRG.EC0.GBTT (0x00), 0xFF))
                {
                    Store (Zero, Index (PBST, 0x00))
                    Store (Ones, Index (PBST, 0x01))
                    Store (Ones, Index (PBST, 0x02))
                    Store (Ones, Index (PBST, 0x03))
                    Return (PBST)
                }

                If (\MES4)
                {
                    Decrement (\MES4)
                    Return (PBST)
                }

                BATS (0x00)
                Store (\_SB.PCI0.SBRG.EC0.BSTS (), Local0)
                Store (\_SB.PCI0.SBRG.EC0.BCRT (), Local1)
                Store (\_SB.PCI0.SBRG.EC0.BRCP (), Local2)
                Store (\_SB.PCI0.SBRG.EC0.BVOT (), Local3)
                BATR ()
                If (LNotEqual (Local0, Ones))
                {
                    If (LNotEqual (Local1, Ones))
                    {
                        If (LNotEqual (Local2, Ones))
                        {
                            If (LNotEqual (Local3, Ones))
                            {
                                FBST (Local0, Local1, Local2, Local3)
                                CBST ()
                            }
                        }
                    }
                }

                Return (PBST)
            }
        }
    }

    Scope (\_SB.PCI0)
    {
        Name (B0CR, 0x00)
        Name (B1CR, 0x00)
        Method (GGCC, 1, Serialized)
        {
            BATS (Arg0)
            Store (\_SB.PCI0.SBRG.EC0.BCRT (), Local0)
            BATR ()
            If (LEqual (Local0, Ones))
            {
                If (Arg0)
                {
                    Store (B1CR, Local0)
                }
                Else
                {
                    Store (B0CR, Local0)
                }
            }

            And (Local0, 0x8000, Local1)
            If (Local1)
            {
                Store (0x00, Local0)
            }

            If (Arg0)
            {
                Store (Local0, B1CR)
            }
            Else
            {
                Store (Local0, B0CR)
            }

            Return (Local0)
        }
    }

    Scope (\_SB.PCI0.SBRG.EC0)
    {
        Name (BADR, 0x0B)
        Name (CADR, 0x09)
        Name (SADR, 0x0A)
        Method (ALMH, 1, NotSerialized)
        {
            If (LEqual (Arg0, BADR))
            {
                NBAT (0x80)
            }
        }

        Method (BIFW, 1, NotSerialized)
        {
            Store (SMBR (RDWD, BADR, Arg0), Local0)
            Store (DerefOf (Index (Local0, 0x00)), Local1)
            If (Local1)
            {
                Return (Ones)
            }
            Else
            {
                Return (DerefOf (Index (Local0, 0x02)))
            }
        }

        Method (BIF0, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1MD, Local0)
                }
                Else
                {
                    Store (B0MD, Local0)
                }

                If (LNotEqual (Local0, 0xFFFF))
                {
                    ShiftRight (Local0, 0x0F, Local1)
                    And (Local1, 0x01, Local1)
                    XOr (Local1, 0x01, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BIF1, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1DC, Local0)
                }
                Else
                {
                    Store (B0DC, Local0)
                }

                And (Local0, 0xFFFF, Local0)
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BIF2, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1FC, Local0)
                }
                Else
                {
                    Store (B0FC, Local0)
                }

                And (Local0, 0xFFFF, Local0)
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BIF3, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1MD, Local0)
                }
                Else
                {
                    Store (B0MD, Local0)
                }

                If (LNotEqual (Local0, 0xFFFF))
                {
                    ShiftRight (Local0, 0x09, Local0)
                    And (Local0, 0x01, Local0)
                    XOr (Local0, 0x01, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BIF4, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1DV, Local0)
                }
                Else
                {
                    Store (B0DV, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BIF9, 0, NotSerialized)
        {
            Name (BSTR, Buffer (0x20) {})
            Store (SMBR (RDBL, BADR, 0x21), Local0)
            If (LNotEqual (DerefOf (Index (Local0, 0x00)), 0x00))
            {
                Store (\MNAM, BSTR)
                Store (0x00, Index (BSTR, 0x04))
            }
            Else
            {
                Store (DerefOf (Index (Local0, 0x02)), BSTR)
                Store (0x00, Index (BSTR, DerefOf (Index (Local0, 0x01))))
            }

            Return (BSTR)
        }

        Method (BIFA, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1SN, Local0)
                }
                Else
                {
                    Store (B0SN, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BSTS, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1ST, Local0)
                }
                Else
                {
                    Store (B0ST, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BCRT, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1CC, Local0)
                }
                Else
                {
                    Store (B0CC, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BRCP, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1RC, Local0)
                }
                Else
                {
                    Store (B0RC, Local0)
                }

                If (LEqual (Local0, 0xFFFF))
                {
                    Store (Ones, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }

        Method (BVOT, 0, NotSerialized)
        {
            If (ECAV ())
            {
                If (BSLF)
                {
                    Store (B1VL, Local0)
                }
                Else
                {
                    Store (B0VL, Local0)
                }
            }
            Else
            {
                Store (Ones, Local0)
            }

            Return (Local0)
        }
    }

    Scope (\)
    {
        Method (CHGS, 1, Serialized)
        {
            Store (\_SB.PCI0.SBRG.EC0.BCHG (Arg0), Local0)
            Return (Local0)
        }

        Name (BSLF, Zero)
        Method (BATS, 1, Serialized)
        {
            If (Arg0)
            {
                Store (One, BSLF)
            }
            Else
            {
                Store (Zero, BSLF)
            }
        }

        Method (BATR, 0, Serialized)
        {
        }
    }

    Scope (\_SB.PCI0.SBRG.EC0)
    {
        Method (_QA1, 0, NotSerialized)
        {
            Store (DCPS (0x00), \DCPF)
            If (\DCPF)
            {
                Sleep (0x07D0)
            }

            Notify (\_SB.PCI0.BAT0, 0x80)
            Notify (\_SB.PCI0.BAT0, 0x81)
        }

        Method (_QA5, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x6E)
            }
            Else
            {
                If (BATP (0x00))
                {
                    Notify (\_SB.PCI0.BAT0, 0x80)
                }
            }
        }

        Method (_QA3, 0, NotSerialized)
        {
            If (BATP (0x00))
            {
                Store (BCLE (0x00), Local0)
                If (LEqual (Local0, 0x00))
                {
                    Notify (\_SB.PCI0.BAT0, 0x81)
                }
                Else
                {
                    Notify (\_SB.PCI0.BAT0, 0x81)
                    Notify (\_SB.PCI0.AC0, 0x80)
                }
            }
        }

        Method (BATP, 1, Serialized)
        {
            If (Arg0)
            {
                Return (\DCP2)
            }
            Else
            {
                Return (\DCPF)
            }
        }

        Method (NBAT, 1, NotSerialized)
        {
            If (BATP (0x00))
            {
                Notify (\_SB.PCI0.BAT0, Arg0)
            }
        }
    }

    Scope (\_SB)
    {
        Device (PWRB)
        {
            Name (_HID, EisaId ("PNP0C0C"))
            Method (_PRW, 0, NotSerialized)
            {
                Return (Package (0x02)
                {
                    0x0B, 
                    0x04
                })
            }
        }
    }

    Scope (\_SB)
    {
        Device (SLPB)
        {
            Name (_HID, EisaId ("PNP0C0E"))
            Method (_PRW, 0, NotSerialized)
            {
                Return (Package (0x02)
                {
                    0x0B, 
                    0x04
                })
            }
        }
    }

    Scope (\)
    {
        Name (MES4, Zero)
        Method (OEMS, 1, NotSerialized)
        {
            If (LEqual (Arg0, 0x03))
            {
                If (LLessEqual (\OSFG, \OSME))
                {
                    Store (One, \WIDE)
                }
                Else
                {
                    Store (Zero, \WIDE)
                }
            }

            SBRS (Arg0)
            \_SB.PCI0.SBRG.EC0.EC0S (Arg0)
            If (LEqual (Arg0, 0x04))
            {
                If (LEqual (OSFG, OS2K))
                {
                    Store (Arg0, SLPN)
                }
            }

            Store (Arg0, SLPN)
            Add (Arg0, 0xD0, DBG8)
            Store (Arg0, SLPT)
            If (Arg0)
            {
                STRP (0x01)
            }

            PRJS (Arg0)
            ISMI (0x9D)
        }

        Method (OEMW, 1, NotSerialized)
        {
            If (\_SB.PCI0.SBRG.EC0.ACPS ())
            {
                ShiftRight (PSTN, 0x08, SLMT)
            }
            Else
            {
                And (PSTN, 0xFF, SLMT)
            }

            ISMI (0x9E)
            Store (Zero, SLPT)
            \_SB.PCI0.SBRG.EC0.EC0W (Arg0)
            If (LEqual (Arg0, 0x04))
            {
                If (LLessEqual (\OSFG, \OSME))
                {
                    Store (0x02, MES4)
                }
                Else
                {
                    Store (Zero, MES4)
                }
            }

            SBRW (Arg0)
            If (LEqual (Arg0, 0x04))
            {
                Notify (\_SB.SLPB, 0x02)
            }

            PRJW (Arg0)
            Add (Arg0, 0xF0, DBG8)
        }
    }

    Scope (\_SB.ATKD)
    {
        Method (FSMI, 1, NotSerialized)
        {
            Store (Arg0, \FSFN)
            Or (Arg0, 0xA0, Local0)
            Store (Local0, \DBG8)
            ISMI (0x90)
            Return (\FSTA)
        }

        Method (FLSH, 1, NotSerialized)
        {
            Store (Arg0, \FSTA)
            FSMI (0x00)
        }

        Method (FINI, 1, NotSerialized)
        {
            Store (Arg0, \FADR)
            Return (FSMI (0x01))
        }

        Method (FERS, 1, NotSerialized)
        {
            Store (Arg0, \FSTA)
            Return (FSMI (0x02))
        }

        Method (FWRI, 1, NotSerialized)
        {
            Store (Arg0, \FADR)
            Store (0x1000, \FSIZ)
            Return (Subtract (0x1000, FSMI (0x03)))
        }

        Method (FWRP, 0, NotSerialized)
        {
            Store (0x00, \FSIZ)
            Return (Subtract (0x1000, FSMI (0x03)))
        }

        Method (FEBW, 1, NotSerialized)
        {
            Store (Arg0, \FADR)
            Return (FSMI (0x04))
        }

        Method (FEBR, 1, NotSerialized)
        {
            Store (Arg0, \FADR)
            Return (FSMI (0x05))
        }

        Method (FEDW, 0, NotSerialized)
        {
            Return (FSMI (0x06))
        }

        Method (ECSR, 1, NotSerialized)
        {
            Store (Arg0, \FSTA)
            Return (FSMI (0x07))
        }
    }

    Scope (\_SB.ATKD)
    {
        Method (AGFN, 1, Serialized)
        {
            If (LEqual (Arg0, 0x00))
            {
                Return (GNBF)
            }

            Store (0x00, Local0)
            OperationRegion (\PARM, SystemMemory, Arg0, 0x08)
            Field (\PARM, DWordAcc, NoLock, Preserve)
            {
                MFUN,   16, 
                SFUN,   16, 
                LEN,    16, 
                STAS,   8, 
                EROR,   8
            }

            Store (0x00, EROR)
            Store (0x01, STAS)
            If (LEqual (MFUN, 0x20))
            {
                BSMI (Arg0)
                And (STAS, 0xFE, STAS)
            }

            If (LEqual (STAS, 0x01))
            {
                Store (0x01, EROR)
                Or (STAS, 0x02, STAS)
            }

            Or (STAS, 0x80, STAS)
            Return (0x00)
        }

        Method (BSMI, 1, Serialized)
        {
            Store (Arg0, \BIPA)
            ISMI (0xA1)
        }
    }

    Scope (\)
    {
        Method (ACPS, 0, Serialized)
        {
            Store (\_SB.PCI0.SBRG.EC0.RPIN (0x03), Local0)
            XOr (Local0, 0x01, Local0)
            Return (Local0)
        }

        Method (DCPS, 1, Serialized)
        {
            Store (\_SB.PCI0.SBRG.EC0.RPIN (0x04), Local0)
            XOr (Local0, 0x01, Local0)
            Return (Local0)
        }

        Name (LCDB, 0x00)
        Method (PRJS, 1, Serialized)
        {
        }

        Method (PRJW, 1, Serialized)
        {
            Notify (\_PR.CPU1, 0x80)
            Notify (\_PR.CPU1, 0x81)
            If (LGreaterEqual (\_PR.CPU1.NCPU, 0x02))
            {
                Notify (\_PR.CPU2, 0x80)
                Notify (\_PR.CPU2, 0x81)
            }
        }

        Method (GLID, 0, Serialized)
        {
            Return (\_SB.PCI0.SBRG.EC0.RPIN (0x06))
        }

        Method (TLID, 0, Serialized)
        {
        }

        Method (TGAC, 0, Serialized)
        {
        }

        Method (TGDC, 1, Serialized)
        {
        }

        Method (FCTR, 3, Serialized)
        {
        }

        Method (OTLD, 1, Serialized)
        {
            \SGPL (0x13, 0x01, Arg0)
            \SGPL (0x0E, 0x01, Arg0)
        }

        Method (OWLD, 1, Serialized)
        {
            If (WLDP)
            {
                Store (Arg0, WRST)
                \SGPL (0x07, 0x01, Arg0)
            }
        }

        Method (OBTD, 1, Serialized)
        {
            If (BTDP)
            {
                Store (Arg0, BRST)
                \SGPL (0x06, 0x01, Arg0)
                \SGPL (0x21, 0x01, LNot (Arg0))
                \_SB.PCI0.SBRG.EC0.SPIN (0x1C, LNot (Arg0))
            }
        }

        Method (OHWR, 0, Serialized)
        {
            Store (Zero, Local0)
            Or (Local0, 0x02, Local0)
            Or (Local0, 0x0400, Local0)
            Store (\_SB.PCI0.SBRG.EC0.RPIN (0x15), Local1)
            If (Local1)
            {
                And (Local0, 0xFFFE, Local0)
            }
            Else
            {
                Or (Local0, 0x01, Local0)
            }

            If (WLDP)
            {
                Or (Local0, 0x80, Local0)
            }

            If (BTDP)
            {
                Or (Local0, 0x0100, Local0)
            }

            Return (Local0)
        }

        Method (ORST, 0, Serialized)
        {
            Store (0x00, Local0)
            If (WRST)
            {
                Or (Local0, 0x01, Local0)
            }

            If (BRST)
            {
                Or (Local0, 0x02, Local0)
            }

            Return (Local0)
        }

        Method (OLCD, 0, Serialized)
        {
            If (LEqual (LCDV, 0x0C32C100))
            {
                Store (0xAF0D1526, LCDV)
            }

            Return (LCDV)
        }

        Method (GBTL, 0, Serialized)
        {
            Return (\_SB.PCI0.SBRG.EC0.RPIN (0x02))
        }

        Method (SBTL, 1, Serialized)
        {
            \_SB.PCI0.SBRG.EC0.SPIN (0x02, Arg0)
        }

        Method (BL2C, 0, NotSerialized)
        {
            Return (Zero)
        }

        Method (STCF, 1, Serialized)
        {
            If (LEqual (Arg0, 0x01))
            {
                \_SB.PCI0.SBRG.EC0.FNCT (0x84, 0x00)
            }
        }

        Method (OTGB, 0, Serialized)
        {
            Store (One, Local0)
            Return (Local0)
        }

        Method (OTPM, 0, Serialized)
        {
            Store (\_SB.PCI0.SBRG.TPM.ACCS, Local0)
            If (LNotEqual (Local0, 0xFF))
            {
                Store (0x01, Local0)
            }
            Else
            {
                Store (0x00, Local0)
            }

            Return (Local0)
        }

        Method (OTID, 0, Serialized)
        {
            Store (\_SB.PCI0.SBRG.TPM.ACCS, Local0)
            If (LNotEqual (Local0, 0xFF))
            {
                If (LEqual (\_SB.PCI0.SBRG.TPM.VDID, 0x687119FA))
                {
                    Return (0x0435CF4D)
                }
            }

            Return (0x0201D824)
        }
    }

    Scope (\_SB.ATKD)
    {
        Method (QMOD, 1, Serialized)
        {
            If (LEqual (Arg0, 0x00))
            {
                Return (0x01)
            }

            If (LEqual (Arg0, 0x01))
            {
                \_SB.PCI0.SBRG.EC0.WMFN (0x7F)
                Return (0x01)
            }

            If (LEqual (Arg0, 0x02))
            {
                \_SB.PCI0.SBRG.EC0.WMFN (0xFF)
                Return (0x01)
            }

            Return (0x01)
        }
    }

    Scope (\_GPE)
    {
        Method (_L03, 0, Serialized)
        {
            Notify (\_SB.PCI0.USB0, 0x02)
        }

        Method (_L04, 0, Serialized)
        {
            Notify (\_SB.PCI0.USB1, 0x02)
        }

        Method (_L0C, 0, Serialized)
        {
            Notify (\_SB.PCI0.USB2, 0x02)
        }

        Method (_L0E, 0, Serialized)
        {
            Notify (\_SB.PCI0.USB3, 0x02)
        }

        Method (_L0D, 0, Serialized)
        {
            Notify (\_SB.PCI0.EUSB, 0x02)
        }

        Method (_L05, 0, Serialized)
        {
            Notify (\_SB.PCI0.MC97, 0x02)
        }

        Method (_L0B, 0, Serialized)
        {
            If (\PMEW)
            {
                Notify (\_SB.PCI0.P0P1, 0x02)
                Store (Zero, \PMEW)
            }
            Else
            {
            }
        }

        Method (_L01, 0, NotSerialized)
        {
            If (LNot (And (\FDRT, 0x00010000)))
            {
                Store (\_SB.RBPE (0x000E005A), Local0)
                Store (\_SB.RBPE (0x000E00DF), Local1)
                If (And (Local1, 0x40))
                {
                    \_SB.WBPE (0x000E005A, 0x08)
                    \_SB.WBPE (0x000E00DF, 0x40)
                    Notify (\_SB.PCI0.P0P1, 0x01)
                }
            }

            If (LNot (And (\FDRT, 0x00020000)))
            {
                Store (\_SB.RBPE (0x000E105A), Local0)
                Store (\_SB.RBPE (0x000E10DF), Local1)
                If (And (Local1, 0x40))
                {
                    \_SB.WBPE (0x000E105A, 0x08)
                    \_SB.WBPE (0x000E10DF, 0x40)
                    Notify (\_SB.PCI0.P0P2, 0x01)
                }
            }

            If (LNot (And (\FDRT, 0x00040000)))
            {
                Store (\_SB.RBPE (0x000E205A), Local0)
                Store (\_SB.RBPE (0x000E20DF), Local1)
                If (And (Local1, 0x40))
                {
                    \_SB.WBPE (0x000E205A, 0x08)
                    \_SB.WBPE (0x000E20DF, 0x40)
                    Notify (\_SB.PCI0.P0P4, 0x01)
                }
            }
        }

        Method (_L09, 0, NotSerialized)
        {
            Store (\_SB.RBPE (0x000E1062), Local0)
            While (And (Local0, 0x01))
            {
                \_SB.WBPE (0x000E1062, Local0)
                \_SB.WBPE (0x000E00DF, 0x80)
                Store (\_SB.RBPE (0x000E1062), Local0)
            }

            Notify (\_SB.PCI0.P0P3.MPCI, 0x02)
        }
    }

    Scope (\_SB.PCI0.SBRG.EC0)
    {
        Method (_Q01, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x52)
            }
        }

        Method (_Q02, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x53)
            }
        }

        Method (_Q03, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x54)
            }
        }

        Method (_Q04, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x55)
            }
        }

        Method (_Q05, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x56)
            }
        }

        Method (_Q0A, 0, NotSerialized)
        {
            Notify (\_SB.SLPB, 0x80)
        }

        Method (_Q0B, 0, NotSerialized)
        {
            If (And (\_SB.ATKD.WAPF, 0x04))
            {
                If (\_SB.ATKP)
                {
                    Notify (\_SB.ATKD, 0x88)
                }
            }
        }

        Method (_Q0E, 0, NotSerialized)
        {
            If (LEqual (OSFG, OSVT))
            {
                If (\_SB.PCI0.P0P1.VGA.PRST ())
                {
                    Store (0x02, \_SB.PCI0.P0P1.VGA.LCDD.BCBH)
                    Notify (\_SB.PCI0.P0P1.VGA.LCDD, 0x87)
                }
            }
            Else
            {
                If (LGreater (LBTN, 0x00))
                {
                    Decrement (LBTN)
                }

                If (LGreater (LBTN, 0x0F))
                {
                    Store (0x0F, LBTN)
                }

                STBR ()
                If (\_SB.ATKP)
                {
                    Notify (\_SB.ATKD, Add (LBTN, 0x20))
                }
            }

            Return (One)
        }

        Method (_Q0F, 0, NotSerialized)
        {
            If (LEqual (OSFG, OSVT))
            {
                If (\_SB.PCI0.P0P1.VGA.PRST ())
                {
                    Store (0x01, \_SB.PCI0.P0P1.VGA.LCDD.BCBH)
                    Notify (\_SB.PCI0.P0P1.VGA.LCDD, 0x86)
                }
            }
            Else
            {
                If (LLess (LBTN, 0x0F))
                {
                    Increment (LBTN)
                }
                Else
                {
                    Store (0x0F, LBTN)
                }

                STBR ()
                If (\_SB.ATKP)
                {
                    Notify (\_SB.ATKD, Add (LBTN, 0x10))
                }
            }

            Return (One)
        }

        Method (_Q10, 0, NotSerialized)
        {
            Store (0x01, Local0)
            Store (RPIN (0x11), Local0)
            XOr (Local0, 0x01, Local0)
            SPIN (0x11, Local0)
            If (\_SB.ATKP)
            {
                Subtract (0x34, Local0, Local0)
                Notify (\_SB.ATKD, Local0)
            }
        }

        Method (_Q11, 0, NotSerialized)
        {
            FHKW ()
            Store (\ADVG (), Local0)
            If (\NATK ())
            {
                If (LLess (Local0, 0x08))
                {
                    Add (Local0, 0x60, Local1)
                }
                Else
                {
                    Subtract (Local0, 0x08, Local1)
                    Add (Local1, 0x8C, Local1)
                }

                If (LEqual (Local1, 0x90))
                {
                    Store (0x8F, Local1)
                }

                If (\_SB.ATKP)
                {
                    Notify (\_SB.ATKD, Local1)
                }
                Else
                {
                    \SWHG (Local0)
                }
            }
            Else
            {
                \SWHG (Local0)
            }

            FHKS ()
        }

        Name (FHKM, One)
        Method (FHKW, 0, Serialized)
        {
            While (LNot (FHKM))
            {
                Sleep (0x0A)
            }

            Store (Zero, FHKM)
        }

        Method (FHKS, 0, Serialized)
        {
            Store (One, FHKM)
        }

        Method (_Q13, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x32)
            }
        }

        Method (_Q14, 0, NotSerialized)
        {
            If (LLess (\AVOL, 0x0F))
            {
                Increment (\AVOL)
            }

            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x31)
            }
        }

        Method (_Q15, 0, NotSerialized)
        {
            If (LGreater (\AVOL, 0x00))
            {
                Decrement (\AVOL)
            }

            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x30)
            }
        }

        Method (_Q20, 0, NotSerialized)
        {
            If (CDFG)
            {
                Store (One, SMBF)
                Store (Zero, CDFG)
            }

            If (ALFG)
            {
                \_SB.PCI0.SBRG.EC0.ALMH (ALAD)
                Store (Zero, ALFG)
            }
        }

        Method (_Q83, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x6B)
            }
        }

        Method (_Q86, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Store (\_SB.PCI0.SBRG.EC0.RPIN (0x15), Local1)
                If (Local1)
                {
                    Notify (\_SB.ATKD, 0x81)
                }
                Else
                {
                    Notify (\_SB.ATKD, 0x80)
                }
            }
        }

        Method (_Q12, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x6B)
            }
        }

        Method (_Q0C, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x50)
            }
        }

        Method (_Q81, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x51)
            }
        }

        Method (_Q80, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x8A)
            }
        }

        Method (_Q6A, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x8A)
            }
        }

        Method (_Q0D, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x51)
            }
        }

        Method (_Q82, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x5C)
            }
        }

        Method (_Q69, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x5C)
            }
        }

        Method (_QB0, 0, NotSerialized)
        {
            Notify (\_TZ.THRM, 0x80)
        }

        Method (_Q68, 0, NotSerialized)
        {
            \DBGR (0x12, 0x34, 0x56, 0x78)
        }

        Method (_Q84, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x95)
            }
        }

        Method (_Q6B, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x99)
            }
        }

        Method (_Q6C, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x40)
            }
        }

        Method (_Q6D, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x41)
            }
        }

        Method (_Q6E, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x43)
            }
        }

        Method (_Q6F, 0, NotSerialized)
        {
            If (\_SB.ATKP)
            {
                Notify (\_SB.ATKD, 0x45)
            }
        }

        Method (_QA6, 0, NotSerialized)
        {
            Store (0x01, \BAOT)
            Notify (\_PR.CPU1, 0x80)
            Notify (\_PR.CPU1, 0x81)
            If (LGreaterEqual (\_PR.CPU1.NCPU, 0x02))
            {
                Notify (\_PR.CPU2, 0x80)
                Notify (\_PR.CPU2, 0x81)
            }
        }

        Method (_QA7, 0, NotSerialized)
        {
            Store (0x00, \BAOT)
            Notify (\_PR.CPU1, 0x80)
            Notify (\_PR.CPU1, 0x81)
            If (LGreaterEqual (\_PR.CPU1.NCPU, 0x02))
            {
                Notify (\_PR.CPU2, 0x80)
                Notify (\_PR.CPU2, 0x81)
            }
        }
    }

    Scope (\_SB.PCI0.USB0)
    {
        Device (RHUB)
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
        }
    }

    Scope (\_SB)
    {
        Scope (PCI0)
        {
            Name (CRS, ResourceTemplate ()
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
                    0x000DFFFF,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00020000,         // Length
                    ,, _Y0B, AddressRangeMemory, TypeStatic)
                DWordMemory (ResourceProducer, PosDecode, MinFixed, MaxFixed, Cacheable, ReadWrite,
                    0x00000000,         // Granularity
                    0x00000000,         // Range Minimum
                    0x00000000,         // Range Maximum
                    0x00000000,         // Translation Offset
                    0x00000000,         // Length
                    ,, _Y0C, AddressRangeMemory, TypeStatic)
            })
            CreateDWordField (CRS, \_SB.PCI0._Y0B._MIN, MIN5)
            CreateDWordField (CRS, \_SB.PCI0._Y0B._MAX, MAX5)
            CreateDWordField (CRS, \_SB.PCI0._Y0B._LEN, LEN5)
            CreateDWordField (CRS, \_SB.PCI0._Y0C._MIN, MIN6)
            CreateDWordField (CRS, \_SB.PCI0._Y0C._MAX, MAX6)
            CreateDWordField (CRS, \_SB.PCI0._Y0C._LEN, LEN6)
            Method (_CRS, 0, NotSerialized)
            {
                Store (MG1L, Local0)
                If (Local0)
                {
                    Store (MG1B, MIN5)
                    Store (MG1L, LEN5)
                    Add (MIN5, Decrement (Local0), MAX5)
                }

                Store (MG2B, MIN6)
                Store (MG2L, LEN6)
                Store (MG2L, Local0)
                Add (MIN6, Decrement (Local0), MAX6)
                Return (CRS)
            }
        }
    }

    Name (WOTB, 0x00)
    Name (WSSB, 0x00)
    Name (WAXB, 0x00)
    Method (_PTS, 1, NotSerialized)
    {
        Store (Arg0, DBG8)
        PTS (Arg0)
        Store (0x00, Index (WAKP, 0x00))
        Store (0x00, Index (WAKP, 0x01))
        If (LAnd (LEqual (Arg0, 0x04), LEqual (OSFL (), 0x02)))
        {
            Sleep (0x0BB8)
        }

        Store (ASSB, WSSB)
        Store (AOTB, WOTB)
        Store (AAXB, WAXB)
        Store (Arg0, ASSB)
        Store (OSFL (), AOTB)
        Store (Zero, AAXB)
    }

    Name (SLID, 0x01)
    Method (_WAK, 1, NotSerialized)
    {
        ShiftLeft (Arg0, 0x04, DBG8)
        Store (0x01, SLID)
        WAK (Arg0)
        If (ASSB)
        {
            Store (WSSB, ASSB)
            Store (WOTB, AOTB)
            Store (WAXB, AAXB)
        }

        If (DerefOf (Index (WAKP, 0x00)))
        {
            Store (0x00, Index (WAKP, 0x01))
        }
        Else
        {
            Store (Arg0, Index (WAKP, 0x01))
        }

        If (MCTH (\_OS, "Microsoft Windows"))
        {
            If (LEqual (Arg0, 0x04))
            {
                Notify (\_SB.PWRB, 0x02)
            }
        }

        Return (WAKP)
    }

    Scope (\_SB.PCI0.SBRG)
    {
        Device (TPM)
        {
            Method (_HID, 0, NotSerialized)
            {
                Return (\OTID ())
            }

            Name (_CID, EisaId ("PNP0C31"))
            Name (_CRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0254,             // Range Minimum
                    0x0254,             // Range Maximum
                    0x01,               // Alignment
                    0x02,               // Length
                    )
                IO (Decode16,
                    0x4700,             // Range Minimum
                    0x4700,             // Range Maximum
                    0x01,               // Alignment
                    0x0C,               // Length
                    )
                Memory32Fixed (ReadWrite,
                    0xFED40000,         // Address Base
                    0x00005000,         // Address Length
                    )
            })
            OperationRegion (\TCMM, SystemMemory, 0xFED40000, 0x5000)
            Field (\TCMM, ByteAcc, NoLock, Preserve)
            {
                ACCS,   8, 
                        Offset (0xF00), 
                VDID,   32
            }

            Method (_STA, 0, NotSerialized)
            {
                Store (\OTPM (), Local0)
                If (LEqual (Local0, 0x01))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0x00)
                }
            }

            Name (UMOR, Buffer (0x10)
            {
                /* 0000 */    0xED, 0x54, 0x60, 0x37, 0x13, 0xCC, 0x75, 0x46, 
                /* 0008 */    0x90, 0x1C, 0x47, 0x56, 0xD7, 0xF2, 0xD4, 0x5D
            })
            Name (UPPI, Buffer (0x10)
            {
                /* 0000 */    0xA6, 0xFA, 0xDD, 0x3D, 0x1B, 0x36, 0xB4, 0x4E, 
                /* 0008 */    0xA4, 0x24, 0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
            })
            Method (_DSM, 4, NotSerialized)
            {
                If (LEqual (Arg0, UMOR))
                {
                    If (LEqual (Arg1, 0x01))
                    {
                        Store (Arg2, \_T00)
                        If (LEqual (0x01, \_T00))
                        {
                            Store (DerefOf (Index (Arg3, 0x00)), Local0)
                            If (Local0) {}
                            Else
                            {
                            }

                            Return (0x00)
                        }
                    }

                    Return (0x01)
                }

                Name (RST3, Package (0x02)
                {
                    0x00, 
                    0x00
                })
                Name (RST4, Package (0x03)
                {
                    0x00, 
                    0x00, 
                    0xFFFFFFFF
                })
                If (LEqual (Arg0, UPPI))
                {
                    If (LEqual (Arg1, 0x01))
                    {
                        Store (Arg2, \_T01)
                        If (LEqual (0x01, \_T01))
                        {
                            Return (Buffer (0x04)
                            {
                                "1.0"
                            })
                        }
                        Else
                        {
                            If (LEqual (0x02, \_T01))
                            {
                                Store (DerefOf (Index (Arg3, 0x00)), Local0)
                                If (LGreater (Local0, 0x0E))
                                {
                                    Return (0x01)
                                }

                                If (LEqual (Match (Package (0x02)
                                            {
                                                0x0C, 
                                                0x0D
                                            }, MEQ, Local0, MTR, 0x00, 0x00), Ones))
                                {
                                    And (Local0, 0x0F, Local0)
                                    And (\PPIS, 0xF0, \PPIS)
                                    Or (\PPIS, Local0, \PPIS)
                                    Return (0x00)
                                }
                                Else
                                {
                                    Return (0x01)
                                }
                            }
                            Else
                            {
                                If (LEqual (0x03, \_T01))
                                {
                                    And (\PPIS, 0x0F, Local0)
                                    Store (Local0, Index (RST3, 0x01))
                                    Return (RST3)
                                }
                                Else
                                {
                                    If (LEqual (0x04, \_T01))
                                    {
                                        Return (0x02)
                                    }
                                    Else
                                    {
                                        If (LEqual (0x05, \_T01))
                                        {
                                            And (\PPIS, 0xF0, Local0)
                                            ShiftRight (Local0, 0x04, Local0)
                                            Store (Local0, Index (RST4, 0x01))
                                            If (LOr (LEqual (\PPIR, 0xF0), LEqual (\PPIR, 0xF1)))
                                            {
                                                Store (0xFFFFFF00, Local0)
                                                Or (Local0, \PPIR, Local0)
                                            }
                                            Else
                                            {
                                                Store (\PPIR, Local0)
                                            }

                                            Store (Local0, Index (RST4, 0x02))
                                            Return (RST4)
                                        }
                                        Else
                                        {
                                            If (LEqual (0x06, \_T01))
                                            {
                                                Return (0x01)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Name (\_S0, Package (0x04)
    {
        0x00, 
        0x00, 
        0x00, 
        0x00
    })
    If (SS1)
    {
        Name (\_S1, Package (0x04)
        {
            0x01, 
            0x00, 
            0x00, 
            0x00
        })
    }

    If (SS3)
    {
        Name (\_S3, Package (0x04)
        {
            0x05, 
            0x00, 
            0x00, 
            0x00
        })
    }

    If (SS4)
    {
        Name (\_S4, Package (0x04)
        {
            0x06, 
            0x00, 
            0x00, 
            0x00
        })
    }

    Name (\_S5, Package (0x04)
    {
        0x07, 
        0x00, 
        0x00, 
        0x00
    })
    Method (PTS, 1, NotSerialized)
    {
        If (Arg0)
        {
            \_SB.PCI0.NPTS (Arg0)
            \_SB.PCI0.SBRG.SPTS (Arg0)
            \OEMS (Arg0)
        }
    }

    Method (WAK, 1, NotSerialized)
    {
        \WDTS (Arg0)
        \_SB.PCI0.NWAK (Arg0)
        \_SB.PCI0.SBRG.SWAK (Arg0)
        \OEMW (Arg0)
    }
}


--=-VtJiQ9mPLKa7fIV+HaLu
Content-Disposition: attachment; filename="DSDT.patch"
Content-Type: text/x-patch; name="DSDT.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- DSDT.dsl.orig	2009-08-17 15:55:59.000000000 +0800
+++ DSDT.dsl	2009-08-17 15:59:06.000000000 +0800
@@ -5000,14 +5000,14 @@ DefinitionBlock ("DSDT.aml", "DSDT", 1, 
         {
             Acquire (MUTE, 0x03E8)
             Add (Arg0, \PCIB, Local0)
-            OperationRegion (PCFG, SystemMemory, Local0, 0x01)
-            Field (PCFG, ByteAcc, NoLock, Preserve)
+            OperationRegion (PCG1, SystemMemory, Local0, 0x01)
+            Field (PCG1, ByteAcc, NoLock, Preserve)
             {
-                XCFG,   8
+                XCG1,   8
             }
 
             Release (MUTE)
-            Return (XCFG)
+            Return (XCG1)
         }
 
         Method (RWPE, 1, NotSerialized)
@@ -5015,14 +5015,14 @@ DefinitionBlock ("DSDT.aml", "DSDT", 1, 
             Acquire (MUTE, 0x03E8)
             And (Arg0, 0xFFFFFFFE, Arg0)
             Add (Arg0, \PCIB, Local0)
-            OperationRegion (PCFG, SystemMemory, Local0, 0x02)
-            Field (PCFG, WordAcc, NoLock, Preserve)
+            OperationRegion (PCG2, SystemMemory, Local0, 0x02)
+            Field (PCG2, WordAcc, NoLock, Preserve)
             {
-                XCFG,   16
+                XCG2,   16
             }
 
             Release (MUTE)
-            Return (XCFG)
+            Return (XCG2)
         }
 
         Method (RDPE, 1, NotSerialized)
@@ -5030,27 +5030,27 @@ DefinitionBlock ("DSDT.aml", "DSDT", 1, 
             Acquire (MUTE, 0x03E8)
             And (Arg0, 0xFFFFFFFC, Arg0)
             Add (Arg0, \PCIB, Local0)
-            OperationRegion (PCFG, SystemMemory, Local0, 0x04)
-            Field (PCFG, DWordAcc, NoLock, Preserve)
+            OperationRegion (PCG3, SystemMemory, Local0, 0x04)
+            Field (PCG3, DWordAcc, NoLock, Preserve)
             {
-                XCFG,   32
+                XCG3,   32
             }
 
             Release (MUTE)
-            Return (XCFG)
+            Return (XCG3)
         }
 
         Method (WBPE, 2, NotSerialized)
         {
             Acquire (MUTE, 0x0FFF)
             Add (Arg0, \PCIB, Local0)
-            OperationRegion (PCFG, SystemMemory, Local0, 0x01)
-            Field (PCFG, ByteAcc, NoLock, Preserve)
+            OperationRegion (PCG4, SystemMemory, Local0, 0x01)
+            Field (PCG4, ByteAcc, NoLock, Preserve)
             {
-                XCFG,   8
+                XCG4,   8
             }
 
-            Store (Arg1, XCFG)
+            Store (Arg1, XCG4)
             Release (MUTE)
         }
 
@@ -5059,13 +5059,13 @@ DefinitionBlock ("DSDT.aml", "DSDT", 1, 
             Acquire (MUTE, 0x03E8)
             And (Arg0, 0xFFFFFFFE, Arg0)
             Add (Arg0, \PCIB, Local0)
-            OperationRegion (PCFG, SystemMemory, Local0, 0x02)
-            Field (PCFG, WordAcc, NoLock, Preserve)
+            OperationRegion (PCG5, SystemMemory, Local0, 0x02)
+            Field (PCG5, WordAcc, NoLock, Preserve)
             {
-                XCFG,   16
+                XCG5,   16
             }
 
-            Store (Arg1, XCFG)
+            Store (Arg1, XCG5)
             Release (MUTE)
         }
 
@@ -5074,13 +5074,13 @@ DefinitionBlock ("DSDT.aml", "DSDT", 1, 
             Acquire (MUTE, 0x03E8)
             And (Arg0, 0xFFFFFFFC, Arg0)
             Add (Arg0, \PCIB, Local0)
-            OperationRegion (PCFG, SystemMemory, Local0, 0x04)
-            Field (PCFG, DWordAcc, NoLock, Preserve)
+            OperationRegion (PCG6, SystemMemory, Local0, 0x04)
+            Field (PCG6, DWordAcc, NoLock, Preserve)
             {
-                XCFG,   32
+                XCG6,   32
             }
 
-            Store (Arg1, XCFG)
+            Store (Arg1, XCG6)
             Release (MUTE)
         }
 
@@ -5089,14 +5089,14 @@ DefinitionBlock ("DSDT.aml", "DSDT", 1, 
             Acquire (MUTE, 0x03E8)
             And (Arg0, 0xFFFFFFFC, Arg0)
             Add (Arg0, \PCIB, Local0)
-            OperationRegion (PCFG, SystemMemory, Local0, 0x04)
-            Field (PCFG, DWordAcc, NoLock, Preserve)
+            OperationRegion (PCG7, SystemMemory, Local0, 0x04)
+            Field (PCG7, DWordAcc, NoLock, Preserve)
             {
-                XCFG,   32
+                XCG7,   32
             }
 
-            And (XCFG, Arg2, Local1)
-            Or (Local1, Arg1, XCFG)
+            And (XCG7, Arg2, Local1)
+            Or (Local1, Arg1, XCG7)
             Release (MUTE)
         }
 

--=-VtJiQ9mPLKa7fIV+HaLu
Content-Disposition: attachment; filename="region-debug.patch"
Content-Type: text/x-patch; name="region-debug.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index 98c7f9c..3323c54 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -347,7 +347,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		 * potentially execute control methods (for example, the _REG method
 		 * for this region)
 		 */
-		acpi_ex_exit_interpreter();
+		if (!(region_obj->region.node->flags & ANOBJ_TEMPORARY)) {
+			acpi_ex_exit_interpreter();
+		}
 
 		status = region_setup(region_obj, ACPI_REGION_ACTIVATE,
 				      handler_desc->address_space.context,
@@ -355,7 +357,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 
 		/* Re-enter the interpreter */
 
-		acpi_ex_enter_interpreter();
+		if (!(region_obj->region.node->flags & ANOBJ_TEMPORARY)) {
+			acpi_ex_enter_interpreter();
+		}
 
 		/* Check for failure of the Region Setup */
 
@@ -408,7 +412,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		 * exit the interpreter because the handler *might* block -- we don't
 		 * know what it will do, so we can't hold the lock on the intepreter.
 		 */
-		acpi_ex_exit_interpreter();
+		if (!(region_obj->region.node->flags & ANOBJ_TEMPORARY)) {
+			acpi_ex_exit_interpreter();
+		}
 	}
 
 	/* Call the handler */
@@ -430,7 +436,9 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		 * We just returned from a non-default handler, we must re-enter the
 		 * interpreter
 		 */
-		acpi_ex_enter_interpreter();
+		if (!(region_obj->region.node->flags & ANOBJ_TEMPORARY)) {
+			acpi_ex_enter_interpreter();
+		}
 	}
 
 	return_ACPI_STATUS(status);

--=-VtJiQ9mPLKa7fIV+HaLu--

