Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab0BKNXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:23:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:47654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0BKNXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:23:16 -0500
Message-ID: <4B74065D.2000707@kernel.org>
Date: Thu, 11 Feb 2010 22:30:05 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 13:22:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 10:01 PM, Miklos Szeredi wrote:
>> That's the requirement coming from allowing the server to determine
>> how these mmaps are served, not from the fact that the management is
>> done via server side mmaps or the server maps those regions into its
>> process address space.  No matter how you do it, if you want to mix
>> and match client mmap requests, the SHMLBA alignment will be visible.
> 
> Can you give an example?

Hmmm... I don't have any specific example.  osspd is the only real
thing which uses it and it serves each mmap request with a separate
region.  Oh... the fmmap example program serves the same region to
mmap requests coming from the same UID, so it does both sharing and
putting maps apart.

>> I suppose you're talking about not allowing offsets to be adjusted at
>> all but I don't think that's a restriction we would want to have at
>> the kernel API level because offset might encode different things for
>> device mmaps.
> 
> Possibly.  But there's some confusion about offsets again.  This
> offset is not the same as the one currently returned in fuse_mmap_out.

This offset is the offset client requests.

> And neither is the SHMLBA alignment requirement so clear:
> 
> You say, that ossp ignores the client mmap offset.  So basically it
> resets the offset to zero, whatever it was, no?  That sounds fine, but
> then you are adjusting the offset by something not necessarily a
> multiple of SHMLBA.

Yeap and that would be a bug.  It will probably have to do % SHMLBA on
the offset.  I don't think all OSS drivers would be caring about these
stuff anyway.  Most of them work on only x86 where SHMLBA == PAGE_SIZE.

> So there are different offsets:
> 
>  a) vma->vm_pgoff (which may mean anything, but usually means b)

Yeap, vma->vm_pgoff can be any value and doesn't really matter.  The
only visible difference would be the /proc listing, right?  Setting
this to the requested offset is trivial.

>  b) the offset at which the pages of the mapping are located
>  c) the offset at which the server side mmap is located

There are three offsets.

a) the offset a client requested

b) the offset into dmmap AS, a client mmap region is mapped to.  This
   could be different from a) by multiple of SHMLBA / PAGE_SIZE.

c) the offset into dmmap AS, a server mmap region is mapped to, where
   collection of these mmaps define the dmmap AS.

The offsets used in b) and c) are the same offsets.

Thanks.

-- 
tejun
