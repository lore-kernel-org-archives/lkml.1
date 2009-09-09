Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZIIX6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZIIX6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZIIX6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:58:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38749 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZIIX6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:58:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <28c262360909090839j626ff818of930cf13a6185123@mail.gmail.com>
References: <20090909131945.0CF5.A69D9226@jp.fujitsu.com> <28c262360909090839j626ff818of930cf13a6185123@mail.gmail.com>
Message-Id: <20090910084602.9CBD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 08:58:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Sep 9, 2009 at 1:27 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> The usefulness of a scheme like this requires:
> >>
> >> 1. There are cpus that continually execute user space code
> >>    without system interaction.
> >>
> >> 2. There are repeated VM activities that require page isolation /
> >>    migration.
> >>
> >> The first page isolation activity will then clear the lru caches of the
> >> processes doing number crunching in user space (and therefore the first
> >> isolation will still interrupt). The second and following isolation will
> >> then no longer interrupt the processes.
> >>
> >> 2. is rare. So the question is if the additional code in the LRU handling
> >> can be justified. If lru handling is not time sensitive then yes.
> >
> > Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
> > I think page migration don't need lru_add_drain_all() as synchronous, because
> > page migration have 10 times retry.
> >
> > Then asynchronous lru_add_drain_all() cause
> >
> >  - if system isn't under heavy pressure, retry succussfull.
> >  - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.
> >
> > I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.
> 
> I think, more exactly, we don't have to drain lru pages for mlocking.
> Mlocked pages will go into unevictable lru due to
> try_to_unmap when shrink of lru happens.

Right.

> How about removing draining in case of mlock?

Umm, I don't like this. because perfectly no drain often make strange test result.
I mean /proc/meminfo::Mlock might be displayed unexpected value. it is not leak. it's only lazy cull.
but many tester and administrator wiill think it's bug... ;)

Practically, lru_add_drain_all() is nearly zero cost. because mlock's page fault is very
costly operation. it hide drain cost. now, we only want to treat corner case issue. 
I don't hope dramatic change.



