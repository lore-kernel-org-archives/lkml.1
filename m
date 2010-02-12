Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0BLJzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:55:25 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50973 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0BLJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:55:23 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B749BDF.8000807@kernel.org> (message from Tejun Heo on Fri, 12
	Feb 2010 09:07:59 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu> <4B74065D.2000707@kernel.org> <E1NfZHO-0003FY-8E@pomaz-ex.szeredi.hu> <4B740CFB.7060409@kernel.org> <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu> <4B749BDF.8000807@kernel.org>
Message-Id: <E1NfsEw-0005AW-Nl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 12 Feb 2010 10:55:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, Tejun Heo wrote:
> The offset problem can't be fixed.  If you allow offsets to be
> adjusted in any way, SHMLBA requirement is gonna be there and for CUSE
> I think having the ability to adjust offset would be useful even if
> multiple files are used.  It can of course be hidden behind a
> highlevel library API tho.

Yes, offset issues can be fixed:

 1) don't change vma->vm_pgoff

 2) in fuse_mmap_out, call it dev_offset, dev_mmap_offset or whatever

 3) on the low level API don't make it an offset pointer that is
 adjusted.  It's not an offset to be either left alone or changed
 (that would be the case if we wanted to allow adjustment to
 vma->vm_pgoff itself).  It's about calclulating a completely new
 offset for the server side mmap.

> > The alternative is for me to start implementing a coherent distributed
> > filesystem, so I can see what the actual requirements for a direct
> > mmap would be.  That would be fun, but it would
> > 
> >   a) delay direct mmap for CUSE by an unknown amount of time
> >   b) delay everything else that I have in the pipeline ;)
> 
> Well, for CUSE, it has been delayed for a long time already so I don't
> think there would be much harm in waiting a bit more.  Any estimates
> on how long it would take?

Well if there were no higher priority things then I think I could do
that in a month.

I don't think I want a swap backed solution.  There is already a
backing for these maps and that is the userspace filesystem.  In fact
most of what is required is already there in the form of the page
cache.  What I think would be interesting to be able to load/save
contents of page cache from the server side, and not necessarily using
server side mmaps (server side mmap is also a possibility, but not an
easy one if it has to cooperate with the page cache).

Basically all we need to ensure, is that the mmap API doesn't conflict
with the above usage.  The problem is that the details for the above
usage will only come out with a real implementation.

Thanks,
Miklos
