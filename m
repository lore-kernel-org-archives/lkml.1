Return-Path: <linux-kernel-owner+w=401wt.eu-S1946468AbXBCPgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946468AbXBCPgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946472AbXBCPgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:36:49 -0500
Received: from dvhart.com ([64.146.134.43]:44550 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946468AbXBCPgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:36:48 -0500
Message-ID: <45C4ABDF.9050701@mbligh.org>
Date: Sat, 03 Feb 2007 07:35:59 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com> <20070203101628.GB28806@infradead.org>
In-Reply-To: <20070203101628.GB28806@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Feb 02, 2007 at 10:20:12PM -0800, Christoph Lameter wrote:
>> This is a new variation on the earlier RFC for tracking mlocked pages.
>> We now mark a mlocked page with a bit in the page flags and remove
>> them from the LRU. Pages get moved back when no vma that references
>> the page has VM_LOCKED set anymore.
>>
>> This means that vmscan no longer uselessly cycles over large amounts
>> of mlocked memory should someone attempt to mlock large amounts of
>> memory (may even result in a livelock on large systems).
>>
>> Synchronization is build around state changes of the PageMlocked bit.
>> The NR_MLOCK counter is incremented and decremented based on
>> state transitions of PageMlocked. So the count is accurate.
>>
>> There is still some unfinished business:
>>
>> 1. We use the 21st page flag and we only have 20 on 32 bit NUMA platforms.
>>
>> 2. Since mlocked pages are now off the LRU page migration will no longer
>>    move them.
>>
>> 3. Use NR_MLOCK to tune various VM behaviors so that the VM does not 
>>    longer fall due to too many mlocked pages in certain areas.
> 
> This patch seems to not handle the cases where more than one process mlocks
> a page and you really need a pincount in the page to not release it before
> all processes have munlock it or died.  I did a similar patch a while
> ago and tried to handle it by overloading the lru lists pointers with
> a pincount, but at some point I gave up because I couldn't get that part
> right.

Doesn't matter - you can just do it lazily. If you find a page that is
locked, move it to the locked list. when unlocking a page you *always*
move it back to the normal list. If someone else is still locking it,
we'll move it back to the lock list on next reclaim pass.

I have a half-finished patch from 6 months ago that does this, but never
found time to complete it ;-(

M.
