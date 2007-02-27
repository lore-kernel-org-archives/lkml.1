Return-Path: <linux-kernel-owner+w=401wt.eu-S965073AbXB0Ayr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073AbXB0Ayr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965045AbXB0Ayp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:54:45 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:36155 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbXB0Ayo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:54:44 -0500
Message-ID: <45E38048.3020705@hitachi.com>
Date: Tue, 27 Feb 2007 09:50:16 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, miklos@szeredi.hu,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, nikita@clusterfs.com
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45DED819.9040404@hitachi.com> <20070224134646.0f4edeae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070224134646.0f4edeae.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa-san,

thanks for your reply.

KAMEZAWA Hiroyuki wrote:
> Interesting, but how about adjust this parameter like below instead of
> adding new control knob ?(this kind of knob is not easy to use.)
>
> ==
>                 struct writeback_control wbc = {
>                         .bdi            = bdi,
>                         .sync_mode      = WB_SYNC_NONE,
>                         .older_than_this = NULL,
>                         .nr_to_write    = 0,
>                         .range_cyclic   = 1,
>                 };
> <snip>
>                 if (nr_reclaimable) {
> 			/* Just do what I can do */
> 			dirty_pages_on_device = count_dirty_pages_on_device_limited(bdi, writechunk);
> 			wbc.nr_to_write = dirty_pages_on_device.
> 			writeback_inodes(&wbc);
>
> ==
>
> count_dirty_pages_on_device_limited(bdi, writechunk) above returns
> dirty pages on bdi. if # of dirty_pages on bdi is larger than writechunk,
> just returns writechunk.


I think that way is not enough to control the total amount of
Dirty+Writeback.

In that way, while writeback_inodes() scans for dirty pages and writes
them back, the caller will be blocked only if the length of the write-
requests queue is longer than nr_requests. If so, Writeback may consume
tens MB memory for each queue, because nr_requests is 128 and the
maximum size of a request is 512KB. If you have several devices, it can
consume more than hundred MB memory.

I concerned about that, so I introduced dirty_limit_ratio to limit the
total amount of Dirty+Writeback pages.


Regards
--
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory
