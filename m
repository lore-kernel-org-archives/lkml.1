Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0CKHWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:22:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0CKHWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:22:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Ds19b1LoTRnNSrjcni1IDJwP+K5Vge1TLxSCBM/5QLFVG2cUNV5dS/CtoENOw8KRO
	eR0lzZOLTp0JYcs47w1EQ==
Date: Thu, 11 Mar 2010 07:22:05 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nitin Gupta <ngupta@vflare.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@gmail.com>, andi@firstfloor.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed
 memory
In-Reply-To: <d760cf2d1003050222m6e509ffaqa498645c52f7d98e@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1003110706340.29854@sister.anvils>
References: <d760cf2d1003050222m6e509ffaqa498645c52f7d98e@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Mar 2010, Nitin Gupta wrote:

> ramzswap driver creates RAM based block devices which can be
> used (only) as swap disks. Pages swapped to these disks are
> compressed and stored in memory itself.
> 
> However, these devices do not get any notification when a swap
> slot is freed (swap_map[i] reaches 0). So, we cannot free memory
> allocated corresponding to this swap slot. Such stale data can
> quickly accumulate in (compressed) memory defeating the whole
> purpose of such devices.
> 
> To overcome this problem, we now add a callback in 'struct swap_info_struct'
> which is called as soon as a swap slot is freed.
> 
> Adding handler for this callback:
> 	swapon notifier --> set_swap_free_notify(swap_type, fn)
> 
> Removing handler:
> 	swapoff notifier --> set_swap_free_notify(swap_type, NULL)
> 
> 
> Alternative approaches:
> 1) Add callback directly in 'struct block_device_operations' but
> that is considered too hacky.
> 2) Use swap discard mechanism: It involves unncessary overhead of
> allocating 'discard bio' requests and its too slow to serve ramzswap
> needs.
> 
>  drivers/staging/ramzswap/ramzswap_drv.c   |   91 +++++++++++++++++++++++++++++
>  drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
>  drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
>  include/linux/swap.h                      |   16 +++++-
>  mm/swapfile.c                             |   78 ++++++++++++++++++++++++
>  5 files changed, 185 insertions(+), 2 deletions(-)

This is one of the various solutions I disliked already, isn't it?

To me this is just a more convoluted and obscure variant of the
block_device_operations swap_slot_free_notify patch you had in mmotm,
which Linus has rejected.

I admit, I did not understand at all what Linus was proposing with
readpage, writepage and address_space_operations: I kept quiet in
the hope that you'd understand where I didn't!

Hugh
