Return-Path: <linux-kernel-owner+w=401wt.eu-S1764741AbYARTWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764741AbYARTWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760397AbYARTWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:22:40 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40025 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758982AbYARTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:22:39 -0500
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, peterz@infradead.org, salikhmetov@gmail.com,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-reply-to: <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>
	(message from Linus Torvalds on Fri, 18 Jan 2008 11:08:57 -0800 (PST))
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <12006091211208-git-send-email-salikhmetov@gmail.com>  <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>  <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins>
 <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org> <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org> <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181106340.2957@woody.linux-foundation.org>
Message-Id: <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 20:22:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > But then background writeout, sync(2), etc, wouldn't update the times.
> 
> Sure it would, but only when doing the final unmap.
> 
> Did you miss the "on unmap and msync" part?

No :)

What I'm saying is that the times could be left un-updated for a long
time if program doesn't do munmap() or msync(MS_SYNC) for a long time.

If program has this pattern:

mmap()
write to map
msync(MS_ASYNC)
sleep(long)
write to map
msync(MS_ASYNC)
sleep(long)
...

Then we'd never see time updates (until the program exits, but that
could be years).

Maybe this doesn't matter, I'm just saying this is a disadvantage
compared to the "update on first dirtying" approach, which would
ensure, that times are updated at least once per 30s.

Miklos
