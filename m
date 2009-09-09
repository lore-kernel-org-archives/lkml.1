Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZIIXoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZIIXoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZIIXoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:44:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38252 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbZIIXn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:43:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux-mm <linux-mm@kvack.org>, Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0909091005010.28070@V090114053VZO-1>
References: <20090909131945.0CF5.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0909091005010.28070@V090114053VZO-1>
Message-Id: <20090910083340.9CB7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 08:43:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 9 Sep 2009, KOSAKI Motohiro wrote:
> 
> > Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
> > I think page migration don't need lru_add_drain_all() as synchronous, because
> > page migration have 10 times retry.
> 
> True this is only an optimization that increases the chance of isolation
> being successful. You dont need draining at all.
> 
> > Then asynchronous lru_add_drain_all() cause
> >
> >   - if system isn't under heavy pressure, retry succussfull.
> >   - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.
> >
> > I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.
> >
> > What do you think?
> 
> The retries can be very fast if the migrate pages list is small. The
> migrate attempts may be finished before the IPI can be processed by the
> other cpus.

Ah, I see. Yes, my last proposal is not good. small migration might be fail.

How about this?
  - pass 1-2,  lru_add_drain_all_async()
  - pass 3-10, lru_add_drain_all()

this scheme might save RT-thread case and never cause regression. (I think)

The last remain problem is, if RT-thread binding cpu's pagevec has migrate
targetted page, migration still face the same issue.
but we can't solve it...
RT-thread must use /proc/sys/vm/drop_caches properly.



