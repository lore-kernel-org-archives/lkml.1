Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0BLN1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:27:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:58752 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab0BLN1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:27:52 -0500
Message-ID: <4B7558C1.2060405@kernel.org>
Date: Fri, 12 Feb 2010 22:33:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu> <4B74065D.2000707@kernel.org> <E1NfZHO-0003FY-8E@pomaz-ex.szeredi.hu> <4B740CFB.7060409@kernel.org> <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu> <4B749BDF.8000807@kernel.org> <E1NfsEw-0005AW-Nl@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfsEw-0005AW-Nl@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 13:26:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/12/2010 06:55 PM, Miklos Szeredi wrote:
> On Fri, 12 Feb 2010, Tejun Heo wrote:
>> The offset problem can't be fixed.  If you allow offsets to be
>> adjusted in any way, SHMLBA requirement is gonna be there and for CUSE
>> I think having the ability to adjust offset would be useful even if
>> multiple files are used.  It can of course be hidden behind a
>> highlevel library API tho.
> 
> Yes, offset issues can be fixed:
> 
>  1) don't change vma->vm_pgoff

vma->vm_pgoff is peripheral unless you mean not adjusting offset at
all.

>  2) in fuse_mmap_out, call it dev_offset, dev_mmap_offset or whatever

Okay.

>  3) on the low level API don't make it an offset pointer that is
>  adjusted.  It's not an offset to be either left alone or changed
>  (that would be the case if we wanted to allow adjustment to
>  vma->vm_pgoff itself).  It's about calclulating a completely new
>  offset for the server side mmap.

And now I'm completely lost.  So, we'll assign new offset (no matter
how it is called) but it doesn't have to be aligned?  It seems like
we've been having this disconnection from the beginning.  Can you
please describe how this can avoid aliasing issues between clients
sharing the same page?  So, in 2), whatever it is called, the server
specifies a value, how is that value used?

>> Well, for CUSE, it has been delayed for a long time already so I don't
>> think there would be much harm in waiting a bit more.  Any estimates
>> on how long it would take?
> 
> Well if there were no higher priority things then I think I could do
> that in a month.

Alright, we'll be missing the upcoming merge window anyway, so no
biggie.

> I don't think I want a swap backed solution.  There is already a
> backing for these maps and that is the userspace filesystem.

Yeap, sure.  This was what I was talking about in the other reply.
Named files would probably be much easier to work with for the server
implementations.

> In fact most of what is required is already there in the form of the
> page cache.  What I think would be interesting to be able to
> load/save contents of page cache from the server side, and not
> necessarily using server side mmaps (server side mmap is also a
> possibility, but not an easy one if it has to cooperate with the
> page cache).

Device mmap use cases might not work very well if the server can't
mmap directly.

> Basically all we need to ensure, is that the mmap API doesn't conflict
> with the above usage.  The problem is that the details for the above
> usage will only come out with a real implementation.

Alright, I'll ping you in a while.

Thanks.

-- 
tejun
