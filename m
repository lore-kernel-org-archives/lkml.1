Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZGWAUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZGWAUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 20:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZGWAUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 20:20:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60751 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZGWAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:20:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 23 Jul 2009 09:18:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@redhat.com
Subject: Re: [PATCH 7/9] blkio-cgroup-v9: Page tracking hooks
Message-Id: <20090723091841.81ff2432.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722.184055.226788113.ryov@valinux.co.jp>
References: <20090721.231505.112612378.ryov@valinux.co.jp>
	<20090721.232316.183036419.ryov@valinux.co.jp>
	<20090722111714.8af6c5d8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722.184055.226788113.ryov@valinux.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 18:40:55 +0900 (JST)
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 21 Jul 2009 23:23:16 +0900 (JST)
> > Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> > 
> > > This patch contains several hooks that let the blkio-cgroup framework to know
> > > which blkio-cgroup is the owner of a page before starting I/O against the page.
> > 
> > > @@ -464,6 +465,7 @@ int add_to_page_cache_locked(struct page
> > >  					gfp_mask & GFP_RECLAIM_MASK);
> > >  	if (error)
> > >  		goto out;
> > > +	blkio_cgroup_set_owner(page, current->mm);
> > >  
> > 
> > This part is doubtful...Is this necessary ? 
> > I recommend you that the caller should attach owner by itself.
> 
> I think that it is reasonable to add the hook right here rather than
> to add many hooks to a variety of places.
> 
Why ? at writing, it's will be overwriten soon, IIUC. Then, this information
is misleading. plz add a hook like this when it means something. In this case,
read/write callers.
IMO, you just increase patch's readbility but decrease easiness of maintaince.


> > IMHO, later io for swap-out is caused by the caller of swapout, not page's
> > owner. plz charge to them or,
> >   - add special BLOCK CGROUP ID for the kernel's swap out. 
> 
> I think that it is not too bad to charge the owner of a page for
> swap-out. From another perspective, it can be considered that swap-out
> is caused by a process which uses a large amount of memory.
> 
No. swap-out is caused by a thread who requests memory even while memory is
in short. IMHO, I/O by memory reqraim should work in priority of memory requester.

Consider following situation.

- A process "A" has big memory. When several threads requests memory, all 
  of them are caught by a blockio cgroup of "A".
- A process "B" has read big file caches. When several threads requests memory, 
  all  of them are caught by a blockio cgroup of "B".

If "A" and "B" 's threshold is small, you'll see big slow down.
But it's not _planned_ behavior in many cases.

If you charges agaisnt memory owner, the admin has to set _big_ priority of I/O
controller to "A" and "B" if it uses much memory. I think the admin can't design
his system. It's nonsense to say "plz set I/O limit propotional to memory usage of
your apps even if it never do I/O in usual."


If this blockio cgroup is introduced, people will see *unexpected* very
terrible slow down and the user will see heartbeat warnings/failover by cluster
management software. Please do I/O at the priority of memory reclaiming requester.


Thanks,
-Kame




