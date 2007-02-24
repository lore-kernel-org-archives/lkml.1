Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbXBXEsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbXBXEsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 23:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933387AbXBXEsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 23:48:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47187 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382AbXBXEsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 23:48:32 -0500
Date: Sat, 24 Feb 2007 13:46:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, miklos@szeredi.hu,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional
 writers
Message-Id: <20070224134646.0f4edeae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <45DED819.9040404@hitachi.com>
References: <45DED819.9040404@hitachi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007 21:03:37 +0900
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com> wrote:

> Hi,
> 
> I have observed a problem that write(2) can be blocked for a long time
> if a system has several disks and is under heavy I/O pressure. This
> patchset is to avoid the problem.
> 
> Example of the probrem:
> 
> There are two processes on a system which has two disks. Process-A
> writes heavily to disk-a, and process-B writes small data (e.g. log
> files) to disk-b occasionally. A portion of system memory, which is
> depends on vm.dirty_ratio (typically 40%), is filled up with Dirty
> and Writeback pages of disk-a.
> 
> In this situation, write(2) of process-B could be blocked for a very
> long time (more then 60 seconds), although the load of disk-b is quite
> low. In particular, the system would become quite slow, if disk-a is
> slow (e.g. backup to an USB disk).
> 
> This seems to be the same problem as discussed in LKML:
> http://marc.theaimsgroup.com/?t=115559902900003
> and
> http://marc.theaimsgroup.com/?t=117182340400003
> 
Interesting, but how about adjust this parameter like below instead of
adding new control knob ?(this kind of knob is not easy to use.)

==
                struct writeback_control wbc = {
                        .bdi            = bdi,
                        .sync_mode      = WB_SYNC_NONE,
                        .older_than_this = NULL,
                        .nr_to_write    = 0,
                        .range_cyclic   = 1,
                };
<snip>
                if (nr_reclaimable) {
			/* Just do what I can do */
			dirty_pages_on_device = count_dirty_pages_on_device_limited(bdi, writechunk);
			wbc.nr_to_write = dirty_pages_on_device.
			writeback_inodes(&wbc);
 
==

count_dirty_pages_on_device_limited(bdi, writechunk) above returns 
dirty pages on bdi. if # of dirty_pages on bdi is larger than writechunk,
just returns writechunk.

-Kame





