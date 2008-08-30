Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYH3DHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYH3DHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 23:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYH3DHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 23:07:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:40562 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbYH3DHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 23:07:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F8xAW/RvMgDBN8CaJS7cufPeiTG7Z3w/rKZ87iFHGVsRw1UjTljDHyGFpZOYUcBpTI
         6YUzn1hXffnLdt3ssyj1V+V4uJWaBakgWhSJVAZKh7DnlbPchOpNvd72nVFm0STJC7//
         ErGjU0oYQyuB5vUoHT5Ur+taO05ZTaKOFVbFU=
Message-ID: <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>
Date: Fri, 29 Aug 2008 20:07:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808300031.16708.rjw@sisk.pl>
	 <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
	 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
	 <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 7:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Linus Torvalds wrote:
>>
>> Yes. And I do think this is a workable model.
>
> Ok, and here's the patch to do
>
>        insert_resource_expand_to_fit(root, new);
>
> and while I still haven't actually tested it, it looks sane and compiles
> to code that also looks sane.
>
> I'll happily commit this as basic infrastructure as soon as somebody ack's
> it and tests that it works (and I'll try it myself soon enough, just for
> fun)

we need to use insert_resource_split_to_fit instead...

otherwise __request_region will not be happy.

have one shrink one

only work with
  |----------------|
          |---------------------|

still has problem with

  |----------------| |------------|     |-----------|
          |------------------------------------|

need to get rid of middle one too.

YH


---
 arch/x86/kernel/e820.c |   20 +++++++++++++-
 include/linux/ioport.h |    2 +
 kernel/resource.c      |   66 ++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 74 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1319,8 +1319,24 @@ void __init e820_reserve_resources_late(

        res = e820_res;
        for (i = 0; i < e820.nr_map; i++) {
-               if (!res->parent && res->end)
-                       insert_resource(&iomem_resource, res);
+#if 1
+               /* test for shrink_with fit */
+               if (!res->parent && res->end) {
+                       if (res->start == 0xe0000000)
+                               res->start = 0xde000000;
+               }
+#endif
+
+               if (!res->parent && res->end &&
insert_resource(&iomem_resource, res)) {
+
+                       printk(KERN_WARNING "found conflict for %s
[%08llx, %08llx], try to insert with shrink\n",
+                               res->name, res->start, res->end);
+
+                       insert_resource_shrink_to_fit(&iomem_resource, res);
+
+                       printk(KERN_WARNING "   shrink to %s [%08llx,
%08llx]\n",
+                               res->name, res->start, res->end);
+               }
                res++;
        }
 }
Index: linux-2.6/include/linux/ioport.h
===================================================================
--- linux-2.6.orig/include/linux/ioport.h
+++ linux-2.6/include/linux/ioport.h
@@ -108,6 +108,8 @@ extern struct resource iomem_resource;

 extern int request_resource(struct resource *root, struct resource *new);
 extern int release_resource(struct resource *new);
+extern void insert_resource_shrink_to_fit(struct resource *root,
+                                         struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern int allocate_resource(struct resource *root, struct resource *new,
                             resource_size_t size, resource_size_t min,
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -363,32 +363,30 @@ int allocate_resource(struct resource *r
 EXPORT_SYMBOL(allocate_resource);

 /**
- * insert_resource - Inserts a resource in the resource tree
+ * __insert_resource - Inserts a resource in the resource tree
  * @parent: parent of the new resource
  * @new: new resource to insert
  *
- * Returns 0 on success, -EBUSY if the resource can't be inserted.
+ * Returns NULL on success, or first conflict resource.
  *
- * This function is equivalent to request_resource when no conflict
+ * This function is equivalent to __request_resource when no conflict
  * happens. If a conflict happens, and the conflicting resources
  * entirely fit within the range of the new resource, then the new
  * resource is inserted and the conflicting resources become children of
  * the new resource.
  */
-int insert_resource(struct resource *parent, struct resource *new)
+static struct resource *__insert_resource(struct resource *parent,
struct resource *new)
 {
-       int result;
+       struct resource *ret_res;
        struct resource *first, *next;

-       write_lock(&resource_lock);
-
        for (;; parent = first) {
-               result = 0;
+               ret_res = NULL;
                first = __request_resource(parent, new);
                if (!first)
                        goto out;

-               result = -EBUSY;
+               ret_res = first;
                if (first == parent)
                        goto out;

@@ -400,15 +398,17 @@ int insert_resource(struct resource *par

        for (next = first; ; next = next->sibling) {
                /* Partial overlap? Bad, and unfixable */
-               if (next->start < new->start || next->end > new->end)
+               if (next->start < new->start || next->end > new->end) {
+                       ret_res = next;
                        goto out;
+               }
                if (!next->sibling)
                        break;
                if (next->sibling->start > new->end)
                        break;
        }

-       result = 0;
+       ret_res = NULL;

        new->parent = parent;
        new->sibling = next->sibling;
@@ -428,11 +428,53 @@ int insert_resource(struct resource *par
        }

  out:
+       return ret_res;
+}
+
+/**
+ * insert_resource_shrink_to_fit - Inserts a resource in the resource tree
+ * @parent: parent of the new resource
+ * @new: new resource to insert
+ */
+void insert_resource_shrink_to_fit(struct resource *root, struct resource *new)
+{
+       write_lock(&resource_lock);
+       while (new->start && !new->parent) {
+               struct resource *conflict;
+
+               conflict = __insert_resource(root, new);
+               if (!conflict)
+                       break;
+               if (conflict->start < new->start) {
+                       new->start = conflict->end;
+                       continue;
+               }
+               if (conflict->end > new->end) {
+                       new->end = conflict->start;
+                       continue;
+               }
+       }
        write_unlock(&resource_lock);
-       return result;
 }

 /**
+ * insert_resource - Inserts a resource in the resource tree
+ * @parent: parent of the new resource
+ * @new: new resource to insert
+ *
+ * Returns 0 on success, -EBUSY if the resource can't be inserted.
+ */
+int insert_resource(struct resource *parent, struct resource *new)
+{
+       struct resource *res_conflict;
+
+       write_lock(&resource_lock);
+       res_conflict = __insert_resource(parent, new);
+       write_unlock(&resource_lock);
+
+       return res_conflict ? -EBUSY : 0;
+}
+/**
  * adjust_resource - modify a resource's start and size
  * @res: resource to modify
  * @start: new start value
