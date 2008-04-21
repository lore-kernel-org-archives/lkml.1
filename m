Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbYDUAhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbYDUAhA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYDUAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:36:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33220 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYDUAgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:36:53 -0400
Date: Mon, 21 Apr 2008 09:41:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, menage@google.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org
Subject: Re: [RFC][-mm] Memory controller hierarchy support (v1)
Message-Id: <20080421094143.bfd27db3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4809AE78.9030000@linux.vnet.ibm.com>
References: <20080419053551.10501.44302.sendpatchset@localhost.localdomain>
	<20080419065624.9837E5A15@siro.lan>
	<4809AE78.9030000@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008 14:04:00 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> YAMAMOTO Takashi wrote:
> >> -	spin_lock_irqsave(&counter->lock, flags);
> >> -	ret = res_counter_charge_locked(counter, val);
> >> -	spin_unlock_irqrestore(&counter->lock, flags);
> >> +	*limit_exceeded_at = NULL;
> >> +	local_irq_save(flags);
> >> +	for (c = counter; c != NULL; c = c->parent) {
> >> +		spin_lock(&c->lock);
> >> +		ret = res_counter_charge_locked(c, val);
> >> +		spin_unlock(&c->lock);
> >> +		if (ret < 0) {
> >> +			*limit_exceeded_at = c;
> >> +			goto unroll;
> >> +		}
> >> +	}
> >> +	local_irq_restore(flags);
> >> +	return 0;
> >> +
> >> +unroll:
> >> +	for (unroll_c = counter; unroll_c != c; unroll_c = unroll_c->parent) {
> >> +		spin_lock(&unroll_c->lock);
> >> +		res_counter_uncharge_locked(unroll_c, val);
> >> +		spin_unlock(&unroll_c->lock);
> >> +	}
> >> +	local_irq_restore(flags);
> >>  	return ret;
> >>  }
> > 
> > i wonder how much performance impacts this involves.
> > 
> > it increases the number of atomic ops per charge/uncharge and
> > makes the common case (success) of every charge/uncharge in a system
> > touch a global (ie. root cgroup's) cachelines.
> > 
> 
> Yes, it does. I'll run some tests to see what the overhead looks like. The
> multi-hierarchy feature is very useful though and one of the TODOs is to make
> the feature user selectable (possibly at run-time)
> 
I think multilevel cgroup is useful but this routines handling of hierarchy
seems never good. An easy idea to aginst this is making a child borrow some
amount of charge from its parent for reducing checks.
If you go this way, please show possibility to reducing overhead in your plan.

BTW, do you have ideas of attributes for children<->parent other than 'limit' ?
For example, 'priority' between childlen.

Thanks,
-Kame

