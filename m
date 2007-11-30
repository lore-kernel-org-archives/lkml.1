Return-Path: <linux-kernel-owner+w=401wt.eu-S934625AbXK3Bdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625AbXK3Bdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934182AbXK3BdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:33:07 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60735 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934041AbXK3BdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:33:04 -0500
Message-ID: <396386387.18082@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 30 Nov 2007 09:32:59 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Michael Rubin <mrubin@google.com>
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file
	writes
References: <20071128192957.511EAB8310@localhost> <396296481.07368@ustc.edu.cn> <532480950711291216l181b0bej17db6c42067aa832@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532480950711291216l181b0bej17db6c42067aa832@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1IxukV-0003Ns-5C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 12:16:36PM -0800, Michael Rubin wrote:
> Due to my faux pas of top posting (see
> http://www.zip.com.au/~akpm/linux/patches/stuff/top-posting.txt) I am
> resending this email.
> 
> On Nov 28, 2007 4:34 PM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > Could you demonstrate the situation? Or if I guess it right, could it
> > be fixed by the following patch? (not a nack: If so, your patch could
> > also be considered as a general purpose improvement, instead of a bug
> > fix.)
> >
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 0fca820..62e62e2 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -301,7 +301,7 @@ __sync_single_inode(struct inode *inode, struct writeback_control *wbc)
> >                          * Someone redirtied the inode while were writing back
> >                          * the pages.
> >                          */
> > -                       redirty_tail(inode);
> > +                       requeue_io(inode);
> >                 } else if (atomic_read(&inode->i_count)) {
> >                         /*
> >                          * The inode is clean, inuse
> >
> 
> By testing the situation I can confirm that the one line patch above
> fixes the problem.
> 
> I will continue testing some other cases to see if it cause any other
> issues but I don't expect it to.

One major concern could be whether a continuous writer dirting pages
at the 'right' pace will generate a steady flow of write I/Os which are
_tiny_hence_inefficient_.

I have gathered some timing info about writeback speed in
http://lkml.org/lkml/2007/10/4/468. For ext3, it takes wb_kupdate()
~15ms to submit 4MB. Whereas one disk I/O typically takes ~5ms. So if
there are too many tiny write I/Os, they will simply get delayed and
merged into bigger ones.

So it's not a problem in *theory* :-)

> I will post this change for 2.6.24 and list Feng as author. If that's
> ok with Feng.

Thank you.

> As for the original patch I will resubmit it for 2.6.25 as a general
> purpose improvement.

There are some discussions and patches on inode number based writeback
clustering which you may want to reference/compare with:
                http://lkml.org/lkml/2007/8/21/396
                http://lkml.org/lkml/2007/8/27/45

Cheers,
Fengguang

