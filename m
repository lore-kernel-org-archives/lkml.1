Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbXKSTep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbXKSTep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbXKSTeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:34:37 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:19949 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbXKSTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:34:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vfcxwm/a9cRMBr32faDCi4xfEljEzrK5YPyAKQUxW1MozjfbAVZqwSZEkQeLxC/jxFE0Yb7Vr2W2wVN7wxgpMSqAXcZauQ7db0VEkFaRGljevCFPVYGf0jmv+rHTpsmE3RNq0acPqMBrYPAuInZKK1jpii5aRgUQCnVeNCar6wI=
Message-ID: <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>
Date: Mon, 19 Nov 2007 20:34:34 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071119075627.GB28432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
	 <20071119075627.GB28432@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 19, 2007 8:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>
> > Trying the last NFSv4 patch (but that patch is only the cause, why I
> > had lockdep enabled) I got this:
> > [   64.550203]
> > [   64.550205] =========================
> > [   64.552213] [ BUG: held lock freed! ]
> > [   64.553633] -------------------------
> > [   64.555055] kcryptd/1022 is freeing memory
> > FFFF81011EBEFB00-FFFF81011EBEFB3F, with a lock still held there!
>
> so kcryptd frees a live, still in use bio? That could be a receipe for
> data corruption. Does SLUB_DEBUG (or SLAB_DEBUG) catch anything?

I have SLUB_DEBUG=y, but not SLUB_DEBUG_ON.
But apart from this message I did not the anything in the syslog.
It seems to not be onetime event, as one the third boot it happend
again. Stacktrace was identical.
Sadly trying 3 boots with slub_debug=FZP and another one with only F
did not trigger it.

But I don't think kcryptd is freeing a bio at that point.
The message said about the freed lock: (kcryptd){--..}, at: [<ffffffff80247dd9>]
(gdb) list *0xffffffff80247dd9
0xffffffff80247dd9 is in run_workqueue (include/asm/bitops_64.h:69).
64       * you should call smp_mb__before_clear_bit() and/or
smp_mb__after_clear_bit()
65       * in order to ensure changes are visible on other processors.
66       */
67      static inline void clear_bit(int nr, volatile void *addr)
68      {
69              __asm__ __volatile__( LOCK_PREFIX
70                      "btrl %1,%0"
71                      :ADDR
72                      :"dIr" (nr));
73      }
increasing the addr a little bit shows:
(gdb) list *0xffffffff80247ddf
0xffffffff80247ddf is in run_workqueue (kernel/workqueue.c:275).
270                     list_del_init(cwq->worklist.next);
271                     spin_unlock_irq(&cwq->lock);
272
273                     BUG_ON(get_wq_data(work) != cwq);
274                     work_clear_pending(work);
275                     lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0,
2, _THIS_IP_);
276                     lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
277                     f(work);
278                     lock_release(&lockdep_map, 1, _THIS_IP_);
279                     lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);


Above this acquire/release sequence is the following comment:
#ifdef CONFIG_LOCKDEP
                /*
                 * It is permissible to free the struct work_struct
                 * from inside the function that is called from it,
                 * this we need to take into account for lockdep too.
                 * To avoid bogus "held lock freed" warnings as well
                 * as problems when looking into work->lockdep_map,
                 * make a copy and use that here.
                 */
                struct lockdep_map lockdep_map = work->lockdep_map;
#endif

Did something trigger this anyway?

Anything I could try, apart from more boots with slub_debug=F?

Torsten
