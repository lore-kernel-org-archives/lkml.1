Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZLCOuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZLCOuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZLCOuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:50:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44282 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbZLCOuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:50:17 -0500
Date: Thu, 3 Dec 2009 14:50:19 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] uswsusp: automatically free the in-memory image once
	s2disk has finished with it
Message-ID: <20091203145018.GG26702@csn.ul.ie>
References: <200912012253.08522.rjw@sisk.pl> <4B16545B.3090703@tuffmail.co.uk> <20091202122019.GD1457@csn.ul.ie> <4B16797C.3010304@tuffmail.co.uk> <20091202211107.GA20830@elf.ucw.cz> <20091202220718.GI1457@csn.ul.ie> <20091202221524.GB20830@elf.ucw.cz> <20091202222516.GD26702@csn.ul.ie> <20091203075301.GA29440@elf.ucw.cz> <4B17B5B8.1060105@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4B17B5B8.1060105@tuffmail.co.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 12:57:28PM +0000, Alan Jenkins wrote:
> Pavel Machek wrote:
>> On Wed 2009-12-02 22:25:16, Mel Gorman wrote:
>>   
>>> On Wed, Dec 02, 2009 at 11:15:24PM +0100, Pavel Machek wrote:
>>>     
>>>> On Wed 2009-12-02 22:07:18, Mel Gorman wrote:
>>>>       
>>>>> On Wed, Dec 02, 2009 at 10:11:07PM +0100, Pavel Machek wrote:
>>>>>         
>>>>>> On Wed 2009-12-02 14:28:12, Alan Jenkins wrote:
>>>>>>           
>>>>>>> The original in-kernel suspend (swsusp) frees the in-memory hibernation
>>>>>>> image before powering off the machine.  s2disk doesn't, so there is
>>>>>>> _much_ less free memory when it tries to power off.
>>>>>>>
>>>>>>> This is a gratuitous difference.  The userspace suspend interface
>>>>>>> /dev/snapshot only allows the hibernation image to be read once.
>>>>>>> Once the s2disk program has read the last page, we can free the entire
>>>>>>> image.
>>>>>>>
>>>>>>> This avoids a hang after writing the hibernation image which was
>>>>>>> triggered by commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61
>>>>>>> "page-allocator: split per-cpu list into one-list-per-migrate-type":
>>>>>>>             
>>>>>> Yes, you work around page-allocator hang. But is it right thing to do?
>>>>>>
>>>>>>           
>>>>> What's wrong with it? The hang is likely because the allocator has no
>>>>> memory to work with. The patch in question makes small changes to the
>>>>> amount of available memory but it shouldn't matter on uni-core. Some
>>>>> structures are slightly larger but it's extremely borderline. I'm at a
>>>>> loss to explain actually why it makes a difference untill things were
>>>>> extremely borderline to begin with.
>>>>>         
>>>> We reserve 4MB, for such purposes, and we already wrote image to disk
>>>> with such constrains, so memory should not be _too_ tight.
>>>>
>>>> Can you try increasing PAGES_FOR_IO to 8MB or something like that?
>>>>
>>>>       
>>> What's wrong with just freeing the memory that is no longer required?
>>>     
>>
>> Nothing. But 4MB was enough to power down before, it is not enough
>> now, and I'd like to understand why.
>> 									Pavel
>>   
>
> Here's a new datum:
>
> Applying this patch has left a less frequent hang.  So far it has  
> happened twice.  (Once playing last night, and once today testing  
> hibernation with KMS enabled).
>
> This hang happens at a different point.  It happens _before_ writing out  
> the hibernation image.  That is, I don't see the textual progress bar,  
> and if I force a power-cycle then it doesn't resume (and complains about  
> uncleanly unmounted filesystems).
>
> Here is the backtrace:
>
> [top of screen]
> s2disk D c1c05580 0 5988 5809 0x00000000
> ...
> Call Trace:
> ...
> ? wait_for_common
> ? default_wake_function
> ? kthread_create
> ? worker_thread
> ? create_workqueue_thread
> ? worker_thread
> ? __create_workqueue_thread
> ? stop_machine_create
> ? disable_nonboot_cpus
> ? hibernation_snapshot
> ? snapshot_ioctl
> ...
> ? sys_ioctl
>

Can you reconfirm that backing out both of those patches makes this 100%
reliable or is it just a lot harder to trigger. It does not even appear
that it's locked up within the page allocator at this trace message.
Assuming c1c05580 is where it's stuck at, where does addr2line say that
is (requires CONFIG_DEBUG_INFO) ?

> It looks like hibernation_snapshot() calls disable_nonboot_cpus()  
> _before_ we allocate the hibernation image.  (I.e. before  
> swsusp_arch_suspend(), which calls swsusp_save()).
>

I'm not that familiar with the area but considering where we are getting
stuck and what the path affected, I thought it might be CPU related.
There is a patch below that prints debugging messages to show how the
CPU is being taken down with respect to PCP draining in case something
has changed there. It also puts in some debugging code in the most
likely place to be infinite looping due to the patch.

> So I think Pavel's right, we still need to work out what's happening here.
>

Can you apply the following patch please and retry?

Two things to watch out for. First, do either of the BUG_ON triggers?
Second, for the TRACE messages, do they always appear in the order of
"draining pages" and then "deleting pagesets"?

Thanks

==== CUT HERE ====
page allocator,suspend: Debugging patch

---
 mm/page_alloc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b11915d..f36d7bd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -557,10 +557,13 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
+	BUG_ON(count > pcp->count);
+
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	while (count) {
 		struct page *page;
 		struct list_head *list;
+		int debug_migratetype = -1;
 
 		/*
 		 * Remove pages from lists in a round-robin fashion. A
@@ -573,6 +576,10 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			batch_free++;
 			if (++migratetype == MIGRATE_PCPTYPES)
 				migratetype = 0;
+			if (debug_migratetype == -1)
+				debug_migratetype = migratetype;
+			else
+				BUG_ON(migratetype == debug_migratetype);
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
@@ -3251,6 +3258,7 @@ static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		printk("TRACE: CPU %d deleting pagesets\n", cpu);
 		free_zone_pagesets(cpu);
 		break;
 	default:
@@ -4549,6 +4557,7 @@ static int page_alloc_cpu_notify(struct notifier_block *self,
 	int cpu = (unsigned long)hcpu;
 
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
+		printk("TRACE: CPU %d draining pages\n", cpu);
 		drain_pages(cpu);
 
 		/*
