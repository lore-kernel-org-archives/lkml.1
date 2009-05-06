Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbZEFOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbZEFOFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759182AbZEFOFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:05:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZEFOFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:05:14 -0400
Message-ID: <4A01987A.6070002@redhat.com>
Date: Wed, 06 May 2009 17:02:34 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       chrisw@redhat.com, alan@lxorguk.ukuu.org.uk, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses registrations.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com> <4A015C69.7010600@redhat.com> <4A0181EA.3070600@redhat.com> <20090506131735.GW16078@random.random> <Pine.LNX.4.64.0905061424480.19190@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0905061424480.19190@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Wed, 6 May 2009, Andrea Arcangeli wrote:
>   
>> For example for the swapping of KSM pages we've been thinking of using
>> external rmap hooks to avoid the VM to know anything specific to KSM
>> pages but to still allow their unmapping and swap.
>>     
>
> There may prove to be various reasons why it wouldn't work out in practice;
> but when thinking of swapping them, it is worth considering if those KSM
> pages can just be assigned to a tmpfs file, then leave the swapping to that.
>
> Hugh
>   

The problem here (as i see it) is reverse mapping for this vmas that 
point into the shared page.
Right now linux use the ->index to find this pages and then unpresent 
them...
But even if we move into allocating them inside tmpfs, who will know how 
to unpresent the virtual addresses when we want to swap the page?

I had old patch that did that extrnal rmap thing, it added few callbacks 
inside rmap.c (you had AnonPage FilePage and ExtRmapPage) and if any 
driver wanted to mangae the reverse mapping by itself it would just 
marked the pages as ExtRmapPages and will then tell the 
try_to_unmap_one() the virtual address it need to unmap...

As far as i remember it required some small changes into memory.c

