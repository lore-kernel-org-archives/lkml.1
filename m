Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbZC3Uft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbZC3Uft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758121AbZC3Ufk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:35:40 -0400
Received: from gw.goop.org ([64.81.55.164]:55765 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbZC3Ufj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:35:39 -0400
Message-ID: <49D12D16.6050407@goop.org>
Date: Mon, 30 Mar 2009 13:35:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       nickpiggin@yahoo.com.au, frankeh@watson.ibm.com,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<1238195024.8286.562.camel@nimitz>  <20090329161253.3faffdeb@skybase> <1238428495.8286.638.camel@nimitz> <49D11184.3060002@goop.org> <49D11287.4030307@redhat.com> <49D11674.9040205@goop.org> <49D12564.40708@redhat.com>
In-Reply-To: <49D12564.40708@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Jeremy Fitzhardinge wrote:
>> Rik van Riel wrote:
>>> Jeremy Fitzhardinge wrote:
>>>
>>>> That said, people have been looking at tracking block IO to work 
>>>> out when it might be useful to try and share pages between guests 
>>>> under Xen.
>>>
>>> Tracking block IO seems like a bass-ackwards way to figure
>>> out what the contents of a memory page are.
>>
>> Well, they're research projects, so nobody said that they're 
>> necessarily useful results ;).  I think the rationale is that, in 
>> general, there aren't all that many sharable pages, and asize from 
>> zero-pages, the bulk of them are the result of IO. 
>
> I'll give you a hint:  Windows zeroes out freed pages.

Right: "aside from zero-pages".  If you exclude zero-pages from your 
count of shared pages, the amount of sharing drops a lot.

> It should also be possible to hook up arch_free_page() so
> freed pages in Linux guests become sharable.
>
> Furthermore, every guest with the same OS version will be
> running the same system daemons, same glibc, etc.  This
> means sharable pages from not just disk IO (probably from
> different disks anyway),

Why?  If you're starting a bunch of cookie-cutter guests, then you're 
probably starting them from the same template image or COW block 
devices.  (Also, if you're wearing the cost of physical IO anyway, then 
additional cost of hashing is relatively small.)

> but also in the BSS and possibly
> even on the heap.

Well, maybe.  Modern systems generally randomize memory layouts, so even 
if they're semantically the same, the pointers will all have different 
values.

Other research into "sharing" mostly-similar pages is more promising for 
that kind of case.

> Eventually.  It starts out with hashing the first 128 (IIRC)
> bytes of page content and comparing the hashes.  If that
> matches, it will do content comparison.
>
> Content comparison is done in the background on the host.
> I suspect (but have not checked) that it is somehow hooked
> up to the page reclaim code on the host.

Yeah, that's the straightforward approach; there's about a research 
project/year doing a Xen implementation, but they never seem to get very 
good results aside from very artificial test conditions.

    J

