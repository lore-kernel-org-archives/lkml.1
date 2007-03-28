Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXC1O4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXC1O4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXC1O4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:56:14 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:16344 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752352AbXC1O4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:56:09 -0400
Message-ID: <460A80AA.8050505@cfl.rr.com>
Date: Wed, 28 Mar 2007 10:50:18 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Peter Bier <peter_bier@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: miniroot ramdisk corruption during intense memory usage
References: <909027047@web.de>
In-Reply-To: <909027047@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2007 14:50:22.0480 (UTC) FILETIME=[697E0900:01C77148]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15082.000
X-TM-AS-Result: No--7.254300-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Bier wrote:
> The following sympthom occured in a variant of the Knoppix-like linux appliance.
> 
> I get a corrupted miniroot ramdisk filesystem under kernel version 2.6.19.1 under intense memory usage during early startup of the system. 
> 
> In the course of a lengthy investigation of this behavior, I found out that the memory pages containing the miniroot ramdisk are freed during the initial installation 
> 
> process due to a memory shortage. It turned out, that shrink_active_list() calls pagevec_strip(), which in turn calls try_to_release_page() which finally calls try_to_free_buffers() which drops the corresponding buffers; if this succeeds, it seems to cause the page to become freed later. 
> 
> This causes pointers of indirect blocks of the filesystem of the miniroot ramdisk to be replaced by zero-filled pages later in the the system's history.
> 
> I fixed this by adding a new flag PG_ramdisk in the include file page-flags.h, setting the flag during ramdisk loading in ramdisk_commit_write() and checking for the flag in try_to_free_buffers() and retruning 0 as result immediately without freeing the buffers. 
> 
> I am not aware if that is the adequate way to solve the problem or if there is a solution that requires fewer and more localized changes of the system, avoiding to give the ramdisk pages a specific treatment
> 
>  
> 
>  
> 
> I did not observe this problem prior to kernel version 2.6.19.1, but I'm not sure whether ths was simply caused by coincidental circumstances during startup. 



The ramdisk driver already marks the pages as "do not discard".  Maybe 
you should investigate why that is no longer being respected?
