Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXFZEG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXFZEG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXFZEGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:06:20 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:40941 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750832AbXFZEGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:06:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=DOufuB0GBwo9VVElJ742IZ6BkqMrSWzXWFBTyM0pn6pwFCk4KUScXt0sw3os9I61PLFE9QAlL3SNgneTVMe2Zf+6T350eNJSlzWEA/c9stSZFWX2Fwa3h3+lRa00S9bUsJrt3d+09Tj1Rgmss6B16HpP2wspPh2tH75wFzhkEu4=  ;
X-YMail-OSG: E4ZPh6QVM1kvO8.ZoJu1I5f2Z_JF6Fxm_5XpJlnSbdcNErCxsogq8x1zFP0Hg_d0OJO_8t560A--
Message-ID: <468090B7.2080200@yahoo.com.au>
Date: Tue, 26 Jun 2007 14:06:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>
CC: Matt Mackall <mpm@selenic.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLOB allocator imcompatible SLAB
References: <m2tzt01kew.wl%ysato@users.sourceforge.jp>	<20070622145635.GX11115@waste.org> <m2ejk05y7c.wl%ysato@users.sourceforge.jp>
In-Reply-To: <m2ejk05y7c.wl%ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoshinori Sato wrote:
> At Fri, 22 Jun 2007 09:56:35 -0500,
> Matt Mackall wrote:
> 
>>On Fri, Jun 22, 2007 at 05:08:07PM +0900, Yoshinori Sato wrote:
>>
>>>Because the page which SLOB allocator got does not have PG_slab,
>>
>>This is for a NOMMU system?
> 
> 
> Yes.
>  
> 
>>You're using an old kernel with an old version of SLOB. SLOB in newer
>>kernels actually sets per-page flags. Nick, can you see any reason not
>>to s/PG_active/PG_slab/ in the current code?

The problem with this is that PG_private is used only for the SLOB
part of the allocator and not the bigblock part.

We _could_ just bite the bullet and have SLOB set PG_slab, however
that would encouarage more users of this flag which we should hope
to get rid of one day.

The real problem is that nommu wants to get the size of either
kmalloc or alloc_pages objects and it needs to differentiate
between them. So I would rather nommu to take its own page flag
(could overload PG_swapcache, perhaps?), and set that flag on
pages it allocates directly, then uses that to determine whether
to call ksize or not.

-- 
SUSE Labs, Novell Inc.
