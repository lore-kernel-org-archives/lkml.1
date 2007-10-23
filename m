Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXJWJaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXJWJaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXJWJa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:30:27 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:32854 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbXJWJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:30:25 -0400
Message-ID: <471DBEF4.4030303@panasas.com>
Date: Tue, 23 Oct 2007 11:29:24 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 09:29:26.0696 (UTC) FILETIME=[347C5280:01C81557]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007 at 23:47 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> On Mon, 22 Oct 2007, Alan Cox wrote:
> 
>> For structures, not array elements or stack objects. Does gcc now get
>> aligned correct as an attribute on a stack object ?
> 
> I think m68k stack layout still guarantees 4-byte-alignment, no?
> 
>> Still doesn't answer the rather more important question - why not just
>> stick a NULL on the end instead of all the nutty hacks ?
> 
> You still do need one bit for the discontiguous case, so it's not like you 
> can avoid the hacks anyway (unless you just blow up the structure 
> entirely) and make it a separate member). So once you have that 
> bit+pointer, using a separate NULL entry isn't exactly prettier. 
> 
> Especially as we actally want to see the difference between 
> "end-of-allocation" and "not yet filled in", so you shouldn't use NULL 
> anyway, you should probably use something like "all-ones".
> 
> 			Linus
> -

Every one is so hysterical about this sg-chaining problem. And massive
patches produced, that when a simple none intrusive solution is proposed
it is totally ignored because every one thinks, "I can not be that stupid".
Well Einstein said: "Simplicity is the ultimate sophistication". So no one
need to feel bad.

I'm talking about Benney's Proposition of a while back.
(I'm including it below, cause I can't bother with the
stupid Archives broken search)

What Benny was proposing is that the scatterlist pointer
might not have the complete information about sizes and 
allocations, but the surrounding code always has, So why
not just pass this information to the decision maker - 
sg_next() - so it can make the right choice, before a suicide.
So sg_next() becomes:

static inline struct scatterlist *sg_next(struct scatterlist *sg,
                                          int next, int nr)
{
       return next < nr ? sg_next_unsafe(sg) : NULL;
}

Where sg_next_unsafe(sg) is what the original sg_next() used to be.

and a user code like for_each_sg() becomes:

/*
 * Loop over each sg element, following the pointer to a new list if necessary
 */
#define for_each_sg(sglist, sg, nr, __i)       \
       for (__i = 0, sg = (sglist); sg; sg = sg_next(sg, ++__i, nr))


In his patch he shows examples of other uses of sg_next they all fit.

The sg_next usage is new and in few places. Not like the sg->page
all over the kernel.

I know he has a patch for the complete kernel, (I know I helped a bit)
and it is a fraction of the size of all the patches that where submitted
after that. And it does not have all the problems that we still have now
with slob allocators, stack, and such.

OK Just my $0.2 
Boaz Harrosh

-----
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2dc7464..3a27e03 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -30,7 +30,7 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
        ((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))

 /**
- * sg_next - return the next scatterlist entry in a list
+ * sg_next_unsafe - return the next scatterlist entry in a list
  * @sg:                The current sg entry
  *
  * Usually the next entry will be @sg@ + 1, but if this sg element is part
@@ -41,7 +41,7 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
  * the current entry, this function will NOT return NULL for an end-of-list.
  *
  */
-static inline struct scatterlist *sg_next(struct scatterlist *sg)
+static inline struct scatterlist *sg_next_unsafe(struct scatterlist *sg)
 {
        sg++;

@@ -51,11 +51,27 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
        return sg;
 }

+/**
+ * sg_next - return the next scatterlist entry in a list
+ * @sg:                The current sg entry
+ * @next:      Index of next sg entry
+ * @nr:                Number of sg entries in the list
+ *
+ * Note that the caller must ensure that there are further entries after
+ * the current entry, this function will NOT return NULL for an end-of-list.
+ *
+ */
+static inline struct scatterlist *sg_next(struct scatterlist *sg,
+                                          int next, int nr)
+{
+       return next < nr ? sg_next_unsafe(sg) : NULL;
+}
+
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
  */
 #define for_each_sg(sglist, sg, nr, __i)       \
-       for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
+       for (__i = 0, sg = (sglist); sg; sg = sg_next(sg, ++__i, nr))

 /**
  * sg_last - return the last scatterlist entry in a list
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7238b2d..57cc1dd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1165,7 +1165,7 @@ sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
        sg = rsv_schp->buffer;
        sa = vma->vm_start;
        for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-            ++k, sg = sg_next(sg)) {
+            sg = sg_next(sg, ++k, rsv_schp->k_use_sg)) {
                len = vma->vm_end - sa;
                len = (len < sg->length) ? len : sg->length;
                if (offset < len) {
@@ -1209,7 +1209,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
        sa = vma->vm_start;
        sg = rsv_schp->buffer;
        for (k = 0; (k < rsv_schp->k_use_sg) && (sa < vma->vm_end);
-            ++k, sg = sg_next(sg)) {
+            sg = sg_next(sg, ++k, rsv_schp->k_use_sg)) {
                len = vma->vm_end - sa;
                len = (len < sg->length) ? len : sg->length;
                sa += len;
@@ -1840,7 +1840,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
        }
        for (k = 0, sg = schp->buffer, rem_sz = blk_size;
             (rem_sz > 0) && (k < mx_sc_elems);
-            ++k, rem_sz -= ret_sz, sg = sg_next(sg)) {
+            rem_sz -= ret_sz, sg = sg_next(sg, ++k, mx_sc_elems)) {

                num = (rem_sz > scatter_elem_sz_prev) ?
                      scatter_elem_sz_prev : rem_sz;
@@ -1913,7 +1913,7 @@ sg_write_xfer(Sg_request * srp)
                if (res)
                        return res;

-               for (; p; sg = sg_next(sg), ksglen = sg->length,
+               for (; p; sg = sg_next_unsafe(sg), ksglen = sg->length,
                     p = page_address(sg->page)) {
                        if (usglen <= 0)
                                break;
@@ -1991,8 +1991,8 @@ sg_remove_scat(Sg_scatter_hold * schp)
                } else {
                        int k;

-                       for (k = 0; (k < schp->k_use_sg) && sg->page;
-                            ++k, sg = sg_next(sg)) {
+                       for (k = 0; sg && sg->page;
+                            sg = sg_next(sg, ++k, schp->k_use_sg)) {
                                SCSI_LOG_TIMEOUT(5, printk(
                                    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
                                    k, sg->page, sg->length));
@@ -2045,7 +2045,7 @@ sg_read_xfer(Sg_request * srp)
                if (res)
                        return res;

-               for (; p; sg = sg_next(sg), ksglen = sg->length,
+               for (; p; sg = sg_next_unsafe(sg), ksglen = sg->length,
                     p = page_address(sg->page)) {
                        if (usglen <= 0)
                                break;
@@ -2092,7 +2092,7 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
        if ((!outp) || (num_read_xfer <= 0))
                return 0;

-       for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, sg = sg_next(sg)) {
+       for (k = 0; sg && sg->page; sg = sg_next(sg, ++k, schp->k_use_sg)) {
                num = sg->length;
                if (num > num_read_xfer) {
                        if (__copy_to_user(outp, page_address(sg->page),
@@ -2142,7 +2142,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
        SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
        rem = size;

-       for (k = 0; k < rsv_schp->k_use_sg; ++k, sg = sg_next(sg)) {
+       for (k = 0; sg; sg = sg_next(sg, ++k, rsv_schp->k_use_sg)) {
                num = sg->length;
                if (rem <= num) {
                        sfp->save_scat_len = num;

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
