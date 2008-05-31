Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbYEaKLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbYEaKLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYEaKLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:11:00 -0400
Received: from gw.goop.org ([64.81.55.164]:40026 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYEaKK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:10:59 -0400
Message-ID: <4841240A.1000008@goop.org>
Date: Sat, 31 May 2008 11:10:18 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 5 of 5] xen: Avoid allocations causing swap activity on
 the resume path
References: <c692f3a12da1e99a4a43.1212192095@localhost>	<4840B0C5.4020606@pobox.com>	<48411F70.5020100@goop.org> <20080531025949.7c8b17bc.akpm@linux-foundation.org>
In-Reply-To: <20080531025949.7c8b17bc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 31 May 2008 10:50:40 +0100 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Does __GFP_HIGH necessarily mean that it won't try to 
>> do IO to push pages out?
>>     
>
> Nope.
>
> __GFP_FS: may enter filesystems
> __GFP_IO: may perform IO
>
> __GFP_IO also means "may do swapout".  Even when swap is on a regular
> file.  This is because we do all the fs-related operations up-front
> during swapon.  So at alloc_pages()-time we can go direct-to-disk-blocks.
>
> So I assume for this application you'll need GFP_NOIO.  That's still
> heaps better than GFP_ATOMIC, because it can sleep and wait for kswapd
> to do stuff, and it can reclaim clean pagecache and clean swapcache.
>   

OK, I'll respin with GFP_NOIO.

> Whether you should also add __GFP_HIGH to cause the page allocation to
> bite harder into the page reserves is unclear to me, sorry.
>   

Well, if the allocation fails the machine is dead in the water, because 
it probably can't go on without its devices.  I think it's worth eating 
to the reserves to avoid that.  (I'll have a close look to only add it 
to allocations which are really unrecoverable if they fail.)

Thanks,
    J
