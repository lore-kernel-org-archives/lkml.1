Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbZLOUut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbZLOUut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760233AbZLOUur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:50:47 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:42946 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZLOUup convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:50:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HedE+SpbjOa818v7TotILumVx9m3chwuzD8RDVU72F/zdFvh2K7xGqcXagJGqqCoeG
         5MZ74lltpiQaeMVMdU0GZj/K1kxcvAMMAnv6aD/uYNA+a18ojAQ/r73cKnN1kVB5bBtQ
         VrUu1uHvqBdc5BHYLPnL1QqmTGlDfxQjIPfgk=
MIME-Version: 1.0
In-Reply-To: <200912150955.03974.bjorn.helgaas@hp.com>
References: <200912130807.44905.tvrtko@ursulin.net>
	 <4B26E4C7.8040100@gmail.com> <4B26E973.6080305@kernel.org>
	 <200912150955.03974.bjorn.helgaas@hp.com>
Date: Tue, 15 Dec 2009 14:50:44 -0600
Message-ID: <51f3faa70912151250y709a42c8l91012a64ef21a476@mail.gmail.com>
Subject: Re: Are these MTRR settings correct?
From: Robert Hancock <hancockrwd@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:55 AM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> On Monday 14 December 2009 06:42:11 pm Yinghai Lu wrote:
>> Robert Hancock wrote:
>> > Something else isn't quite right. It looks like MMCONFIG area should be
>> > reserved:
>> >
>> > [    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been
>> > reserved
>> >
>> > but the code didn't seem to detect that. In fact there doesn't seem to
>> > be any output about whether it was or wasn't reserved, which from the
>> > code it seems there should be.
>> >
>> > Maybe because of that ACPI method execution error?
>>
>> could be sth pnpacpi brokenness?
>
> Robert, I assume you're referring to this from Tvrtko's post
> (http://lkml.org/lkml/2009/12/13/90):
>
> [    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000e0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
> ...
> [    0.250088] PCI: Found AMD Family 10h NB with MMCONFIG support.
> [    0.250091] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.250092] PCI: Not using MMCONFIG.
> ...
> [    0.253491] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE_NOT_FOUND
> [    0.253495] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81656ab0), AE_NOT_FOUND
> ...
> [    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
>
> I think we're rejecting MMCONFIG in the early call to
> pci_mmcfg_reject_broken(), when we check only E820 resources, not
> ACPI resources.  And indeed, the 0xe0000000-0xefffffff range is
> not mentioned in E820.  Which output did you expect to see?
>
> I am uncomfortable with this early/late checking and looking at both
> E820 and ACPI.  It just feels hacky and error-prone.  I'm not happy about
> adding Yinghai's special-case "if we found AMD Fam10h, don't check for
> reservations" patch either.

I would expect to see the report of whether it was reserved in ACPI or
not, if the E820 check failed. The early check would reject it, but
the late call (after the ACPI interpreter initializes) would accept it
because it discovers that it's actually reserved in the ACPI
motherboard resources.

>
> I assume that Windows runs on this box without requiring per-machine
> hacks in the kernel.  Linux should be able to do the same, and the fact
> that we can't is telling us we're doing somethign wrong.  We should fix
> whatever's wrong rather than papering over it.

I wouldn't have a problem with the E820 check being removed, since
it's not actually reliable by itself anyway. In fact I'm not sure that
we need any of the reservation checks at all.

The whole reason we have this junk in there is because early on it was
thought that a bunch of problems people were seeing with systems not
working with MMCONFIG turned on were because their MMCONFIG was
broken, and the reservation checks were there to try to weed this out
by making sure the MCFG data pointed to a memory area that was marked
as reserved. Originally it was checking E820 only, which turned out to
be invalid because the firmware specification only told BIOS people to
reserve the space in ACPI motherboard resources, not E820.

 Later on it was discovered that most of the problems were because we
did all config-space access using MMCONFIG, including the base access,
and combined with the fact that we don't disable decode on PCI devices
when sizing memory BARs, the BAR location during sizing would overlap
the MMCONFIG space and result in the device sucking up the MMCONFIG
accesses, usually causing a lockup. So it wasn't actually due to any
broken MMCONFIG motherboards at all. This was solved by using MMCONFIG
for extended config space access only, so that when we move the BAR
temporarily during sizing, we're not trying to access the MMCONFIG
region it overlaps (since BAR sizing requires only base access).

(Lesson: yes, BIOSes are broken a lot, but you can't jump to conclusions.)

It would be interesting to know if there are any systems where the
code reports the MCFG area is not reserved in the ACPI motherboard
resources. I would tend to suspect not, because if it wasn't, Windows
would potentially assign devices to that memory area on such boards
and cause things to fail horribly, which presumably isn't happening.
We might be able to just get rid of all that code.
