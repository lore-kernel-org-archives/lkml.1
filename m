Return-Path: <linux-kernel-owner+w=401wt.eu-S965313AbXBUDzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965313AbXBUDzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 22:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965324AbXBUDzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 22:55:49 -0500
Received: from PPPa3.e4.eacc.dti.ne.jp ([124.255.36.4]:1040 "EHLO
	jroun.nowhere" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965313AbXBUDzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 22:55:48 -0500
X-Greylist: delayed 2863 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 22:55:48 EST
From: hooanon05@yahoo.co.jp
Subject: Re: [Unionfs] Re: [-mm patch] UNION_FS must depend on SLAB 
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, unionfs@filesystems.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070220151356.GA19239@filer.fsl.cs.sunysb.edu>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070220000810.GK13958@stusta.de> <84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com> <20070220151356.GA19239@filer.fsl.cs.sunysb.edu>
Date: Wed, 21 Feb 2007 12:07:27 +0900
Message-Id: <E1HJhpH-0000fR-4w@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Josef Sipek:
> That's the only user of malloc_sizes. It is supposed to be an optimization -
> we get the smallest sized piece of memory even if we don't need all of it.
> This way we don't reallocate & memcpy needlessly.

How about exporting ksize to modules, and introduce a new function such
like this?
Of course, adding gfp_t to its parameter list make this function more generic.

void *kzrealloc(void *p, int nused, int new_sz)
{
	void *q;

	if (new_sz <= nused)
		return p;
	if (new_sz <= ksize(p)) {
		memset(p + nused, 0, new_sz - nused);
		return p;
	}

	q = kmalloc(new_sz, GFP_KERNEL);
	if (unlikely(!q))
		return NULL;
	memcpy(q, p, nused);
	memset(q + nused, 0, new_sz - nused);
	kfree(p);
	return q;
}


Junjiro Okajima
