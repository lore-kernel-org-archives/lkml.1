Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZHSSnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZHSSnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZHSSnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:43:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZHSSnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:43:10 -0400
Date: Wed, 19 Aug 2009 14:41:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com,
       agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 02/24] io-controller: Core of the elevator fair queuing
Message-ID: <20090819184142.GD4391@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-3-git-send-email-vgoyal@redhat.com> <4A8C21DE.1080001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8C21DE.1080001@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:01:34PM +0200, Jerome Marchand wrote:
> Hi Vivek,
> 
> Vivek Goyal wrote:
> > o This is core of the io scheduler implemented at elevator layer. This is a mix
> >   of cpu CFS scheduler and CFQ IO scheduler. Some of the bits from CFS have
> >   to be derived so that we can support hierarchical scheduling. Without
> >   cgroups or with-in group, we should essentially get same behavior as CFQ.
> > 
> > o This patch only shows non-hierarchical bits. Hierarhical code comes in later
> >   patches.
> > 
> > o This code is the building base of introducing fair queuing logic in common
> >   elevator layer so that it can be used by all the four IO schedulers.
> 
> > +static void enqueue_io_entity(struct io_entity *entity)
> > +{
> > +	struct io_service_tree *st = entity->st;
> > +	struct io_sched_data *sd = io_entity_sched_data(entity);
> > +
> > +	/* In case task ioprio class changed while entity was off tree */
> > +	io_entity_update_prio(entity);
> > +	st->nr_active++;
> > +	sd->nr_active++;
> > +	entity->on_st = 1;
> > +	place_entity(st, entity, 0);
> > +	__enqueue_io_entity(st, entity);
> > +}
> 
> > +static void put_prev_io_entity(struct io_entity *entity)
> > +{
> > +	struct io_service_tree *st = entity->st;
> > +	struct io_sched_data *sd = io_entity_sched_data(entity);
> > +
> > +	st->active_entity = NULL;
> > +	sd->active_entity = NULL;
> > +
> > +	if (unlikely(entity->ioprio_changed)) {
> > +		dequeue_io_entity(entity);
> > +		io_entity_update_prio(entity);
> 
> That call to io_entity_update_prio() looks redundant with the one in
> enqueue_io_entity().
> 

thanks Jerome. Yes it does look like a redundant call. Will get rid of it
in next posting.

Vivek

> > +		enqueue_io_entity(entity);
> > +	} else
> > +		__enqueue_io_entity(st, entity);
> > +}
> 
> Jerome
