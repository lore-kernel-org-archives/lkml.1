Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbZHEBla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbZHEBla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbZHEBl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:41:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58145 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbZHEBl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:41:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 5 Aug 2009 10:39:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: scgtrp@gmail.com, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH 2/3] kcore: fix vread/vwrite to be aware of
 holes.
Message-Id: <20090805103938.e3ff9cbb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090804182457.8135110f.akpm@linux-foundation.org>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com>
	<20090803201845.c3ae49b5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090804143031.b9769a13.akpm@linux-foundation.org>
	<20090805100843.dbdabcfa.kamezawa.hiroyu@jp.fujitsu.com>
	<20090804182457.8135110f.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 18:24:57 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 5 Aug 2009 10:08:43 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > > > +		/*
> > > > +		 * To do safe access to this _mapped_ area, we need
> > > > +		 * lock. But adding lock here means that we need to add
> > > > +		 * overhead of vmalloc()/vfree() calles for this _debug_
> > > > +		 * interface, rarely used. Instead of that, we'll use
> > > > +		 * kmap() and get small overhead in this access function.
> > > > +		 */
> > > > +		if (p) {
> > > > +			/* we can expect USR1 is not used */
> > > 
> > > It would be nice if the comment were to explain _why_ KM_USER1 is known
> > > to be free here.
> > > 
> > ok, will do. Hmm, but KM_USR0 is better ?
> > I'm not sure difference between KM_USR0/KM_USR1...
> 
> KM_USER0 is conventionally the first one to use.  We only use KM_USER1
> if it is known that KM_USER0 is already used.
> 
Hmm, It sounds better to update this to use KM_USER0 when I applying Amerigo's comment.

Thanks,
-Kame


> > 
> > 
> > > 
> > > > +			void *map = kmap_atomic(p, KM_USER1);
> > > > +			memcpy(buf, map + offset, length);
> > > > +			kunmap_atomic(map, KM_USER1);
> > > 
> > > Can use clear_highpage().
> > > 
> > ah, "buf" is expected to be kmalloc'ed buffer. I'll explain it in Usage
> > or adds comment.
> > 
> 
> argh, memcpy != memset.  I knew that ;)
> 

