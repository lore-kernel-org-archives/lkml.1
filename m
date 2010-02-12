Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0BLNxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:53:47 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43654 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0BLNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:53:40 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B7558C1.2060405@kernel.org> (message from Tejun Heo on Fri, 12
	Feb 2010 22:33:53 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org> <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu> <4B73FE96.2080707@kernel.org> <E1NfYfb-00039p-Uh@pomaz-ex.szeredi.hu> <4B74065D.2000707@kernel.org> <E1NfZHO-0003FY-8E@pomaz-ex.szeredi.hu> <4B740CFB.7060409@kernel.org> <E1NfaD3-0003MQ-Du@pomaz-ex.szeredi.hu> <4B749BDF.8000807@kernel.org> <E1NfsEw-0005AW-Nl@pomaz-ex.szeredi.hu> <4B7558C1.2060405@kernel.org>
Message-Id: <E1NfvxX-0005UA-8P@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 12 Feb 2010 14:53:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, Tejun Heo wrote:
> >  3) on the low level API don't make it an offset pointer that is
> >  adjusted.  It's not an offset to be either left alone or changed
> >  (that would be the case if we wanted to allow adjustment to
> >  vma->vm_pgoff itself).  It's about calclulating a completely new
> >  offset for the server side mmap.
> 
> And now I'm completely lost.  So, we'll assign new offset (no matter
> how it is called) but it doesn't have to be aligned?  It seems like
> we've been having this disconnection from the beginning.  Can you
> please describe how this can avoid aliasing issues between clients
> sharing the same page?  So, in 2), whatever it is called, the server
> specifies a value, how is that value used?

That dev_offset value is used as an offset into the server side mmap
address space.  And yes, vma->vm_pgoff and dev_offset should be SHMLBA
multiples apart.

But don't call that _adjustment_.  That's totally confusing, these are
*two* *different* *offsets*.  There's an alignment requirement but
that's all.  If they are the same that is pure coincidence.

And dev_offset (which points into the dmmap address space) is only
required if the filesystem/CUSE driver needs server side mmap.

> > In fact most of what is required is already there in the form of the
> > page cache.  What I think would be interesting to be able to
> > load/save contents of page cache from the server side, and not
> > necessarily using server side mmaps (server side mmap is also a
> > possibility, but not an easy one if it has to cooperate with the
> > page cache).
> 
> Device mmap use cases might not work very well if the server can't
> mmap directly.

I understand that, and that's where the interesting part comes in:
make the mmap API in a way that it works with and without server side
mmap.

Thanks,
Miklos
