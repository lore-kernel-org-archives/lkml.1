Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYDDJfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYDDJfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYDDJew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:34:52 -0400
Received: from gw.goop.org ([64.81.55.164]:41681 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYDDJeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:34:50 -0400
Message-ID: <47F5F5FC.3090800@goop.org>
Date: Fri, 04 Apr 2008 02:33:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 00 of 24] More Xen updates
References: <patchbomb.1207158829@localhost> <20080404081034.GB30799@elte.hu>
In-Reply-To: <20080404081034.GB30799@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080303030204060007030803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080303030204060007030803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Hi Ingo,
>>
>> More patches.  There are three groups:
>>
>> - some code movements to make common code available to other
>>   architectures (namely, ia64)
>> - Xen device driver updates, including a new xen paravirt framebuffer driver,
>> - The Xen balloon driver (shrink only, so no dependency on memory hotplug yet)
>> - some "using smp_processor_id while preemptable" warning fixes,
>>   mostly as a result of the core kernel's tendency to do tlb flushes
>>   and update init_mm while preemptable,
>> - other little Xen cleanups
>>     
>
> thanks, applied for testing. The .25 Xen items we've got queued up are:
>
>  Subject: xen: refactor xen_{alloc,release}_{pte,pmd}()
>  Subject: xen: do not pin/unpin PMD pages
>  Subject: xen: clear PG_pinned in release_{pte,pmd}()
>   

Mark just posted another bugfix patch - attached.

    J



--------------080303030204060007030803
Content-Type: text/plain;
 name="xen-Fix-grant-table-bug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xen-Fix-grant-table-bug.patch"

Subject: xen: Fix grant table bug

From: Michael Abd-El-Malek <mabdelmalek@cmu.edu>

A PV OS has two grant table data structures: the grant table itself
and a free list.  The free list is composed of an array of pages,
which grow dynamically as the guest OS requires more grants.  While
the grant table contains 8-byte entries, the free list contains 4-byte
entries.  So we have half as many pages in the free list than in the
grant table.

There was a bug in the free list allocation code. The free list was
indexed as if it was the same size as the grant table.  But it's only
half as large.  So memory got corrupted, and I was seeing crashes in
the slab allocator later on.

Taken from:

  http://xenbits.xensource.com/linux-2.6.18-xen.hg?rev/4018c0da3360

Signed-off-by: Michael Abd-El-Malek <mabdelmalek@cmu.edu>
Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/grant-table.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

===================================================================
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -381,11 +381,15 @@ EXPORT_SYMBOL_GPL(gnttab_cancel_free_callback);
 static int grow_gnttab_list(unsigned int more_frames)
 {
 	unsigned int new_nr_grant_frames, extra_entries, i;
+	unsigned int nr_glist_frames, new_nr_glist_frames;
 
 	new_nr_grant_frames = nr_grant_frames + more_frames;
 	extra_entries       = more_frames * GREFS_PER_GRANT_FRAME;
 
-	for (i = nr_grant_frames; i < new_nr_grant_frames; i++) {
+	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	new_nr_glist_frames =
+		(new_nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	for (i = nr_glist_frames; i < new_nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_ATOMIC);
 		if (!gnttab_list[i])
 			goto grow_nomem;
@@ -407,7 +411,7 @@ static int grow_gnttab_list(unsigned int more_frames)
 	return 0;
 
 grow_nomem:
-	for ( ; i >= nr_grant_frames; i--)
+	for ( ; i >= nr_glist_frames; i--)
 		free_page((unsigned long) gnttab_list[i]);
 	return -ENOMEM;
 }
@@ -530,7 +534,7 @@ static int gnttab_expand(unsigned int req_entries)
 static int __devinit gnttab_init(void)
 {
 	int i;
-	unsigned int max_nr_glist_frames;
+	unsigned int max_nr_glist_frames, nr_glist_frames;
 	unsigned int nr_init_grefs;
 
 	if (!is_running_on_xen())
@@ -543,15 +547,15 @@ static int __devinit gnttab_init(void)
 	 * grant reference free list on the current hypervisor.
 	 */
 	max_nr_glist_frames = (boot_max_nr_grant_frames *
-			       GREFS_PER_GRANT_FRAME /
-			       (PAGE_SIZE / sizeof(grant_ref_t)));
+			       GREFS_PER_GRANT_FRAME / RPP);
 
 	gnttab_list = kmalloc(max_nr_glist_frames * sizeof(grant_ref_t *),
 			      GFP_KERNEL);
 	if (gnttab_list == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < nr_grant_frames; i++) {
+	nr_glist_frames = (nr_grant_frames * GREFS_PER_GRANT_FRAME + RPP - 1) / RPP;
+	for (i = 0; i < nr_glist_frames; i++) {
 		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_KERNEL);
 		if (gnttab_list[i] == NULL)
 			goto ini_nomem;
-- 



_______________________________________________
Xen-devel mailing list
Xen-devel@lists.xensource.com
http://lists.xensource.com/xen-devel


--------------080303030204060007030803--
