Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbXL0S7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbXL0S7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXL0S7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:59:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbXL0S7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:59:11 -0500
Date: Thu, 27 Dec 2007 10:58:31 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <4773EBB4.2020805@shaw.ca>
Message-ID: <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no> <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no> <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Dec 2007, Robert Hancock wrote:

> Linus Torvalds wrote:
> > 
> > But yes. The *fact* is that MMCONFIG has not just been globally broken, but
> > broken on a per-device basis. I don't know why (and quite frankly, I doubt
> > anybody does), but the PCI device ID corruption happened only for a specific
> > set of devices.
> > 
> > Whether it was a timing issue with particular devices or whether it was a
> > timing issue with some particular bridge (and could affect any devices
> > behind that bridge), who knows... It almost certainly was brought on by a
> > borderline (or broken) northbridge, but it apparently only affected specific
> > devices - which makes me suspect that it wasn't *entirely* due to just the
> > northbridge, and it was a combination of things.
> 
> Pointer to such a report? The only single-device problems I'm aware of
> are with some devices within the K8 integrated northbridge, which we
> already handle. Other than that, the only non-global problems I'm aware
> of are devices behind host bridges which can't receive/handle MMCONFIG
> requests, in which case the problem would be bus-wide.

There was a thread called "PCI vendor id == 1 regression?" (Kai Ruhnau was 
the main reporter for that one). But looking back, it seems that one 
didn't hit the kernel mailing list, so I guess google cannot pick it up. I 
can forward all the emails if you want, but quite frankly, you don't 
really want to. It boils down to:

Stephen Hemminger:
  "There have been two reports with different hardware of the PCI vendor
   id of 0001 showing up. I got a report on sky2, and Francois saw similar
   problem on r8169.
   In one case, it happened only with 2.6.23 kernel, the correct id was
   returned by older kernels.

   This is a heads up, there may be a PCI problem. Or just
   some users smoking strange fall leaves."

And then one of the reporters:

  "Good kernel:

   02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)
	00: ab 11 64 43 07 00 10 00 12 00 00 02 01 00 00 00

   Bad kernel:

   02:00.0 Ethernet controller: Unknown device 0001:4364 (rev 12)
	00: 01 00 64 43 07 00 10 00 12 00 00 02 01 00 00 00"

and after I suspected it was mmconfig-related and asked him to try "lspci 
-H1" to force conf1 accesses from user space on a broken kernel:

   "Bare lspci gives the wrong vendor ID, lspci -H1 the right one."

for *one* single device.

In other words, just a single word in mmconfig was corrupt, but it was 
consistently corrupt.

The PCI device chain for that particular report was:

	00:00.0 Host bridge: ATI Technologies Inc Unknown device 7930
	..
	00:06.0 PCI bridge: ATI Technologies Inc Unknown device 7936 (prog-if 00 [Normal decode])
	..
	02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)

and with the bug, the PCI vendor ID for that ethernet chip was 0x0001 
(bogus vendor) rather than the correct Marvell ID (0x11ab).

But as mentioned, there were other reports too of the exact same bug (with 
different PCI devices, but the same "vendor == 0001" bogosity).

Googling for

	lspci "Unknown device 0001:" mmconfig

shows reports like these:

	http://lkml.org/lkml/2007/10/29/500
	http://madwifi.org/ticket/1587
	http://www.nvnews.net/vbulletin/showthread.php?t=103271
	http://naoya.g.hatena.ne.jp/naoya/20070529/1180436756
	http://bbs.archlinux.org/viewtopic.php?id=34321
	...

which all seem to be due to this same bug with different cards (but the 
common theme seems to be an ATI northbridge).

The point is: mmconfig is easily broken. In surprising ways. The whole 
concept is stupid, it was badly done, and it has never gotten any testing 
what-so-ever until Linux started using it (and now Vista). And hardware 
that isn't tested is broken by *definition*.

And there's no point in blaming AMD. They may have gotten it wrong, but 
hey, so did Intel (with machines that lock up completely), so it's not 
like this is some "bad AMD" case. It's a "bad mmconfig" case.

	                    Linus
