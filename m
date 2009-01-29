Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZA2Bs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZA2Bs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZA2BsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:48:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46502 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbZA2BsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:48:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arve =?SHIFT_JIS?B?SGr4bm5lduVn?= <arve@android.com>
Subject: Re: lowmemory android driver not needed?
Cc: kosaki.motohiro@jp.fujitsu.com, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha =?SHIFT_JIS?B?WXJq9myBRQ==?= 
	<juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
In-Reply-To: <d6200be20901212213x1069762cpd377d04bc5a04a91@mail.gmail.com>
References: <2f11576a0901160518g52a3e70endc98fe4792a98b9b@mail.gmail.com> <d6200be20901212213x1069762cpd377d04bc5a04a91@mail.gmail.com>
Message-Id: <20090128234209.A949.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 29 Jan 2009 10:48:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Fri, Jan 16, 2009 at 5:18 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > also quick review to lowmemorykiller.c
> 
> >> static struct shrinker lowmem_shrinker = {
> >>         .shrink = lowmem_shrink,
> >>         .seeks = DEFAULT_SEEKS * 16
> >> };
> >
> > why do you choice *16?
> 
> To indicate that it is more expensive to restart a killed process than
> a regular cache page.

I think you already know this answer isn't actual answer.
anybody know >1 mean expensive. a reviewer want to know why DEFAULT_SEEKS * 16
is best, not *10 nor *20.



> >> static uint32_t lowmem_debug_level = 2;
> >> static int lowmem_adj[6] = {
> >
> > why do you choice [6]?
> 
> We use six levels.

if you don't consider other user and other usage case,
this file can't merge forever.

The top problem is, this file stay on non proper place.
then, MM folks don't review at all.

I think this patch need to receive MM folks review.
Greg, please drop this file from stagin awhile.
(of cource, my intention is this one file only, other hardware depended 
driver file is needed to staging)

	Naked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> >> static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
> >> {
> >>         struct task_struct *p;
> >>         struct task_struct *selected = NULL;
> >>         int rem = 0;
> >>         int tasksize;
> >>         int i;
> >>         int min_adj = OOM_ADJUST_MAX + 1;
> >>         int selected_tasksize = 0;
> >>         int array_size = ARRAY_SIZE(lowmem_adj);
> >>         int other_free = global_page_state(NR_FREE_PAGES) + global_page_state(NR_FILE_PAGES);
> >
> > I think you don't consider mlocked page (and/or other unevictable page).
> > if much mlocked file page exist, other_free can become large value.
> > then, this routine don't kill any process.
> 
> Yes, this is a problem we have seen, but I did not find counter for
> pinned cache pages. I may be able to use NR_UNEVICTABLE if
> CONFIG_UNEVICTABLE_LRU is enabled now though.

hm hom.


> Another problem we run into is that allocations of contiguous pages
> can cause kswapd to empty all the caches. This will not trigger this
> lowmemorykiller or the regular oom killer.

strange usage.
you shouldn't use high order allocation on embedded machine.



> >>         read_lock(&tasklist_lock);
> >>         for_each_process(p) {
> >
> > Oops. too long locking.
> > shrink_slab() is freqentlly called function. I don't like costly operation.
> >
> >>                 if(p->oomkilladj >= 0 && p->mm) {
> >>                         tasksize = get_mm_rss(p->mm);
> >>                         if(nr_to_scan > 0 && tasksize > 0 && p->oomkilladj >= min_adj) {
> >>                                 if(selected == NULL ||
> >>                                    p->oomkilladj > selected->oomkilladj ||
> >>                                    (p->oomkilladj == selected->oomkilladj &&
> >>                                     tasksize > selected_tasksize)) {
> >>                                         selected = p;
> >>                                         selected_tasksize = tasksize;
> >>                                         lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
> >>                                                      p->pid, p->comm, p->oomkilladj, tasksize);
> >>                                 }
> >>                         }
> >>                         rem += tasksize;
> >
> > this code mean,
> > shrinker->shrink(0, gfp_mask) indicate to recalculate total rss every time.
> > it is too CPU and battery wasting.
> >
> 
> How about this:
> ----
> diff --git a/drivers/misc/lowmemorykiller.c b/drivers/misc/lowmemorykiller.c
> index 3715d56..3f4e41a 100644
> --- a/drivers/misc/lowmemorykiller.c
> +++ b/drivers/misc/lowmemorykiller.c
> @@ -71,6 +71,12 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>         }
>         if(nr_to_scan > 0)
>                 lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma
> %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
> +       rem = global_page_state(NR_ACTIVE_ANON) +
> global_page_state(NR_ACTIVE_FILE);
> +       if (!nr_to_scan || min_adj == OOM_ADJUST_MAX + 1) {
> +               lowmem_print(5, "lowmem_shrink %d, %x, return %d\n",
> nr_to_scan, gfp_mask, rem);
> +               return rem;
> +       }
> +

I don't understand your intention.
if file server machine has tons NR_ACTIVE_FILE, this logic kill many 
process.

Do I misunderstand anything?

>         read_lock(&tasklist_lock);
>         for_each_process(p) {
>                 if(p->oomkilladj >= 0 && p->mm) {
> @@ -86,7 +92,6 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>                                                      p->pid, p->comm,
> p->oomkilladj, tasksize);
>                                 }
>                         }
> -                       rem += tasksize;
>                 }
>         }
>         if(selected != NULL) {





