Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYICJ1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYICJ1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYICJ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:27:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:2546 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYICJ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oqRk0MNxaFhc4bFZnKKRTSHbT6dvxJUFqNlEv3DEjrqAS5njmFf36aCWzmk3rTQtVh
         vwJCfjkV2NQXZd9FWZaczCpzS5++adDzZm5exflPZvzp0tZ7ov6uOCzk1j0JsB15IGHK
         GUGcW3UGlPYHyJxdaAo2xczqsOYythHQX8YjY=
Message-ID: <84144f020809030227jce7d3c2wab9e9c00b2fcdfe5@mail.gmail.com>
Date: Wed, 3 Sep 2008 12:27:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Steve VanDeBogart" <vandebo-lkml@nerdbox.net>
Subject: Re: [uml-devel] [PATCH 5/6] slab: Annotate slab
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       dkegel@google.com, jiayingz@google.com,
       "John Reiser" <jreiser@bitwagon.com>
In-Reply-To: <alpine.DEB.1.00.0809022036560.15543@abydos.NerdBox.Net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
	 <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net>
	 <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
	 <alpine.DEB.1.00.0809022036560.15543@abydos.NerdBox.Net>
X-Google-Sender-Auth: 8442108d6b11fafe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, Sep 3, 2008 at 8:08 AM, Steve VanDeBogart
<vandebo-lkml@nerdbox.net> wrote:
> Thank you for pointing out the location of the kmemcheck code.  I looked
> around briefly but didn't find the latest version.  It does seem that
> kmemcheck and Valgrind annotations want to live in the same places so it
> makes perfect sense to combine them where possible.  I'm not exactly sure
> what you find so ugly about the Valgrind annotations, please elaborate.

Upper case macros and littering #ifdefs in the code. See the kmemcheck
hooks how to do it in a clean way.

On Wed, Sep 3, 2008 at 8:08 AM, Steve VanDeBogart
<vandebo-lkml@nerdbox.net> wrote:
> It is true that code above the allocator should not be touching free'd
> slab objects.  However, it is also true that objects from slabs that
> have a constructor should retain their per byte un/initialized state
> through allocation and free cycles (just the semantic of slabs with
> constructors AFAICT).

Sorry for being unclear, sure, object should be marked as initialized
when they're returned from kmem_cache_alloc(). However, what I
disagree with is *where* you're marking them as initialized. Surely
they're not semantically initialized when the slabs are allocated
(although technically they are).

On Wed, Sep 3, 2008 at 8:08 AM, Steve VanDeBogart
<vandebo-lkml@nerdbox.net> wrote:
> Ideally, we'd tell Valgrind that the bytes of a free'd slab object are
> no longer accessible, but the initialized state should remain the same
> until the object is made accessible again by the next allocation of
> the object.  Unfortunately, the compression method for A & V bits in
> Valgrind doesn't allow a region to be inaccessible and retain validness
> bits.

I don't see why you should mark them initialized all the time. Just
mark them as uninitialized on kmem_cache_free() and again as
initialized when they're about to be returned from kmem_cache_alloc()
like we do in kmemcheck.

                              Pekka
