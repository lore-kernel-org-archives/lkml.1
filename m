Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZGBNwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZGBNwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZGBNvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:51:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36365 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZGBNvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:51:07 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       npiggin@suse.de
In-reply-to: <4A48EEDC.807@kernel.org> (message from Tejun Heo on Tue, 30 Jun
	2009 01:42:04 +0900)
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-5-git-send-email-tj@kernel.org> <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu> <4A48EEDC.807@kernel.org>
Message-Id: <E1MMMgq-0002R2-FO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Jul 2009 15:51:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Tejun Heo wrote:
> One problem to consider is that mmaps of the same file doesn't always
> share the mapping.  For example, on a normal filesystem, shared mmaps
> of a file will always share the same pages; however, mmaps of a device
> node might or might not share the mapping.  For example, mmaps could
> represent separate data streams or a shared buffer space which the
> different mmaps might partially use for data passing between
> themselves without notifying the server.  So, the server should be
> able to determine whether a mmap is gonna be shared with another mmap
> or not and that's where the passing fd back and forth came in.
> 
> Simlar thing can be done by letting the kernel part of fuse keep track
> of mapped pages using server provided page IDs and letting the server
> determine sharing or creation of pages and communicate it to the
> kernel part.  It would require more code but the interface should be
> less convoluted and more flexible.  Is this what you have in mind?

Something like that.  In fact we could possibly allow even sharing the
pages with userspace, similarly to how drivers do it with the
hardware.  Afaics sound drivers now map the dma memory with
remap_pfn_range().  Similary we could allocate a chunk of
non-swapabble kernel memory on request from the userspace server and
map its pages using this trick to both the server's and the client's
address space.

This is still sort of OSSP specific, I don't see clearly how it could
be made more generic.

> >> mmap request is handled in two steps.  MMAP first queries the server
> >> whether it wants to share the mapping with an existing one or create a
> >> new one, and if so, with which flags.  MMAP_COMMIT notifies the server
> >> the result of mmap and if successful the fd the server can use to
> >> access the mmap region.
> > 
> > And you might have noticed I'm not a big fan of these three way handshake
> > messages ;)
> 
> Believe it or not, I'm not particularly big fan of it either.  I just
> couldn't think of anything better at the time.  :-)

A better scheme would be to assume that MMAP is successful, and if
there's an error, send a MUNMAP request.  That way the normal case is
simpler and there's no need for an extra message type.

Thanks,
Miklos
