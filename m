Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbYBRKCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbYBRKCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbYBRKAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:00:19 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:21697 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539AbYBRKAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:00:16 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] drivers/base: export gpl (un)register_memory_notifier
Date: Mon, 18 Feb 2008 11:00:11 +0100
User-Agent: KMail/1.8.2
Cc: Dave Hansen <haveblue@us.ibm.com>, Christoph Raisch <RAISCH@de.ibm.com>,
       Thomas Q Klein <TKLEIN@de.ibm.com>, ossthema@linux.vnet.ibm.com,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, Greg KH <greg@kroah.com>,
       apw <apw@uk.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, netdev <netdev@vger.kernel.org>,
       tklein@linux.ibm.com
References: <200802111724.12416.ossthema@de.ibm.com> <OF58A8E0B3.B5CC265E-ONC12573F0.00496E2B-C12573F0.0049850F@de.ibm.com> <1203094538.8142.23.camel@nimitz.home.sr71.net>
In-Reply-To: <1203094538.8142.23.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802181100.12995.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

switching to proper mail client...

Dave Hansen <haveblue@us.ibm.com> wrote on 15.02.2008 17:55:38:

> I've been thinking about that, and I don't think you really *need* to
> keep a comprehensive map like that. 
> 
> When the memory is in a particular configuration (range of memory
> present along with unique set of holes) you get a unique ehea_bmap
> configuration.  That layout is completely predictable.
> 
> So, if at any time you want to figure out what the ehea_bmap address for
> a particular *Linux* virtual address is, you just need to pretend that
> you're creating the entire ehea_bmap, use the same algorithm and figure
> out host you would have placed things, and use that result.
> 
> Now, that's going to be a slow, crappy linear search (but maybe not as
> slow as recreating the silly thing).  So, you might eventually run into
> some scalability problems with a lot of packets going around.  But, I'd
> be curious if you do in practice.

Up to 14 addresses translation per packet (sg_list) might be required on 
the transmit side. On receive side it is only 1. Most packets require only 
very few translations (1 or sometimes more)  translations. However, 
with more then 700.000 packets per second this approach does not seem 
reasonable from performance perspective when memory is fragmented as you
described.

> 
> The other idea is that you create a mapping that is precisely 1:1 with
> kernel memory.  Let's say you have two sections present, 0 and 100.  You
> have a high_section_index of 100, and you vmalloc() a 100 entry array.
> 
> You need to create a *CONTIGUOUS* ehea map?  Create one like this:
> 
> EHEA_VADDR->Linux Section
> 0->0
> 1->0
> 2->0
> 3->0
> ...
> 100->100
> 
> It's contiguous.  Each area points to a valid Linux memory address.
> It's also discernable in O(1) to what EHEA address a given Linux address
> is mapped.  You just have a couple of duplicate entries. 

This has a serious issues with constraint I mentions in the previous mail: 

"- MRs can have a maximum size of the memory available under linux"

The requirement is not met that the memory region must not be 
larger then the available memory for that partition. The "create MR" 
H_CALL will fails (we tried this and discussed with FW development)


Regards,
Jan-Bernd & Christoph
