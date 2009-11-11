Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbZKKGWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbZKKGWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZKKGWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:22:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60405 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZKKGWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:22:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 11 Nov 2009 15:20:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with
 nodemask v4.1
Message-Id: <20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com>
	<20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110163419.361E.A69D9226@jp.fujitsu.com>
	<20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
	<20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 21:58:31 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 11 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Index: mm-test-kernel/drivers/char/sysrq.c
> > ===================================================================
> > --- mm-test-kernel.orig/drivers/char/sysrq.c
> > +++ mm-test-kernel/drivers/char/sysrq.c
> > @@ -339,7 +339,7 @@ static struct sysrq_key_op sysrq_term_op
> >  
> >  static void moom_callback(struct work_struct *ignored)
> >  {
> > -	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0);
> > +	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, NULL);
> >  }
> >  
> >  static DECLARE_WORK(moom_work, moom_callback);
> > Index: mm-test-kernel/mm/oom_kill.c
> > ===================================================================
> > --- mm-test-kernel.orig/mm/oom_kill.c
> > +++ mm-test-kernel/mm/oom_kill.c
> > @@ -196,27 +196,47 @@ unsigned long badness(struct task_struct
> >  /*
> >   * Determine the type of allocation constraint.
> >   */
> > -static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> > -						    gfp_t gfp_mask)
> > -{
> >  #ifdef CONFIG_NUMA
> > +static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
> > +				    gfp_t gfp_mask, nodemask_t *nodemask)
> > +{
> >  	struct zone *zone;
> >  	struct zoneref *z;
> >  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> > -	nodemask_t nodes = node_states[N_HIGH_MEMORY];
> > +	int ret = CONSTRAINT_NONE;
> >  
> > -	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
> > -		if (cpuset_zone_allowed_softwall(zone, gfp_mask))
> > -			node_clear(zone_to_nid(zone), nodes);
> > -		else
> > -			return CONSTRAINT_CPUSET;
> > +	/*
> > +	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
> > + 	 * to kill current.We have to random task kill in this case.
> > + 	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
> > + 	 */
> > +	if (gfp_mask & __GPF_THISNODE)
> > +		return ret;
> >  
> 
> That shouldn't compile.
> 
Why ?

Thanks,
-Kame

