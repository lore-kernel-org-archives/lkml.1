Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYDAXf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYDAXf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYDAXfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:35:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:49444 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbYDAXfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:35:11 -0400
Message-ID: <ab3f9b940804011635g2de833d0l44558f78a1cce1e5@mail.gmail.com>
Date: Tue, 1 Apr 2008 16:35:06 -0700
From: "Tom May" <tom@tommay.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2008 at 8:19 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>  The /dev/mem_notify is low memory notification device.
>  it can avoid swappness and oom by cooperationg with the user process.
>
>  the Linux Today article is very nice description. (great works by Jake Edge)
>  http://www.linuxworld.com/news/2008/020508-kernel.html
>
>  <quoted>
>  When memory gets tight, it is quite possible that applications have memory
>  allocated—often caches for better performance—that they could free.
>  After all, it is generally better to lose some performance than to face the
>  consequences of being chosen by the OOM killer.
>  But, currently, there is no way for a process to know that the kernel is
>  feeling memory pressure.
>  The patch provides a way for interested programs to monitor the /dev/mem_notify
>   file to be notified if memory starts to run low.
>  </quoted>
>
>
>  You need not be annoyed by OOM any longer :)
>  please any comments!

Thanks for this patch set!  I ported it to 2.6.23.9 and tried it, on a
system with no swap since I'm evaluating this for an embedded system.
In practice, the criterion it uses for notifications wasn't sufficient to avoid
memory problems, including OOM, in a cyclic allocate/notify/free
sequence which is probably typical.

I tried it with a real-world program that, among other things, mmaps
anonymous pages and touches them at a reasonable speed until it gets
notified via /dev/mem_notify, releases most of them with
madvise(MADV_DONTNEED), then loops to start the cycle again.

What tends to happen is that I do indeed get notifications via
/dev/mem_notify when the kernel would like to be swapping, at which
point I free memory.  But the notifications come at a time when the
kernel needs memory, and it gets the memory by discarding some Cached
or Mapped memory (I can see these decreasing in /proc/meminfo with
each notification).  With each mmap/notify/madvise cycle the Cached
and Mapped memory gets smaller, until eventually while I'm touching
pages the kernel can't find enough memory and will either invoke the
OOM killer or return ENOMEM from syscalls.  This is precisely the
situation I'm trying to avoid by using /dev/mem_notify.

The criterion of "notify when the kernel would like to swap" feels
correct, but in addition I seem to need something like "notify when
cached+mapped+free memory is getting low".

I'll need to be looking into doing this, so any comments or ideas are
welcome.

Thanks,
.tom
