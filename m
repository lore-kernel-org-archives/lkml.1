Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZGEOvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZGEOvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZGEOvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:51:44 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:34153 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbZGEOvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ttmd3iBoNJD43ZE7BemknWmQRGYNc0UWKYkgVVe2VB2TbmBDueVbnlN+FFuPH4Vilt
         INTN1KQqAQI5kSPTqHtFxIf+q/YOLz2159koVkrihT4OaVKVpwvhX03nR0qXkYrePflv
         6IeVQqe30Ropf+aDPxqDbu4/uOS7Ci95tHQTE=
MIME-Version: 1.0
In-Reply-To: <20090705211127.0917.A69D9226@jp.fujitsu.com>
References: <20090705182451.08FF.A69D9226@jp.fujitsu.com>
	 <20090705121003.GB5252@localhost>
	 <20090705211127.0917.A69D9226@jp.fujitsu.com>
Date: Sun, 5 Jul 2009 23:51:46 +0900
Message-ID: <28c262360907050751t1fccbf4t4ace572b4e003a13@mail.gmail.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 5, 2009 at 9:23 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Sun, Jul 05, 2009 at 05:25:32PM +0800, KOSAKI Motohiro wrote:
>> > Subject: [PATCH] add isolate pages vmstat
>> >
>> > If the system have plenty threads or processes, concurrent reclaim can
>> > isolate very much pages.
>> > Unfortunately, current /proc/meminfo and OOM log can't show it.
>> >
>> > This patch provide the way of showing this information.
>> >
>> >
>> > reproduce way
>> > -----------------------
>> > % ./hackbench 140 process 1000
>> >    => couse OOM
>> >
>> > Active_anon:4419 active_file:120 inactive_anon:1418
>> >  inactive_file:61 unevictable:0 isolated:45311
>> >                                          ^^^^^
>> >  dirty:0 writeback:580 unstable:0
>> >  free:27 slab_reclaimable:297 slab_unreclaimable:4050
>> >  mapped:221 kernel_stack:5758 pagetables:28219 bounce:0
>> >
>> >
>> >
>> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > ---
>> >  drivers/base/node.c    |    2 ++
>> >  fs/proc/meminfo.c      |    2 ++
>> >  include/linux/mmzone.h |    1 +
>> >  mm/page_alloc.c        |    6 ++++--
>> >  mm/vmscan.c            |    4 ++++
>> >  mm/vmstat.c            |    2 +-
>> >  6 files changed, 14 insertions(+), 3 deletions(-)
>> >
>> > Index: b/fs/proc/meminfo.c
>> > ===================================================================
>> > --- a/fs/proc/meminfo.c
>> > +++ b/fs/proc/meminfo.c
>> > @@ -65,6 +65,7 @@ static int meminfo_proc_show(struct seq_
>> >             "Active(file):   %8lu kB\n"
>> >             "Inactive(file): %8lu kB\n"
>> >             "Unevictable:    %8lu kB\n"
>> > +           "IsolatedPages:  %8lu kB\n"
>> >             "Mlocked:        %8lu kB\n"
>> >  #ifdef CONFIG_HIGHMEM
>> >             "HighTotal:      %8lu kB\n"
>> > @@ -109,6 +110,7 @@ static int meminfo_proc_show(struct seq_
>> >             K(pages[LRU_ACTIVE_FILE]),
>> >             K(pages[LRU_INACTIVE_FILE]),
>> >             K(pages[LRU_UNEVICTABLE]),
>> > +           K(global_page_state(NR_ISOLATED)),
>>
>> Glad to see you renamed it to NR_ISOLATED :)
>> But for the user visible name, how about IsolatedLRU?
>
> Ah, nice.  below is update patch.
>
> Changelog
> ----------------
>  since v1
>    - rename "IsolatedPages" to "IsolatedLRU"
>
>
> =================================
> Subject: [PATCH] add isolate pages vmstat
>
> If the system have plenty threads or processes, concurrent reclaim can
> isolate very much pages.
> Unfortunately, current /proc/meminfo and OOM log can't show it.
>
> This patch provide the way of showing this information.
>
>
> reproduce way
> -----------------------
> % ./hackbench 140 process 1000
>   => couse OOM
>
> Active_anon:4419 active_file:120 inactive_anon:1418
>  inactive_file:61 unevictable:0 isolated:45311
>                                         ^^^^^
>  dirty:0 writeback:580 unstable:0
>  free:27 slab_reclaimable:297 slab_unreclaimable:4050
>  mapped:221 kernel_stack:5758 pagetables:28219 bounce:0
>
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/base/node.c    |    2 ++
>  fs/proc/meminfo.c      |    2 ++
>  include/linux/mmzone.h |    1 +
>  mm/page_alloc.c        |    6 ++++--
>  mm/vmscan.c            |    4 ++++
>  mm/vmstat.c            |    2 +-
>  6 files changed, 14 insertions(+), 3 deletions(-)
>
> Index: b/fs/proc/meminfo.c
> ===================================================================
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -65,6 +65,7 @@ static int meminfo_proc_show(struct seq_
>                "Active(file):   %8lu kB\n"
>                "Inactive(file): %8lu kB\n"
>                "Unevictable:    %8lu kB\n"
> +               "IsolatedLRU:    %8lu kB\n"
>                "Mlocked:        %8lu kB\n"
>  #ifdef CONFIG_HIGHMEM
>                "HighTotal:      %8lu kB\n"
> @@ -109,6 +110,7 @@ static int meminfo_proc_show(struct seq_
>                K(pages[LRU_ACTIVE_FILE]),
>                K(pages[LRU_INACTIVE_FILE]),
>                K(pages[LRU_UNEVICTABLE]),
> +               K(global_page_state(NR_ISOLATED)),
>                K(global_page_state(NR_MLOCK)),
>  #ifdef CONFIG_HIGHMEM
>                K(i.totalhigh),
> Index: b/include/linux/mmzone.h
> ===================================================================
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -100,6 +100,7 @@ enum zone_stat_item {
>        NR_BOUNCE,
>        NR_VMSCAN_WRITE,
>        NR_WRITEBACK_TEMP,      /* Writeback using temporary buffers */
> +       NR_ISOLATED,            /* Temporary isolated pages from lru */
>  #ifdef CONFIG_NUMA
>        NUMA_HIT,               /* allocated in intended node */
>        NUMA_MISS,              /* allocated in non intended node */
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2116,8 +2116,7 @@ void show_free_areas(void)
>        }
>
>        printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> -               " inactive_file:%lu"
> -               " unevictable:%lu"
> +               " inactive_file:%lu unevictable:%lu isolated:%lu\n"

It's good.
I have a one suggestion.

I know this patch came from David's OOM problem a few days ago.

I think total pages isolated of all lru doesn't help us much.
It just represents why [in]active[anon/file] is zero.

How about adding isolate page number per each lru ?

IsolatedPages(file)
IsolatedPages(anon)

It can help knowing exact number of each lru.

-- 
Kind regards,
Minchan Kim
