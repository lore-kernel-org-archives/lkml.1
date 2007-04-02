Return-Path: <linux-kernel-owner+w=401wt.eu-S965862AbXDBVPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862AbXDBVPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965871AbXDBVPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:15:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55421 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965862AbXDBVPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:15:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Mon, 2 Apr 2007 23:18:27 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200704012123.54797.rjw@sisk.pl> <4610BDD7.5070201@gmail.com>
In-Reply-To: <4610BDD7.5070201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704022318.28451.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 2 April 2007 10:24, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> >>> On Thursday, 29 March 2007 09:44, Jiri Slaby wrote:
> >>>> swsusp: critical section:
> >>>> swsusp: Need to copy 131380 pages
> >>>> swsusp: Not enough free memory
> >>>> Error -12 suspending
> >>>> Enabling non-boot CPUs ...
> 
> > As a workaround, you can try to change the initial image size so that it's
> > smaller than a half of the RAM size.  If that works, I'd like to send you a
> > debug patch, if you don't mind. :-)
> 
> Yes, post it.

Appended.  Please send me the dmesg output from after a failing suspend
(or in case it doesn't fail, from after the first one).

> # cat /sys/power/image_size
> 524288000
> # echo disk >/sys/power/state
> error
> # echo disk >/sys/power/state
> error
> # echo $((400*1024*1024)) > /sys/power/image_size
> # echo disk >/sys/power/state
> ok
> # dmesg|grep Memory:
> Memory: 1027160k/1048256k available (2559k kernel code, 20348k reserved,
> 1114k data, 188k init)
> 
> I don't undestand it too much, but can't be shared video memory involved
> somehow?

No, I don't think so.  There probably is a bug in swsusp_shrink_memory().

Greetings,
Rafael

---
---
 kernel/power/snapshot.c |    2 +-
 kernel/power/swsusp.c   |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc5/kernel/power/snapshot.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/snapshot.c
+++ linux-2.6.21-rc5/kernel/power/snapshot.c
@@ -1093,7 +1093,7 @@ static int enough_free_mem(unsigned int 
 	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
-	pr_debug("swsusp: Normal pages needed: %u + %u + %u, available pages: %u\n",
+	printk("swsusp: Normal pages needed: %u + %u + %u, available pages: %u\n",
 		nr_pages, PAGES_FOR_IO, meta, free);
 
 	return free > nr_pages + PAGES_FOR_IO + meta;
Index: linux-2.6.21-rc5/kernel/power/swsusp.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/swsusp.c
+++ linux-2.6.21-rc5/kernel/power/swsusp.c
@@ -227,22 +227,26 @@ int swsusp_shrink_memory(void)
 		size = count_data_pages() + PAGES_FOR_IO;
 		tmp = size;
 		size += highmem_size;
-		for_each_zone (zone)
+		for_each_zone (zone) {
+			printk("Normal pages needed: %lu\n", tmp);
+			printk("Highmem pages needed: %lu\n", highmem_size);
 			if (populated_zone(zone)) {
+				tmp += snapshot_additional_pages(zone);
 				if (is_highmem(zone)) {
 					highmem_size -=
 					zone_page_state(zone, NR_FREE_PAGES);
 				} else {
 					tmp -= zone_page_state(zone, NR_FREE_PAGES);
 					tmp += zone->lowmem_reserve[ZONE_NORMAL];
-					tmp += snapshot_additional_pages(zone);
 				}
 			}
+		}
 
 		if (highmem_size < 0)
 			highmem_size = 0;
 
 		tmp += highmem_size;
+		printk("Pages needed (total): %lu\n", tmp);
 		if (tmp > 0) {
 			tmp = __shrink_memory(tmp);
 			if (!tmp)
@@ -252,7 +256,7 @@ int swsusp_shrink_memory(void)
 			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
 			pages += tmp;
 		}
-		printk("\b%c", p[i++%4]);
+		/*printk("\b%c", p[i++%4]);*/
 	} while (tmp > 0);
 	do_gettimeofday(&stop);
 	printk("\bdone (%lu pages freed)\n", pages);
