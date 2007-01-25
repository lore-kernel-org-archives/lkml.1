Return-Path: <linux-kernel-owner+w=401wt.eu-S965376AbXAYR6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbXAYR6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965379AbXAYR6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:58:30 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:47199 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376AbXAYR63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:58:29 -0500
Message-ID: <45B8EF74.6010704@in.ibm.com>
Date: Thu, 25 Jan 2007 23:27:08 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>, Aubrey Li <aubreylee@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Henn, erich, Michael" <Michael.Hennerich@analog.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com> <45B75208.90208@linux.vnet.ibm.com> <Pine.LNX.4.64.0701240655400.9696@schroedinger.engr.sgi.com> <45B82F41.9040705@linux.vnet.ibm.com> <45B835FE.6030107@redhat.com> <45B844E3.4050203@linux.vnet.ibm.com> <45B8D5AB.8040803@redhat.com>
In-Reply-To: <45B8D5AB.8040803@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Vaidyanathan Srinivasan wrote:
>> Rik van Riel wrote:
> 
>>> There are a few databases out there that mmap the whole
>>> thing.  Sleepycat for one...
>>
>> That is why my suggestion would be not to touch mmapped pagecache
>> pages in the current pagecache limit code.  The limit should concern
>> only unmapped pagecache pages.
> 
> So you want to limit how much data the kernel caches for mysql
> or postgresql, but not limit how much of the rpm database is
> cached ?!
> 
> IMHO your proposal does the exact opposite of what would be
> right for my systems :)
> 

<Jumping in late into the discussion>

One scenario I can think of is

A group of I/O intensive task can cause readahead and
dirty page I/O and make good forward progress, but
they'll hit another group of processes by swapping
their pages out. How do we make fair forward progress?
The system administrator can currently control the
amount of swappiness by setting it, but swappiness is
a reclaim time control parameter.

We can control dirty page I/O by setting vm_dirty_ratio.
Readahead is also tuneable with fadvise(), but not many
applications use fadvise.

The question now is, is it easier for the system administrator
to say, limit my page cache usage to say 30% of total memory available,
so that other allocations do not have to wait on disk I/O or page
reclaim (consider slab allocations, other kernel data structures).

A low priority task might run infrequently and end up spending all
it's time either swapping in pages or reclaiming memory and by
the time it runs again, it ends up doing the same thing.

I understand the swap token mitigates this problem to some extent,
but limiting the page cache will give the system administrator
control over system memory behaviour.

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
