Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYAQMqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYAQMqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYAQMpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:45:53 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48483 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbYAQMpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:45:51 -0500
To: salikhmetov@gmail.com
CC: miklos@szeredi.hu, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-reply-to: <4df4ef0c0801170416s5581ae28h90d91578baa77738@mail.gmail.com>
	(salikhmetov@gmail.com)
Subject: Re: [PATCH -v5 2/2] Updating ctime and mtime at syncing
References: <12005314662518-git-send-email-salikhmetov@gmail.com>
	 <1200531471556-git-send-email-salikhmetov@gmail.com>
	 <E1JFSgG-0006G1-6V@pomaz-ex.szeredi.hu> <4df4ef0c0801170416s5581ae28h90d91578baa77738@mail.gmail.com>
Message-Id: <E1JFU7r-0006PK-So@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 17 Jan 2008 13:45:43 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 4. Recording the time was the file data changed
> >
> > Finally, I noticed yet another issue with the previous version of my patch.
> > Specifically, the time stamps were set to the current time of the moment
> > when syncing but not the write reference was being done. This led to the
> > following adverse effect on my development system:
> >
> > 1) a text file A was updated by process B;
> > 2) process B exits without calling any of the *sync() functions;
> > 3) vi editor opens the file A;
> > 4) file data synced, file times updated;
> > 5) vi is confused by "thinking" that the file was changed after 3).

Updating the time in remove_vma() would fix this, no?

> > All these changes to inode.c are unnecessary, I think.
> 
> The first part is necessary to account for "remembering" the modification time.
> 
> The second part is for handling block device files. I cannot see any other
> sane way to update file times for them.

Use file_update_time(), which will do the right thing.  It will in
fact do the same thing as write(2) on the device, which is really what
we want.

Block devices being mapped for write through different device
nodes..., well, I don't think we really need to handle such weird
corner cases 100% acurately.

Miklos
