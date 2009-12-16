Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbZLPAOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbZLPAOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932065AbZLPAOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:14:54 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:55101 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286AbZLPAOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZOyH+xnNSlJ3zoUVJ5Anj2du3Kus9dGt9VyOV17uJLrWvpYkAmBYo1Yw3I7zgT/90q
         LzR7qXibXz7SuGPr31lSXx2KIV0d9xi6OXumChtCuTbSKYz/D7b2iWBC1/wKpXPe5ilX
         6LM9ZCyvLPFC6pyXLAT9wXAH+4YAziVpgIuDM=
MIME-Version: 1.0
In-Reply-To: <20091215130957.22047f92@jbarnes-piketon>
References: <200912130807.44905.tvrtko@ursulin.net>
	 <4B26E4C7.8040100@gmail.com> <4B26E973.6080305@kernel.org>
	 <200912150955.03974.bjorn.helgaas@hp.com>
	 <51f3faa70912151250y709a42c8l91012a64ef21a476@mail.gmail.com>
	 <20091215130957.22047f92@jbarnes-piketon>
Date: Tue, 15 Dec 2009 18:14:52 -0600
Message-ID: <51f3faa70912151614w30d1839cq66e8673ee5712e55@mail.gmail.com>
Subject: Re: Are these MTRR settings correct?
From: Robert Hancock <hancockrwd@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 3:09 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 15 Dec 2009 14:50:44 -0600
> Robert Hancock <hancockrwd@gmail.com> wrote:
>> I wouldn't have a problem with the E820 check being removed, since
>> it's not actually reliable by itself anyway. In fact I'm not sure that
>> we need any of the reservation checks at all.
>>
>> The whole reason we have this junk in there is because early on it was
>> thought that a bunch of problems people were seeing with systems not
>> working with MMCONFIG turned on were because their MMCONFIG was
>> broken, and the reservation checks were there to try to weed this out
>> by making sure the MCFG data pointed to a memory area that was marked
>> as reserved. Originally it was checking E820 only, which turned out to
>> be invalid because the firmware specification only told BIOS people to
>> reserve the space in ACPI motherboard resources, not E820.
>>
>>  Later on it was discovered that most of the problems were because we
>> did all config-space access using MMCONFIG, including the base access,
>> and combined with the fact that we don't disable decode on PCI devices
>> when sizing memory BARs, the BAR location during sizing would overlap
>> the MMCONFIG space and result in the device sucking up the MMCONFIG
>> accesses, usually causing a lockup. So it wasn't actually due to any
>> broken MMCONFIG motherboards at all. This was solved by using MMCONFIG
>> for extended config space access only, so that when we move the BAR
>> temporarily during sizing, we're not trying to access the MMCONFIG
>> region it overlaps (since BAR sizing requires only base access).
>>
>> (Lesson: yes, BIOSes are broken a lot, but you can't jump to
>> conclusions.)
>>
>> It would be interesting to know if there are any systems where the
>> code reports the MCFG area is not reserved in the ACPI motherboard
>> resources. I would tend to suspect not, because if it wasn't, Windows
>> would potentially assign devices to that memory area on such boards
>> and cause things to fail horribly, which presumably isn't happening.
>> We might be able to just get rid of all that code.
>
> Yeah, that sounds like an accurate summary.  I'd be in favor of ripping
> out the e820 check (it's totally useless and just confusing) and moving
> to using mmconfig for everything, not just extended space, provided we
> disable decode around our BAR sizing (some bridges needed quirks there
> though).

That may be viable, yes. Linus was opposed to the decode-disable last
time he weighed in, though, although he did seem like he could be
convinced if suitable exceptions were in place where it might break
things..

> The ACPI resource checks seem harmless; as you say I'd expect every
> machine running Windows to already have that part of the firmware
> tested with the "Windows boots, ship it" validation.
