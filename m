Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbXFDSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbXFDSrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbXFDSrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:47:33 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756150AbXFDSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:47:32 -0400
Date: Mon, 4 Jun 2007 11:47:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Christoph Lameter wrote:
>
> Instead of returning the smallest available object return ZERO_SIZE_PTR.

Ok, I just noticed that this still has a bug: not just kfree(), but 
krealloc() needs to treat ZERO_SIZE_PTR properly.

Your patch introduces two bugs in mm/slub.c:krealloc():

 - The

	if (unlikely(!p))
		return kmalloc(new_size, flags);

   test needs to be for NULL or ZERO_SIZE_PTR. Otherwise it will oops in 
   ksize(p), I think.

 - And the

	if (unlikely(!new_size)) {
		kfree(p);
		return NULL;
	}

   thing should logically return ZERO_SIZE_PTR instead of NULL.

So basically

	krealloc(kmalloc(0), n, flags);

must work, and

	krealloc(old, 0, flags)

should return a zero-sized allocation.

I'd forgotten about krealloc(), because that whole concept is fairly new.

		Linus
