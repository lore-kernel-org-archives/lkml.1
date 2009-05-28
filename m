Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbZE1IwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbZE1IwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbZE1IwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:52:04 -0400
Received: from ms01.sssup.it ([193.205.80.99]:57903 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758619AbZE1IwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:52:01 -0400
Date: Thu, 28 May 2009 10:52:07 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: Nauman Rafique <nauman@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 02/20] io-controller: Common flat fair queuing code in elevaotor layer
Message-ID: <20090528085207.GA18909@gandalf.sssup.it>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-3-git-send-email-vgoyal@redhat.com> <e98e18940905271353kc6890dbxa1ea63026c8faec1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940905271353kc6890dbxa1ea63026c8faec1@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nauman Rafique <nauman@google.com>
> Date: Wed, May 27, 2009 01:53:59PM -0700
>
> On Tue, May 26, 2009 at 3:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > This is common fair queuing code in elevator layer. This is controlled by
...
> > +/**
> > + * __bfq_lookup_next_entity - return the first eligible entity in @st.
> > + * @st: the service tree.
> > + *
> > + * Update the virtual time in @st and return the first eligible entity
> > + * it contains.
> > + */
> > +static struct io_entity *__bfq_lookup_next_entity(struct io_service_tree *st)
> > +{
> > +	struct io_entity *entity;
> > +
> > +	if (RB_EMPTY_ROOT(&st->active))
> > +		return NULL;
> > +
> > +	bfq_update_vtime(st);
> 
> Vivek, Paolo, Fabio,
> Over here we call bfq_update_vtime(), and this function could have
> been called even when we are just doing a lookup (and not an extract).
> So vtime is updated while we are not really selecting the next queue
> for service (for an example, see elv_preempt_queue()). This can result
> in a call to update_vtime when only an entity with small weight (say
> weight=1) is backlogged and another entity with bigger weight (say 10)
> is getting serviced so it is not in the tree (we extract the entity
> which is getting service). This results in a big vtime jump to the
> start time of the entity with weight 1 (entity of weight 1 would have
> big start times, as it has small weight). Now when another entity with
> bigger weight (say 90) gets backlogged, it is assigned a new vtime
> from service tree's vtime, causing it to get a big value. In the
> meanwhile, iog for weight 10 keeps getting service for many quantums,
> as it was continuously backlogged.
> 
> The problem happens because we extract an entity (removing it from the
> tree) while it is getting service, and do vtime jumps based on what is
> still in the tree. I think we need to add an extra check on the vtime
> of the entity in service, before we take a vtime jump.
> 
> I have actually seen this happening when trying to debug on of my
> tests. Please let me know what you think.
> 

IIRC this behavior is not coming from bfq, as the original code
called __bfq_lookup_next_entity() without extraction only if there
was no entity under service (in bfq_update_next_active() it checked
for sd->active_entity != NULL).

I've not looked at the details of what changed, thus I don't know
why the old behavior cannot be maintained, but the virtual time jump
should be avoided in this case (and it is not specified by the wf2q+
algorithm).

[ sorry for the excessive trimming, but due to some charset problems
  the quotations were unreadable ]
