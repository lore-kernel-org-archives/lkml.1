Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbYAWNzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbYAWNzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 08:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYAWNzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 08:55:35 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43054 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYAWNze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 08:55:34 -0500
To: salikhmetov@gmail.com
CC: miklos@szeredi.hu, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <4df4ef0c0801230425o13a1f3a6p87298c6767eb62ce@mail.gmail.com>
	(salikhmetov@gmail.com)
Subject: Re: [PATCH -v8 4/4] The design document for memory-mapped file times update
References: <12010440803930-git-send-email-salikhmetov@gmail.com>
	 <1201044083554-git-send-email-salikhmetov@gmail.com>
	 <E1JHbs1-00025n-Ac@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801230237g2f26f0d1j2d2ada2ce62ba284@mail.gmail.com>
	 <E1JHdE4-0002Jk-QG@pomaz-ex.szeredi.hu>
	 <E1JHdav-0002MW-GH@pomaz-ex.szeredi.hu> <4df4ef0c0801230425o13a1f3a6p87298c6767eb62ce@mail.gmail.com>
Message-Id: <E1JHg4a-0002ep-Et@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 Jan 2008 14:55:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Miklos, thanks for your program. Its output is given below.
> 
> debian:~/miklos# mount | grep mnt
> tmpfs on /mnt type tmpfs (rw)
> debian:~/miklos# ./miklos /mnt/file
> begin   1201089989      1201089989      1201085868
> write   1201089990      1201089990      1201085868
> mmap    1201089990      1201089990      1201089991
> store b 1201089992      1201089992      1201089991
> msync   1201089992      1201089992      1201089991
> store c 1201089994      1201089994      1201089991
> msync   1201089994      1201089994      1201089991
> store d 1201089996      1201089996      1201089991
> munmap  1201089996      1201089996      1201089991
> close   1201089996      1201089996      1201089991
> sync    1201089996      1201089996      1201089991
> debian:~/miklos# ./miklos /mnt/file -r
> begin   1201090025      1201090025      1201089991
> write   1201090026      1201090026      1201089991
> mmap    1201090026      1201090026      1201090027
> fetch x 1201090026      1201090026      1201090027
> store b 1201090026      1201090026      1201090027
> msync   1201090026      1201090026      1201090027
> fetch y 1201090026      1201090026      1201090027
> store c 1201090032      1201090032      1201090027
> msync   1201090032      1201090032      1201090027
> fetch z 1201090032      1201090032      1201090027
> store d 1201090036      1201090036      1201090027
> munmap  1201090036      1201090036      1201090027
> close   1201090036      1201090036      1201090027
> sync    1201090036      1201090036      1201090027
> debian:~/miklos#
> 
> I think that after the patches applied the msync() system call does
> everything, which it is expected to do. The issue you're now talking
> about is one belonging to do_fsync() and the design of the tmpfs
> driver itself, I believe.

Right.  My problem is that msync() does _too_much_ for ram-backed
mappings.  It shouldn't write protect pages in this case, because it
has a high cost and dubious value.

Similar argument probably holds for file_update_time() from the fault
handlers.  They should examine, if it's a ram-backed fs (with
mapping_cap_account_dirty()) and not update the times for those.

It's better to consistently not update the times, than to randomly do
so, which could lead to false expectations, and hard to track down
bugs.

Miklos
