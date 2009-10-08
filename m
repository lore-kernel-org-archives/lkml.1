Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbZJHFeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbZJHFeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 01:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZJHFea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 01:34:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:34562 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbZJHFe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 01:34:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,523,1249282800"; 
   d="scan'208";a="196402522"
Date: Thu, 8 Oct 2009 13:33:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Staubach <staubach@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/45] some writeback experiments
Message-ID: <20091008053335.GA19458@localhost>
References: <20091007073818.318088777@intel.com> <4ACC9BE2.5070409@redhat.com> <20091007151822.GA9574@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007151822.GA9574@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:18:22PM +0800, Wu Fengguang wrote:
> On Wed, Oct 07, 2009 at 09:47:14PM +0800, Peter Staubach wrote:
> > 
> > > # vmmon -d 1 nr_writeback nr_dirty nr_unstable      # (per 1-second samples)
> > >      nr_writeback         nr_dirty      nr_unstable
> > >             11227            41463            38044
> > >             11227            41463            38044
> > >             11227            41463            38044
> > >             11227            41463            38044
> 
> I guess in the above 4 seconds, either client or (more likely) server
> is blocked. A blocked server cannot send ACKs to knock down both

Yeah the server side is blocked.  The nfsd are mostly blocked in
generic_file_aio_write(), in particular, the i_mutex lock! I'm copying
one or two big files over NFS, so the i_mutex lock is heavily contented.

I'm using the default wsize=4096 for NFS-root..

wfg ~% ps -o pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:24,comm ax|g nfs
  329   329 TS       -  -5  24   1  0.0 S<   worker_thread            nfsiod
 4690  4690 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4691  4691 TS       -  -5  24   0  0.0 D<   generic_file_aio_write   nfsd
 4692  4692 TS       -  -5  24   0  0.0 D<   generic_file_aio_write   nfsd
 4693  4693 TS       -  -5  24   0  0.0 D<   generic_file_aio_write   nfsd
 4694  4694 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4695  4695 TS       -  -5  24   1  0.1 D<   generic_file_aio_write   nfsd
 4696  4696 TS       -  -5  24   1  0.0 D<   log_wait_commit          nfsd
 4697  4697 TS       -  -5  24   0  0.0 D<   generic_file_aio_write   nfsd
wfg ~% ps -o pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:24,comm ax|g nfs
  329   329 TS       -  -5  24   1  0.0 S<   worker_thread            nfsiod
 4690  4690 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4691  4691 TS       -  -5  24   0  0.0 D<   generic_file_aio_write   nfsd
 4692  4692 TS       -  -5  24   0  0.0 D<   generic_file_aio_write   nfsd
 4693  4693 TS       -  -5  24   0  0.0 D<   sync_buffer              nfsd
 4694  4694 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4695  4695 TS       -  -5  24   1  0.1 D<   generic_file_aio_write   nfsd
 4696  4696 TS       -  -5  24   1  0.0 D<   generic_file_aio_write   nfsd
 4697  4697 TS       -  -5  24   0  0.0 D<   generic_file_aio_write   nfsd

wfg ~% ps -o pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:24,comm ax|g nfs
  329   329 TS       -  -5  24   1  0.0 S<   worker_thread            nfsiod
 4690  4690 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4691  4691 TS       -  -5  24   0  0.1 D<   get_request_wait         nfsd
 4692  4692 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4693  4693 TS       -  -5  24   0  0.1 S<   svc_recv                 nfsd
 4694  4694 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4695  4695 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4696  4696 TS       -  -5  24   0  0.1 S<   svc_recv                 nfsd
 4697  4697 TS       -  -5  24   1  0.1 D<   generic_file_aio_write   nfsd

wfg ~% ps -o pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:24,comm ax|g nfs
  329   329 TS       -  -5  24   1  0.0 S<   worker_thread            nfsiod
 4690  4690 TS       -  -5  24   1  0.1 D<   get_write_access         nfsd
 4691  4691 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4692  4692 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4693  4693 TS       -  -5  24   1  0.1 D<   generic_file_aio_write   nfsd
 4694  4694 TS       -  -5  24   1  0.1 D<   get_write_access         nfsd
 4695  4695 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4696  4696 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd
 4697  4697 TS       -  -5  24   0  0.1 D<   generic_file_aio_write   nfsd

Thanks,
Fengguang

> nr_writeback/nr_unstable. And the stuck nr_writeback will freeze
> nr_dirty as well, because the dirtying process is throttled until
> it receives enough "PG_writeback cleared" event, however the bdi-flush
> thread is also blocked when trying to clear more PG_writeback, because
> the client side nr_writeback limit has been reached. In summary,
> 
> server blocked => nr_writeback stuck => nr_writeback limit reached
> => bdi-flush blocked => no end_page_writeback() => dirtier blocked
> => nr_dirty stuck
> 
> Thanks,
> Fengguang
> 
> > >             11045            53987             6490
> > >             11033            53120             8145
> > >             11195            52143            10886
> > >             11211            52144            10913
> > >             11211            52144            10913
> > >             11211            52144            10913
> > > 
> > > btrfs seems to maintain a private pool of writeback pages, which can go out of
> > > control:
> > > 
> > >      nr_writeback         nr_dirty
> > >            261075              132
> > >            252891              195
> > >            244795              187
> > >            236851              187
> > >            228830              187
> > >            221040              218
> > >            212674              237
> > >            204981              237
> > > 
> > > XFS has very interesting "bumpy writeback" behavior: it tends to wait
> > > collect enough pages and then write the whole world.
> > > 
> > >      nr_writeback         nr_dirty
> > >             80781                0
> > >             37117            37703
> > >             37117            43933
> > >             81044                6
> > >             81050                0
> > >             43943            10199
> > >             43930            36355
> > >             43930            36355
> > >             80293                0
> > >             80285                0
> > >             80285                0
> > > 
> > > Thanks,
> > > Fengguang
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
