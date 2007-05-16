Return-Path: <linux-kernel-owner+w=401wt.eu-S1030250AbXEPVC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250AbXEPVC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030455AbXEPVBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:01:30 -0400
Received: from [212.12.190.104] ([212.12.190.104]:33033 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760059AbXEPVB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:01:27 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Date: Thu, 17 May 2007 00:01:21 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705170001.21099.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Chris Mason <chris.mason@oracle.com> wrote:
> > > Should be: it uses first-fit.
> > >
> > > >  Looks like ext3 is just walking a list of
> > > > bh/jh, maybe we can just sort the silly thing?
> > >
> > > The IO scheduler is supposed to do that.
> > >
> > > But I don't know what's causing this.
> >
> > I had high hopes of blaming cfq, but deadline gives the same results:
> >
> > create dir kernel-0 222MB in 5.38 seconds (41.33 MB/s)
> > ... [ ~30MB/s here ] ...
> > create dir kernel-7 222MB in 8.11 seconds (27.42 MB/s)
> > create dir kernel-8 222MB in 18.39 seconds (12.09 MB/s)
> > create dir kernel-9 222MB in 6.91 seconds (32.18 MB/s)
> > create dir kernel-10 222MB in 24.32 seconds (9.14 MB/s)
> > create dir kernel-11 222MB in 12.06 seconds (18.44 MB/s)
> > create dir kernel-12 222MB in 10.95 seconds (20.31 MB/s)
> >
> > The good news is that if you let it run long enough, the times
> > stabilize.  The bad news is:
> >
> > create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
> > create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
> > create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
> > create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)
>
> well hang on.  Doesn't this just mean that the first few runs were writing
> into pagecache and the later ones were blocking due to dirty-memory
> limits?
>
> Or do you have a sync in there?
>
> > echo 2048 > /sys/block/..../nr_requests didn't do it either.
> >
> > I guess I'll have systemtap tell me more about the log flushing.

Try these:
# echo anticipatory > /sys/block/.../scheduler
# echo 0 > /sys/block/.../iosched/antic_expire
# echo 192 > /sys/block/.../max_sectors_kb
# echo 192 > /sys/block/.../read_ahead_kb

These give me best performance, but most noticeably antic_expire > 0 leaves 
the IOScheduler in a apparent limbo.

see http://bugzilla.kernel.org/show_bug.cgi?id=5900


Thanks!

--
Al

