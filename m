Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0BKLl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:41:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:54711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab0BKLlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:41:55 -0500
Message-ID: <4B73EE68.4070004@kernel.org>
Date: Thu, 11 Feb 2010 20:47:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 11:40:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 06:31 PM, Miklos Szeredi wrote:
> On Thu, 11 Feb 2010, Tejun Heo wrote:
>>> If there's a pattern there, we might make the sharing/non-sharing
>>> automated, and greatly simplify the interface.
>>
>> Isn't the interface pretty simple as it is?
> 
> On one hand it's simple, on the other it has pretty weird
> limitations, considering that server side mmap shouldn't be
> mandatory.

It's not like it's something completely foreign.  It's a limitation
which can also be found in shared memory and the server side mmap
doesn't really have much to do with it.  It's also necessary to avoid
aliasing issues among clients.

> But of course if server side mmap isn't used, then the SHMLBA
> limitation is not necessary anymore so the implementation could
> choose an arbitrary "offset".

It of course is necessary.  How else can aliasing among clients be
avoided?  The alignment is not only for the server.  If you're gonna
share memories and want to adjust the mapping in any way, you need to
follow the SHMLBA alignment.

> My biggest gripe with the kernel API is that we shouldn't be calling
> that thing in fuse_mmap_out an offset at all, because it's not and
> it's confusing (like making you set vma->vm_pgoff to that value, which
> is bogus).  Adding a separate "page_id" or whatever would make me
> happy.

It _is_ an offset into the dmmap address space.  mmap() requests to
map certain length at certain offset of an address space.  The FUSE
server can redirect the offset to make it share, not share or combine
or whatever.  It's very simple conceptually.

> And if the server wants to mmap /dev/fuse then it can do that and send
> the result in "dev_offset", to make it clear that it's a different
> offset from the one the client used on the mmap.  And it can even use
> that value as page_id, if it wants to or it can use a different
> page_id.
> 
> Does that sound reasonable?

I can't really follow what you're suggesting.  Either you're
misunderstanding why SHMLBA is necessary or I'm being plain dumb.  Can
you please describe what you have on mind without referring to the
current implementation?  How would it work?

>> If we want to make it easier for API users by imposing limits, I
>> think the correct layer to do that would be at the library level.
> 
> Hmm, might do that.  High level library users definitely shouldn't be
> having to mess around with SHMLBA.

The main thing would be to let the library manage mmap regions and ask
the server only two things - region size and share ID both of which
are optional.  If both are not set (ie. -1 and -1), the mmap request
won't be shareable and sized as requested by the client.  If the
server returns a positive ID, all mmap requests with the same ID will
share the region.

Also, I said it before but SHMLBA is something which is already known
to the userland for shared memories.  I really don't think this is too
much to ask for if the server is playing with direct mmap.

Thanks.

-- 
tejun
