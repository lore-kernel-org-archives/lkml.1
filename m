Return-Path: <linux-kernel-owner+w=401wt.eu-S1751439AbXA0WgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbXA0WgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXA0WgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:36:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXA0WgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:36:08 -0500
Message-ID: <45BBD3D1.60605@redhat.com>
Date: Sat, 27 Jan 2007 17:36:01 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>	<45B9A00C.4040701@yahoo.com.au>	<Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>	<20070126031300.59f75b06.akpm@osdl.org>	<Pine.LNX.4.64.0701260742340.6141@schroedinger.engr.sgi.com>	<20070126101027.90bf3e63.akpm@osdl.org>	<Pine.LNX.4.64.0701261021200.7848@schroedinger.engr.sgi.com>	<20070126104206.f0b45f74.akpm@osdl.org>	<45BBCFE9.5010600@redhat.com> <20070127143013.e2c839c0.akpm@osdl.org>
In-Reply-To: <20070127143013.e2c839c0.akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 27 Jan 2007 17:19:21 -0500
> Rik van Riel <riel@redhat.com> wrote:
> 
>> Andrew Morton wrote:
>>
>>> Of course it would.  But how do you know it is "too expensive"?  We "scan
>>> all the vmas mapping a page" as a matter of course in the page scanner -
>>> millions of times a minute.  If that's "too expensive" then ouch.
>> We can do it lazily.
>>
>> At mlock time, move pages onto the mlocked list, unless they
>> are there already.
> 
> Needs another page flag to determine what list the page is on (eek).
> 
>> On munlock, move pages to the active list.
> 
> We'd need to determine whether some other vma has mlocked the page too. 
> That's either the page_struct refcount or the vma walk.  The latter is
> equivalent to what I'm suggesting.

It doesn't have to be 100% accurate.  The pages that are mapped
both mlocked and non-mlocked will probably be only shared
libraries.

>>  For mlock-only
>> memory (shared memory segments?) we could add a simple check
>> to see if the next process on the list has the page mlocked,
>> checking only that one.

As long as we get it right for the large objects, it should be
fine.

> I'm still not sure what problem we're trying to solve here.
> 
> Knowing how many mlocked pages there are in a zone doesn't sound terribly
> interesting and I don't recall ever wanting to know that.
> 
> Being able to keep mlocked pages off the LRU altogether sounds more useful.

> It's all rather a tight corner case - people don't use mlock much.

Just because it's not common does not mean you can just ignore
it and hope Linux doesn't unexpectedly fall over.

One thing that knowing the amount of mlocked data in each zone
(and node) would allow us to do is spread the mlocked memory
around a little better at allocation time.  This could prevent
some of the "I started a 6GB Oracle on my 8GB system and it
immediately fell over" bugs.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
