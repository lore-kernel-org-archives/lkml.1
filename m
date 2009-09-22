Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZIVOi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZIVOi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZIVOi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:38:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762AbZIVOiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:38:54 -0400
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: Heinz Mauelshagen <heinzm@redhat.com>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, lmb@suse.de,
       jens.axboe@oracle.com, neilb@suse.de, hch@infradead.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
In-Reply-To: <20090921144308.GG8072@barkeeper1-xen.linbit>
References: <20090918200803.GM23126@kernel.dk>
	 <20090919141334N.fujita.tomonori@lab.ntt.co.jp>
	 <20090919220232.GB31849@suse.de>
	 <20090921223815U.fujita.tomonori@lab.ntt.co.jp>
	 <20090921144308.GG8072@barkeeper1-xen.linbit>
Content-Type: text/plain
Organization: Red Hat GmbH
Date: Tue, 22 Sep 2009 07:37:00 +0200
Message-Id: <1253597820.9619.12.camel@nb.ww.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 16:43 +0200, Lars Ellenberg wrote:
> On Mon, Sep 21, 2009 at 10:39:42PM +0900, FUJITA Tomonori wrote:
> > > Either
> > > 
> > > a) there's going to be a transition period during which the "old"
> > > interface is supported but depreciated and scheduled to be removed (all
> > > driving the new unified same back-end),
> > 
> > We should avoid removing the existing interface. Once we merge drbd, I
> > don't think that it's a good idea to remove the drbd user interface.
> 
> 
> the drbd user interface is presented via
> low level drbdsetup
> and high level drbdadm (parses configuration files,
> and calls out to drbdsetup).
> 
> changing (simplifying) the in-kernel configuration can be done any time,
> as long as we can write a compat layer in the user land tools,
> i.e. write drbdsetup so it will accept the same command line,
> and try, based on "something" (sysfs file, genetlink group, 
> environment variable, whatever) the "new" kernel interface,
> or the "old" one.
> 
> I don't see any issue here.
> 
> > I don't think so. It's much easier to implement something that
> > supports fewer user interfaces.
> 
> We can choose whatever user-kernel interface you like,
> and change it with every dot release --
> we'd just need to add additional compat code into
> the drbdsetup userland binary.
> 
> > > > BTW, DM already has something like drbd? I thought that there is a
> > > > talk about that new target at LinuxCon.
> > > 
> > > dm-replicator is nowhere near as usable as DRBD, and not upstream yet
> > 
> > I don't think usability at this point is important. The design
> > matters. dm-replicator is built on the existing framework.
> > 
> > And my question is, if drbd and dm-replicator will provide similar
> > features, then why do we need both in mainline?
> 
> dm-replicator is not there yet, and as such has zero user base.

dm-replicator is work in progress and we're aiming to ship it with
RHEL6.

> 
> To actually use it in the HA clustering world, quite a lot
> userland glue would have to be written, which is not there yet either.

We had quite some target table syntax settlement to work through but
lvm2 support is coming along now hence leveraging the existing LVM2 UI
(e.g. lvconvert) to support managing remote replication of a set of
logical volumes to one or more remote sites.

> 
> In contrast, DRBD is used in production, in many thousands of
> installations worldwide since many years.
> 
> By design, dm-replicator is more comparable to dm-raid1, with the
> knowledge that several mirror legs may break independently
> (resulting in one "dirty log" per mirror leg), and come back
> independendly, as well as the option of adding an on-disk ring-buffer to
> any mirror leg.

The on-disk ring-buffer is not an option, it's mandatory and being used
to ensure write ordering fidelity for all devices eing replicated in
groups to one or more remote sites. dm-replicator ensures write ordering
for a group of devices rather than single devices while replicating.

The per remote device dirty logs are being used for initial
synchronization of remote devices *and* to allow fallback to dirty
logging in case the replication log (which ensures write ordering
fidelity to allow for remote recovery after a failover) runs full. That
fallback mode allows us to avoid starvation of application io when the
log gets full.

> 
> It is by design NOT able to do dual-active mode.

This is a false statement.

dm-replicator abstracts the logging of the data and the transport out
into separate plugin-type modules. It just happens to be that the
initial version is active-passive because of our requirements which aim
at long distance replication, hence don't require active-active
initially. A different log module can support active-active but this is
not our goal initially.

> 
> If any of you happens to be at LinuxCon,
> please discuss with Heinz (Maulshagen, dm-replicator)
> and Phil (Reisner, DRBD), who both are present.
> 
> Heinz' talk about replicator is scheduled today, 10:30 am, 
> that would be a good opportunity, I guess.

My talk's past now but I'm still at the conference till Wednesday so
please feel free to contact me.

Heinz

> 
> > > either. (Further, it's another independent implementation, pursued
> > > instead of unifying any of the existing ones or helping to merge drbd -
> > > don't get me started on my thoughts of that.)
> > 
> > Again, dm-replicator is built on the existing framework instead of
> > adding another 'multiple (virtual) devices' framework into mainline.
> 
> Well, not exactly.
> 
> It adds quite a bit of additional framework (to the device mapper
> subsystem), before it then starts to use that additional framework
> via the generic device mapper hooks.
> 
> On that same line DRBD could argue that it uses the existing generic
> block layer framework, just adding a bit functionality ;)
> 

