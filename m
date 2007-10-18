Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXJRKyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXJRKyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765086AbXJRKxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:53:09 -0400
Received: from sa4.bezeqint.net ([192.115.104.18]:53439 "EHLO sa4.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760482AbXJRKxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:53:06 -0400
Message-ID: <47173B00.3070303@panasas.com>
Date: Thu, 18 Oct 2007 12:52:48 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <alpine.LFD.0.999.0710171022340.26902@woody.linux-foundation.org> <20071017180042.GP15552@kernel.dk> <alpine.LFD.0.999.0710171114320.26902@woody.linux-foundation.org> <20071017182206.GS15552@kernel.dk>
In-Reply-To: <20071017182206.GS15552@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct. 17, 2007, 20:22 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Oct 17 2007, Linus Torvalds wrote:
>>
>> On Wed, 17 Oct 2007, Jens Axboe wrote:
>>>> So avoiding the "sg_next()" on the last entry is pointless. 
>>> Yeah, I didn't quite understand why if sg was valid, why dereferencing
>>> *(sg + 1)->page would crap out :/
>> Actually, I take that back. If 'sg' is the last entry in a *non*linked 
>> scatter-gather list (ie we don't use the last entry as a link, we actually 
>> use it as a real SG entry), then "sg_next(sg)" will indeed access past the 
>> end of the whole allocated array, and will access one past the end.
>>
>> And with page-alloc debugging, that *will* blow up.
>>
>> So I think your change to use "sg_next()" only when you actually need a 
>> next pointer is the correct one after all.
> 
> Thanks, so I'm not totally crazy :-)
> 
> Can you just pull:
> 
>   git://git.kernel.dk/data/git/linux-2.6-block.git for-linus
> 
> then so we get those two pieces correct? Then the remaining issue seems
> to be a new one that is biting Ingo elsewhere, at least we'll all be on
> the same page then.
> 

Jens, for_each_sg still calls sg_next on the last entry which will
dereference a possibly bogus sg->page (for the sg_is_chain(sg)
condition in sg_next) if the last entry is the last one on the page
of unchained entry and sg+1 falls over into an uninitialized page.

How about the following?
(untested yet.
 sg.c included here as an example for usage out of scatterlist.h)

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

