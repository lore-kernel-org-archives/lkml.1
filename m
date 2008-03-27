Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYC0AJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYC0AJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYC0AJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:09:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46331 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbYC0AJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:09:24 -0400
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <47EAD83A.2000000@goop.org>
References: <47EAD83A.2000000@goop.org>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 17:09:04 -0700
Message-Id: <1206576544.7883.21.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 16:11 -0700, Jeremy Fitzhardinge wrote:
> 
> 
> I'm trying to make use of hotplug memory in the Xen balloon driver.
> If 
> you want to expand a domain to be larger than its initial size, it
> must 
> add new page structures to describe the new memory.
> 
> The platform is x86-32, with CONFIG_SPARSEMEM and 
> CONFIG_HOTPLUG_MEMORY.  Because the new memory is only
> pseudo-physical, 
> the physical address within the domain is arbitrary, and I added a 
> add_memory_resource() function so I could use allocate_resource() to 
> find an appropriate address to put the new memory at.
> 
> When I want to expand the domain's memory, I do (error checking
> edited 
> out for brevity):
> 
>         res = kzalloc(sizeof(*res), GFP_KERNEL);
> 
>         res->name = "Xen Balloon";
>         res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> 
>         ret = allocate_resource(&iomem_resource, res, size, 0, -1,
>                                 PAGE_SIZE, NULL, NULL);
> 
>         ret = add_memory_resource(0, res);

Yeah, this is your problem.  You've only allocated the iomem *resource*
for the memory area, which means that you've basically claimed the
physical addresses.

But, you don't have any 'struct page's there.

We really screwed up the memory hotplug code and ended up with some
incredibly arcane function names.  You might want to look at
add_memory().  It is hidden away in mm/memory_hotplug.c :)

You might also note that most of the ppc64 memory hotplug is driven by
userspace.  The hypervisor actually contacts a daemon on the guest to
tell it where its new memory is.  That daemon does the addition
through /sys/devices/system/memory/probe.  

-- Dave

