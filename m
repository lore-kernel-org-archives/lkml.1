Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZEUUTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZEUUTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZEUUS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:18:57 -0400
Received: from claw.goop.org ([74.207.240.146]:33146 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbZEUUS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:18:56 -0400
Message-ID: <4A15B72E.2070202@goop.org>
Date: Thu, 21 May 2009 13:18:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org> <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org> <20090519142656T.fujita.tomonori@lab.ntt.co.jp> <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org> <4A1592CF.8000208@goop.org> <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
In-Reply-To: <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
> I can work with that, but it's going to be a bit inefficient, as I 
> actually need the dma_addr_t, not the phys_addr_t, so I'll have to 
> convert.  In every case, this is a conversion I've already done and 
> that I need in the calling code as well.  Can we pass in both the 
> phys_addr_t and the dma_addr_t?

The Xen implementation would needs to do the phys to bus conversion page 
by page anyway, so it wouldn't help much.  But it also wouldn't hurt.

How expensive is the phys-to-bus conversion on power?  Is it worth 
making the interface more complex for?  Would passing phys+bus mean that 
we wouldn't also need to pass dev?

> We have both in every case but one, which is in swiotlb_map_page where 
> we call address_needs_mapping() without calling range_needs_mapping.  
> It's not actually clear to me that we need that check, though.  Can 
> someone explain what case that was designed to catch?

It called them together a little earlier in the function, and the phys 
address is still available.

I guess the test is checking for a bad implementation of map_single().  
I found a single instance of someone reporting the message (in 2.6.11, 
when swiotlb was ia64-specific: http://lkml.org/lkml/2008/3/3/249).  
panic() is an odd way to handle an error (even an one which is an 
implementation bug), but I guess it's better than scribbling on the 
wrong memory.

    J
