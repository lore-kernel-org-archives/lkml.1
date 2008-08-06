Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYHFTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYHFTr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYHFTrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:47:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:14281 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbYHFTrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=NokBDh8FuNRagvaU7IwfXHu1W6UV6BfgjOIMll0Kur/TJ4g6SqEkllQ5LZJ7e75dD0
         36XTT94I7LgiTkNmVoMEdpTR2vn01kc1WUi8r9kvsODBw6+lhAnZQhQOeNlcvd6r+na3
         YkfXoDLdSDgSxlUY9pITgJdPRs/IQxVEJ4Xgk=
Date: Wed, 6 Aug 2008 21:47:55 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
Message-ID: <20080806194754.GC31312@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <20080803143837.GA26672@gollum.tnic> <20080803162214.394b13a1@lxorguk.ukuu.org.uk> <20080803165135.GA31977@gollum.tnic> <4898630C.7090403@ru.mvista.com> <9ea470500808050732s7be29360ge358790e955be06a@mail.gmail.com> <58cb370e0808050741v7ff3f20awb3d91a84486f8547@mail.gmail.com> <20080806061023.GA23773@gollum.tnic> <48998C58.20703@ru.mvista.com> <9ea470500808060703p4a94c868i25106e081aad75c4@mail.gmail.com> <4899C9F4.9040002@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4899C9F4.9040002@ru.mvista.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 07:57:40PM +0400, Sergei Shtylyov wrote:
> Boris Petkov wrote:
>
>>>> From: Borislav Petkov <petkovbb@gmail.com>
>>>> Date: Sun, 3 Aug 2008 18:46:35 +0200
>>>> Subject: [PATCH] ide-generic: handle probing of legacy io-ports v4
>
>>>> Avoid probing the io-ports in case an IDE PCI controller is present and it uses
>>>> the legacy iobases. If we still want to enforce the probing, we do
>
>>>> ide_generic.probe_mask=0x3f
>
>>>> on the kernel command line. The iobase checking code is adapted from
>>>> drivers/ata/pata_legacy.c after converting hex pci ids into their
>>>> corresponding
>>>> macros in <linux/pci_ids.h>.
>
>>>> CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>>>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>
>>> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>
>>>> diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
>>>> index 8fe8b5b..efce159 100644
>>>> --- a/drivers/ide/ide-generic.c
>>>> +++ b/drivers/ide/ide-generic.c
>
>>> [...]
>
>>>> @@ -100,19 +101,69 @@ static const u16 legacy_bases[] = { 0x1f0, 0x170,
>>>> 0x1e8, 0x168, 0x1e0, 0x160 };
>>>> static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
>>>> #endif
>>>> +static void ide_generic_check_pci_legacy_iobases(int *primary, int
>>>> *secondary)
>>>> +{
>>>> +       struct pci_dev *p = NULL;
>>>> +       u16 val;
>>>> +
>>>> +       for_each_pci_dev(p) {
>>>> +               int r;
>>>> +
>>>> +               for (r = 0; r < 6; r++) {
>>>> +                       if (pci_resource_start(p, r) == 0x1f0)
>>>> +                               *primary = 1;
>>>> +                       if (pci_resource_start(p, r) == 0x170)
>>>> +                               *secondary = 1;
>>>> +               }
>
>>> Would have been probably enough to test only BAR0/2, don't you think?
>
>> I assume you're referring to the legacy ioports fixup in
>> drivers/pci/probe.c:pci_setup_device().
>
>    And to the fact that the value 0x1f0 should only be ever seen in BAR0 
> and 0x170 in BAR2 even if they would have been read off the chips (some 
> chips have these values reading back even in legacy mode, and even could 
> malfunction if other values are written there), not fixed up there, and 
> certainly not in BAR1 or BAR3, so it's quite pointless to look in these 
> BARs too.

So the comment in there saying that in some cases BAR0-3 could contain junk is a
bogus? In other words, can we assume that one will always read 0x1f0 from BAR0
and 0x170 from BAR2 in compatibility mode. If so, the check is even simpler:

	if (pci_resource_start(p, 0) == 0x1f0)
		*primary = 1;
	if (pci_resource_start(p, 2) == 0x170)
		*secondary = 1;


-- 
Regards/Gruss,
    Boris.
