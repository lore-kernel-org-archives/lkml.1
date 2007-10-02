Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbXJBMNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbXJBMNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXJBMNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:13:34 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52432 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752170AbXJBMNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:13:33 -0400
Message-ID: <391327210.01048@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 2 Oct 2007 20:13:27 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Greg KH <gregkh@suse.de>,
       Chakri n <chakriin5@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       richard kennedy <richard@rsk.demon.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] writeback: avoid possible balance_dirty_pages() lockup
	on a light-load bdi
Message-ID: <20071002121327.GA5718@mail.ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <391063897.19256@ustc.edu.cn> <470118EE.1020103@redhat.com> <391290444.23950@ustc.edu.cn> <20071001191457.2f7c7538.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001191457.2f7c7538.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 07:14:57PM -0700, Andrew Morton wrote:
> On Tue, 2 Oct 2007 10:00:40 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > writeback: avoid possible balance_dirty_pages() lockup on a light-load bdi
> > 
> > On a busy-writing system, a writer could be hold up infinitely on a
> > light-load device. It will be trying to sync more than available dirty data.
> > 
> > The problem case:
> > 
> > 0. sda/nr_dirty >= dirty_limit;
> >    sdb/nr_dirty == 0
> > 1. dd writes 32 pages on sdb
> > 2. balance_dirty_pages() blocks dd, and tries to write 6MB.
> > 3. it never gets there: there's only 128KB dirty data.
> > 4. dd may be blocked for a loooong time
> 
> Please quantify loooong.

There're only two 'break' conditions in the loop:
1. nr_dirty + nr_unstable + nr_writeback < dirty_limit
   => *mostly* FALSE for a busy system
   => *always* FALSE in Chakri's stucked NFS case
2. nr_written >= 6MB
   for a light-load bdi:
   => *never* TRUE until there comes many new writers, contributing
      more dirty pages to sync
   => more worse, those new writers will also stuck here...
      the obvious unbalance here is:
           each writer contributes only 32KB new dirty pages, but
           want to consume (not necessarily available) 6MB

So loooong = min(global-less-busy-time, bdi-many-new-writers-arrival-time).

> > Fix it by returning on 'zero dirty inodes' in the current bdi.
> > (In fact there are slight differences between 'dirty inodes' and 'dirty pages'.
> > But there is no available counters for 'dirty pages'.)
> > 
> > But the newly introduced 'break' could make the nr_writeback drift away
> > above the dirty limit. The workaround is to limit the error under 1MB.
> 
> I'm still not sure that we fully understand this yet.
> 
> If the sdb writer is stuck in balance_dirty_pages() then all sda writers
> will be in balance_dirty_pages() too, madly writing stuff out to sda.  And
> pdflush will be writing out sda as well.  All this writeout to sda should
> release the sdb writer.
> 
> Why isn't this happening?

You are right in the reasoning. The exact consequence is:
        the light-load sdb is made as _unresponsive_ as the busy sda

Hence Chakri's case: whenever NFS is stuck, every device get stuck.

> 
> > Cc: Chuck Ebbert <cebbert@redhat.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> > ---
> >  mm/page-writeback.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- linux-2.6.22.orig/mm/page-writeback.c
> > +++ linux-2.6.22/mm/page-writeback.c
> > @@ -250,6 +250,11 @@ static void balance_dirty_pages(struct a
> >  			pages_written += write_chunk - wbc.nr_to_write;
> >  			if (pages_written >= write_chunk)
> >  				break;		/* We've done our duty */
> > +			if (list_empty(&mapping->host->i_sb->s_dirty) &&
> > +			    list_empty(&mapping->host->i_sb->s_io) &&
> > +			    nr_reclaimable + global_page_state(NR_WRITEBACK) <=
> > +				    dirty_thresh + (1 << (20-PAGE_CACHE_SHIFT)))
> > +				break;
> >  		}
> >  		congestion_wait(WRITE, HZ/10);
> >  	}
> 
> Well that has a nice safetly net.  Perhaps it could fail a bit later on,
> but that depends on why it's failing.

In theory, every CPU/paralle writer could contribute 8 pages of error.
Hence we get 1MB/32KB = 32 (CPUs/writers).

One more serious problem is, a busy writer could also drain all the
dirty pages and make (nr_writeback == dirty_limit+1MB). In that case,
I suspect the light-load sdb writer still have good chance to
make progress(need confirmation).

> How well tested was this?

Not well tested till now. My system becomes unusable soon after
starting the NFS write(even before plugging the network). I'm seeing
large latencies in try_to_wake_up(). Hope that Ingo could help it out.

> If we merge this for 2.6.23 then I expect that we'll immediately unmerge it
> for 2.6.24 because Peter's stuff fixes this problem by other means.
> 
> Do we all agree with the above sentence?

Yeah, Peter and me were both aware of the timing.
This patch is only meant for 2.6.23 and 2.6.22.10.

Fengguang

