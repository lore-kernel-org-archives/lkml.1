Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZIQMkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZIQMkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbZIQMkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:40:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:57063 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZIQMkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,403,1249282800"; 
   d="scan'208";a="188696376"
Date: Thu, 17 Sep 2009 20:40:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: [RFC][PATCH][bugfix] more checks for negative f_pos handling v4
Message-ID: <20090917124039.GB9462@localhost>
References: <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com> <20090916142956.9998ba71.kamezawa.hiroyu@jp.fujitsu.com> <20090917145319.97f67737.kamezawa.hiroyu@jp.fujitsu.com> <20090917150726.9acb0f40.kamezawa.hiroyu@jp.fujitsu.com> <20090917062124.GA6964@localhost> <20090917155100.3cc2dfb6.kamezawa.hiroyu@jp.fujitsu.com> <20090917071428.GA9232@localhost> <20090917162324.d60a7950.kamezawa.hiroyu@jp.fujitsu.com> <20090917094203.GA13885@localhost> <b756a8e49c515a5ada93ac90d1076056.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b756a8e49c515a5ada93ac90d1076056.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 06:54:00PM +0800, KAMEZAWA Hiroyuki wrote:
> Wu Fengguang wrote:
> > On Thu, Sep 17, 2009 at 03:23:24PM +0800, KAMEZAWA Hiroyuki wrote:
> >> On Thu, 17 Sep 2009 15:14:28 +0800
> >> Wu Fengguang <fengguang.wu@intel.com> wrote:
> >>
> >> > On Thu, Sep 17, 2009 at 02:51:00PM +0800, KAMEZAWA Hiroyuki wrote:
> >> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> > >
> >> > > Now, rw_verify_area() checsk f_pos is negative or not. And if
> >> > > negative, returns -EINVAL.
> >> > >
> >> > > But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..
> >> > > has negative offsets. And we can't do any access via read/write
> >> > > to the file(device).
> >> > >
> >> > > This patch introduce a flag S_VERYBIG and allow negative file
> >> > > offsets for big files. (usual files don't allow it.)
> >> > >
> >> > > Changelog: v3->v4
> >> > >  - make changes in mem.c aligned.
> >> > >  - change __negative_fpos_check() to return int.
> >> > >  - fixed bug in "pos" check.
> >> > >  - added comments.
> >> > >
> >> > > Changelog: v2->v3
> >> > >  - fixed bug in rw_verify_area (it cannot be compiled)
> >> > >
> >> > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> > > ---
> >> > >  drivers/char/mem.c |   23 +++++++++++++----------
> >> > >  fs/proc/base.c     |    2 ++
> >> > >  fs/read_write.c    |   22 ++++++++++++++++++++--
> >> > >  include/linux/fs.h |    2 ++
> >> > >  4 files changed, 37 insertions(+), 12 deletions(-)
> >> > >
> >> > > Index: mmotm-2.6.31-Sep14/fs/read_write.c
> >> > > ===================================================================
> >> > > --- mmotm-2.6.31-Sep14.orig/fs/read_write.c
> >> > > +++ mmotm-2.6.31-Sep14/fs/read_write.c
> >> > > @@ -205,6 +205,21 @@ bad:
> >> > >  }
> >> > >  #endif
> >> > >
> >> > > +static int
> >> > > +__negative_fpos_check(struct inode *inode, loff_t pos, size_t
> >> count)
> >> > > +{
> >> > > +	/*
> >> > > +	 * pos or pos+count is negative here, check overflow.
> >> > > +	 * too big "count" will be caught in rw_verify_area().
> >> > > +	 */
> >> > > +	if ((pos < 0) && (pos + count < pos))
> >> > > +		return -EOVERFLOW;
> >> >
> >> > This returns -EOVERFLOW when pos=-10 and count=1. What's the
> >> intention?
> >>   Hmm ?
> >>
> >>   pos+count=-9 > -10 ? it's ok. no -EOVERFLOW
> >>
> >>   pos=-10, count=11,
> >>   pos+count=1 > -10, then overflow.
> >
> > Hmm, it seems less confusing to do
> >
> > static int __negative_fpos_check(struct inode *inode,
> >                                  unsigned long pos,
> >                                  unsigned long count)
> > {
> >         if (pos + count < pos)
> >                 return -EOVERFLOW;
> >         ...
> > }
> >
> have to avoid pos == LONGLONGMAX case.

Ah sorry, didn't know loff_t could be long long..

Thanks,
Fengguang

