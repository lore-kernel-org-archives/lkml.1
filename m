Return-Path: <linux-kernel-owner+w=401wt.eu-S1751813AbYLAHPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbYLAHPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 02:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAHPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 02:15:34 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:34716 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYLAHPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 02:15:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Z1SlpBsWmGmzrdyR7X2DzwyeGdSGlPEOsFRavWliBbA+13j5m2zG+N5Mkm7B1zoUUe
         grrQX1Lkq82tYbNnC6MIKukI1uKPA+IJtlOgWFWAb7DVL/IYx/NNAo+9RbZLrB3UnoYG
         zt/04iSwXMahxwR/M4Pxf+lFkkJA8aao3LVY4=
Message-ID: <84144f020811302315p2ba9fb55g4319ad12a7fa4347@mail.gmail.com>
Date: Mon, 1 Dec 2008 09:15:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: f0c4d8b7d38d599f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Sat, Nov 29, 2008 at 12:43 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> +/*
> + * Insert a pointer into the pointer hash table.
> + */
> +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
> +{

[...]

> +       if (ptr < min_addr)
> +               min_addr = ptr;
> +       if (ptr + size > max_addr)
> +               max_addr = ptr + size;
> +       /*
> +        * Update the boundaries before inserting the object in the
> +        * prio search tree.
> +        */
> +       smp_mb();

I'm not sure I understand the purpose of this memory barrier. As soon
as some other CPU acquires object_tree_lock, updates to the boundaries
will be visible due to the implicit memory barriers in locking
functions (see Documentation/memory-barrier.txt for details).

However, I'm wondering why this isn't a smp_wmb() and..

> +/*
> + * Scan a block of memory (exclusive range) for pointers and move
> + * those found to the gray list.
> + */
> +static void scan_block(void *_start, void *_end, struct memleak_object *scanned)
> +{
> +       unsigned long *ptr;
> +       unsigned long *start = PTR_ALIGN(_start, BYTES_PER_WORD);
> +       unsigned long *end = _end - (BYTES_PER_WORD - 1);
> +
> +       for (ptr = start; ptr < end; ptr++) {

...why don't we have the pairing smp_rmb() here before we read
min_addr and max_addr?

> +
> +               /*
> +                * The boundaries check doesn't need to be precise
> +                * (hence no locking) since orphan objects need to
> +                * pass a scanning threshold before being reported.
> +                */
> +               if (pointer < min_addr || pointer >= max_addr)
> +                       continue;

                Pekka
