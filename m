Return-Path: <linux-kernel-owner+w=401wt.eu-S965072AbXB0A5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965072AbXB0A5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965045AbXB0A5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:57:08 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:36955 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbXB0A5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:57:07 -0500
Message-ID: <45E380DA.6090509@hitachi.com>
Date: Tue, 27 Feb 2007 09:52:42 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Nikita Danilov <nikita@clusterfs.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, miklos@szeredi.hu,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45DED819.9040404@hitachi.com> <17888.14958.85897.289141@gargle.gargle.HOWL>
In-Reply-To: <17888.14958.85897.289141@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikita,

thanks for your comments.

Nikita Danilov wrote:
>> While Dirty+Writeback pages get more than 40% of memory, process-B is
>> blocked in balance_dirty_pages() until writeback of some (`write_chunk',
>> typically = 1536) dirty pages on disk-b is started.
>
> May be the simpler solution is to use separate variables to control
> ratelimit and write chunk?

No, I think it's difficult to throttle total Dirty+Writeback only with
write_chunk, because write_chunk just affects Dirty and Writeback of
each device (in this case, throttling is done in write-requests queue of
the each backing device, as I said in another mail).

Throttling of the total Dirty+Writeback should be also done in VM itself,
and to control that, I added `dirty_limit_ratio.'


> writeback_set_ratelimit() adjusts ratelimit_pages to avoid too frequent
> calls to balance_dirty_pages(), but once we are inside of
> writeback_inodes(), there is no need to write especially many pages in
> one go: overhead of any additional looping is negligible, when compared
> with the cost of writing.
>
> Speaking of which, now that expensive get_writeback_state() is gone from
> page-writeback.c why do we need adjustable ratelimiting at all? It looks
> like writeback_set_ratelimit() can be dropped, and fixed ratelimit used
> instead.

As far as I can see, adjustable ratelimiting is the actual cause of the
long wait on writing to disk with light load.
I think removing adjustable ratelimiting should be done in another patch...


Regards
--
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory
