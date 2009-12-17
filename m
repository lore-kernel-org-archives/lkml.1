Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZLQTzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZLQTzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZLQTzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:55:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178AbZLQTze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:55:34 -0500
Message-ID: <4B2A8CA8.6090704@redhat.com>
Date: Thu, 17 Dec 2009 14:55:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: FWD:  [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
References: <20091211164651.036f5340@annuminas.surriel.com> <1260810481.6666.13.camel@dhcp-100-19-198.bos.redhat.com> <20091217193818.9FA9.A69D9226@jp.fujitsu.com> <4B2A22C0.8080001@redhat.com>
In-Reply-To: <4B2A22C0.8080001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After removing some more immediate bottlenecks with
the patches by Kosaki and me, Larry ran into a really
big one:

Larry Woodman wrote:

> Finally, having said all that, the system still struggles reclaiming 
> memory with
> ~10000 processes trying at the same time, you fix one bottleneck and it 
> moves
> somewhere else.  The latest run showed all but one running process 
> spinning in
> page_lock_anon_vma() trying for the anon_vma_lock.  I noticed that there 
> are
> ~5000 vma's linked to one anon_vma, this seems excessive!!!
> 
> I changed the anon_vma->lock to a rwlock_t and page_lock_anon_vma() to use
> read_lock() so multiple callers could execute the page_reference_anon code.
> This seems to help quite a bit.

The system has 10000 processes, all of which are child
processes of the same parent.

Pretty much all memory is anonymous memory.

This means that pretty much every anonymous page in the
system:
1) belongs to just one process, but
2) belongs to an anon_vma which is attached to 10,000 VMAs!

This results in page_referenced scanning 10,000 VMAs for
every page, despite the fact that each page is typically
only mapped into one process.

This seems to be our real scalability issue.

The only way out I can think is to have a new anon_vma
when we start a child process and to have COW place new
pages in the new anon_vma.

However, this is a bit of a paradigm shift in our object
rmap system and I am wondering if somebody else has a
better idea :)
