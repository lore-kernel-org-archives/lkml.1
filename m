Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbZHLJjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbZHLJjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932322AbZHLJjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:39:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:43941 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbZHLJjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:39:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,365,1246863600"; 
   d="scan'208";a="174916377"
Date: Wed, 12 Aug 2009 17:39:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "hch@infradead.org" <hch@infradead.org>,
       "mfasheh@suse.com" <mfasheh@suse.com>,
       "aia21@cantab.net" <aia21@cantab.net>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "swhiteho@redhat.com" <swhiteho@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] [16/19] HWPOISON: Enable .remove_error_page for
	migration aware file systems
Message-ID: <20090812093935.GA2724@localhost>
References: <20090805093643.E0C00B15D8@basil.firstfloor.org> <4A7FBFD1.2010208@hitachi.com> <20090810074421.GA6838@basil.fritz.box> <4A80EAA3.7040107@hitachi.com> <20090811071756.GC14368@basil.fritz.box> <20090812080540.GA32342@wotan.suse.de> <20090812082331.GD28848@basil.fritz.box> <20090812084613.GB32342@wotan.suse.de> <20090812085727.GE28848@basil.fritz.box> <20090812090518.GC32342@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812090518.GC32342@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 05:05:18PM +0800, Nick Piggin wrote:
> On Wed, Aug 12, 2009 at 10:57:27AM +0200, Andi Kleen wrote:
> > On Wed, Aug 12, 2009 at 10:46:13AM +0200, Nick Piggin wrote:
> > > On Wed, Aug 12, 2009 at 10:23:31AM +0200, Andi Kleen wrote:
> > > > > page corruption, IMO, because by definition they should be able to
> > > > > tolerate panic. But if they do not know about this change to -EIO
> > > > > semantics, then it is quite possible to cause problems.
> > > > 
> > > > There's no change really. You already have this problem with
> > > > any metadata error, which can cause similar trouble.
> > > > If the application handles those correctly it will also 
> > > > handle hwpoison correctly.
> > > 
> > > What do you mean metadata error?
> > 
> > e.g. when there's an write error on the indirect block or any
> > other fs metadata. This can also cause you to lose data. The error 
> > reporting also works through the address space like with hwpoison,
> > so it only gets reported once.
> 
> Well, this is also a filesystem issue, but anyway the data typically
> does not get thrown out. So a subsequent fsync should be able to
> retry.

Right. In normal EIO, the data in page cache is still good and
accessible.

> But if the filesystem can't handle such errors and loses the original
> data when there is an IO error in newly dirty metadata, then it's
> a problem in the filesystem really isn't it?

Right, and the fs should report EIO on future sync attempts as long as
the problem sticks.

> > I'm not really against fixing that (make the error more sticky
> > as Fengguang puts it), but I don't think it needs to be mixed
> > with hwpoison.
> 
> I don't know if making it sticky realy "fixes" it. The problem is
> different semantics of what EIO means. My example illustrates this.

Case 1: (re)sync on EIO: sticky EIO will help.

Case 2: read out the data from page cache and rewrite it somewhere.
Sticky EIO is not enough, because here the application assumes the
dirty page is still accessible. In this case, patch
http://lkml.org/lkml/2009/6/11/294 will help. It effectively freezes
the radix tree, so that no new pages will be loaded to replace the 
corrupted data and fake a 'good' one.

Thanks,
Fengguang
