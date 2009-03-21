Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbZCURhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbZCURhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 13:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZCURhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 13:37:24 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:59538 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZCURhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 13:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wIQyRng+6vVlivyYKaU1+VcDT4zRNkmS6eaT6pwU2BoM6lMltUGX+9FVhTVNKy5K4v
         86KLvgo4IO8qthBH7rFqCPMAlBYS33mgH8sqXfPb2+UrLvwD85RRGX7Y1EY9sFGg28zW
         cJedMU+/Jt8rp/ejxyR5lPVyP2Kg9Ludl2XWg=
Message-ID: <49C5258D.4030900@vflare.org>
Date: Sat, 21 Mar 2009 23:06:13 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
References: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>	 <49C3F1EE.90903@vflare.org>	 <20090321032137.8dc113e8.akpm@linux-foundation.org>	 <49C4D9C4.1030103@vflare.org>	 <20090321052416.6eb38759.akpm@linux-foundation.org> <84144f020903210921m7603b9bfwed948a016b2f9429@mail.gmail.com>
In-Reply-To: <84144f020903210921m7603b9bfwed948a016b2f9429@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Sat, Mar 21, 2009 at 2:24 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> I assumed that you were referring to moving xvmalloc() down into
>> drivers/block.  That would be bad, because then xvmalloc() will _never_ be
>> usable by anything other than ramzblock <new name!>?
> 
> Who is going to use it? The only reason compcache needs something
> special is because it wants to take advantage of GFP_HIGHMEM pages.
> Are there other subsystems that need this capability as well?
> 

As I mentioned earlier, highmem is not the only advantage. Don't forget
O(1) alloc/free and low fragmentation. Sometime in next week, I will post
additional numbers comparing SLUB and xvmalloc.

One point I noted in SLUB is that, it needs to allocate higher order pages
to minimize space wastage at end of every page. For in-memory swap compression,
we simply cannot allocate higher order pages since its going to used under
memory crunch (its a swap device!) and we cannot hope to find lot of higher
order pages under such conditions. If we enforce it to use 0-order pages
then we cannot allocate > 2048b since all such allocations will end-up
using entire page!
Also, if we decide to use SLUB for objects of size < 2048b only then how will
we store bigger objects provided we can only use 0-order pages?
(we need storage for range, say, [32, 3/4*PAGE_SIZE]).

Nitin
