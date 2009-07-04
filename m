Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZGDLNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZGDLNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 07:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZGDLNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 07:13:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:39882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbZGDLNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 07:13:44 -0400
Message-ID: <4A4F3998.5020805@kernel.org>
Date: Sat, 04 Jul 2009 20:14:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-5-git-send-email-tj@kernel.org> <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu> <4A48EEDC.807@kernel.org> <E1MMMgq-0002R2-FO@pomaz-ex.szeredi.hu>
In-Reply-To: <E1MMMgq-0002R2-FO@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 11:12:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
>> Simlar thing can be done by letting the kernel part of fuse keep track
>> of mapped pages using server provided page IDs and letting the server
>> determine sharing or creation of pages and communicate it to the
>> kernel part.  It would require more code but the interface should be
>> less convoluted and more flexible.  Is this what you have in mind?
> 
> Something like that.  In fact we could possibly allow even sharing the
> pages with userspace, similarly to how drivers do it with the
> hardware.

This was possible with the original implementation.  Hmmm... we'll
need some sort of filehandle to represent the address space one way or
the other.

> Afaics sound drivers now map the dma memory with remap_pfn_range().
> Similary we could allocate a chunk of non-swapabble kernel memory on
> request from the userspace server and map its pages using this trick
> to both the server's and the client's address space.
> 
> This is still sort of OSSP specific, I don't see clearly how it could
> be made more generic.

Using non-swappable memory would be fine for most device emulations
but mapping large amount of pages would be problematic.  Hmmm... this
is difficult.  It's a compromise among flexibility, scalability and
code complexity.

>>>> mmap request is handled in two steps.  MMAP first queries the server
>>>> whether it wants to share the mapping with an existing one or create a
>>>> new one, and if so, with which flags.  MMAP_COMMIT notifies the server
>>>> the result of mmap and if successful the fd the server can use to
>>>> access the mmap region.
>>> And you might have noticed I'm not a big fan of these three way handshake
>>> messages ;)
>> Believe it or not, I'm not particularly big fan of it either.  I just
>> couldn't think of anything better at the time.  :-)
> 
> A better scheme would be to assume that MMAP is successful, and if
> there's an error, send a MUNMAP request.  That way the normal case is
> simpler and there's no need for an extra message type.

The reason why the second stage was necessary was because the fd needs
to be communicated back to the server.  The kernel doesn't know
whether the server wants to share an existing fd or create a new one
so the MMAP queries that and MMAP_COMMIT communicates newly created fd
if necessary.  What can be done is to always create a new fd and let
the server override it if it wants the map to be shared and then the
kernel can kill the unused fd.

Thanks.

-- 
tejun
