Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXDLVd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXDLVd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXDLVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:33:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44038 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXDLVd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:33:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Thu, 12 Apr 2007 23:36:57 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200704111640.47171.rjw@sisk.pl> <461CF87C.4060801@gmail.com>
In-Reply-To: <461CF87C.4060801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122336.57600.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 April 2007 17:02, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > On Wednesday, 11 April 2007 12:45, Jiri Slaby wrote:
> >> Rafael J. Wysocki napsal(a):
> >>> On Wednesday, 11 April 2007 09:36, Jiri Slaby wrote:
> >>>> Rafael J. Wysocki napsal(a):
> >>>>> On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
> >>>>>> I have bad news for you :(. I thought I had unpatched kernel, but it happens
> >>>>>> in -rc6 too.
> >>>>> I guess you mean you're still seeing the 'not enough memory to suspend'
> >>>>> problem?
> >>>> Yes:
> >>>> Disabling non-boot CPUs ...
> >>>> kvm: disabling virtualization on CPU1
> >>>> Breaking affinity for irq 9
> >>>> CPU 1 is now offline
> >>>> SMP alternatives: switching to UP code
> >>>> CPU1 is down
> >>>> swsusp: critical section:
> >>>> swsusp: Need to copy 158309 pages
> >>>> swsusp: Not enough free memory
> >>>> Error -12 suspending
> >>>> Enabling non-boot CPUs ...
> >>>> SMP alternatives: switching to SMP code
> >>>> Booting processor 1/2 APIC 0x1
> >>>> Initializing CPU#1
> >>> How reproducible is it?  I'm going to try to reproduce it on one of my boxes.
> >> My tip is one of three cases: after some work on fresh boot -- some
> >> consumers such as thunderbird, firefox, 10 or so terminals with
> >> gnome-session. Single xterm + gnome-session semms not to be a problem.
> > 
> > Does the workaround with setting the image size below 1/2 of RAM work for you?
> 
> Yes. Yesterday I must set the value to 350M -- 400M was not enough.

Well, I can't reproduce it.

Can you please try to reproduce it with the appended patch applied and send
the output of dmesg to me?

Greetings,
Rafael

---
 kernel/power/snapshot.c |    4 ++--
 kernel/power/swsusp.c   |   16 ++++++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6.21-rc6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/snapshot.c
+++ linux-2.6.21-rc6/kernel/power/snapshot.c
@@ -871,9 +871,9 @@ static int enough_free_mem(unsigned int 
 		if (!is_highmem(zone))
 			free += zone_page_state(zone, NR_FREE_PAGES);
 	}
-
+	printk("swsusp: Normal pages needed: %u\n", nr_pages);
 	nr_pages += count_pages_for_highmem(nr_highmem);
-	pr_debug("swsusp: Normal pages needed: %u + %u + %u, available pages: %u\n",
+	printk("swsusp: Normal pages needed: %u + %u + %u, available pages: %u\n",
 		nr_pages, PAGES_FOR_IO, meta, free);
 
 	return free > nr_pages + PAGES_FOR_IO + meta;
Index: linux-2.6.21-rc6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/swsusp.c
+++ linux-2.6.21-rc6/kernel/power/swsusp.c
@@ -214,8 +214,8 @@ int swsusp_shrink_memory(void)
 	long tmp;
 	struct zone *zone;
 	unsigned long pages = 0;
-	unsigned int i = 0;
-	char *p = "-\\|/";
+	/*unsigned int i = 0;
+	char *p = "-\\|/";*/
 	struct timeval start, stop;
 
 	printk("Shrinking memory...  ");
@@ -227,7 +227,9 @@ int swsusp_shrink_memory(void)
 		size = count_data_pages() + PAGES_FOR_IO;
 		tmp = size;
 		size += highmem_size;
-		for_each_zone (zone)
+		printk("Pages needed: %ld normal, %ld highmem\n",
+			tmp, highmem_size);
+		for_each_zone (zone) {
 			if (populated_zone(zone)) {
 				tmp += snapshot_additional_pages(zone);
 				if (is_highmem(zone)) {
@@ -238,11 +240,17 @@ int swsusp_shrink_memory(void)
 					tmp += zone->lowmem_reserve[ZONE_NORMAL];
 				}
 			}
+			printk("Pages needed: %ld normal, %ld highmem\n",
+				tmp, highmem_size);
+		}
 
 		if (highmem_size < 0)
 			highmem_size = 0;
 
+		printk("Pages needed: %ld normal, %ld highmem\n",
+			tmp, highmem_size);
 		tmp += highmem_size;
+		printk("Pages needed: %ld\n", tmp);
 		if (tmp > 0) {
 			tmp = __shrink_memory(tmp);
 			if (!tmp)
@@ -252,7 +260,7 @@ int swsusp_shrink_memory(void)
 			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
 			pages += tmp;
 		}
-		printk("\b%c", p[i++%4]);
+		/*printk("\b%c", p[i++%4]);*/
 	} while (tmp > 0);
 	do_gettimeofday(&stop);
 	printk("\bdone (%lu pages freed)\n", pages);
