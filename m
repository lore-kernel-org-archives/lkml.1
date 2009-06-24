Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZFXKdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZFXKdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZFXKdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:33:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35338 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZFXKdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:33:04 -0400
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de,
       tj@kernel.org
In-reply-to: <1245317073-24000-5-git-send-email-tj@kernel.org> (message from
	Tejun Heo on Thu, 18 Jun 2009 18:24:33 +0900)
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-5-git-send-email-tj@kernel.org>
Message-Id: <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Jun 2009 12:33:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Tejun Heo wrote:
> This patch implements direct mmap.  It allows FUSE server to honor
> each mmap request with anonymous mapping.  FUSE server can make
> multiple mmap requests share a single anonymous mapping or separate
> mappings as it sees fit.

One thing that worries me is that this isn't generic enough.  It may
be good for OSS emulation, but if someone would want to use it for
normal file based mmap, I don't think it would be usable: there's no
synchronization between normal I/O paths.

Now that's not a big problem as long as there's a possility to extend
the current interface in that direction.  E.g. add the possibility for
userspace to handle faults and unmap pages from the address space on
demand.

The other problem is that sharing address spaces between filesystems
in this way is inherently hackish.  CODA manages to get away with it,
but CODA doesn't want to reimplement mmap/munmap in exotic ways.

Is there s a possibility to do this without needing to share the
pages?  E.g. implement explicit calls (notifications) on the fuse
interface to read and write the mapped pages.  That would get rid of
all the ugly problems caused by having to pass and translate file
descriptors on the fuse interface.

> 
> mmap request is handled in two steps.  MMAP first queries the server
> whether it wants to share the mapping with an existing one or create a
> new one, and if so, with which flags.  MMAP_COMMIT notifies the server
> the result of mmap and if successful the fd the server can use to
> access the mmap region.

And you might have noticed I'm not a big fan of these three way handshake
messages ;)

Thanks,
Miklos
