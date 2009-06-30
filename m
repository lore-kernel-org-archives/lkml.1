Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZF3Kaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZF3Kaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZF3Kaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:30:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZF3Kaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:30:46 -0400
Date: Tue, 30 Jun 2009 13:30:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: steve@chygwyn.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH v4] slow-work: add (module*)work->ops->owner to fix
	races with module clients
Message-ID: <20090630103001.GA30065@redhat.com>
References: <20090629191653.14240.44995.stgit@dev.haskins.net> <1246351383.3383.1.camel@localhost.localdomain> <20090630090715.GD29725@redhat.com> <20090630091832.GA14767@fogou.chygwyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630091832.GA14767@fogou.chygwyn.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 10:18:32AM +0100, steve@chygwyn.com wrote:
> Hi,
> 
> On Tue, Jun 30, 2009 at 12:07:15PM +0300, Michael S. Tsirkin wrote:
> > On Tue, Jun 30, 2009 at 09:43:03AM +0100, Steven Whitehouse wrote:
> > > Hi,
> > > 
> > > I'm happy to ACK this, but the race doesn't exist in GFS2's case because
> > > we wait for all work related to each GFS2 fs at umount time and the
> > > module unload cannot happen until all GFS2 fs are umounted,
> > > 
> > > Steve.
> > 
> > I wonder whether the following holds:
> > 
> > static void gfs2_recover_put_ref(struct slow_work *work)
> > {
> >         struct gfs2_jdesc *jd = container_of(work, struct gfs2_jdesc, jd_work);
> >         clear_bit(JDF_RECOVERY, &jd->jd_flags);
> >         smp_mb__after_clear_bit();
> >         wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
> > 
> > <- umount can complete here?
> > 
> > }
> > 
> > 
> > If yes, .text of the module could go away between the point marked by <-
> > and return from gfs2_recover_put_ref.
> > 
> >
> Well in theory, yes. In reality I don't think it could ever happen

Right. IIUC, that's all Gregory's patch is trying to address: a
theoretical race condition.

-- 
MST
