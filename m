Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbZLOVKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbZLOVKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbZLOVKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:10:13 -0500
Received: from outbound-mail-129.bluehost.com ([67.222.38.29]:39424 "HELO
	outbound-mail-129.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755494AbZLOVKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:10:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lQR1zZo5xzQR68iURDv/E8Z4Ct/6ANXB4V5tLjnzhxBLNEvlbo1Ywz8r+Acl/fXUE0U+w4D/zltuSBWgfpqlE+eD0VtDAJ1SreXwZAI4DjPBFAvbLN2vwll4QvrZYG/y;
Date: Tue, 15 Dec 2009 13:09:57 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Are these MTRR settings correct?
Message-ID: <20091215130957.22047f92@jbarnes-piketon>
In-Reply-To: <51f3faa70912151250y709a42c8l91012a64ef21a476@mail.gmail.com>
References: <200912130807.44905.tvrtko@ursulin.net>
	<4B26E4C7.8040100@gmail.com>
	<4B26E973.6080305@kernel.org>
	<200912150955.03974.bjorn.helgaas@hp.com>
	<51f3faa70912151250y709a42c8l91012a64ef21a476@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 14:50:44 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:
> I wouldn't have a problem with the E820 check being removed, since
> it's not actually reliable by itself anyway. In fact I'm not sure that
> we need any of the reservation checks at all.
> 
> The whole reason we have this junk in there is because early on it was
> thought that a bunch of problems people were seeing with systems not
> working with MMCONFIG turned on were because their MMCONFIG was
> broken, and the reservation checks were there to try to weed this out
> by making sure the MCFG data pointed to a memory area that was marked
> as reserved. Originally it was checking E820 only, which turned out to
> be invalid because the firmware specification only told BIOS people to
> reserve the space in ACPI motherboard resources, not E820.
> 
>  Later on it was discovered that most of the problems were because we
> did all config-space access using MMCONFIG, including the base access,
> and combined with the fact that we don't disable decode on PCI devices
> when sizing memory BARs, the BAR location during sizing would overlap
> the MMCONFIG space and result in the device sucking up the MMCONFIG
> accesses, usually causing a lockup. So it wasn't actually due to any
> broken MMCONFIG motherboards at all. This was solved by using MMCONFIG
> for extended config space access only, so that when we move the BAR
> temporarily during sizing, we're not trying to access the MMCONFIG
> region it overlaps (since BAR sizing requires only base access).
> 
> (Lesson: yes, BIOSes are broken a lot, but you can't jump to
> conclusions.)
> 
> It would be interesting to know if there are any systems where the
> code reports the MCFG area is not reserved in the ACPI motherboard
> resources. I would tend to suspect not, because if it wasn't, Windows
> would potentially assign devices to that memory area on such boards
> and cause things to fail horribly, which presumably isn't happening.
> We might be able to just get rid of all that code.

Yeah, that sounds like an accurate summary.  I'd be in favor of ripping
out the e820 check (it's totally useless and just confusing) and moving
to using mmconfig for everything, not just extended space, provided we
disable decode around our BAR sizing (some bridges needed quirks there
though).

The ACPI resource checks seem harmless; as you say I'd expect every
machine running Windows to already have that part of the firmware
tested with the "Windows boots, ship it" validation.

-- 
Jesse Barnes, Intel Open Source Technology Center
