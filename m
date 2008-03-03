Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbYCCTMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbYCCTMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYCCTMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:12:34 -0500
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:40350 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753503AbYCCTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:12:33 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: benh@kernel.crashing.org
Subject: Re: Weirdness in pci_read_bases()
Date: Mon, 3 Mar 2008 11:12:27 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
References: <1204252667.15052.402.camel@pasglop>
In-Reply-To: <1204252667.15052.402.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031112.27658.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 28, 2008 6:37 pm Benjamin Herrenschmidt wrote:
> Hi !
>
> There is something dodgy going on in pci_read_bases().
>
> In addition to the fact (or related to it) that we tend to treat
> res->start == 0 as meaning "unassigned" (which at this stage is mostly
> incorrect, but let's say I can cope),

Yeah, that sounds like trouble.  I expect this may become a problem even for 
PC architectures in the future (IOMMUs on multiple busses for example), so 
maybe it makes sense to change the core to not assume 0 == unassigned?

> > however, there is some bit of code  
> that I think is just plain wrong:
>
> 		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
> 		pci_read_config_dword(dev, reg, &l);
> 		pci_write_config_dword(dev, reg, ~0);
> 		pci_read_config_dword(dev, reg, &sz);
> 		pci_write_config_dword(dev, reg, l);
> 		if (!sz || sz == 0xffffffff)
> 			continue;
> 		if (l == 0xffffffff)
> 			l = 0;
>
> So here, we read the BAR value, which at this stage could either be some
> assigned address or some ff's from a freshly unassigned BAR. _however_
> that test against 0xffffffff looks totally bogus to me.
>
> If we read that value, we write 0 in l. Which means that if we read some
> unassigned resource that had the address space bits set to IO, we
> overwrite this with a bit encoding that means Memory, and further along,
> start sizing & treating this as a memory resource.

But we should never hit the l == 0xffffffff case if it's a memory BAR, since 
the low bit will be 0, right?

I think Grant is probably right that the only time we'd hit this is if the bus 
is down and we're getting back all 1s for every read (though that's a PC 
specific assumption).

> This isn't a problem I'm encountering in practice. I just noticed that
> while trying to audit what it would take to fix the code to stop using
> res->start = 0 as a way to mark unassigned resources (unrelated), so it
> doesn't -need- to be fixed per-se, but I'm curious where that came from
> in the first place.

Yeah, it seems like it could be safely removed, but this is an area where we 
should probably move slowly (i.e. one, very small change to the probing code 
at a time) or it may be difficult to isolate any bugs in the wild.

Jesse
