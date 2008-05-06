Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYEFFWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYEFFWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYEFFWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:22:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:54409 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYEFFWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:22:05 -0400
Message-ID: <ab3f9b940805052222o4f4a7dev3f4dce92b3766435@mail.gmail.com>
Date: Mon, 5 May 2008 22:22:03 -0700
From: "Tom May" <tom@tommay.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: "=?ISO-2022-JP?B?RGFuaWVsIFNwGyRCaU8bKEJn?=" <daniel.spang@gmail.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080503205732.642F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080501232431.F617.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <ab3f9b940805021521o4680116fyde099f16d66a1e5a@mail.gmail.com>
	 <20080503205732.642F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the talk about how what is using memory, whether things are in
Java or native, etc., is missing the point.  I'm not sure I'm making
my point, so I'll try again: regardless of memory size, mlock, etc.,
the interaction between client and /dev/mem_notify can be unstable,
and is unstable in my case:

- User-space code page faults in MAP_ANONYMOUS regions until there is
no free memory.
- The kernel gives a notification.
- There kernel frees some cache to satisfy the memory request.
- The user-space code gets the notification and frees anonymous pages.
 Concurrently
with this, some thread(s) in the system may continue to page fault.
- The cycle repeats.
- This works well, perhaps hundreds or thousands of cycles, until all
or most of the cache has been freed and we get an oom handling a page
fault.

My requirement is to have a stable system, with memory allocated on
demand to whatever process(es) want it (jvm, web browser, ...) until a
low memory notification occurs, which causes them to free whatever
memory they no longer need, then continue, without arbitrary static
limits on Java heap size, web browser cache size, etc.

My workaround to make things stable is to put pages in the cache
(after releasing anonymous pages and increasing free memory) by
accessing pages in _text, but that seems silly and expensive.

.tom

On Sat, May 3, 2008 at 5:26 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> > >  your memnotify check routine is written by native or java?
>  >
>  > Some of each.
>
>  Wow!
>  you have 2 /dev/mem_notify checking routine?
>  java routine free java memory, native routine free native memory, right?
>
>
>
>  > >  my point is "on swapless system, /dev/mem_notify checked routine should be mlocked".
>  >
>  > mlocking didn't fix things, it just made the oom happen at a different
>  > time (see graphs below), both in the small test program where I used
>  > mlockall, and in the jvm where during initialization I read
>  > /proc/self/maps and mlocked each region of memory that was mapped to a
>  > file.  Note that without swap, all of the anonymous pages containing
>  > the java code are effectively locked in memory, too, so everything
>  > runs without page faults.
>
>  okey.
>
>
>
>  > >  I hope understand your requirement more.
>  >
>  > Most simply, I need to get low memory notifications while there is
>  > still enough memory to handle them before oom.
>
>  Ah, That's your implementation idea.
>  I hope know why don't works well my current implementation at first.
>
>
>
>  > >  Can I ask your system more?
>  >
>  > x86, Linux 2.6.23.9 (with your patches trivially backported), 128MB,
>  > no swap.  Is there something else I can tell you?
>  >
>  > >  I think all java text and data is mapped.
>  >
>  > It's not what /proc/meminfo calls "Mapped".  It's in anonymous pages
>  > with no backing store, i.e., mmap with MAP_ANONYMOUS.
>
>  okey.
>  Mapped of /proc/meminfo mean mapped pages with file backing store.
>
>  therefore, that isn't contain anonymous memory(e.g. java).
>
>
>  > >  When cached+mapped+free memory is happend?
>  > >  and at the time, What is used memory?
>  >
>  > Here's a graph of MemFree, Cached, and Mapped over time (I believe
>  > Mapped is mostly or entirely subset of Cached here, so it's not
>  > actually important):
>  >
>  > http://www.tommay.net/memory.png
>
>  I hope know your system memory usage detail.
>  your system have 128MB, but your graph vertical line represent 0M - 35M.
>  Who use remain 93MB(128-35)?
>  We should know who use memory intead decrease cached memory.
>
>  So, Can you below operation before mesurement?
>
>  # echo 100 > /proc/sys/vm/swappiness
>  # echo 3 >/proc/sys/vm/drop_caches
>
>  and, Can you mesure AnonPages of /proc/meminfo too?
>  (Can your memory shrinking routine reduce anonymous memory?)
>
>  if JVM use memory as anonymous memory and your memory shrinking routine can't
>  anonymous memory, that isn't mem_notify proble,
>  that is just poor JVM garbege collection problem.
>
>  Why I think that?
>  mapped page of your graph decrease linearly.
>  if notification doesn't happened, it doesn't decrease.
>
>  thus,
>  in your system, memory notification is happend rightly.
>  but your JVM doesn't have enough freeable memory.
>
>  if my assumption is right, increase number of memory notification
>  doesn't solve your problem.
>
>  Sould we find way of good interaction to JVM GC and mem_notify shrinker?
>  Sould mem_notify shrinker kick JVM GC for shrink anonymous memory?
>
>
>
>
>  > My thought was to notify only when the threshold is crossed, i.e.,
>  > edge-triggered not level-triggered.
>
>  Hm, interesting..
>
>
>
>  > But I now think a threshold
>  > mechanism may be too complicated, and artificially putting pages in
>  > the cache works just as well.  As a proof-of-concept, I do this, and
>  > it works well, but is inefficient:
>  >
>  >    extern char _text;
>  >    for (int i = 0; i < bytes; i += 4096) {
>  >        *((volatile char *)&_text + i);
>  >    }
>
>  you intent populate to .text segment?
>  if so, you can mamp(MAP_POPULATE), IMHO.
>
>
>
>  > I think embedded Java is a perfect user of /dev/mem_notify :-) I was
>  > happy to see your patches and the criteria you used for notification.
>  > But I'm having a problem in practice :-(
>
>  Yeah, absolutely.
>  I'll try to set up JVM to my test environment tomorrow.
>
>
>
