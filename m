Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXFZFBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXFZFBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXFZFBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:01:38 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:37351 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751957AbXFZFBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:01:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=OVQgLo0Wfhm/hZ1XjYx5NS0rzCT8WZJNyAaQCTUoAbVtiNrLbFlreh8nadow1xTCKrh08S4D/1vC86q77sg0DWhXKEXrjpD3SWtgP3/UGmWQI89Oznywsd8bkCyRLHt3/7E9caQsGYr8sx2SLr4RohnCqF9q/YLp94AtYAcLx/s=  ;
X-YMail-OSG: ASJMBAUVM1mjHmGUvTwpNImkEvpLcKVs_jQeWD3_2lUgsGaTpHWaOOuDgSsy3RL94aD3_iu8Pg--
Message-ID: <46809D88.2080208@yahoo.com.au>
Date: Tue, 26 Jun 2007 15:00:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLOB allocator imcompatible SLAB
References: <m2tzt01kew.wl%ysato@users.sourceforge.jp> <20070622145635.GX11115@waste.org> <m2ejk05y7c.wl%ysato@users.sourceforge.jp> <468090B7.2080200@yahoo.com.au> <20070626045635.GC11115@waste.org>
In-Reply-To: <20070626045635.GC11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Tue, Jun 26, 2007 at 02:06:15PM +1000, Nick Piggin wrote:
> 
>>Yoshinori Sato wrote:
>>
>>>At Fri, 22 Jun 2007 09:56:35 -0500,
>>>Matt Mackall wrote:
>>>
>>>
>>>>On Fri, Jun 22, 2007 at 05:08:07PM +0900, Yoshinori Sato wrote:
>>>>
>>>>
>>>>>Because the page which SLOB allocator got does not have PG_slab,
>>>>
>>>>This is for a NOMMU system?
>>>
>>>
>>>Yes.
>>>
>>>
>>>
>>>>You're using an old kernel with an old version of SLOB. SLOB in newer
>>>>kernels actually sets per-page flags. Nick, can you see any reason not
>>>>to s/PG_active/PG_slab/ in the current code?
>>
>>The problem with this is that PG_private is used only for the SLOB
>>part of the allocator and not the bigblock part.
> 
> 
> That's fine, at least for the purposes of kobjsize. We only mark
> actual SLOB-managed pages, kobjsize assumes the rest are alloc_pages
> and that's indeed what they are.

OK, but that only makes it work in this case. I think we should
either call PG_slab part of the kmem/kmalloc API and implement
that, or say it isn't and make nommu do something else?


>>We _could_ just bite the bullet and have SLOB set PG_slab, however
>>that would encouarage more users of this flag which we should hope
>>to get rid of one day.
>>
>>The real problem is that nommu wants to get the size of either
>>kmalloc or alloc_pages objects and it needs to differentiate
>>between them. So I would rather nommu to take its own page flag
>>(could overload PG_swapcache, perhaps?), and set that flag on
>>pages it allocates directly, then uses that to determine whether
>>to call ksize or not.
> 
> 
> I think we already established on the last go-round that the kobjsize
> scheme was rather hopelessly broken anyway. 

I can't remember, but that would be another good reason to confine
it to nommu.c wouldn't it?

-- 
SUSE Labs, Novell Inc.
