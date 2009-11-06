Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbZKFPOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbZKFPOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758638AbZKFPOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:14:22 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:54420 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbZKFPOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:14:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x1Dm4guO+Mzec9SIUGCzGVyD1li6Ohi2WSC3iB8Blyg0Zti0jVfgysm4qHgDSiT85y
         IH1zHfEIpSSLW5oYb7Euk+EPwRQBILvh/lrdCpU0lnxYMFJdXelXnjRnzt8f7DXY4Bmj
         U/mBzKJqfFwt8YYKvHz6F7Rgkz7JgHsytLbVk=
MIME-Version: 1.0
In-Reply-To: <20091106133833.GA23151@gamma.logic.tuwien.ac.at>
References: <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
	 <20091102155543.E60E.A69D9226@jp.fujitsu.com>
	 <20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091102141917.GJ2116@gamma.logic.tuwien.ac.at>
	 <28c262360911020640k3f9dfcdct2cac6cc1d193144d@mail.gmail.com>
	 <20091105132109.GA12676@gamma.logic.tuwien.ac.at>
	 <loom.20091105T213323-393@post.gmane.org>
	 <28c262360911051418r1aefbff6oa54a63d887c0ea48@mail.gmail.com>
	 <20091106000113.GE22289@gamma.logic.tuwien.ac.at>
	 <20091106133833.GA23151@gamma.logic.tuwien.ac.at>
Date: Sat, 7 Nov 2009 00:14:26 +0900
Message-ID: <28c262360911060714h16cf55dfibbecc090c76341ab@mail.gmail.com>
Subject: Re: OOM killer, page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: Jody Belka <jody+lkml@jj79.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 10:38 PM, Norbert Preining <preining@logic.at> wrote:
> Hi Kim,
>
> On Fr, 06 Nov 2009, preining wrote:
>> Recompiling already and trying to recreate the oom-killer boom.
>
> Well, after rebooting into that kernel I get *loads*, every few seconds,
> of warnings in the log. Hard to sort out what is real. Is that expected?

I guess it is VM_FAULT_NOPAGE of i915_gem or somethings.
It's not of our concern but VM_FAULT_OOM.
I couldn't expect that. So let's change debug patch following as.

Most important thing is "Who return VM_FAULT_OOM".
It it return VM_FAULT_OOM, OOM killer will kill any process who have a
high score. In case of you, it was 'X'.

If you don't see it until 2.6.32-rc5, It should be regression in somewhere.
If we can know it, we can pass the problem to maintainer of it.

Could you try it again below patch?
If you reproduce it, you can match function address of log with
function address
of your System.map. Pz, let me know it. :)

diff --git a/mm/memory.c b/mm/memory.c
index 7e91b5f..97a6fcb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2713,8 +2713,13 @@ static int __do_fault(struct mm_struct *mm,
struct vm_area_struct *vma,
    vmf.page = NULL;

    ret = vma->vm_ops->fault(vma, &vmf);
-   if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+   if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
+       if (ret & VM_FAULT_OOM) {
+           printk(KERN_DEBUG "fault handler : 0x%lx\n", vma->vm_ops->fault);
+
+       }
        return ret;
+   }

    if (unlikely(PageHWPoison(vmf.page))) {
        if (ret & VM_FAULT_LOCKED)



>
> Excerpt from the log:
> [ 2077.753841] vma->vm_ops->fault : 0xffffffff811df4bd
> [ 2077.753842] ------------[ cut here ]------------
> [ 2077.753845] WARNING: at mm/memory.c:2722 __do_fault+0x89/0x382()
> [ 2077.753847] Hardware name: VGN-Z11VN_B
> ...
> [ 2077.753880] Pid: 4892, comm: Xorg Tainted: G        W  2.6.32-rc6 #5
> [ 2077.753881] Call Trace:
> [ 2077.753884]  [<ffffffff8108c6cc>] ? __do_fault+0x89/0x382
> [ 2077.753887]  [<ffffffff8108c6cc>] ? __do_fault+0x89/0x382
> [ 2077.753889]  [<ffffffff8103ae54>] ? warn_slowpath_common+0x77/0xa3
> [ 2077.753892]  [<ffffffff8108c6cc>] ? __do_fault+0x89/0x382
> [ 2077.753895]  [<ffffffff81341a82>] ? _spin_unlock+0x23/0x2f
> [ 2077.753898]  [<ffffffff8108e5d0>] ? handle_mm_fault+0x2b9/0x608
> [ 2077.753900]  [<ffffffff810af792>] ? do_vfs_ioctl+0x443/0x47b
> [ 2077.753903]  [<ffffffff81026759>] ? do_page_fault+0x25f/0x27b
> [ 2077.753906]  [<ffffffff81341e8f>] ? page_fault+0x1f/0x30
> [ 2077.753908] ---[ end trace d3324ef5061f0136 ]---
>
> hundreds/thousands of them.
>
> And even without starting anything else. Is that what you want?
> My syslog file has grown to some hundred megabytes ...
>
>
> Best wishes
>
> Norbert
>
> -------------------------------------------------------------------------------
> Dr. Norbert Preining                                        Associate Professor
> JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
> Vienna University of Technology                               preining@logic.at
> Debian Developer (Debian TeX Task Force)                    preining@debian.org
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> LARGOWARD (n.)
> Motorists' name for the kind of pedestrian who stands beside a main
> road and waves on the traffic, as if it's their right of way.
>                        --- Douglas Adams, The Meaning of Liff
>



-- 
Kind regards,
Minchan Kim
