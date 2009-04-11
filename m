Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbZDKJD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbZDKJD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 05:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZDKJDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 05:03:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50496 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbZDKJDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 05:03:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49E05C36.9040204@s5r6.in-berlin.de>
Date: Sat, 11 Apr 2009 11:00:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090323 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
CC: Andrea Righi <righi.andrea@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and mm->mmap_sem
 ...} causes Xfbdev not working
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>	<20090409125850.GA2727@linux>	<20090410222122.87be60f6.krzysztof.h1@poczta.fm>	<20090410220521.GB21294@linux> <20090411080415.7fe924a2.krzysztof.h1@poczta.fm>
In-Reply-To: <20090411080415.7fe924a2.krzysztof.h1@poczta.fm>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt wrote:
> On Sat, 11 Apr 2009 00:05:22 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>> mmmh... I may have missed something, but the common fb_mmap() should
>> acquire mm->mmap_sem and then info->lock, while fb_ioctl() can do that
>> in reverse order (info->lock first and then mm->mmap_sem) causing the
>> circular locking dependency. Are you sure that pushing info->lock down
>> each driver's fb_mmap will fix the problem?
> 
> Right. The fb_mmap is called with the mmap_sem already held.
> I will try other possibilities like breaking info->lock() into two
> mutexex.

I had to deal with interaction of mmap_sem with a driver lock twice yet.
I solved it cheaply by replacing mutex_lock(driver_mutex) by
mutex_trylock(driver_mutex).

The obvious drawback is that thic changes kernel behaviour visibly to
userspace:  Under contention, the ioctl/read/write fails with -EAGAIN
instead of being blocked until the other thread finished its
ioctl/read/write/mmap on the same fd (if the driver mutex is
instantiated per fd, like in my case).

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8449fc3ae58bf8ee5acbd2280754cde67b5db128
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=638570b54346f140bc09b986d93e76025d35180f

(In these two drivers, the change of behaviour is irrelevant to real
userspace clients.)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
