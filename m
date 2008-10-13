Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbYJMQ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbYJMQ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYJMQ6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:58:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:8444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbYJMQ6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:58:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,404,1220252400"; 
   d="scan'208";a="390968087"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: bibo mao <bibo.mao@gmail.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Date: Mon, 13 Oct 2008 09:49:57 -0700
Subject: RE: [patch 1/1]pat: fix type check error on chk_conflict function
Thread-Topic: [patch 1/1]pat: fix type check error on chk_conflict function
Thread-Index: Acksce6EWBteRj00ReO3DkRjHYgEqAA4V4lA
Message-ID: <7E82351C108FA840AB1866AC776AEC463789D134@orsmsx505.amr.corp.intel.com>
References: <fbd277f20810120652o607cddcbse398c9b40f0892aa@mail.gmail.com>
In-Reply-To: <fbd277f20810120652o607cddcbse398c9b40f0892aa@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No. This patch is not right. Inlined some comments below.

Thanks,
Venki

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of bibo mao
>Sent: Sunday, October 12, 2008 6:52 AM
>To: akpm@linux-foundation.org
>Cc: linux-kernel@vger.kernel.org
>Subject: [patch 1/1]pat: fix type check error on chk_conflict function
>
> On chk_conflict() function, if new->type does not match entry->type
>  and type is not NULL, this does not go through conflict path. This
>  patch fix this bug.

No. If the type is not NULL, then new->type != entry->type is not a conflict.
In this case, the caller is looking to map some region with some type and
willing to take a type as output of reserve_memtype in "type" parameter.

So, reserve should succeed with proper type returned to the caller.

But, if type parameter is NULL, then the caller of reserve cannot really
take an output and strictly wants req_type mapping. In that case, if we have
new->type != entry->type we have to return an error. That is what the current
code is doing.

The second list_for_each_entry loop below checks for conflicting requirements
which cannot be satisfied and that will be an error in both type being NULL
and not NULL cases.

>
> Signed-off-by:  bibo.mao@gmail.com
>
>----------------------------------------------------------------------
>diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>index 12cac5e..0632308 100644
>--- a/arch/x86/mm/pat.c
>+++ b/arch/x86/mm/pat.c
>@@ -183,28 +183,29 @@ static unsigned long pat_x_mtrr_type(u64 start,
>u64 end, unsigned long req_type)
> static int chk_conflict(struct memtype *new, struct memtype *entry,
>                        unsigned long *type)
> {
>-       if (new->type != entry->type) {
>-               if (type) {
>-                       new->type = entry->type;
>-                       *type = entry->type;
>-               } else
>-                       goto conflict;
>-       }
>+       int err = -EBUSY;
>+
>+       if (new->type != entry->type)
>+               goto conflict;
>
>         /* check overlaps with more than one entry in the list */
>        list_for_each_entry_continue(entry, &memtype_list, nd) {
>                if (new->end <= entry->start)
>                        break;
>-               else if (new->type != entry->type)
>+               else if (new->type != entry->type) {
>+                       err = -EINVAL;
>                        goto conflict;
>+               }
>        }
>        return 0;
>
>  conflict:
>+       if (type)
>+               *type = entry->type;
>        printk(KERN_INFO "%s:%d conflicting memory types "
>               "%Lx-%Lx %s<->%s\n", current->comm,
>current->pid, new->start,
>               new->end, cattr_name(new->type),
>cattr_name(entry->type));
>-       return -EBUSY;
>+       return err;
> }
>
> static struct memtype *cached_entry;
>@@ -278,9 +279,6 @@ int reserve_memtype(u64 start, u64 end, unsigned
>long req_type,
>        new->end = end;
>        new->type = actual_type;
>
>-       if (new_type)
>-               *new_type = actual_type;
>-
>        spin_lock(&memtype_lock);
>
>        if (cached_entry && start >= cached_start)
>@@ -326,6 +324,9 @@ int reserve_memtype(u64 start, u64 end, unsigned
>long req_type,
>
>        spin_unlock(&memtype_lock);
>
>+       if (new_type)
>+               *new_type = actual_type;
>+
>        dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s,
>req %s, ret %s\n",
>                start, end, cattr_name(new->type),
>cattr_name(req_type),
>                new_type ? cattr_name(*new_type) : "-");
>@@ -474,15 +475,22 @@ void map_devmem(unsigned long pfn, unsigned long
>size, pgprot_t vma_prot)
>        u64 addr = (u64)pfn << PAGE_SHIFT;
>        unsigned long flags;
>        unsigned long want_flags = (pgprot_val(vma_prot) &
>_PAGE_CACHE_MASK);
>+       int err;
>
>-       reserve_memtype(addr, addr + size, want_flags, &flags);
>-       if (flags != want_flags) {
>+       err = reserve_memtype(addr, addr + size, want_flags, &flags);
>+       if (err == -EBUSY) {
>                printk(KERN_INFO
>                "%s:%d /dev/mem expected mapping type %s for
>%Lx-%Lx, got %s\n",
>                        current->comm, current->pid,
>                        cattr_name(want_flags),
>                        addr, (unsigned long long)(addr + size),
>                        cattr_name(flags));
>+       } else if (err == -EINVAL) {
>+               printk(KERN_INFO
>+               "%s:%d /dev/mem has both mapping type %s and
>%s for %Lx-%Lx \n",
>+                       current->comm, current->pid,
>+                       cattr_name(want_flags), cattr_name(flags),
>+                       addr, (unsigned long long)(addr + size));
>        }
> }
>--
>To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
