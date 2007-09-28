Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbXI1JBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbXI1JBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbXI1JB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:01:26 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:48053 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbXI1JBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fNlPSXO4nO5NNCjDeCs7tCDW1sNoHT9xQ/T6l4Q+pN6zfGFnJf6Ne1FUr0OfLCTaqg2v941cNGL5OEGLDoVEaRW5BF9irxr8RKFzykOkbNj/VvMMXFke+KUB74qmJEqg966Rzmbl9XuKf8ui3m9w6RQUPUVo1c6GpdqjgL0CdQI=
Message-ID: <92cbf19b0709280201o3778f945mf1d8d61cbb3d0558@mail.gmail.com>
Date: Fri, 28 Sep 2007 02:01:23 -0700
From: "Chakri n" <chakriin5@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
In-Reply-To: <1190968800.31636.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190962752.31636.15.camel@twins>
	 <92cbf19b0709280127yba48b60wfe58e532944894ca@mail.gmail.com>
	 <1190968800.31636.26.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for explaining the adaptive logic.

> However other devices will at that moment try to maintain a limit of 0,
> which ends up being similar to a sync mount.
>
> So they'll not get stuck, but they will be slow.
>
>

Sync should be ok, when the situation is bad like this and some one
hijacked all the buffers.

But, I see my simple dd to write 10blocks on local disk never
completes even after 10 minutes.

[root@h46 ~]# dd if=/dev/zero of=/tmp/x count=10

I think the process is completely stuck and is not progressing at all.

Is something going wrong in the calculations where it does not fall
back to sync mode.

Thanks
--Chakri

On 9/28/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> [ please don't top-post! ]
>
> On Fri, 2007-09-28 at 01:27 -0700, Chakri n wrote:
>
> > On 9/27/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > On Thu, 2007-09-27 at 23:50 -0700, Andrew Morton wrote:
> > >
> > > > What we _don't_ want to happen is for other processes which are writing to
> > > > other, non-dead devices to get collaterally blocked.  We have patches which
> > > > might fix that queued for 2.6.24.  Peter?
> > >
> > > Nasty problem, don't do that :-)
> > >
> > > But yeah, with per BDI dirty limits we get stuck at whatever ratio that
> > > NFS server/mount (?) has - which could be 100%. Other processes will
> > > then work almost synchronously against their BDIs but it should work.
> > >
> > > [ They will lower the NFS-BDI's ratio, but some fancy clipping code will
> > >   limit the other BDIs their dirty limit to not exceed the total limit.
> > >   And with all these NFS pages stuck, that will still be nothing. ]
> > >
> > Thanks.
> >
> > The BDI dirty limits sounds like a good idea.
> >
> > Is there already a patch for this, which I could try?
>
> v2.6.23-rc8-mm2
>
> > I believe it works like this,
> >
> > Each BDI, will have a limit. If the dirty_thresh exceeds the limit,
> > all the I/O on the block device will be synchronous.
> >
> > so, if I have sda & a NFS mount, the dirty limit can be different for
> > each of them.
> >
> > I can set dirty limit for
> >  -  sda to be 90% and
> >  -  NFS mount to be 50%.
> >
> > So, if the dirty limit is greater than 50%, NFS does synchronously,
> > but sda can work asynchronously, till dirty limit reaches 90%.
>
> Not quite, the system determines the limit itself in an adaptive
> fashion.
>
>   bdi_limit = total_limit * p_bdi
>
> Where p is a faction [0,1], and is determined by the relative writeout
> speed of the current BDI vs all other BDIs.
>
> So if you were to have 3 BDIs (sda, sdb and 1 nfs mount), and sda is
> idle, and the nfs mount gets twice as much traffic as sdb, the ratios
> will look like:
>
>  p_sda: 0
>  p_sdb: 1/3
>  p_nfs: 2/3
>
> Once the traffic exceeds the write speed of the device we build up a
> backlog and stuff gets throttled, so these proportions converge to the
> relative write speed of the BDIs when saturated with data.
>
> So what can happen in your case is that the NFS mount is the only one
> with traffic is will get a fraction of 1. If it then disconnects like in
> your case, it will still have all of the dirty limit pinned for NFS.
>
> However other devices will at that moment try to maintain a limit of 0,
> which ends up being similar to a sync mount.
>
> So they'll not get stuck, but they will be slow.
>
>
