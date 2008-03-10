Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYCJQZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYCJQZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYCJQZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:25:05 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:4033 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750999AbYCJQZE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:25:04 -0400
X-Greylist: delayed 1018 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 12:25:03 EDT
Message-ID: <47D55CE0.3020402@tungstengraphics.com>
Date: Mon, 10 Mar 2008 17:08:00 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [RFC] iomap_atomic_prot_pfn()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

For the new DRM graphics memory manager, there is a need to map and 
patch graphics command buffers from within the kernel. When the memory 
manager has sorted out where the buffers are located, the command stream 
and state buffers need to be patched up with references to the new 
locations. At this point, the buffers are usually located in graphics 
memory or bound to the AGP aperture.

So there is a need to do quick map - write - unmap of a single or 
possibly a pair of these pages, and it seems something like 
kmap_atomic() would be the best thing, in order to avoid IPI tlb flushing.
It seems like ioremap_nocache() is too slow, and it's not really an 
option to permanently map a large area of graphics memory or AGP 
aperture space.

So I've considered implementing something like the following:

void *iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type,
                                                pgprot_t protection);

Initially at least on some architectures: x86 and ppc.

But there are some options:
1) Reuse the fixmap kmap_atomic KM_USER? and KM_IRQ? slots on 
architectures that support them, and add them to the fixmap of the other.
2) Add completely new fixmap slots on all architectures, starting with 
the ones listed above.
3) Don't do any of this, but allocate some permanent ptes using vmap() 
and hack those ptes within the driver when needed.

So basically I'm asking for some guidance on which is the preferred 
method to do this. Any comments appreciated.

/Thomas Hellström
Tungsten Graphics






