Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZFYOTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZFYOTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZFYOTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:19:44 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51995 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZFYOTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:19:43 -0400
Subject: Re: More odd kmemleak traces.
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090625003451.GA23387@redhat.com>
References: <20090625003451.GA23387@redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 25 Jun 2009 15:19:30 +0100
Message-Id: <1245939570.26218.59.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 14:19:31.0529 (UTC) FILETIME=[F4F85390:01C9F59F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 20:34 -0400, Dave Jones wrote:
> I see a bunch of kmemleak traces on one of my machines.
> These traces all seem to be early allocations during boot up,
> and I don't see anything obvious from the traces to figure out what
> we're leaking.  False positives?
> 
> Lots of these...
> 
> kmemleak: unreferenced object 0xdb9fde70 (size 40):
> kmemleak:   comm "swapper", pid 1, jiffies 4294668061
> kmemleak:   backtrace:
> kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
> kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
> kmemleak:     [<c066c901>] acpi_ut_allocate_object_desc_dbg+0x46/0x89
[...]

As I said in the previous e-mail, could you enable stack scanning with

echo "stack=on" > /sys/kernel/debug/kmemleak

and then cat /sys/kernel/debug/kmemleak? This should reduce the false
positives quite a lot (but with the risk of more false negatives). The
leaked objects may also be found at a subsequent scan and then kmemleak
reports "referenced object ...".

IIRC, there were some leaks in ACPI code in the past as well but the
code is too complex to be able to check whether they are real or not.

If an object is consistently reported as unreferenced in the
debug/kmemleak file, it means that it wasn't freed and it's pointer
cannot be found. The debug method I use is to try to find where the
pointer is stored in the call path and whether it is still there or not.
Usually one leak in the top part could trigger subsequent reports so
only the first ones may need to be investigated (they are always
reported in the order they were allocated).

> And a few of these in pnp..
> 
> kmemleak: unreferenced object 0xd9d0db40 (size 16):
> kmemleak:   comm "swapper", pid 1, jiffies 4294674288
> kmemleak:   backtrace:
> kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
> kmemleak:     [<c04f5c89>] kmem_cache_alloc_notrace+0x121/0x13d
> kmemleak:     [<c067b9da>] reserve_range+0x4a/0x177
> kmemleak:     [<c067bba5>] system_pnp_probe+0x9e/0xcd
> kmemleak:     [<c0676c30>] pnp_device_probe+0x91/0xc1
[...]
> kmemleak: unreferenced object 0xd9d8c9a0 (size 64):
> kmemleak:   comm "swapper", pid 1, jiffies 4294674288
> kmemleak:   backtrace:
> kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
> kmemleak:     [<c04f5c89>] kmem_cache_alloc_notrace+0x121/0x13d
> kmemleak:     [<c0453d29>] __request_region+0x49/0x175
> kmemleak:     [<c067ba8c>] reserve_range+0xfc/0x177
> kmemleak:     [<c067bba5>] system_pnp_probe+0x9e/0xcd
> kmemleak:     [<c0676c30>] pnp_device_probe+0x91/0xc1

Here, the first object is the kmalloc'ed regionid whose pointer is
stored in the next unreferenced object (res->name in __request_region).
So only the struct resource allocated in __request_region needs to be
investigated.

But, as above, could you try the debug/kmemleak file? It is possible
that it is just transient (if that's the case, I could enable stack
scanning by default to avoid such reports).

Thanks.

-- 
Catalin

