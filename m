Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYHEOdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYHEOdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYHEOca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:32:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:4382 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbYHEOc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:32:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=mfn3VdrqO059jO+wUAg+r05Z1Nwswd3VhbEb1GN2+f4rJLaAm98EZwMfZmcHByd7J4
         vxBvi20hlMDbiLbhhxmWB2EK79Cld1BTZW3kw/0aRQPVdgSLuaxpoUeM4v/xFGRDwCmj
         zCNyIwvJ0DeUi14yfjP6cFhln0Nhx4RurR7dY=
Message-ID: <9ea470500808050732s7be29360ge358790e955be06a@mail.gmail.com>
Date: Tue, 5 Aug 2008 16:32:25 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <4898630C.7090403@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080715053356.GA18628@gollum.tnic>
	 <200808021902.12191.bzolnier@gmail.com>
	 <20080802183253.GA2239@gollum.tnic>
	 <200808022046.16990.bzolnier@gmail.com>
	 <20080803073756.GA8762@gollum.tnic>
	 <20080803125907.67676948@lxorguk.ukuu.org.uk>
	 <20080803143837.GA26672@gollum.tnic>
	 <20080803162214.394b13a1@lxorguk.ukuu.org.uk>
	 <20080803165135.GA31977@gollum.tnic> <4898630C.7090403@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 4:26 PM, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Borislav Petkov wrote:
>
>> Avoid probing the io-ports in case an IDE PCI controller is present and it
>> uses
>> the legacy iobases. If we still want to enforce the probing, we do
>
>> ide_generic.probe_mask=0x3f
>
>> on the kernel command line. The iobase checking code is adapted from
>> drivers/ata/pata_legacy.c
>
>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>
>> diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
>> index 8fe8b5b..e9b7b69 100644
>> --- a/drivers/ide/ide-generic.c
>> +++ b/drivers/ide/ide-generic.c
>
> [...]
>>
>> @@ -100,19 +100,71 @@ static const u16 legacy_bases[] = { 0x1f0, 0x170,
>> 0x1e8, 0x168, 0x1e0, 0x160 };
>>  static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
>>  #endif
>>  +
>
>   Extra newline...
>
>> +static void ide_generic_check_pci_legacy_iobases(int *primary, int
>> *secondary)
>> +{
>> +       struct pci_dev *p = NULL;
>> +       u16 val;
>> +
>> +       for_each_pci_dev(p) {
>> +               int r;
>> +
>> +               for (r = 0; r < 6; r++) {
>> +                       if (pci_resource_start(p, r) == 0x1f0)
>> +                               *primary = 1;
>> +                       if (pci_resource_start(p, r) == 0x170)
>> +                               *secondary = 1;
>> +               }
>> +
>> +               /* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
>> +               if (p->vendor == 0x1078 && p->device == 0x0000)
>> +                       *primary = *secondary = 1;
>> +
>> +               /* Cyrix CS5520 pre SFF MWDMA ATA on the bridge */
>> +               if (p->vendor == 0x1078 && p->device == 0x0002)
>> +                       *primary = *secondary = 1;
>
>   I think the above two if statements should be collapsed into a single one.

This is code is actually from the pata_legacy.c but yep, you're right,
those can merge.

>
>> +
>> +               /* Intel MPIIX - PIO ATA on non PCI side of bridge */
>> +               if (p->vendor == 0x8086 && p->device == 0x1234) {
>
>   Also, perhaps it makes sense to #include <linux/pci_ids.h> and use the
> macros defined there...

Will look into it later and redo the patch, thanks for reviewing. I
still haven't heard from
Bart, though, whether he's OK with the code duplication...?

-- 
Regards/Gruﬂ,
Boris
