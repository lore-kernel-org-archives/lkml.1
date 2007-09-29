Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbXI2TxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbXI2TxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXI2TxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:53:04 -0400
Received: from smtp.nokia.com ([131.228.20.170]:30595 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbXI2TxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:53:03 -0400
X-Greylist: delayed 2455 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2007 15:53:03 EDT
Message-ID: <46FEA332.9090904@yandex.ru>
Date: Sat, 29 Sep 2007 22:10:42 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Write-back from inside FS - need suggestions
References: <46FCC686.3050009@yandex.ru>        <46FE2167.8000800@yandex.ru> <20070929033939.6ee65e19.akpm@linux-foundation.org>
In-Reply-To: <20070929033939.6ee65e19.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Sep 2007 19:10:43.0207 (UTC) FILETIME=[6E979170:01C802CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I'd have thought that a suitable wrapper around a suitably-modified
> sync_sb_inodes() would be appropriate for both filesystems?

Ok, I've modified sync_inodes_sb() so that I can pass it my own wbc,
where I set wcb->nr_to_write = 20. It gives me _exactly_ what I want.
It just flushes a bit more then 20 pages and returns. I use
WB_SYNC_ALL. Great!

Now I would like to understand why it works :-) To my surprise, it
does not deadlock! I call it from ->prepare_write where I'm holding
i_mutex, and it works just fine. It calls ->writepage() without trying
to lock i_mutex! This looks like some witchcraft for me.

This means that if I'm in the middle of an operation or ino #X, I own
its i_mutex, but not I_LOCK, I can be preempted and ->writepage can
be called for a dirty page belonging to this inode #X? I haven't seen
this in practice and I do not believe this may happen. Why?

Could you or someone please give me a hint what exactly
inode->i_flags & I_LOCK protects? What is its relationship to i_mutex?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
