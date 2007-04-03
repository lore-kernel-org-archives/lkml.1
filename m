Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXDCKqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXDCKqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 06:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXDCKqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 06:46:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58199 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646AbXDCKqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 06:46:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Tue, 3 Apr 2007 12:50:06 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200704022318.28451.rjw@sisk.pl> <46120449.7070302@gmail.com>
In-Reply-To: <46120449.7070302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031250.07307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 April 2007 09:37, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > On Monday, 2 April 2007 10:24, Jiri Slaby wrote:
> >> Rafael J. Wysocki napsal(a):
> >>>>> On Thursday, 29 March 2007 09:44, Jiri Slaby wrote:
> >>>>>> swsusp: critical section:
> >>>>>> swsusp: Need to copy 131380 pages
> >>>>>> swsusp: Not enough free memory
> >>>>>> Error -12 suspending
> >>>>>> Enabling non-boot CPUs ...
> >>> As a workaround, you can try to change the initial image size so that it's
> >>> smaller than a half of the RAM size.  If that works, I'd like to send you a
> >>> debug patch, if you don't mind. :-)
> >> Yes, post it.
> > 
> > Appended.  Please send me the dmesg output from after a failing suspend
> > (or in case it doesn't fail, from after the first one).
> 
> It doesn't fail, here is the output:

Okay, so I think the appended patch is needed.  Could you please revert the
debug one, apply the appended one instead and see if it helps?

> Shrinking memory...  Normal pages needed: 135122
> Highmem pages needed: 0
> Normal pages needed: 132256
> Highmem pages needed: 0
> Normal pages needed: 8271
> Highmem pages needed: 0
> Pages needed (total): 8271
> Normal pages needed: 119657
> Highmem pages needed: 0
> Normal pages needed: 116791
> Highmem pages needed: 0
> Normal pages needed: 18446744073709528969
> Highmem pages needed: 0
> Pages needed (total): 18446744073709528969
> 
> Heh :), tmp is signed, this is -22647, I guess.

Yup.

> done (15505 pages freed)
> Freed 62020 kbytes in 0.16 seconds (387.62 MB/s)
> 
> Complete dmesg may be obtained here:
> http://www.fi.muni.cz/~xslaby/sklad/dmesg.swsusp

Thanks for testing.

Greetings,
Rafael

---
 kernel/power/swsusp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc5/kernel/power/swsusp.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/power/swsusp.c
+++ linux-2.6.21-rc5/kernel/power/swsusp.c
@@ -229,13 +229,13 @@ int swsusp_shrink_memory(void)
 		size += highmem_size;
 		for_each_zone (zone)
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
 
