Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbYHFIYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbYHFIYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYHFIYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:24:19 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:61536 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbYHFIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:24:18 -0400
X-BigFish: VPS-10(zz936eQ3117Kzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K567C4-01-2YK-01
Date: Wed, 6 Aug 2008 10:24:00 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/2] x86: fix memory leaks when doing CPU hotplug
Message-ID: <20080806082400.GC5427@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2008 08:24:04.0104 (UTC) FILETIME=[C9684880:01C8F79D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches fix two memory leaks with CPU hotplug.
Some per CPU data is allocated each time a CPU is set online.
But this space is never freed.

Usually this memory leak is not a big deal (for normal CPU hotplug usage).
But during stress tests with lots of CPU offline/online cycles this
really matters.

The entire leak is 40K (10 pages) for each offline/online cycle per
CPU.  I've verified both fixes performing more than 90000 CPU
offline/online cycles.

This is not a regression but I think it's still 2.6.27 material.
Please apply.


Regards,

Andreas


BTW, there is still a leak of about 600 bytes per offline/online cycle
per CPU -- according to slabinfo this might be sysfs related. The most
suspicious entries are:

Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
sysfs_dir_cache         266085      80    41.9M      10235/4/0   26 0   0  50 PZFU
kmalloc-8               130870       8    10.5M       2568/5/0   51 0   0   9 PZFU


