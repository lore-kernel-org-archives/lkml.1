Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbZIJBYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbZIJBYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZIJBYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:24:07 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47529 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZIJBYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Uc7Gx27/SKoJN5IXFVdmV3WAVt5FSpV00j5N0fjE6Gc0AF7JhFw54bvZ3IsCdgyk2h
         gpBEgxaTaF1/jwuoTJRdxhLLoS46gtFGIDFj0Q4W8at3lQHmp/LwpSCPmMoehS3C6nN6
         7mNfZ/WZqo47CkyjWR9qQzrKgmWqTrOkthbBo=
Date: Thu, 10 Sep 2009 10:23:41 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
Message-Id: <20090910102341.b59ca0ad.minchan.kim@barrios-desktop>
In-Reply-To: <20090910101051.9CCC.A69D9226@jp.fujitsu.com>
References: <20090910084602.9CBD.A69D9226@jp.fujitsu.com>
	<20090910100057.a1375276.minchan.kim@barrios-desktop>
	<20090910101051.9CCC.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 10:15:07 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Thu, 10 Sep 2009 08:58:20 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > On Wed, Sep 9, 2009 at 1:27 PM, KOSAKI Motohiro
> > > > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > >> The usefulness of a scheme like this requires:
> > > > >>
> > > > >> 1. There are cpus that continually execute user space code
> > > > >>    without system interaction.
> > > > >>
> > > > >> 2. There are repeated VM activities that require page isolation /
> > > > >>    migration.
> > > > >>
> > > > >> The first page isolation activity will then clear the lru caches of the
> > > > >> processes doing number crunching in user space (and therefore the first
> > > > >> isolation will still interrupt). The second and following isolation will
> > > > >> then no longer interrupt the processes.
> > > > >>
> > > > >> 2. is rare. So the question is if the additional code in the LRU handling
> > > > >> can be justified. If lru handling is not time sensitive then yes.
> > > > >
> > > > > Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
> > > > > I think page migration don't need lru_add_drain_all() as synchronous, because
> > > > > page migration have 10 times retry.
> > > > >
> > > > > Then asynchronous lru_add_drain_all() cause
> > > > >
> > > > >  - if system isn't under heavy pressure, retry succussfull.
> > > > >  - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.
> > > > >
> > > > > I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.
> > > > 
> > > > I think, more exactly, we don't have to drain lru pages for mlocking.
> > > > Mlocked pages will go into unevictable lru due to
> > > > try_to_unmap when shrink of lru happens.
> > > 
> > > Right.
> > > 
> > > > How about removing draining in case of mlock?
> > > 
> > > Umm, I don't like this. because perfectly no drain often make strange test result.
> > > I mean /proc/meminfo::Mlock might be displayed unexpected value. it is not leak. it's only lazy cull.
> > > but many tester and administrator wiill think it's bug... ;)
> > 
> > I agree. I have no objection to your approach. :)
> > 
> > > Practically, lru_add_drain_all() is nearly zero cost. because mlock's page fault is very
> > > costly operation. it hide drain cost. now, we only want to treat corner case issue. 
> > > I don't hope dramatic change.
> > 
> > Another problem is as follow.
> > 
> > Although some CPUs don't have any thing to do, we do it. 
> > HPC guys don't want to consume CPU cycle as Christoph pointed out.
> > I liked Peter's idea with regard to this. 
> > My approach can solve it, too. 
> > But I agree it would be dramatic change. 
> 
> Is Perter's + mine approach bad?

It's good to me! :)

> It mean,
> 
>   - RT-thread binding cpu is not grabbing the page
> 	-> mlock successful by Peter's improvement
>   - RT-thread binding cpu is grabbing the page
> 	-> mlock successful by mine approach
> 	   the page is culled later.
> 
> 
> 
> 


-- 
Kind regards,
Minchan Kim
