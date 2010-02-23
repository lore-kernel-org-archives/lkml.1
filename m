Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab0BWGP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:15:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56591 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0BWGP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:15:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 23 Feb 2010 15:12:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       rientjes@google.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] memcg: page fault oom improvement
Message-Id: <20100223151225.e7fdadc5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100223061020.GH3063@balbir.in.ibm.com>
References: <20100223120315.0da4d792.kamezawa.hiroyu@jp.fujitsu.com>
	<20100223061020.GH3063@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 11:40:20 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-02-23 12:03:15]:
> 
> > Nishimura-san, could you review and test your extreme test case with this ?
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, because of page_fault_oom_kill, returning VM_FAULT_OOM means
> > random oom-killer should be called. Considering memcg, it handles
> > OOM-kill in its own logic, there was a problem as "oom-killer called
> > twice" problem.
> > 
> > By commit a636b327f731143ccc544b966cfd8de6cb6d72c6, I added a check
> > in pagefault_oom_killer shouldn't kill some (random) task if
> > memcg's oom-killer already killed anyone.
> > That was done by comapring current jiffies and last oom jiffies of memcg.
> > 
> > I thought that easy fix was enough, but Nishimura could write a test case
> > where checking jiffies is not enough. So, my fix was not enough.
> > This is a fix of above commit.
> > 
> > This new one does this.
> >  * memcg's try_charge() never returns -ENOMEM if oom-killer is allowed.
> >  * If someone is calling oom-killer, wait for it in try_charge().
> >  * If TIF_MEMDIE is set as a result of try_charge(), return 0 and
> >    allow process to make progress (and die.) 
> >  * removed hook in pagefault_out_of_memory.
> > 
> > By this, pagefult_out_of_memory will be never called if memcg's oom-killer
> > is called and scattered codes are now in memcg's charge logic again.
> > 
> > TODO:
> >  If __GFP_WAIT is not specified in gfp_mask flag, VM_FAULT_OOM will return
> >  anyway. We need to investigate it whether there is a case.
> > 
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Balbir Singh <balbir@in.ibm.com>
> > Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I've not reviewed David's latest OOM killer changes. Are these changes based on top of
> what is going to come in with David's proposal?

About this change. no. This is an independent patch.
But through these a few month work, I(we) noticed page_fault_out_of_memory() is
dangerous and VM_FALUT_OOM should not be returned as much as possible.
About memcg, it's not necessary to return VM_FAULT_OOM when we know oom-killer
is called.

This fix itself is straightforward. But difficult thing here is test case, I think.

Thanks,
-Kame


