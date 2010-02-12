Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0BLAGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:06:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:42976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0BLAGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:06:21 -0500
Message-ID: <4B749BDF.8000807@kernel.org>
Date: Fri, 12 Feb 2010 09:07:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu> <4B74065D.2000707@kernel.org> <E1NfZHO-0003FY-8E@pomaz-ex.szeredi.hu> <4B740CFB.7060409@kernel.org> <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 00:05:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 11:40 PM, Miklos Szeredi wrote:
>> Then, sharing those pages would cause aliasing issues.
> 
> You said a few mails up:
> 
>   "There are device mmap() implementations which simply ignore @offset
>    because offsetting doesn't make any sense at all"
> 
> Which means a) doesn't necessarily matter, so it's not something that
> determines aliasing issues.

Mmap regions of devices aren't always used as shared memories.  IO
regions often don't have cache backing at all.  Also, certain arch is
often assumed.

And yes it is something which determines aliasing issues.  There is no
way around it.

>>>> The offsets used in b) and c) are the same offsets.
>>>
>>> Why are they the same?
>>
>> I meant they point into the same space.  If they're the same value,
>> they point to the same page.
> 
> I'm beginning to undestand what you mean by "dmmap AS".

The thing described by rbtree of struct dmmap_regions.

> The thing is, I'm still not sure if or how this kind of mmap makes
> sense outside of the CUSE context.  Which makes designing the API
> difficult.

For this to be useful for normal FS, it has to be backed by multiple
swap backed files and I can almost guarantee you would need to be
passing fds around.

> So, for now maybe it's best to go with your implementation, fix issues
> with the offsets and make it CUSE only for the moment.

The offset problem can't be fixed.  If you allow offsets to be
adjusted in any way, SHMLBA requirement is gonna be there and for CUSE
I think having the ability to adjust offset would be useful even if
multiple files are used.  It can of course be hidden behind a
highlevel library API tho.

> The alternative is for me to start implementing a coherent distributed
> filesystem, so I can see what the actual requirements for a direct
> mmap would be.  That would be fun, but it would
> 
>   a) delay direct mmap for CUSE by an unknown amount of time
>   b) delay everything else that I have in the pipeline ;)

Well, for CUSE, it has been delayed for a long time already so I don't
think there would be much harm in waiting a bit more.  Any estimates
on how long it would take?

Thanks.

-- 
tejun
