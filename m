Return-Path: <linux-kernel-owner+w=401wt.eu-S1161744AbXDXMgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161744AbXDXMgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 08:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161745AbXDXMgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 08:36:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58777 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161744AbXDXMgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 08:36:09 -0400
Date: Tue, 24 Apr 2007 14:32:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Cc: Thiemo.Nagel@ph.tum.de, linuxkernel Org <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
Message-ID: <20070424123200.GK3744@kernel.dk>
References: <79880979-51BB-4D28-A3E8-3AE0F56F5B0A@e18.physik.tu-muenchen.de> <20070424091807.GA3744@kernel.dk> <6A6800B3-F9C8-4046-9E1C-A8CEA81B2CE0@e18.physik.tu-muenchen.de> <20070424093904.GB3744@kernel.dk> <20070424094003.GC3744@kernel.dk> <5A404D4C-BB61-45AB-9A7A-B380FE222137@e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A404D4C-BB61-45AB-9A7A-B380FE222137@e18.physik.tu-muenchen.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24 2007, Roland Kuhn wrote:
> Hi Jens!
> 
> [I made a typo in the Cc: list so that lkml is only included as of  
> now. Actually I copied the typo from you ;-) ]

Well no, you started the typo, I merely propagated it and forgot to fix
it up :-)

> >On Tue, Apr 24 2007, Jens Axboe wrote:
> >>On Tue, Apr 24 2007, Roland Kuhn wrote:
> >>>Hi Jens!
> >>>
> >>>On 24 Apr 2007, at 11:18, Jens Axboe wrote:
> >>>
> >>>>On Tue, Apr 24 2007, Roland Kuhn wrote:
> >>>>>Hi Jens!
> >>>>>
> >>>>>We're using a custom built fileserver (dual core Athlon64, using
> >>>>>x64_64 arch) with 22 disks in a RAID6 and while resyncing /dev/md2
> >>>>>(9.1GB ext3) after a hardware incident (cable pulled on one  
> >>>>>disk) the
> >>>>>machine would reliably oops while serving some large files over
> >>>>>NFSv3. The oops message scrolled partly off the screen, but the IP
> >>>>>was in cfq_dispatch_insert, so I tried your debug patch from
> >>>>>yesterday with 2.6.21-rc7. I used netconsole for capturing the  
> >>>>>output
> >>>>>(which works nicely, thanks Matt!) and as usual the condition
> >>>>>triggered after about half a minute, this with the following  
> >>>>>printout
> >>>>>instead of crashing (still works fine):
> >>>>>
> >>>>>cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report  
> >>>>>the
> >>>>>issue to lkml@vger.kernel.org
> >>>>>cfq: busy=1,drv=1,timer=0
> >>>>>cfq rr_list:
> >>>>>cfq busy_list:
> >>>>> 4272: sort=0,next=0000000000000000,q=0/1,a=2/0,d=0/1,f=221
> >>>>>cfq idle_list:
> >>>>>cfq cur_rr:
> >>>>>cfq: rbroot not empty, but ->next_rq == NULL! Fixing up, report  
> >>>>>the
> >>>>>issue to lkml@vger.kernel.org
> >>>>>cfq: busy=1,drv=1,timer=0
> >>>>>cfq rr_list:
> >>>>>cfq busy_list:
> >>>>> 4276: sort=0,next=0000000000000000,q=0/1,a=2/0,d=0/1,f=221
> >>>>>cfq idle_list:
> >>>>>cfq cur_rr:
> >>>>>
> >>>>>There was no backtrace, so the only thing I can tell is that  
> >>>>>for the
> >>>>>previous crashes some nfs threads were always involved, only  
> >>>>>once did
> >>>>>it happen inside an interrupt handler (with the "aieee" kind of
> >>>>>message).
> >>>>>
> >>>>>If you want me to try something else, don't hesitate to ask!
> >>>>
> >>>>Nifty, great that you can reproduce so quickly. I'll try a 3-drive
> >>>>raid6
> >>>>here and see if read activity along with a resync will trigger
> >>>>anything.
> >>>>If that doesn't work for me, I'll provide you with a more extensive
> >>>>debug patch (if you don't mind).
> >>>>
> >>>Sure. You might want to include NFS file access into your tests,
> >>>since we've not triggered this with locally accessing the disks.  
> >>>BTW:
> >>
> >>How are you exporting the directory (what exports options) - how  
> >>is it
> >>mounted by the client(s)? What chunksize is your raid6 using?
> >
> >And what are the nature of the files on the raid (huge, small, ?) and
> >what are the client(s) doing? Just approximately, I know these things
> >can be hard/difficult/impossible to specify.
> >
> The files are 100-400MB in size and the client is merging them into a  
> new file in the same directory using the ROOT library, which does in  
> essence alternating sequences of
> 
> _llseek(somewhere)
> read(n bytes)
> _llseek(somewhere+n)
> read(m bytes)
> ...
> 
> and then
> 
> _llseek(somewhere)
> rt_sigaction(ignore INT)
> write(n bytes)
> rt_sigaction(INT->DFL)
> time()
> _llseek(somewhere+n)
> ...
> 
> where n is of the the order of 30kB. The input files are treated  
> sequentially, not randomly.

Ok, I'll see if I can reproduce it. No luck so far, I'm afraid.

> BTW: the machine just stopped dead, no sign whatsoever on console or  
> netconsole, so I rebooted with elevator=deadline
> (need to get some work done besides ;-) )

Unfortunately expected, if we can race and lose an update to ->next_rq,
we can race and corrupt some of the internal data structures as well. If
you have the time and inclination, it would be interesting to see if you
can reproduce with some debugging options enabled:

- Enable all preempt, spinlock and lockdep debugging measures
- Possibly slab poisoning, although that may slow you down somewhat

Are you using 4kb stacks?

-- 
Jens Axboe

