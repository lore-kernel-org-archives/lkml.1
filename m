Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbZHYE0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbZHYE0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 00:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZHYE0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 00:26:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:57017 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZHYE0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 00:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PSgOt5CsfTGTZBwBVfa2iYwoYrg2eWH3u9rVuY9ZTnoN7usgIlExLmhtpKr1qeYwLt
         kwZFq87Y6jl4FIRqSd6i+TTVUrIkC8/JWCxoMEURS7XV3Ko5fecSyEJC5Drp3bBIihuM
         UgWtrM/GhW94pDDHgRVJLbjKEmKiAknYutJ5k=
MIME-Version: 1.0
In-Reply-To: <4A93033B.3050606@vflare.org>
References: <200908241007.47910.ngupta@vflare.org>
	 <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com>
	 <4A92EBB4.1070101@vflare.org>
	 <84144f020908241243y11f10e8eudc758b61527e0e9c@mail.gmail.com>
	 <4A93033B.3050606@vflare.org>
Date: Tue, 25 Aug 2009 07:26:53 +0300
X-Google-Sender-Auth: add3a91f9cbe9283
Message-ID: <84144f020908242126n5c7d93aah7305f4da64f6965@mail.gmail.com>
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org, hugh.dickins@tiscali.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Tue, Aug 25, 2009 at 12:16 AM, Nitin Gupta<ngupta@vflare.org> wrote:
> Now, if code cleanup is the aim rather that reducing the no. of conversions,
> then I think use of PFNs is still preferred due to minor implementation
> details mentioned above.
>
> So, I think the interface should be left in its current state.

I don't agree. For example, grow_pool() does xv_alloc_page() and
immediately passes the PFN to get_ptr_atomic() which does conversion
back to struct page. Passing PFNs around is not a good idea because
it's very non-obvious, potentially broken (the 64-bit issue Hugh
mentioned), and you lose type checking. The whole wrapper thing around
kmap() (which is also duplicated in the actual driver) is a pretty
clear indication that you're doing it the wrong way.

So again, _storing_ PFNs in internal data structures is probably a
reasonable optimization (given the 64-bit issues are sorted out) but
making the APIs work on them is not. It's much cleaner to have few
places that do page_to_pfn() on stores and pass struct pages around.

                        Pekka
