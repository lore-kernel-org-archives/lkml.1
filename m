Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZF2Qlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZF2Qlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZF2Qlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:41:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:45531 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbZF2Qlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:41:40 -0400
Message-ID: <4A48EEDC.807@kernel.org>
Date: Tue, 30 Jun 2009 01:42:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, npiggin@suse.de
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-5-git-send-email-tj@kernel.org> <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu>
In-Reply-To: <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 16:40:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

Miklos Szeredi wrote:
> On Thu, 18 Jun 2009, Tejun Heo wrote:
>> This patch implements direct mmap.  It allows FUSE server to honor
>> each mmap request with anonymous mapping.  FUSE server can make
>> multiple mmap requests share a single anonymous mapping or separate
>> mappings as it sees fit.
> 
> One thing that worries me is that this isn't generic enough.  It may
> be good for OSS emulation, but if someone would want to use it for
> normal file based mmap, I don't think it would be usable: there's no
> synchronization between normal I/O paths.

I would love if it can be made more elegant and generic.  Although I
wrote it, I have to agree the whole thing doesn't look too pretty.

> Now that's not a big problem as long as there's a possility to extend
> the current interface in that direction.  E.g. add the possibility for
> userspace to handle faults and unmap pages from the address space on
> demand.
>
> The other problem is that sharing address spaces between filesystems
> in this way is inherently hackish.  CODA manages to get away with it,
> but CODA doesn't want to reimplement mmap/munmap in exotic ways.
> 
> Is there s a possibility to do this without needing to share the
> pages?  E.g. implement explicit calls (notifications) on the fuse
> interface to read and write the mapped pages.  That would get rid of
> all the ugly problems caused by having to pass and translate file
> descriptors on the fuse interface.

Hmmm... yeah, it would be great if the fd ugliness can be killed.

One problem to consider is that mmaps of the same file doesn't always
share the mapping.  For example, on a normal filesystem, shared mmaps
of a file will always share the same pages; however, mmaps of a device
node might or might not share the mapping.  For example, mmaps could
represent separate data streams or a shared buffer space which the
different mmaps might partially use for data passing between
themselves without notifying the server.  So, the server should be
able to determine whether a mmap is gonna be shared with another mmap
or not and that's where the passing fd back and forth came in.

Simlar thing can be done by letting the kernel part of fuse keep track
of mapped pages using server provided page IDs and letting the server
determine sharing or creation of pages and communicate it to the
kernel part.  It would require more code but the interface should be
less convoluted and more flexible.  Is this what you have in mind?

>> mmap request is handled in two steps.  MMAP first queries the server
>> whether it wants to share the mapping with an existing one or create a
>> new one, and if so, with which flags.  MMAP_COMMIT notifies the server
>> the result of mmap and if successful the fd the server can use to
>> access the mmap region.
> 
> And you might have noticed I'm not a big fan of these three way handshake
> messages ;)

Believe it or not, I'm not particularly big fan of it either.  I just
couldn't think of anything better at the time.  :-)

Thanks.

-- 
tejun
