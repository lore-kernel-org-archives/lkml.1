Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbYGIKmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbYGIKmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYGIKmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:42:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:63514 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYGIKmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:42:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=d0K6H33tSlvMwxwraJ3DBZLNU5vHc/KgxeHxs51LH7qhPEmbwGcROjcJe0axwkydNu
         n43pOka9BIN2rjrFavRbJPyJTfkzvqntmclqg4rfvmyBL5vigFjx1GF3l5TFq5+X/n1u
         TUnnGhwP9KauH/olLwAvl8LR9pJb0JVN3bqkA=
Message-ID: <84144f020807090342h36719b2exa8bea85625a127e9@mail.gmail.com>
Date: Wed, 9 Jul 2008 13:42:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: KokHow.Teh@infineon.com
Subject: Re: Kmem_cache handling in linux-2.6.2x kernel
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <31E09F73562D7A4D82119D7F6C172986046C7113@sinse303.ap.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <31E09F73562D7A4D82119D7F6C172986046C6ACA@sinse303.ap.infineon.com>
	 <84144f020807090306o49f4deb4m3ded12acc961f214@mail.gmail.com>
	 <31E09F73562D7A4D82119D7F6C172986046C7113@sinse303.ap.infineon.com>
X-Google-Sender-Auth: 13fe413557e3b3e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 9, 2008 at 1:30 PM,  <KokHow.Teh@infineon.com> wrote:
> In my applications, only part of total number of objects of the
> kmem_cache are freed. So my question is what happen to these "freed"
> objects? How are these "freed" objects managed by the linux-MM? Would
> they be reused by other kmem_cache_alloc() and/or kmalloc()?

The free'd objects will be returned to the cache and are, of course,
reused by later kmem_cache_alloc() and kmalloc() calls. Note that with
_SLAB_, you never have cache sharing, so an object free'd by
kmem_cache_free() is only available for a kmem_cache_alloc() of the
same cache.

At some point in time, I wrote:
>>In addition, SLUB does slab merging so the same cache can be
>> transparently used by other kmem_cache_alloc() callers. So there really
>> are no reservation guarantees for a cache in OOM conditions.

On Wed, Jul 9, 2008 at 1:30 PM,  <KokHow.Teh@infineon.com> wrote:
> (1) SLUB is not available in 2.6.20 kernel which I am using for my
> products. In this case, is there similar mechamisms in place to
> faciliate "page-sharing" amongst the kmem_cache_alloc() callers?

No.

On Wed, Jul 9, 2008 at 1:30 PM,  <KokHow.Teh@infineon.com> wrote:
> (2) Does this "page-sharing" happen for kmalloc() callers?

The caches for kmalloc() are set up first, so a kmalloc() never dips
into a cache created by kmem_cache_create(). But a kmem_cache_alloc()
can dip into a kmalloc cache. Look at the create_kmalloc_cache() calls
in kmem_cache_init() and the find_mergeable() call in
kmem_cache_create() in mm/slub.c for details.

Btw, you mentioned that you're allocating 64 KBs. So with SLUB, if you
use _kmalloc()_ the request will be passed through to the page
allocator directly (see kmalloc_large()).
