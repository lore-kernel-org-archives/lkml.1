Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZKBGhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZKBGhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 01:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZKBGhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 01:37:36 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50898 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZKBGhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 01:37:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=CFmKT3A5L6QgEX5AtmfNrMHS6E4zSU2jd3nuMil3w2byY+yKl+dYsDpLO67EOtpwv0
         V3fjaIeNtTAxdfLUp+ZMGdzK4NiKoevuMEJVx48ywNp5MTOSNlsKrerZewtjz7tqdpEn
         5RL9cK2zUp71LHNSdTCoBsp7IqXfiobAaQcEU=
Date: Mon, 2 Nov 2009 15:35:00 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: OOM killer, page fault
Message-Id: <20091102153500.78d4f862.minchan.kim@barrios-desktop>
In-Reply-To: <20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091030063216.GA30712@gamma.logic.tuwien.ac.at>
	<20091102005218.8352.A69D9226@jp.fujitsu.com>
	<20091102135640.93de7c2a.minchan.kim@barrios-desktop>
	<20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 14:02:16 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 2 Nov 2009 13:56:40 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > On Mon,  2 Nov 2009 13:24:06 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Hi,
> > > 
> > > (Cc to linux-mm)
> > > 
> > > Wow, this is very strange log.
> > > 
> > > > Dear all,
> > > > 
> > > > (please Cc)
> > > > 
> > > > With 2.6.32-rc5 I got that one:
> > > > [13832.210068] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0
> > > 
> > > order = 0
> > 
> > I think this problem results from 'gfp_mask = 0x0'.
> > Is it possible?
> > 
> > If it isn't H/W problem, Who passes gfp_mask with 0x0?
> > It's culpit. 
> > 
> > Could you add BUG_ON(gfp_mask == 0x0) in __alloc_pages_nodemask's head?
> > 
> 
> Maybe some code returns VM_FAULT_OOM by mistake and pagefault_oom_killer()
> is called. digging mm/memory.c is necessary...

I suspect GPU drivers related to X.
It seems many of them returs VM_FAULT_OOM.

If it happens by file map fault, following debug patch can show the culpit.

Norbert, Could you apply this patch and test again?
If you can get the address, you can find function symbol with System.map.


diff --git a/mm/memory.c b/mm/memory.c
index 7e91b5f..47e4b15 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2713,7 +2713,11 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
        vmf.page = NULL;
 
        ret = vma->vm_ops->fault(vma, &vmf);
-       if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+       if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
+               printk(KERN_DEBUG "vma->vm_ops->fault : 0x%lx\n", vma->vm_ops->fault);
+               WARN_ON(1);
+               
+       }
                return ret;
 
        if (unlikely(PageHWPoison(vmf.page))) {





-- 
Kind regards,
Minchan Kim
