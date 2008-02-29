Return-Path: <linux-kernel-owner+w=401wt.eu-S932957AbYB2Suk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957AbYB2Suk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbYB2Suc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:50:32 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:36992
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbYB2Sub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:50:31 -0500
Date: Fri, 29 Feb 2008 19:50:29 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] reserve RAM below PHYSICAL_START
Message-ID: <20080229185029.GZ8091@v2.random>
References: <20080227003325.GS28483@v2.random> <47C84D14.2000400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C84D14.2000400@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Feb 29, 2008 at 10:21:08AM -0800, H. Peter Anvin wrote:
> Hi Andrea,
>
> Sorry for the long delay in replying.
>
> I'm trying to grok the use cases for this.  In particular, it seems like a 
> particularly restricted case of wanting to be able to reserve an arbitrary 
> bit of memory, which seems like it would be more useful (don't we already 
> have memmap= options for that, anyway?)

I'll answer the memmap in separate email.

> In particular, what's the reason for reserving *low* memory?  Low memory 
> (first megabyte) is full of special-use address space which, as the Xen 

The only special ones are zero page and trampoline (the trampoline
optionally can later be moved near 640k with an independent patch).

> address space discussion has showed, is nontrivial to tamper with even if 
> it initially works.  If you want a dedicated chunk of mappable PCI space, 
> it would seem cleaner to have it higher up in the memory map.

The whole e820 must be PCI mappable, bootloader starts in real mode
and if any dma happens it will crash. This is to let any guest OS or
bootloader run with pci passthrough. There's no paravirt here, the
guest has fully native drivers (which is the whole point of this
approach I guess).

This will allow things like running random 3d apps on a random 3d card
on random OS with random 3d driver, all on top of linux host that
leaves the first 1G free for this OS to run with direct access to the
graphics card. Clearly linux host isn't safe, but if you trust that
guest OS that talks directly to the 3d card, you can run many more
guests that are fully swapped out or ballooned or rss limited or ksm
shared, etc... plus the host can run apps too. This is to retain the
full KVM/Linux virtualization power and flexibility without leaving 3d
or any other proprietary hardware out of the equation in the
pci-passthrough guest.
