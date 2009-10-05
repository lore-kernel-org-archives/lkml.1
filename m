Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZJEMnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZJEMnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 08:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZJEMnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 08:43:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZJEMnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 08:43:19 -0400
Date: Mon, 5 Oct 2009 08:31:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: m-ikeda@ds.jp.nec.com, nauman@google.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20091005123148.GB22143@redhat.com>
References: <20091001133109.GA4058@redhat.com> <20091002025731.GA2738@redhat.com> <4AC6623F.70600@ds.jp.nec.com> <20091005.193808.104033719.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005.193808.104033719.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 07:38:08PM +0900, Ryo Tsuruta wrote:
> Hi,
> 
> Munehiro Ikeda <m-ikeda@ds.jp.nec.com> wrote:
> > Vivek Goyal wrote, on 10/01/2009 10:57 PM:
> > > Before finishing this mail, will throw a whacky idea in the ring. I was
> > > going through the request based dm-multipath paper. Will it make sense
> > > to implement request based dm-ioband? So basically we implement all the
> > > group scheduling in CFQ and let dm-ioband implement a request function
> > > to take the request and break it back into bios. This way we can keep
> > > all the group control at one place and also meet most of the requirements.
> > >
> > > So request based dm-ioband will have a request in hand once that request
> > > has passed group control and prio control. Because dm-ioband is a device
> > > mapper target, one can put it on higher level devices (practically taking
> > > CFQ at higher level device), and provide fairness there. One can also
> > > put it on those SSDs which don't use IO scheduler (this is kind of forcing
> > > them to use the IO scheduler.)
> > >
> > > I am sure that will be many issues but one big issue I could think of that
> > > CFQ thinks that there is one device beneath it and dipsatches requests
> > > from one queue (in case of idling) and that would kill parallelism at
> > > higher layer and throughput will suffer on many of the dm/md configurations.
> > >
> > > Thanks
> > > Vivek
> > 
> > As long as using CFQ, your idea is reasonable for me.  But how about for
> > other IO schedulers?  In my understanding, one of the keys to guarantee
> > group isolation in your patch is to have per-group IO scheduler internal
> > queue even with as, deadline, and noop scheduler.  I think this is
> > great idea, and to implement generic code for all IO schedulers was
> > concluded when we had so many IO scheduler specific proposals.
> > If we will still need per-group IO scheduler internal queues with
> > request-based dm-ioband, we have to modify elevator layer.  It seems
> > out of scope of dm.
> > I might miss something...
> 
> IIUC, the request based device-mapper could not break back a request
> into bio, so it could not work with block devices which don't use the
> IO scheduler.
> 

I think current request based multipath drvier does not do it but can't it
be implemented that requests are broken back into bio?

Anyway, I don't feel too strongly about this approach as it might
introduce more serialization at higher layer.

> How about adding a callback function to the higher level controller?
> CFQ calls it when the active queue runs out of time, then the higer
> level controller use it as a trigger or a hint to move IO group, so
> I think a time-based controller could be implemented at higher level.
> 

Adding a call back should not be a big issue. But that means you are
planning to run only one group at higher layer at one time and I think
that's the problem because than we are introducing serialization at higher
layer. So any higher level device mapper target which has multiple
physical disks under it, we might be underutilizing these even more and
take a big hit on overall throughput.

The whole design of doing proportional weight at lower layer is optimial 
usage of system.

> My requirements for IO controller are:
> - Implement s a higher level controller, which is located at block
>   layer and bio is grabbed in generic_make_request().

How are you planning to handle the issue of buffered writes Andrew raised?

> - Can work with any type of IO scheduler.
> - Can work with any type of block devices.
> - Support multiple policies, proportional wegiht, max rate, time
>   based, ans so on.
> 
> The IO controller mini-summit will be held in next week, and I'm
> looking forard to meet you all and discuss about IO controller.
> https://sourceforge.net/apps/trac/ioband/wiki/iosummit

Is there a new version of dm-ioband now where you have solved the issue of
sync/async dispatch with-in group? Before meeting at mini-summit, I am
trying to run some tests and come up with numbers so that we have more
clear picture of pros/cons.

Thanks
Vivek
