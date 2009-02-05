Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZBENYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZBENYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZBENXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:23:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34874 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbZBENXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:23:51 -0500
Message-ID: <74935449f7bd1248f959a526d56ca02a.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <498ADA5D.90201@virident.com>
References: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info>
    <20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com>
    <20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com>
    <20090204185501.837ff5d6.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.1.10.0902041037150.19633@qirst.com>
    <20090205101503.b1fd7df6.kamezawa.hiroyu@jp.fujitsu.com>
    <498ADA5D.90201@virident.com>
Date: Thu, 5 Feb 2009 22:23:45 +0900 (JST)
Subject: Re: [RFC][PATCH] release mmap_sem before starting migration (Was
 Re: Need to take mmap_sem lock in move_pages.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Swamy Gowda" <swamy@virident.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, brice.goglin@inria.fr,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swamy Gowda wrote:
> KAMEZAWA Hiroyuki wrote:
>> On Wed, 4 Feb 2009 10:39:19 -0500 (EST)
>> Christoph Lameter <cl@linux-foundation.org> wrote:
>>
>>> On Wed, 4 Feb 2009, KAMEZAWA Hiroyuki wrote:
>>>
>>> > mmap_sem can be released after page table walk ends.
>>>
>>> No. read lock on mmap_sem must be held since the migrate functions
>>> manipulate page table entries. Concurrent large scale changes to the
>>> page
>>> tables (splitting vmas, remapping etc) must not be possible.
>>>
>> Just for clarification:
>>
>> 1. changes in page table is not problem from the viewpoint of kernel.
>>   (means no panic, no leak,...)
>> 2. But this loses "atomic" aspect of migration and will allow unexpected
>>   behaviors.
>>   (means the page-mapping status after sys_move may not be what user
>> expects.)
>>
>>
>> Thanks,
>> -Kame
>>
>>
> But I can't understand how user can see different page->mapping , since
> new page->mapping still holds the anon_vma pointer which should still
> contain the changes in the vma list( due to split vma etc). But,
> considering it as a problem how is it avoided in case of hotremove?
>
I'm sorry page-mapping in my text is not page->mapping. Just means
process's memory map.

In my point of view, no problems (I wrote no problem in the kernel.)

One big difference between sys_move_pages and hot remove is
hot-remove retries many times but sys_move_pages() doesn't.
So, race/contention in migrate_page() will dramatically decrease
success-rate of page migration by system call.

In user side, sys_move_pages(), we may have to think more.
I wonder that there may be much more contentions of pte_lock and
page_lock() etc... if we remove mmap_sem.
The good point of mmap_sem is the waiter can sleep without any troubles
and nest of locks.

Thanks,
-Kame

