Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYFWFun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYFWFun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYFWFue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:50:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:54810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYFWFud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:50:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,688,1204531200"; 
   d="scan'208";a="580827777"
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
	via linked list of setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <20080618114511.GB28838@elte.hu>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
	 <20080618114511.GB28838@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 23 Jun 2008 13:54:01 +0800
Message-Id: <1214200441.25753.5.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 23 Jun 2008 05:50:30.0341 (UTC) FILETIME=[0B669F50:01C8D4F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul,

This patch can be used for machine whose E820 memory map has more than
128 entries. So it is not necessary to use EFI memory map for this (EFI
memory map is used for EFI runtime services only).

With this patch, your previous patch:

x86 boot: add code to add BIOS provided EFI memory entries to kernel

is not necessary, so can be reversed.

What do you think about that?

Best Regards,
Huang Ying

On Wed, 2008-06-18 at 13:45 +0200, Ingo Molnar wrote:
> * Huang, Ying <ying.huang@intel.com> wrote:
> 
> > Because of the size limits of struct boot_params (zero page), the 
> > maximum number of E820 memory map entries can be passed to kernel is 
> > 128. As pointed by Paul Jackson, there is some machine produced by SGI 
> > with so many nodes that the number of E820 memory map entries is more 
> > than 128. To enabling Linux kernel on these system, a new setup data 
> > type named SETUP_E820_EXT is defined to pass additional memory map 
> > entries to Linux kernel.
> > 
> > This patch is based on x86/auto-latest branch of git-x86 tree and has 
> > been tested on x86_64 and i386 platform.
> 
> applied to tip/x86/mpparse, thanks.
> 
> this bit collided with a recent change:
> 
> > -	do {
> > -		u64 start = biosmap->addr;
> > -		u64 size = biosmap->size;
> > -		u64 end = start + size;
> > -		u32 type = biosmap->type;
> > -
> > -		/* Overflow in 64 bits? Ignore the memory map. */
> > -		if (start > end)
> > -			return -1;
> > -
> > -		add_memory_region(start, size, type);
> > -	} while (biosmap++, --nr_map);
> > -	return 0;
> > +	return __copy_e820_map(biosmap, nr_map);
> 
> because add_memory_region() got renamed to e820_add_region(). I did the 
> obvious fixup.
> 
> 	Ingo
