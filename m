Return-Path: <linux-kernel-owner+w=401wt.eu-S932763AbZAPLmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbZAPLmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758709AbZAPLmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:42:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:23000 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974AbZAPLm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:42:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WMwqAhvCdoQJxwd/DhNZh6m20fDQZSg4x+WRCyBm7CrheKLi8L2lPPjelylOZZ0oDA
         kcuhWyW67MyaPGVR0DeBONWeF9fjxd4KooHybIsmlijm/Y7mXhNkDrywsd05DY/S4m6E
         3RBEr5duq+GatF4lxgrA423fjh7X0a6g1BnB4=
MIME-Version: 1.0
In-Reply-To: <5d5443650901150532r20a4c25q834afadde2f98a3@mail.gmail.com>
References: <20090114010223.GA21380@kroah.com>
	 <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
	 <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz>
	 <20090114104834.18387fca@lxorguk.ukuu.org.uk>
	 <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com>
	 <20090114231739.GB24111@kroah.com>
	 <d6200be20901141532y6f236104kd521041d640c152e@mail.gmail.com>
	 <20090115001224.GC11328@kroah.com>
	 <5d5443650901150532r20a4c25q834afadde2f98a3@mail.gmail.com>
Date: Fri, 16 Jan 2009 20:42:27 +0900
Message-ID: <2f11576a0901160342x291267cn11b33d65ec9239b4@mail.gmail.com>
Subject: Re: lowmemory android driver not needed?
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Greg KH <greg@kroah.com>,
       =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       =?ISO-8859-1?Q?ext_Juha_Yrj=F6l=E4?= <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And there is one more lowmem driver developed by Nokia for Nokia 8xx
> tablets it seems. CCed Tony Lindgren,  Juha and Viktor.
>
> http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=blob;f=security/lowmem.c;h=ae78a530af39703e335ad769f1e6f097f63ec6dd;hb=HEAD


quick review.

> 325 static struct security_operations lowmem_security_ops = {
> 326         /* Use the capability functions for some of the hooks */
> 327         .ptrace_may_access = cap_ptrace_may_access,
> 328         .ptrace_traceme = cap_ptrace_traceme,
> 329         .capget = cap_capget,
> 330         .capset_check = cap_capset_check,
> 331         .capset_set = cap_capset_set,
> 332         .capable = cap_capable,
> 333
> 334         .bprm_apply_creds = cap_bprm_apply_creds,
> 335         .bprm_set_security = cap_bprm_set_security,
> 336
> 337         .task_post_setuid = cap_task_post_setuid,
> 338         .task_reparent_to_init = cap_task_reparent_to_init,
> 339         .vm_enough_memory = low_vm_enough_memory,
> 340 };


.vm_enough_memory is the hook of virtual memory accounting, not rss.
modern almost linux application and glibc largely use virtual address space
than actual resident memory.

then, vm_enough_memory don't provide proper hook.


>  57 static ctl_table lowmem_table[] = {
> 58         {
> 59                 .ctl_name = VM_LOWMEM_DENY_PAGES,
> 60                 .procname = "lowmem_deny_watermark_pages",
> 61                 .data = &deny_pages,
> 62                 .maxlen = sizeof(long),
> 63                 .mode = 0644,
> 64                 .child = NULL,
> 65                 .proc_handler = &proc_dointvec,
> 66                 .strategy = &sysctl_intvec,
> 67         }, {

you can set .ctl_name to CTL_UNNUMBERED.


> 249 static int low_vm_enough_memory(struct mm_struct *mm, long pages)
> 250 {
> 251         unsigned long free, allowed;
> 252         int cap_sys_admin = 0, notify;
> 253
> 254         if (cap_capable(current, CAP_SYS_ADMIN) == 0)
> 255                 cap_sys_admin = 1;
> 256
> 257         allowed = totalram_pages - hugetlb_total_pages();
> 258         allowed_pages = allowed;
> 259
> 260         /* We activate ourselves only after both parameters have been
> 261          * configured. */
> 262         if (deny_pages == 0 || notify_low_pages == 0 || notify_high_pages == 0)
> 263                 return  __vm_enough_memory(mm, pages, cap_sys_admin);
> 264
> 265         vm_acct_memory(pages);
> 266
> 267         /* Easily freed pages when under VM pressure or direct reclaim */
> 268         free = global_page_state(NR_FILE_PAGES);

this line assume file page can evictable. but it is not true.
we should consider mlocked file page.


> 269         free += nr_swap_pages;
> 270         free += global_page_state(NR_SLAB_RECLAIMABLE);
> 271
> 272         if (likely(free > notify_low_pages))
> 273                 goto enough_memory;
> 274
> 275         /* No luck, lets make it more expensive and try again.. */
> 276         free += nr_free_pages();
> 277
> 278         if (free < deny_pages) {
> 279                 int i;
> 280
> 281                 lowmem_free_pages = free;
> 282                 low_watermark_state(1);
> 283                 high_watermark_state(1);
> 284                 /* Memory allocations by root are always allowed */
> 285                 if (cap_sys_admin)
> 286                         return 0;
> 287
> 288                 /* OOM unkillable process is allowed to consume memory */
> 289                 if (current->oomkilladj == OOM_DISABLE)
> 290                         return 0;

No generic assumption.

> 292                 /* uids from allowed_uids vector are also allowed no matter what */
> 293                 for (i = 0; i < LOWMEM_MAX_UIDS && allowed_uids[i]; i++)
> 294                         if (current->uid == allowed_uids[i])
> 295                                 return 0;

Oops, LOWMEM_MAX_UIDS is ugly restriction.


> 297                 vm_unacct_memory(pages);
> 298                 if (printk_ratelimit()) {
> 299                         printk(MY_NAME ": denying memory allocation to process %d (%s> )\n",
> 300                                current->pid, current->comm);
> 301                 }
> 302                 return -ENOMEM;
> 303         }
> 304
> 305 enough_memory:
> 306         /* See if we need to notify level 1 */
> 307         low_watermark_state(free < notify_low_pages);
> 308
> 309         /*
> 310          * In the level 2 notification case things are more complicated,
> 311          * as the level that we drop the state and send a notification
> 312          * should be lower than when it is first triggered. Having this
> 313          * on the same watermark level ends up bouncing back and forth
> 314          * when applications are being stupid.
> 315          */
> 316         notify = free < notify_high_pages;
> 317         if (notify || free - nr_decay_pages > notify_high_pages)
> 318                 high_watermark_state(notify);
> 319
> 320         /* We have plenty of memory */
> 321         lowmem_free_pages = free;

It seems racy.
if this code run on smp, lowmem_free_pages can hold unproper value.


> 322         return 0;
> 323 }


then, In my first look, this code deeply depend on embedded and nokia
process management policy.
I don't think it can merge mainline.
