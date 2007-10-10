Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXJJMXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXJJMXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 08:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbXJJMWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 08:22:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:3919 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbXJJMWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 08:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=OqJqeJnwSPhWVAy1vnr5lZopa20N8uksUI4v011qohhEJtX88xzaq9DRL1+zCznpsEy5bZjRYB7bb7RKUDh5OKSfVu/rvzWAJQCIIF0SG6Q5jLNgIwBqYZ8cWMtZ6jUVtoLWlfhMCUlwNlbow32AfMLrkdq813BtCsax/kDX8Pw=
Date: Wed, 10 Oct 2007 21:18:54 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
Message-ID: <20071010121853.GA3911@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <20071009161328.GA6470@APFDCB5C> <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 11:46:14AM -0700, Christoph Lameter wrote:
> On Wed, 10 Oct 2007, Akinobu Mita wrote:
> 
> > This patch removes init_alloc_cpu_cpu() from cpu hotplug notifier. But
> > call it for each possible CPUs not only online CPUs at initialization time.
> 
> Could you check if a per cpu structure has already been allocated and then 
> simply skip the call to init? Otherwise we end up with lots of per cpu 
> structures for cpus that will never show up. 
> 
> if (!get_cpu_slab(s, cpu))
> 	init_alloc_cpu_cpu( ...)
> 

I couldn't use get_cpu_slab() for that check. But I reviced the patch to do
what you said.

Subject: slub: fix cpu hotplug offline/online path

This patch fixes the problem introduced by:
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch

I got slub BUG report when I tried to do cpu hotplug/unplug
$ while true; do
	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu1/online
done

This is because init_alloc_cpu_cpu() is called every time when the CPU is
going to be onlined but init_alloc_cpu_cpu() is not intented to be called
twice or more for same CPU. Then it breaks kmem_cache_cpu_free list for
the CPU.

This patch checks if a per cpu structure has already been allocated and then
simply skip the call to init_alloc_cpu_cpu().

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/slub.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: 2.6-mm/mm/slub.c
===================================================================
--- 2.6-mm.orig/mm/slub.c
+++ 2.6-mm/mm/slub.c
@@ -2033,6 +2033,11 @@ static void init_alloc_cpu_cpu(int cpu)
 {
 	int i;
 
+	if (per_cpu(kmem_cache_cpu_free, cpu)) {
+		/* Already initialized once */
+		return;
+	}
+
 	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
 		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
 }
