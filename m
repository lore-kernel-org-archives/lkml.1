Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbXJAP6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbXJAP6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbXJAP57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:57:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbXJAP56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:57:58 -0400
Message-ID: <470118EE.1020103@redhat.com>
Date: Mon, 01 Oct 2007 11:57:34 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
CC: Chakri n <chakriin5@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>, akpm@linux-foundation.org,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       richard kennedy <richard@rsk.demon.co.uk>
Subject: Re: A unresponsive file system can hang all I/O in the system on
 linux-2.6.23-rc6 (dirty_thresh problem?)
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <391063897.19256@ustc.edu.cn>
In-Reply-To: <391063897.19256@ustc.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2007 07:04 AM, Fengguang Wu wrote:
> On Thu, Sep 27, 2007 at 11:32:36PM -0700, Chakri n wrote:
>> Hi,
>>
>> In my testing, a unresponsive file system can hang all I/O in the system.
>> This is not seen in 2.4.
>>
>> I started 20 threads doing I/O on a NFS share. They are just doing 4K
>> writes in a loop.
>>
>> Now I stop NFS server hosting the NFS share and start a
>> "dd" process to write a file on local EXT3 file system.
>>
>> # dd if=/dev/zero of=/tmp/x count=1000
>>
>> This process never progresses.
> 
> Peter, do you think this patch will help?
> 
> ===
> writeback: avoid possible balance_dirty_pages() lockup on light-load bdi
> 
> On a busy-writing system, a writer could be hold up infinitely on a
> light-load device. It will be trying to sync more than enough dirty data.
> 
> The problem case:
> 
> 0. sda/nr_dirty >= dirty_limit;
>    sdb/nr_dirty == 0
> 1. dd writes 32 pages on sdb
> 2. balance_dirty_pages() blocks dd, and tries to write 6MB.
> 3. it never gets there: there's only 128KB dirty data.
> 4. dd may be blocked for a loooong time as long as sda is overloaded
> 
> Fix it by returning on 'zero dirty inodes' in the current bdi.
> (In fact there are slight differences between 'dirty inodes' and 'dirty pages'.
> But there is no available counters for 'dirty pages'.)
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  mm/page-writeback.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- linux-2.6.22.orig/mm/page-writeback.c
> +++ linux-2.6.22/mm/page-writeback.c
> @@ -227,6 +227,9 @@ static void balance_dirty_pages(struct a
>  		if (nr_reclaimable + global_page_state(NR_WRITEBACK) <=
>  			dirty_thresh)
>  				break;
> +		if (list_empty(&mapping->host->i_sb->s_dirty) &&
> +		    list_empty(&mapping->host->i_sb->s_io))
> +			break;
>  
>  		if (!dirty_exceeded)
>  			dirty_exceeded = 1;
> 

This looks better than the other candidate to fix the problem. Are we going
to fix 2.6.23 before release? Multiple people have reported this problem now...

