Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYFRQVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYFRQVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYFRQUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:20:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:11180 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYFRQUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CTYbugWzZboOfTHa40nYgmF9gcZF9T3kSkNxUgayts0KP82vofjMeuVUUIFjeSBcLr
         fvBGYusODsBQlN6o7gncasw+QvwGIpTVtBEw6oqHVxMuPBHAKsn4lFkXPRXnZRssmMDu
         /S3MgG9FTn+Vsz4RcHN4OubJ0axvJusAhvau8=
Message-ID: <86802c440806180920r4caf9392j4da6c104930d5bc6@mail.gmail.com>
Date: Wed, 18 Jun 2008 09:20:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: RFC [PATCH] x86: try to remove arch_get_ram_range
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "Jan Engelhardt" <jengelh@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080618084850.40adb1a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806162010.55495.yhlu.kernel@gmail.com>
	 <20080618140726.GF11501@elte.hu>
	 <20080618084850.40adb1a8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 8:48 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 18 Jun 2008 16:07:26 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> > want to remove arch_get_ram_range, and use early_node_map instead.
>>
>> (small request: please include diffstat output in your patches in the
>> future if possible: "quilt refresh --diffstat" will do that - this way
>> people will know why they were Cc:-ed)
>>
>> this touches the MM:
>>
>>  arch/x86/mm/init_32.c     |    6 +++--
>>  drivers/pci/intel-iommu.c |   51 +++++++++++++++++++++++++++++++++-------------
>>  include/linux/mm.h        |    2 -
>>  mm/page_alloc.c           |   10 ++++++---
>>  4 files changed, 49 insertions(+), 20 deletions(-)
>>
>> but has many dependencies on ongoing arch/x86 work. Andrew, is this
>> change fine with with you?
>>
>
> Beats me - I don't even have a mm/page_alloc.c:work_with_active_regions()
> in my tree.
>

i cut and paste from tip...

commit a6b01b5fe51a99ecc0844a9e646819941227fd25
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Mon Jun 16 20:10:55 2008 -0700

    RFC x86: try to remove arch_get_ram_range

    want to remove arch_get_ram_range, and use early_node_map instead.

    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 67f8f6a..017ac56 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2933,10 +2933,14 @@ void __init free_bootmem_with_active_regions(int nid,
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
 {
        int i;
+       int ret;

-       for_each_active_range_index_in_nid(i, nid)
-               work_fn(early_node_map[i].start_pfn, early_node_map[i].end_pfn,
-                       data);
+       for_each_active_range_index_in_nid(i, nid) {
+               ret = work_fn(early_node_map[i].start_pfn,
+                             early_node_map[i].end_pfn, data);
+               if (ret)
+                       break;
+       }
 }
 /**
  * sparse_memory_present_with_active_regions - Call memory_present
for each active range

commit e827df2898d988698e5b829009255579638a0110
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sat Jun 14 18:32:52 2008 -0700

    x86, mm: use add_highpages_with_active_regions() for high pages init v2

    use early_node_map to init high pages, so we can remove page_is_ram() and
    page_is_reserved_early() in the big loop with add_one_highpage

    also remove page_is_reserved_early(), it is not needed anymore.

    v2: fix the build of other platforms

    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 26a028c..8548eea 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2955,6 +2955,14 @@ void __init free_bootmem_with_active_regions(int nid,
        }
 }

+void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
+{
+       int i;
+
+       for_each_active_range_index_in_nid(i, nid)
+               work_fn(early_node_map[i].start_pfn, early_node_map[i].end_pfn,
+                       data);
+}
 /**
  * sparse_memory_present_with_active_regions - Call memory_present
for each active range
  * @nid: The node to call memory_present for. If MAX_NUMNODES, all
nodes will be used.
