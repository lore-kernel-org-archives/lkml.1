Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYGIKGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYGIKGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYGIKGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:06:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:44520 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbYGIKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Y8eZjzC0+joD9zkv8TxgZxKqVmD/x9zNySc3SjRZQ/UfF+xwc1HdctXuLJ9dfP8S1C
         oLqM0aLI70btyfpOfCjU2WG113ug4jZBENrMzi9UTDP5ru1rrxjcOEsHoKOdlmJbwCDx
         i6bZKupQkEWtG1s1t2p605+q2CQ/YSWxTziLo=
Message-ID: <84144f020807090306o49f4deb4m3ded12acc961f214@mail.gmail.com>
Date: Wed, 9 Jul 2008 13:06:45 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: KokHow.Teh@infineon.com
Subject: Re: Kmem_cache handling in linux-2.6.2x kernel
Cc: linux-kernel@vger.kernel.org,
       "Christoph Lameter" <cl@linux-foundation.org>
In-Reply-To: <31E09F73562D7A4D82119D7F6C172986046C6ACA@sinse303.ap.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31E09F73562D7A4D82119D7F6C172986046C6ACA@sinse303.ap.infineon.com>
X-Google-Sender-Auth: d2560ad5465d8002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 9, 2008 at 8:06 AM,  <KokHow.Teh@infineon.com> wrote:
>        I have a question about kmem_cache implemented in Linux-2.6.2x
> kernel. I have an application that allocates and free 64KByte chunks of
> memory (32-byte aligned) quite often. Therefore, I create a lookaside
> cache for that purpose and use kmem_cache_alloc(), kmem_cache_free() to
> allocate and free the caches. The application works very well in this
> model. However, my concern here is if kmem_cache_free() does return the
> cache to the system-wide pool so that it could be used by other
> applications when need arises; when system is low in memory resources,
> for instance. This is a question about the internal workings of the
> memory management system of the Linux-2.6.2x kernel as to how efficient
> it manages this lookasie caches. The concern is valid because if this
> lookaside cache is not managed well, i.e, it is not returned to the
> system-wide free memory pools to be used by other applications, this
> will penalize the performace and throughput of the whole system due to
> the dynamic behaviour of the utilization of system memory resources. For
> example, other applications might be swapping in and out of the harddisk
> and if the kmem_cache_free()'ed memory objects could be used by these
> applications, it will help in this case to reduce the number of swaps
> that happen, thereby freeing the CPU and/or DMA from doing the swapping
> to do other critical tasks.

I'm not sure I understand the question. The pages allocated for a
particular cache are given back to the page allocator whenever all
objects of a slab are freed. In addition, SLUB does slab merging so
the same cache can be transparently used by other kmem_cache_alloc()
callers. So there really are no reservation guarantees for a cache in
OOM conditions.

On Wed, Jul 9, 2008 at 8:06 AM,  <KokHow.Teh@infineon.com> wrote:
>        On the other hand, if the caches are returned to the system-wide
> free memory pool, what are the advantages of using kmem_cache_t compared
> to the conventional kmalloc()/kfree()?

The main advantages for using kmem_cache_create() are that (1) you
control the alignment and (2) you get tighter packing for the objects
(less internal fragmentation).
