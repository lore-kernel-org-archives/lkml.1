Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXDKSPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXDKSPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXDKSPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:15:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14663 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbXDKSPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:15:48 -0400
Date: Wed, 11 Apr 2007 11:15:14 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070411181514.GO28322@mami.zabbo.net>
References: <20070410235353.325A7346F64@localhost> <20070410221849.dcec1ce3.akpm@linux-foundation.org> <b040c32a0704110954q64694780v1d57937cfcc3466d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0704110954q64694780v1d57937cfcc3466d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry I wasn't thorough enough.  And partially because I was worried
> about changing structure type for user space facing struct aio_ring.
> Now that I looked through all arches, it looks safe as all arch's
> atomic_t has the same size as int.

> Here is the updated patch.

> @@ -144,7 +144,7 @@ struct kiocb {
>  struct aio_ring {
>  	unsigned	id;	/* kernel internal index number */
>  	unsigned	nr;	/* number of io_events */
> -	unsigned	head;
> +	atomic_t	head;
>  	unsigned	tail;

Embedding an atomic_t in an ABI struct?  That makes everyone else
nervous too, right?

It may look safe on i386/x86-64 today, but this doesn't seem like wise
practice.  Is there any reason to believe that atomic_t will never
change size?  Does anything else do this already?

If nothing else, the "unsigned" (should be __u32, sigh) could be cast to
an atomic_t.

Is being able to do atomic work on a u32 between the kernel and
userspace something that all archs have support for?  I mean, take the
fact that userspace and the kernel could both be doing these atomic ops
on different virtual addresses and so conceivably different cachelines.
Is that a problem for anyone?

I do find myself wondering if the notion of userspace ring
synchronization shouldn't be built around futexes.  They weren't around
when this mmap()ed ring business was created.

- z
