Return-Path: <linux-kernel-owner+w=401wt.eu-S1751265AbXA0Wab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbXA0Wab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXA0Wab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:30:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36840 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbXA0Waa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:30:30 -0500
Date: Sat, 27 Jan 2007 14:30:13 -0800
From: Andrew Morton <akpm@osdl.org>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
Message-Id: <20070127143013.e2c839c0.akpm@osdl.org>
In-Reply-To: <45BBCFE9.5010600@redhat.com>
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>
	<45B9A00C.4040701@yahoo.com.au>
	<Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
	<20070126031300.59f75b06.akpm@osdl.org>
	<Pine.LNX.4.64.0701260742340.6141@schroedinger.engr.sgi.com>
	<20070126101027.90bf3e63.akpm@osdl.org>
	<Pine.LNX.4.64.0701261021200.7848@schroedinger.engr.sgi.com>
	<20070126104206.f0b45f74.akpm@osdl.org>
	<45BBCFE9.5010600@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 17:19:21 -0500
Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> > Of course it would.  But how do you know it is "too expensive"?  We "scan
> > all the vmas mapping a page" as a matter of course in the page scanner -
> > millions of times a minute.  If that's "too expensive" then ouch.
> 
> We can do it lazily.
> 
> At mlock time, move pages onto the mlocked list, unless they
> are there already.

Needs another page flag to determine what list the page is on (eek).

> On munlock, move pages to the active list.

We'd need to determine whether some other vma has mlocked the page too. 
That's either the page_struct refcount or the vma walk.  The latter is
equivalent to what I'm suggesting.

>  For mlock-only
> memory (shared memory segments?) we could add a simple check
> to see if the next process on the list has the page mlocked,
> checking only that one.
> 
> While scanning the active list, move mlocked pages that are
> found back onto the mlocked list.
> 
> This lazy movement of pages will impact shared libraries,
> but probably not shared memory segments.
> 
> Does this sound workable?

I'm still not sure what problem we're trying to solve here.

Knowing how many mlocked pages there are in a zone doesn't sound terribly
interesting and I don't recall ever wanting to know that.

Being able to keep mlocked pages off the LRU altogether sounds more useful.

It's all rather a tight corner case - people don't use mlock much.
