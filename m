Return-Path: <linux-kernel-owner+w=401wt.eu-S1754290AbXLIVg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbXLIVg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbXLIVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:36:46 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48251 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbXLIVgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:36:43 -0500
Date: Sun, 9 Dec 2007 22:36:42 +0100
From: Andreas Mohr <andi@lisas.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andreas Mohr <andi@lisas.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209213642.GA27096@rhlx01.hs-esslingen.de>
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no> <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no> <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no> <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no> <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no> <475AE150.9050306@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AE150.9050306@shaw.ca>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ACPI _GTM suspend issue sorta fixed, read below]

On Sat, Dec 08, 2007 at 12:24:16PM -0600, Robert Hancock wrote:
> Matthew Garrett wrote:
>> On Sat, Dec 08, 2007 at 02:20:01AM -0800, Andrew Morton wrote:
>>> On Sat, 8 Dec 2007 11:12:57 +0100 Andreas Mohr <andi@lisas.de> wrote:
>>>> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
>>>> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
>>>> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV1._GTF] (Node c180b888), AE_AML_PACKAGE_LIMIT
>>>> ata1.01: _GTF evaluation failed (AE 0x300d)
>>
>> 037f6bb79f753c014bc84bca0de9bf98bb5ab169 ought to have fixed this?
>>
>
> I should think it should have.

Yup, the _GTF problem is certainly fixed, but this is a dead-end
since I showed the -rc1 vs. -rc2 behaviour, whereas I still have
failing suspend in -rc4 with this patch confirmed to be applied
(source does contain the changes) and confirmed to apparently be working
(no errors in dmesg any more).

IOW, what I'm concerned about is not a _GTF error on boot any more,
but a seemingly fatally handled _GTM error on suspend.


...OK, dug some more into this, and now I managed to get it to work,
and it was indeed _GTM which broke my whole suspend:

Since _GTM is failing on me (and the point is, it's failing
catastrophically, not "normally"!), ata_acpi_on_suspend()
calling ata_acpi_gtm() fails with -EINVAL instead of -ENOENT,
however ata_acpi_on_suspend() has the following correction only:

        if (rc == -ENOENT)
                rc = 0;

to make sure a suspend doesn't get aborted (fatal error) when
_GTM is simply empty.

Changing this into

        if ((rc == -ENOENT) || (rc == -EINVAL))
                rc = 0;

to additionally account for _invalid_ _GTM execution makes my suspend
(and resume!) work again on -rc4.


Now the question is whether this error code correction is ok, or whether a
catastrophically failing _GTM should have been truly registered on boot
already (where it does gtm to fetch cable timings) to subsequently avoid
doing any ATA ACPI things on suspend at all.


And the second, possibly much more lucrative, question would be
whether we're actually doing something wrong with our ACPI _GTM execution
which triggers the AE_AML_PACKAGE_LIMIT problem.

This might help here, perhaps (relevant snippets of AML dump):

                Device (CHN0)
                {
                    Name (_ADR, 0x00)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (PMPT, PMUE, PMUT, PSPT, PSUE, PSUT))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, TMD0)
                        Store (PMPT, GMPT)
                        Store (PMUE, GMUE)
                        Store (PMUT, GMUT)
                        Store (PSPT, GSPT)
                        Store (PSUE, GSUE)
                        Store (PSUT, GSUT)
                        STM ()
                        Store (GMPT, PMPT)
                        Store (GMUE, PMUE)
                        Store (GMUT, PMUT)
                        Store (GSPT, PSPT)
                        Store (GSUE, PSUE)
                        Store (GSUT, PSUT)
                    }

                Device (CHN1)
                {
                    Name (_ADR, 0x01)
                    Method (_GTM, 0, NotSerialized)
                    {
                        Return (GTM (SMPT, SMUE, SMUT, SSPT, SSUE, SSUT))
                    }

                    Method (_STM, 3, NotSerialized)
                    {
                        Store (Arg0, TMD0)
                        Store (SMPT, GMPT)
                        Store (SMUE, GMUE)
                        Store (SMUT, GMUT)
                        Store (SSPT, GSPT)
                        Store (SSUE, GSUE)
                        Store (SSUT, GSUT)
                        STM ()
                        Store (GMPT, SMPT)
                        Store (GMUE, SMUE)
                        Store (GMUT, SMUT)
                        Store (GSPT, SSPT)
                        Store (GSUE, SSUE)
                        Store (GSUT, SSUT)
                    }


                Method (GTM, 6, Serialized)
                {
                    Store (Ones, PIO0)
                    Store (Ones, PIO1)
                    Store (Ones, DMA0)
                    Store (Ones, DMA1)
                    Store (0x10, CHNF)
                    If (REGF) {}
                    Else
                    {
                        Return (TMD0)
                    }

                    Store (Match (DerefOf (Index (TIM0, 0x01)), MEQ, Arg0, MTR,
                        0x00, 0x00), Local6)
                    Store (DerefOf (Index (DerefOf (Index (TIM0, 0x00)), Local6)
),
                        Local7)
                    Store (Local7, DMA0)
                    Store (Local7, PIO0)
                    Store (Match (DerefOf (Index (TIM0, 0x01)), MEQ, Arg3, MTR,
                        0x00, 0x00), Local6)
                    Store (DerefOf (Index (DerefOf (Index (TIM0, 0x00)), Local6)
),
                        Local7)
                    Store (Local7, DMA1)
                    Store (Local7, PIO1)
                    If (Arg1)
                    {
                        If (A133 ())
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x0D)),
 Arg2)),
                                Local5)
                        }
                        Else
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x0A)),
 Arg2)),
                                Local5)
                        }

                        If (A133 ())
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x0C)),
 Local5)),
                                DMA0)
                        }
                        Else
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x04)),
 Local5)),
                                DMA0)
                        }

                        Or (CHNF, 0x01, CHNF)
                    }

                    If (Arg4)
                    {
                        If (A133 ())
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x0D)), Arg5)),
                                Local5)
                        }
                        Else
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x0A)), Arg5)),
                                Local5)
                        }

                        If (A133 ())
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x0C)), Local5)),
                                DMA1)
                        }
                        Else
                        {
                            Store (DerefOf (Index (DerefOf (Index (TIM0, 0x04)), Local5)),
                                DMA1)
                        }

                        Or (CHNF, 0x04, CHNF)
                    }

                    Return (TMD0)
                }


Reminder: issue tracked at #9530.


Thanks,

Andreas Mohr
