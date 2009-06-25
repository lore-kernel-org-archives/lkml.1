Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZFYJZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZFYJZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbZFYJZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:25:35 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55838 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbZFYJZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:25:34 -0400
Subject: Re: kmemleak false positive?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090625001137.GB22755@redhat.com>
References: <20090625001137.GB22755@redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 25 Jun 2009 10:25:17 +0100
Message-Id: <1245921918.26218.19.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 09:25:21.0191 (UTC) FILETIME=[DC8C7B70:01C9F576]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 20:11 -0400, Dave Jones wrote:
> During boot, I see the following traces from kmemleak.
> They seem to be pointing at kmemleak itself. 

The stack trace includes kmemleak_alloc (I skipped one level but
depending on gcc inlining it may need two) but the allocation happened
via debug_objects_mem_init(), more exactly the fill_pool() in
lib/debugobjects.c

> False positive?
[...]
> kmemleak: unreferenced object 0xdb804000 (size 20):
> kmemleak:   comm "swapper", pid 0, jiffies 4294667296
> kmemleak:   backtrace:
> kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
> kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
> kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
> kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
> kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
> kmemleak:     [<ffffffff>] 0xffffffff

It could be a false positive. Do you get some "kmemleak: referenced"
messages as well at a later time? In this case, it is just transient
"leak", caused maybe by pointers stored on the stack or registers.

Is the obj_pool in lib/debugobjects.c supposed to be empty at the end of
the test and all objects freed? The obj_pool is a list and the first
elements in this list are from obj_static_pool, which is __initdata.
Objects added to the list may be referred by chaining with the
obj_static_pool objects but kmemleak doesn't scan __initdata as this is
usually freed before kmemleak does its first scan. So, if it is just a
transient "leak", kmemleak should later report "kmemleak: referenced" if
a kmem_cache_free() is called on any of the reported objects.

You can mount debugfs on /sys/kerne/debug and read the kmemleak file in
there (it triggers a new scan as well). You can also echo stack=on to
the above kmemleak file to enable kernel stack scanning.

Could you send me your config options for DEBUG_OBJECTS_* and slab
allocator so I can try to reproduce this?

Thanks.

-- 
Catalin

