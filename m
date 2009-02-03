Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZBCBnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZBCBnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZBCBnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:43:25 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:35063 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751120AbZBCBnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:43:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1FvDrIQf84t6z08IDS4HzNhspa9Ky+8KYwsFjjkBhb0lJqWFe4kF4FSZR8JNFQgI71ymCM+R4/HXR7W4Y4OOulf3FFasWjpIYseuto/aXUKurT8I076gzCHvvaxdQAEdbwOCPuwFj6Ug1MeVICTAJBU5UeWcHXzqD6p1CGT+BK8=  ;
X-YMail-OSG: L.GERogVM1nMw8R7adsjhFLjHJkmvCwMKkOYa0sSDI2e3gwm0QotBF9pxDaM8hIjvSUV6Uv5Jr8yGByJQQGdrr3gZGnO2xL1dUmlqsZ3BgGuoXYr6zwXrjubKebskMezRqWkYXkEXzrtDvCG1wfx1E5s9nxxKrcx3TR5rGCZnN56.mUT1_nOMfraAxbOUw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
Date: Tue, 3 Feb 2009 12:42:54 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20090114150900.GC25401@wotan.suse.de> <200901240409.27449.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901261241070.22291@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0901261241070.22291@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031242.56206.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 04:46:49 Christoph Lameter wrote:
> On Sat, 24 Jan 2009, Nick Piggin wrote:
> > > > SLUB can directly free an object to any slab page. "Queuing" on free
> > > > via the per cpu slab is only possible if the object came from that
> > > > per cpu slab. This is typically only the case for objects that were
> > > > recently allocated.
> > >
> > > Ah yes ok that's right. But then you don't get LIFO allocation
> > > behaviour for those cases.
> >
> > And actually really this all just stems from conceptually in fact you
> > _do_ switch to a different queue (from the one being allocated from)
> > to free the object if it is on a different page. Because you have a
> > set of queues (a queue per-page). So freeing to a different queue is
> > where you lose LIFO property.
>
> Yes you basically go for locality instead of LIFO if the free does not hit
> the per cpu slab. If the object is not in the per cpu slab then it is
> likely that it had a long lifetime and thus LIFOness does not matter
> too much. It is likely that many objects from that slab are going to be
> freed at the same time. So the first free warms up the "queue" of the page
> you are freeing to.

I don't really understand this. It is easy to lose cache hotness information.
Free two objects from different pages. The first one to be freed is likely
to be cache hot, but it will not be allocated again (any time soon).


> This is an increasingly important feature since memory chips prefer
> allocations next to each other. Same page accesses are faster
> in recent memory subsystems than random accesses across memory.

DRAM chips? How about avoiding the problem and keeping the objects in cache
so you don't have to go to RAM.


> LIFO used
> to be better but we are increasingly getting into locality of access being
> very important for access.

Locality of access includes temporal locality. Which is very important. Which
SLUB doesn't do as well at.


> Especially with the NUMA characteristics of the
> existing AMD and upcoming Nehalem processors this will become much more
> important.

Can you demonstrate that LIFO used to be better but no longer is? What
NUMA characteristics are you talking about?

