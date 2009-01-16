Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbZAPNSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbZAPNSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763146AbZAPNSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:18:17 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:32381 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759451AbZAPNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:18:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H9Ku9qvEAJTNQo4ASIVwgjW30cMF+I35mvhA4GRQO4KBJqKiyF//i2y6RMw9yIgBTO
         Fmmv1Wbet5QEqC+trgirIH/d3yslVqmw0DscB2ci51qSwduJ46Ech0ZSJtEcl6rh6DHH
         bN5+iJ8alPST0ThRwk58W8OW0i1TYFHpKzvIo=
MIME-Version: 1.0
In-Reply-To: <2f11576a0901160342x291267cn11b33d65ec9239b4@mail.gmail.com>
References: <20090114010223.GA21380@kroah.com>
	 <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz>
	 <20090114104834.18387fca@lxorguk.ukuu.org.uk>
	 <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com>
	 <20090114231739.GB24111@kroah.com>
	 <d6200be20901141532y6f236104kd521041d640c152e@mail.gmail.com>
	 <20090115001224.GC11328@kroah.com>
	 <5d5443650901150532r20a4c25q834afadde2f98a3@mail.gmail.com>
	 <2f11576a0901160342x291267cn11b33d65ec9239b4@mail.gmail.com>
Date: Fri, 16 Jan 2009 22:18:13 +0900
X-Google-Sender-Auth: c8045391ed9f4ee0
Message-ID: <2f11576a0901160518g52a3e70endc98fe4792a98b9b@mail.gmail.com>
Subject: Re: lowmemory android driver not needed?
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Brian Swetland <swetland@google.com>,
       arve@google.com, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       =?ISO-8859-1?Q?ext_Juha_Yrj=F6l=E4?= <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also quick review to lowmemorykiller.c

> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/mm.h>
> #include <linux/oom.h>
> #include <linux/sched.h>
>
> static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask);
>
> static struct shrinker lowmem_shrinker = {
>         .shrink = lowmem_shrink,
>         .seeks = DEFAULT_SEEKS * 16
> };

why do you choice *16?


> static uint32_t lowmem_debug_level = 2;
> static int lowmem_adj[6] = {

why do you choice [6]?

>         0,
>         1,
>         6,
>         12,
> };
>
> static int lowmem_adj_size = 4;
> static size_t lowmem_minfree[6] = {
>         3*512, // 6MB
>         2*1024, // 8MB
>         4*1024, // 16MB
>         16*1024, // 64MB
> };
> static int lowmem_minfree_size = 4;
>
> #define lowmem_print(level, x...) do { if(lowmem_debug_level >= (level)) printk(x); } while(0)
>
> module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
> module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size, S_IRUGO | S_IWUSR);
> module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size, S_IRUGO | S_IWUSR);
> module_param_named(debug_level, lowmem_debug_level, uint, S_IRUGO | S_IWUSR);
>
> static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
> {
>         struct task_struct *p;
>         struct task_struct *selected = NULL;
>         int rem = 0;
>         int tasksize;
>         int i;
>         int min_adj = OOM_ADJUST_MAX + 1;
>         int selected_tasksize = 0;
>         int array_size = ARRAY_SIZE(lowmem_adj);
>         int other_free = global_page_state(NR_FREE_PAGES) + global_page_state(NR_FILE_PAGES);

I think you don't consider mlocked page (and/or other unevictable page).
if much mlocked file page exist, other_free can become large value.
then, this routine don't kill any process.


>         if(lowmem_adj_size < array_size)
>                 array_size = lowmem_adj_size;
>         if(lowmem_minfree_size < array_size)
>                 array_size = lowmem_minfree_size;
>         for(i = 0; i < array_size; i++) {
>                 if(other_free < lowmem_minfree[i]) {
>                         min_adj = lowmem_adj[i];
>                         break;
>                 }
>         }
>
>
>         if(nr_to_scan > 0)
>                 lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_fr> ee, min_adj);
>         read_lock(&tasklist_lock);
>         for_each_process(p) {

Oops. too long locking.
shrink_slab() is freqentlly called function. I don't like costly operation.

>                 if(p->oomkilladj >= 0 && p->mm) {
>                         tasksize = get_mm_rss(p->mm);
>                         if(nr_to_scan > 0 && tasksize > 0 && p->oomkilladj >= min_adj) {
>                                 if(selected == NULL ||
>                                    p->oomkilladj > selected->oomkilladj ||
>                                    (p->oomkilladj == selected->oomkilladj &&
>                                     tasksize > selected_tasksize)) {
>                                         selected = p;
>                                         selected_tasksize = tasksize;
>                                         lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
>                                                      p->pid, p->comm, p->oomkilladj, tasksize);
>                                 }
>                         }
>                         rem += tasksize;

this code mean,
shrinker->shrink(0, gfp_mask) indicate to recalculate total rss every time.
it is too CPU and battery wasting.


>                 }
>         }
>         if(selected != NULL) {
>                 lowmem_print(1, "send sigkill to %d (%s), adj %d, size %d\n",
>                              selected->pid, selected->comm,
>                              selected->oomkilladj, selected_tasksize);
>                 force_sig(SIGKILL, selected);
>                 rem -= selected_tasksize;
>         }
>         lowmem_print(4, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
>         read_unlock(&tasklist_lock);
>         return rem;
> }
