Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbXISO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbXISO7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbXISO7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:59:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:22817 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbXISO7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Ht4LMm1xiYqAodgaLh3ZaVYnPg2kUIRb6Q2H3Xsel9ZhNb5JkwGep5qjGjBRtICkWszfxMWtatvSBqjvCSmqsB8iXQ9GnsqsZOg3ZUc+IdP3yZtl7akfXb+Rb6QJ1SvnhyT5lmeitZXgOkKAU7E9yAu4o6X1GbmQ4YKH9kBTogk=
Message-ID: <46F13938.1070709@gmail.com>
Date: Wed, 19 Sep 2007 16:59:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com>
In-Reply-To: <46F10DCB.1090302@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 01:53 PM, Jiri Slaby wrote:
> On 09/19/2007 01:43 PM, Jiri Slaby wrote:
>> On 09/18/2007 10:18 AM, Andrew Morton wrote:
>>> - The Vaio hangs when quitting X due to x86_64-mm-cpa-clflush.patch, but
>>>   I didn't drop that patch because the iommu patch series depends on it.
>> No matter whether slub/slab is selected someone gets a page and moves/adds its
> 
> Oh, only adds, if it moves, it won't break the list. Going to check for
> POISON1/2 in __list_add, will get results (if any) in few moments...

Huh, it took longer than I expect :). Changed this:
diff --git a/arch/x86_64/mm/pageattr.c b/arch/x86_64/mm/pageattr.c
index 836c218..cd8499c 100644
--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -112,7 +112,14 @@ static inline void save_page(struct page *fpage, int data)
                        return;
                SetPageFlush(fpage);
        }
+       printk("ADD (%s): E=%p, H=%p, H->N=%p, N->P=%p, N->N=%p; PREV0=%p, "
+                       "NEXT0=%p, ",
+                       current->comm, &fpage->lru,
+                       &deferred_pages, deferred_pages.next,
+                       deferred_pages.next->prev, deferred_pages.next->next,
+                       fpage->lru.prev, fpage->lru.next);
        list_add(&fpage->lru, &deferred_pages);
