Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbZCLEAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbZCLEAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZCLEAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:00:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49095 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZCLEAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:00:06 -0400
Date: Thu, 12 Mar 2009 12:58:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 2/5] add softlimit to res_counter
Message-Id: <20090312125839.3b01e20c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090312035444.GC23583@balbir.in.ibm.com>
References: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312095612.4a7758e1.kamezawa.hiroyu@jp.fujitsu.com>
	<20090312035444.GC23583@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 09:24:44 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

>
> > +int res_counter_set_softlimit(struct res_counter *cnt, unsigned long long val)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&cnt->lock, flags);
> > +	cnt->softlimit = val;
> > +	spin_unlock_irqrestore(&cnt->lock, flags);
> > +	return 0;
> > +}
> > +
> > +bool res_counter_check_under_softlimit(struct res_counter *cnt)
> > +{
> > +	struct res_counter *c;
> > +	unsigned long flags;
> > +	bool ret = true;
> > +
> > +	local_irq_save(flags);
> > +	for (c = cnt; ret && c != NULL; c = c->parent) {
> > +		spin_lock(&c->lock);
> > +		if (c->softlimit < c->usage)
> > +			ret = false;
> 
> So if a child was under the soft limit and the parent is *not*, we
> _override_ ret and return false?
> 
yes. If you don't want this behavior I'll rename this to
res_counter_check_under_softlimit_hierarchical().


> > +		spin_unlock(&c->lock);
> > +	}
> > +	local_irq_restore(flags);
> > +	return ret;
> > +}
> 
> Why is the check_under_softlimit hierarchical? 

At checking whether a mem_cgroup is a candidate for softlimit-reclaim,
we need to check all parents.

> BTW, this patch is buggy. See above.
> 

Not buggy. Just meets my requiremnt.


Thanks,
-Kame

