Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXEQQFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXEQQFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 12:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXEQQFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 12:05:21 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53593 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263AbXEQQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 12:05:20 -0400
Date: Thu, 17 May 2007 20:03:11 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: Review status (Re: [PATCH] LogFS take three)
Message-ID: <20070517160308.GA26643@2ka.mipt.ru>
References: <20070515151919.GA32510@lazybastard.org> <20070515152149.GB32059@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070515152149.GB32059@lazybastard.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 17 May 2007 20:03:25 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jörn.

Is logfs 32bit fs or 674bit, since although you use 64bit values for
offsets, area management and strange converstions like described below 
from offset into segment number are performed in 32bit?
Is it enough for SSD for example to be 32bit only? Or if it is 64bit,
could you please explain logic behind area management?

I've found that you store segment numbers as 32bit values (for example
in prepare_write()), and convert requested 64bit offset into segment
number via superblock's s_segshift.
This conversation seems confusing to me in case of real 64bit offsets.
For example this one obtained via prepare_write:

7  1 logfs_prepare_write    78  fs/logfs/file.c
8  2 logfs_readpage_nolock    20  fs/logfs/file.c
9  1 logfs_read_block   351  fs/logfs/readwrite.c
10  1 logfs_read_loop   139  fs/logfs/readwrite.c
11  2 logfs_segment_read   108  fs/logfs/readwrite.c
12  1 wbuf_read         289 

u32 segno = ofs >> super->s_segshift;

ofs is originally obtained from inode's li_data array, which is filled
with raw segment numbers which can be 64bit (here is another issue,
since logfs_segment_write() returns signed, so essentially logfs is
63bit filesystem).

But here I've came to area management in logfs, and found that it is
32bit only, for example __logfs_segment_write()/__logfs_get_free_bytes() 
returns signed 32 bit value (so it is reduced to 31 bit), which is then 
placed into li_data as 64bit value. The latter
(__logfs_get_free_bytes()) truncates 64bit data value obtained via
dev_ofs() into signed 32 bit value.

-- 
	Evgeniy Polyakov
