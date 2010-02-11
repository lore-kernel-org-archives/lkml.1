Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab0BKLry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:47:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:56794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0BKLrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:47:52 -0500
Message-ID: <4B73F006.7090706@kernel.org>
Date: Thu, 11 Feb 2010 20:54:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfVho-0002nJ-V2@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 11:47:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 06:51 PM, Miklos Szeredi wrote:
> And even a page_id is superfluous, since all we want is differentiate
> between possibly separate maps for the same file and don't care about
> individual pages.
> 
> And even differentiating between maps on the same file is only ever
> possible for char devs, normal files will only ever have a single map.
> 
> So instead of "page_id" it could just be a "map_id", which will be
> zero for normal maps, and whatever for /dev/fuse maps.

Well, not exactly.  There are device mmap() implementations which
simply ignore @offset because offsetting doesn't make any sense at
all.  ossp mmap is actually done that way.  I really don't think it
would be wise to impose such restriction at the kernel API level.  For
highlevel interface, dealing with separate regions could be fine tho.

>> And if the server wants to mmap /dev/fuse then it can do that and send
>> the result in "dev_offset", to make it clear that it's a different
>> offset from the one the client used on the mmap.  And it can even use
>> that value as page_id, if it wants to or it can use a different
>> page_id.
> 
> And there's a weakness in the current server side mmap interface, for
> example:
> 
>  1) user mmaps region 3-5 (in page index)
>       server maps this region at 3-5
> 
>  2) user mmaps region 1-7
>      server can't tell kernel that it wants to reuse region 3-5 but
>      wants to create two other regions
> 
> What happens in that case?

If the server wants the two regions to be separate, it can map it to
say 5-11 and returnt he offset of 5.  If it wants them to be shared,
it will have to mmap 1-2 and 6-7 and return offset of 1.  But, the
server should really know better than growing the area this way.  If
this type of expansion ever becomes problem, we can implement
expendable mmap on the server side (ie. don't require VM_DONT_EXPAND).

> On the other hand if the map_id is separate from the dev_offset, then
> the server can map the second region as one map and the kernel can
> connect it up with the right pages based on the map_id returned in the
> MMAP reply.

How is this not possible in the current implementation?

Thanks.

-- 
tejun