+       printk("PREV1=%p, NEXT1=%p\n", fpage->lru.prev, fpage->lru.next);
 }

 /*
@@ -274,6 +281,7 @@ void global_flush_tlb(void)
        down_read(&init_mm.mmap_sem);
        arg.full_flush = full_flush;
        full_flush = 0;
+       printk("FLUSH\n");
        list_replace_init(&deferred_pages, &arg.l);
        up_read(&init_mm.mmap_sem);

diff --git a/include/linux/list.h b/include/linux/list.h
index f29fc9c..1add963 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -265,6 +265,8 @@ static inline void list_del_init(struct list_head *entry)
 static inline void list_move(struct list_head *list, struct list_head *head)
 {
        __list_del(list->prev, list->next);
+       list->next = LIST_POISON1;
+       list->prev = LIST_POISON2;
        list_add(list, head);
 }

@@ -277,6 +279,8 @@ static inline void list_move_tail(struct list_head *list,
                                  struct list_head *head)
 {
        __list_del(list->prev, list->next);
+       list->next = LIST_POISON1;
+       list->prev = LIST_POISON2;
        list_add_tail(list, head);
 }

diff --git a/lib/list_debug.c b/lib/list_debug.c
index 4350ba9..57573d5 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -15,15 +15,34 @@
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-
+#include <linux/sched.h>
 void __list_add(struct list_head *new,
                              struct list_head *prev,
                              struct list_head *next)
 {
+       static unsigned int a, b;
+       unsigned long off;
+
+       if (unlikely(!a && current && current->comm[0] == 'X'))
+               a++;
+
+       if (unlikely(a && !b && (void *)new >= (void *)mem_map &&
+               (void *)new < (void *)(mem_map + 1048576) &&
+               (new->prev != LIST_POISON2 || new->next != LIST_POISON1) &&
+               (new->prev != NULL || new->next != NULL) &&
+               (new->prev != new || new->next != new))) {
+               off = ((void *)new - (void *)mem_map) % sizeof(struct page);
+               if (off == offsetof(struct page, lru)) {
+                       printk(KERN_DEBUG "POISONS (%p): "
+                                       "%p, %p\n", new, new->prev, new->next);
+                       dump_stack();
+               }
+       }
        if (unlikely(next->prev != prev)) {
                printk(KERN_ERR "list_add corruption. next->prev should be "
                        "prev (%p), but was %p. (next=%p).\n",
                        prev, next->prev, next);
+               b++;
                BUG();
        }
        if (unlikely(prev->next != next)) {

---------8<---------8<---------8<---------8<---------8<---------8<----
and got this:
ADD (X): E=ffff81000115b9e0, H=ffffffff80673aa0, H->N=ffff8100011573e0,
N->P=ffffffff80673aa0, N->N=ffff81000115ba18; PREV0=0000000000200200,
NEXT0=0000000000100100, PREV1=ffffffff80673aa0, NEXT1=ffff8100011573e0
/----------------------------------------------------------\
this (^^^^) was output from unmap path, see (1) below
and here (vvvv) follows output from free_page path, see (2)
\----------------------------------------------------------/
POISONS (ffff81000115b9e0): ffffffff80673aa0, ffff8100011573e0

Call Trace:
 [<ffffffff80328c06>] __list_add+0xf6/0x190
 [<ffffffff80328cac>] list_add+0xc/0x10
 [<ffffffff8026e46d>] free_hot_cold_page+0xfd/0x170
 [<ffffffff8026e52b>] free_hot_page+0xb/0x10
 [<ffffffff8026e555>] __free_pages+0x25/0x30
 [<ffffffff8026e58b>] free_pages+0x2b/0x40
 [<ffffffff8037cf16>] agp_generic_destroy_page+0x56/0x70
 [<ffffffff8037d9d5>] agp_free_memory+0x65/0xd0
 [<ffffffff8037c0e9>] agp_free_memory_wrap+0x39/0x60
 [<ffffffff8037c79b>] agp_release+0xdb/0x1c0
 [<ffffffff80291440>] __fput+0xc0/0x1b0
 [<ffffffff802915b6>] fput+0x16/0x20
 [<ffffffff8028e516>] filp_close+0x56/0x90
 [<ffffffff8023a552>] put_files_struct+0xc2/0xd0
 [<ffffffff8023ba55>] do_exit+0x1e5/0x990
 [<ffffffff8023c237>] do_group_exit+0x37/0x90
 [<ffffffff8023c2a2>] sys_exit_group+0x12/0x20
 [<ffffffff8020bd0e>] system_call+0x7e/0x83

ADD (X): E=ffff81000115b9a8, H=ffffffff80673aa0, H->N=ffff81000115b9e0,
N->P=ffffffff8067ef50, N->N=ffff81000115ba18; PREV0=0000000000200200,
NEXT0=0000000000100100, <3>list_add corruption. next->prev should be prev
(ffffffff80673aa0), but was ffffffff8067ef50. (next=ffff81000115b9e0).
------------[ cut here ]------------
kernel BUG at /home/l/latest/xxx/lib/list_debug.c:46!
invalid opcode: 0000 [1] SMP
last sysfs file: /devices/pci0000:00/0000:00:02.0/enable
CPU 1
Modules linked in: ipv6 floppy sr_mod ehci_hcd cdrom rtc_cmos usbhid rtc_core
rtc_lib
Pid: 1603, comm: X Not tainted 2.6.23-rc6-mm1_64 #51
RIP: 0010:[<ffffffff80328c73>]  [<ffffffff80328c73>] __list_add+0x163/0x190
RSP: 0018:ffff810004e31c38  EFLAGS: 00010202
RAX: 0000000000000079 RBX: ffff81000115b9a8 RCX: ffffffff80673f68
RDX: ffffffff80673f68 RSI: 0000000000000086 RDI: ffffffff80673f60
RBP: ffff810004e31c58 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff80673aa0
R13: ffff81000115b9e0 R14: 0000000000006350 R15: ffff810006211a80
FS:  0000000000000000(0000) GS:ffff810003016500(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000514cc0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 1603, threadinfo ffff810004e30000, task ffff810003b26bd0)
last branch before last exception/interrupt
 from  [<ffffffff80238a83>] printk+0xa3/0xb0
 to  [<ffffffff80328c6c>] __list_add+0x15c/0x190
Stack:  ffffffff8067ef50 ffff81000115b9a8 ffff81000115b980 ffff8100011573b8
 ffff810004e31c68 ffffffff80328cac ffff810004e31d08 ffffffff80225b28
 ffff81000115ba18 0000000000200200 0000000000100100 ffffffff8067ee80
Call Trace:
 [<ffffffff80328cac>] list_add+0xc/0x10
 [<ffffffff80225b28>] __change_page_attr+0x478/0x4a0
 [<ffffffff80225bf6>] change_page_attr_addr+0xa6/0x140
 [<ffffffff80225cc3>] change_page_attr+0x33/0x40
 [<ffffffff8037cf04>] agp_generic_destroy_page+0x44/0x70
 [<ffffffff8037d9d5>] agp_free_memory+0x65/0xd0
 [<ffffffff8037c0e9>] agp_free_memory_wrap+0x39/0x60
 [<ffffffff8037c79b>] agp_release+0xdb/0x1c0
 [<ffffffff80291440>] __fput+0xc0/0x1b0
 [<ffffffff802915b6>] fput+0x16/0x20
 [<ffffffff8028e516>] filp_close+0x56/0x90
 [<ffffffff8023a552>] put_files_struct+0xc2/0xd0
 [<ffffffff8023ba55>] do_exit+0x1e5/0x990
 [<ffffffff8023c237>] do_group_exit+0x37/0x90
 [<ffffffff8023c2a2>] sys_exit_group+0x12/0x20
 [<ffffffff8020bd0e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 80 ba e2 02 00 00 58 b8 01 00 00 00 0f 45 05 c6
RIP  [<ffffffff80328c73>] __list_add+0x163/0x190
 RSP <ffff810004e31c38>
Fixing recursive fault but reboot is needed!


---------8<---------8<---------8<---------8<---------8<---------8<----
That means
void agp_generic_destroy_page(void *addr)
{
        struct page *page;

        if (addr == NULL)
                return;

        page = virt_to_page(addr);
(1)     unmap_page_from_agp(page);
        put_page(page);
(2)     free_page((unsigned long)addr);
        atomic_dec(&agp_bridge->current_memory_agp);
}

(1) unmap_page_from_agp -> change_page_attr -> change_page_attr_addr ->
__change_page_attr -> save_page -> list_add(&fpage->lru, &deferred_pages);
(2) free_page -> free_pages -> __free_pages -> free_hot_page ->
free_hot_cold_page -> list_add(&page->lru, &pcp->list);

any ideas how to fix this?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
