Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYAQNkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYAQNkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYAQNki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:40:38 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:4352 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYAQNkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:40:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IAsahMHStBKLjMcyjwO6vevrSoji6jslvnCzAXXnrpDk4Nh4QjBFyWV6McwuhCshTDaA5M5Gi3JXlu1mYo0uzhuheElZ/h/G+nqMCA2IGP7n/QUfM/kxVb7CnVRTkWI76oddCV5sw5ejOUVyk9EtPB2SDVlbduioKR0RDg+eUdo=
Message-ID: <4df4ef0c0801170540p36d3c566w973251527fc3bca1@mail.gmail.com>
Date: Thu, 17 Jan 2008 16:40:35 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH -v5 2/2] Updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <E1JFUrm-0006XG-SB@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12005314662518-git-send-email-salikhmetov@gmail.com>
	 <1200531471556-git-send-email-salikhmetov@gmail.com>
	 <E1JFSgG-0006G1-6V@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801170416s5581ae28h90d91578baa77738@mail.gmail.com>
	 <E1JFU7r-0006PK-So@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801170516k3f82dc69ieee836b5633378a@mail.gmail.com>
	 <E1JFUrm-0006XG-SB@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/17, Miklos Szeredi <miklos@szeredi.hu>:
> > 2008/1/17, Miklos Szeredi <miklos@szeredi.hu>:
> > > > > 4. Recording the time was the file data changed
> > > > >
> > > > > Finally, I noticed yet another issue with the previous version of my patch.
> > > > > Specifically, the time stamps were set to the current time of the moment
> > > > > when syncing but not the write reference was being done. This led to the
> > > > > following adverse effect on my development system:
> > > > >
> > > > > 1) a text file A was updated by process B;
> > > > > 2) process B exits without calling any of the *sync() functions;
> > > > > 3) vi editor opens the file A;
> > > > > 4) file data synced, file times updated;
> > > > > 5) vi is confused by "thinking" that the file was changed after 3).
> > >
> > > Updating the time in remove_vma() would fix this, no?
> >
> > We need to save modification time. Otherwise, updating time stamps
> > will be confusing the vi editor.
>
> remove_vma() will be called when process B exits, so if the times are
> updated there, and the flag is cleared, the times won't be updated
> later.
>
> > >
> > > > > All these changes to inode.c are unnecessary, I think.
> > > >
> > > > The first part is necessary to account for "remembering" the modification time.
> > > >
> > > > The second part is for handling block device files. I cannot see any other
> > > > sane way to update file times for them.
> > >
> > > Use file_update_time(), which will do the right thing.  It will in
> > > fact do the same thing as write(2) on the device, which is really what
> > > we want.
> > >
> > > Block devices being mapped for write through different device
> > > nodes..., well, I don't think we really need to handle such weird
> > > corner cases 100% acurately.
> >
> > The file_update_time() cannot be used for implementing
> > the "auto-update" feature, because the sync() system call
> > doesn't "know" about the file which was memory-mapped.
>
> I'm not sure this auto-updating is really needed (POSIX doesn't
> mandate it).

Peter Shtaubach, author of the first solution for this bug,
and Jacob Ostergaard, the reporter of this bug, insist the "auto-update"
feature to be implemented.

>
> At least split it out into a separate patch, so it can be considered
> separately on it's own merit.
>
> I think doing the same with the page-table reprotecting in MS_ASYNC is
> also a good idea.  That will leave us with
>
>  1) a base patch: update time just from fsync() and remove_vma()
>  2) update time on sync(2) as well
>  3) update time on MS_ASYNC as well
>
> I'd happily ack the first one, which would solve the most serious
> issues, but have some reservations about the other two.
>
> Miklos
>
