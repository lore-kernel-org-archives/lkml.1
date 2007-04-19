Return-Path: <linux-kernel-owner+w=401wt.eu-S2993158AbXDSHLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993158AbXDSHLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993155AbXDSHKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:10:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993158AbXDSHKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:10:47 -0400
Message-ID: <4627154F.4000409@redhat.com>
Date: Thu, 19 Apr 2007 03:07:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Abhijit Bhopatkar <bainonline@gmail.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, akpm@osdl.org, jgarzik@pobox.com,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH] [RFC] Throttle swappiness for interactive tasks
References: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>	 <46268519.7080702@redhat.com>	 <2ff216280704182014h6ff2eed3g4301ee8d1bfbed14@mail.gmail.com>	 <4626F038.8020606@redhat.com> <2ff216280704182222w32d46b34u4168cf859032520a@mail.gmail.com>
In-Reply-To: <2ff216280704182222w32d46b34u4168cf859032520a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Abhijit Bhopatkar wrote:

> In my mind i find it fundamentally wrong to separate anon pages from
> page cache. It should rather be lot more dependent on which task
> accessed them last. Although it seems due to some twisted relationships
> bet anon pages and interactive tasks separating them improves it.
> Am i missing something here?

The IO cost for anonymous (and other swap backed) pages is
completely different from the IO cost of file system backed
pages.

On file systems, data is typically grouped together on disk
by related content.  Programs often access data linearly,
meaning that with readahead we can load a lot of pages into
memory with only a few disk seeks.

Anonymous memory does not have this benefit. For one, memory
tends to get written to swap by LRU order, not by related
content.  To make things worse, repeated malloc/free cycles
can cause the memory adjacant to each other inside a process
to be completely unrelated, making virtual address based
swap clustering less useful.

The goal of page replacement is to minimize the total time
spent waiting on page faults.  This is not exactly the same
as minimizing the total number of page faults.

> Can you send me those patches please or point me to where i can find those?

You can get the latest one here:

http://surriel.com/patches/2.6/vm-split/linux-2.6-vm-split.patch

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
