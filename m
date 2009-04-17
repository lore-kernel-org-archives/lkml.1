Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZDQAcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZDQAcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758523AbZDQAcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:32:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788AbZDQAcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:32:07 -0400
Date: Fri, 17 Apr 2009 02:31:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: add filter_mutex to protect filter
	predicates
Message-ID: <20090417003143.GE29630@elte.hu>
References: <1239863904.6903.12.camel@tropicana> <49E6ED5A.6080003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E6ED5A.6080003@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Tom Zanussi wrote:
> > This patch adds a filter_mutex to prevent the filter predicates from
> > being accessed concurrently by various external functions.
> > 
> > It's based on a previous patch by Li Zefan:
> >         "[PATCH 7/7] tracing/filters: make filter preds RCU safe"
> > 
> > but any problems with it were added by me. ;-)
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > 
> 
> Reviewed-and-tested-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> except:
> 
> > @@ -348,17 +399,15 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
> >  		if (strcmp(call->system, system->name))
> >  			continue;
> >  
> > -		if (!find_event_field(call, pred->field_name))
> > -			continue;
> > -
> > -		err = filter_add_pred(call, pred);
> > +		err = __filter_add_pred(call, pred);
> >  		if (err == -ENOMEM) {
> >  			system->preds[system->n_preds] = NULL;
> > -			return err;
> > +			system->n_preds--;
> > +			break;
> 
> now we return 0 but not ENOMEM in this failure case.

ok - i'll wait for this fix.

	Ingo
