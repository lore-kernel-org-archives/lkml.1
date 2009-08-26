Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZHZSTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZHZSTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZHZSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:19:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZHZSTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:19:08 -0400
Date: Wed, 26 Aug 2009 14:19:08 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dm snapshot: implement .iterate_devices
Message-ID: <20090826181908.GB26018@redhat.com>
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com> <20090826145045.GH643@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826145045.GH643@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26 2009 at 10:50am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Sun, Aug 23, 2009 at 02:11:07AM -0400, Mike Snitzer wrote:
> > This patch implements .iterate_devices for the origin and snapshot
> > targets.  dm-snapshot's lack of .iterate_devices resulted in the
> > inability to properly establish queue_limits for both targets.  
> > With 4K sector drives: an unfortunate side-effect of not establishing
> > proper limits in either targets' DM device was that IO to the devices
> > would fail even though both had been created without error.
> > Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 should have implemented
> > .iterate_devices for dm-snap.c's origin and snapshot targets.
>  
> > +static int snapshot_iterate_devices(struct dm_target *ti,
> > +				    iterate_devices_callout_fn fn, void *data)
> > +{
> > +	struct dm_snapshot *snap = ti->private;
> > +
> > +	return fn(ti, snap->origin, 0, ti->len, data);
> > +}
> 
> > +static int origin_iterate_devices(struct dm_target *ti,
> > +				  iterate_devices_callout_fn fn, void *data)
> > +{
> > +	struct dm_dev *dev = ti->private;
> > +
> > +	return fn(ti, dev, 0, ti->len, data);
> > +}
> 
> Why are these both seemingly the same?  Is one sufficient?

One is not sufficient.  If snapshot_iterate_devices() isn't provided the
snapshot fails IO on 4K drives; e.g. an ext3 mount in my test case:
sd 13:0:0:0: [sdc] Bad block number requested
EXT3-fs: unable to read superblock

> And where are the characteristics of the 'cow' device taken into account?

As we discussed, the snapshot_iterate_devices() needs more intelligence.

For now the current snapshot_iterate_devices() is a means to establish
more reasonable limits based on the origin.  So in my 4K drive case it
was a means to an end but it was naively incomplete.  One _could_ have a
cow with different logical_block_size, etc. (e.g. 512B origin + 4K cow).
So stacking the cow limits is clearly needed.

I'll work on a proper solution for snapshot_iterate_devices() and get
that to you ASAP.

Thanks for the review.

Mike
