Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0BJLuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:50:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:45367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab0BJLuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:50:19 -0500
Message-ID: <4B729F07.8020704@kernel.org>
Date: Wed, 10 Feb 2010 20:56:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 11:49:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/10/2010 08:29 PM, Miklos Szeredi wrote:
>> This is achieved by enforcing address to offset alignment.  IOW, all
>> maps are forced to be SHMLBA aligned to offset so that all maps are
>> SHMLBA aligned to each other.
> 
> Okay, lets be a little clearer.  There are client side maps and server
> side maps.  Client side maps are naturally aligned (same offset ->
> same page).

Same offset -> same page doesn't hold.  Clients mappings sharing the
same offset can end up with different physical pages.  ie. Process A
opening /dev/dsp and mmapping at 0 and process B doing the same thing
clearly need to be served with different pages and that's one of the
reasons why the server is given the ability to adjust the offset.

> So that leaves server side maps needing to be aligned to client side
> maps.  Since we use the offset into the mmap as the ID, we might as
> well just cheat and calculate a maching offset for the server side map
> and use that.  I'm not worried about changing vma->vm_pgoff there, if
> that's the only way to get proper alignment, since those are not
> "proper" mmaps anyway.
...
> Currently you are aligning client/client maps by changing the
> requested offset.  That's like saying: you wanted the file mapped from
> offset X, but we mapped it from offset Y because that's better
> aligned.  It doesn't make much sense, if the filesystem is doing
> something nasty like that, then to hell with cache alignment.

I think we're misunderstanding each other pretty good here.  I really
can't understand the above paragraph.  The offset adjustment is to
allow the server to choose which clients share which mappings.  It's
not to align anything.  The alignment is done by the generic VM layer
against the offset.  The SHMLBA requirement for the FUSE server is
there so that the FUSE server doesn't break the alignment while
changing the offset.

Can you please elaborate how you think the thing can work without
referencing the proposed implementation?  Let's find out where the
misundertanding is.

Thanks.

-- 
tejun
