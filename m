Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYGGKh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYGGKh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYGGKhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:37:18 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:25075 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752205AbYGGKhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:37:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=frsOuq7Ic8CxbE+6GsstsAKRvdSQN3gvpmgm1KHl4Tks4g+lIsb8QxtUdMac8glBvZAAka59MWmK/Ic2mJYmlt94yCruPtZj/ufspNJo/QVdlzkHf8DbSCfZL/S66+AVtUGCvYnuUqVyCn5mAKVWO7f/1Tdqf8LqmzXQVyt/5tA=  ;
X-YMail-OSG: oHBNTosVM1l3ldcHYOUjlNhMaeSHtTTrfo7RPVxRMfgABVLBGeIrQdqmwLRe0N_rXHE7lXzuX8VNA_MOOWBgC5EXGL4XkUJBehmS8H8A6_XQvEblGqLteTXibvP5tDZniY4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] fix task dirty balancing
Date: Mon, 7 Jul 2008 20:36:54 +1000
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20080702082644.BA45D5A17@siro.lan> <20080705150401.8bd28b71.kamezawa.hiroyu@jp.fujitsu.com> <1215250202.6320.10.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1215250202.6320.10.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072036.54553.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2008 19:30, Peter Zijlstra wrote:
> On Sat, 2008-07-05 at 15:04 +0900, KAMEZAWA Hiroyuki wrote:

> > And task-dirty-limit don't have to take care of following 2 case ?
> >   - __set_page_dirty_nobuffers(struct page *page) (increment
> > BDI_RECRAIMABLE) - test_set_page_writeback() (increment BDI_RECLAIMABLE)
>
> Gah - what a mess...

It's not so bad once you get past the funny names and conventions :)


> It's in set_page_dirty() so it wouldn't have to be in all the
> a_ops->set_page_dirty() functions...

At some point, they have to actually set the page dirty though, in
which case they would normally call __set_page_dirty_nobuffers or
similar (ie. rather than SetPageDirty, unless they really know what
they're doing).


> But now it turns out people don't use set_page_dirty() to dirty
> pages :-(

They do, but they also use other things :) Filesystems of course are
in complete control of the aops, so they can definitely bypass it.


> For the purpose of task_dirty_inc() I guess we might as well pair it
> with task_io_account_write() for each PAGE_CACHE_SIZE (and ignore the
> DIO bit, since that doesn't care about the dirty limit anyway).

Yes, the dirty increment should go in the same places where we increment
all the dirty statistics... it's the right spot to do it AFAIKS.


> Might be my ignorance, but _why_ do we have __set_page_dirty_nobuffers()
> reimplemented in fs/buffers.c:__set_page_dirty() ? - those two functions
> look suspiciously similar.

Probably no really good reason. The buffers.c code should probably be
merged / unified in page-writeback.c.


> Also, why was the EXPORT added anyway - fs/buffers.o never ends up in
> modules?

Definitely it would. Almost every filesystem can be build modularly. Or
did you mean some other symbol?

