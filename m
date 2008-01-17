Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbYAQNQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbYAQNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYAQNQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:16:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:4851 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYAQNQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:16:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wH5TL/Q2eOxsprtS2mA1lPVi+UAyCsHZ+Hzykf7fQkGuOb72TxQa5fk2/ZqMvq8mAfiLgX3od1V/HdvtD4bJnQ/WeMJfjFIS1Ch6t4KQgJEAtMqpKyDc8PFf0bospc74x0ZHQOwmc2IC6e3Xar+VZSIsi1F4uKA2j2DlQwvVNT0=
Message-ID: <4df4ef0c0801170516k3f82dc69ieee836b5633378a@mail.gmail.com>
Date: Thu, 17 Jan 2008 16:16:47 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH -v5 2/2] Updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <E1JFU7r-0006PK-So@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12005314662518-git-send-email-salikhmetov@gmail.com>
	 <1200531471556-git-send-email-salikhmetov@gmail.com>
	 <E1JFSgG-0006G1-6V@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801170416s5581ae28h90d91578baa77738@mail.gmail.com>
	 <E1JFU7r-0006PK-So@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/17, Miklos Szeredi <miklos@szeredi.hu>:
> > > 4. Recording the time was the file data changed
> > >
> > > Finally, I noticed yet another issue with the previous version of my patch.
> > > Specifically, the time stamps were set to the current time of the moment
> > > when syncing but not the write reference was being done. This led to the
> > > following adverse effect on my development system:
> > >
> > > 1) a text file A was updated by process B;
> > > 2) process B exits without calling any of the *sync() functions;
> > > 3) vi editor opens the file A;
> > > 4) file data synced, file times updated;
> > > 5) vi is confused by "thinking" that the file was changed after 3).
>
> Updating the time in remove_vma() would fix this, no?

We need to save modification time. Otherwise, updating time stamps
will be confusing the vi editor.

>
> > > All these changes to inode.c are unnecessary, I think.
> >
> > The first part is necessary to account for "remembering" the modification time.
> >
> > The second part is for handling block device files. I cannot see any other
> > sane way to update file times for them.
>
> Use file_update_time(), which will do the right thing.  It will in
> fact do the same thing as write(2) on the device, which is really what
> we want.
>
> Block devices being mapped for write through different device
> nodes..., well, I don't think we really need to handle such weird
> corner cases 100% acurately.

The file_update_time() cannot be used for implementing
the "auto-update" feature, because the sync() system call
doesn't "know" about the file which was memory-mapped.

>
> Miklos
>
