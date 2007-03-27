Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbXC0Jpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbXC0Jpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXC0Jpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:45:43 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:54351 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbXC0Jpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:45:42 -0400
Message-ID: <4608E799.2050801@linux.vnet.ibm.com>
Date: Tue, 27 Mar 2007 15:14:57 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: Aubrey Li <aubreylee@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       ckrm-tech@lists.sourceforge.net, Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, devel@openvz.org, xemul@sw.ru,
       Paul Menage <menage@google.com>, Christoph Lameter <clameter@sgi.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/3][RFC] Containers: Pagecache controller reclaim
References: <45ED251C.2010400@linux.vnet.ibm.com> <45ED266E.7040107@linux.vnet.ibm.com> <6d6a94c50703262044q22e94538i5e79a32a82f7c926@mail.gmail.com> <4608C4F6.4020407@linux.vnet.ibm.com> <6d6a94c50703270141u5e59f73dj8bef0de0cfed1924@mail.gmail.com>
In-Reply-To: <6d6a94c50703270141u5e59f73dj8bef0de0cfed1924@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Aubrey Li wrote:
> On 3/27/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
>> Correct, shrink_page_list() is called from shrink_inactive_list() but
>> the above code is patched in shrink_active_list().  The
>> 'force_reclaim_mapped' label is from function shrink_active_list() and
>> not in shrink_page_list() as it may seem in the patch file.
>>
>> While removing pages from active_list, we want to select only
>> pagecache pages and leave the remaining in the active_list.
>> page_mapped() pages are _not_ of interest to pagecache controller
>> (they will be taken care by rss controller) and hence we put it back.
>>  Also if the pagecache controller is below limit, no need to reclaim
>> so we put back all pages and come out.
> 
> Oh, I just read the patch, not apply it to my local tree, I'm working
> on 2.6.19 now.
> So the question is, when vfs pagecache limit is hit, the current
> implementation just reclaim few pages, so it's quite possible the
> limit is hit again, and hence the reclaim code will be called again
> and again, that will impact application performance.

Yes, you are correct.  So if we start reclaiming one page at a time,
then the cost of reclaim is very high and we would be calling the
reclaim code too often.  Hence we have a 'buffer zone' or 'reclaim
threshold' or 'push back' around the limit.  In the patch we have a 64
page (256KB) NR_PAGES_RECLAIM_THRESHOLD:

 int pagecache_acct_shrink_used(unsigned long nr_pages)
 {
 	unsigned long ret = 0;
 	atomic_inc(&reclaim_count);
+
+	/* Don't call reclaim for each page above limit */
+	if (nr_pages > NR_PAGES_RECLAIM_THRESHOLD) {
+		ret += shrink_container_memory(
+				RECLAIM_PAGECACHE_MEMORY, nr_pages, NULL);
+	}
+
 	return 0;
 }

Hence we do not call the reclaimer if the threshold is exceeded by
just 1 page... we wait for 64 pages or 256KB of pagecache memory to go
 overlimit and then call the reclaimer which will reclaim all 64 pages
in one shot.

This prevents the reclaim code from being called too often and it also
keeps the cost of reclaim low.

In future patches we are planing to have a percentage based reclaim
threshold so that it would scale well with the container size.

--Vaidy

