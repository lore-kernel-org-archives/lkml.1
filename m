Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbZE2PmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbZE2PmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbZE2PmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:42:01 -0400
Received: from smtp.nokia.com ([192.100.122.230]:29854 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892AbZE2PmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:42:00 -0400
Message-ID: <4A20011E.7020900@nokia.com>
Date: Fri, 29 May 2009 18:37:02 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>	 <4A1E9D0B.4090402@gmail.com>  <4A1E9D8B.8020908@gmail.com> <1243542908.6645.104.camel@laptop>
In-Reply-To: <1243542908.6645.104.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 May 2009 15:37:09.0794 (UTC) FILETIME=[545BE820:01C9E073]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2009-05-28 at 17:19 +0300, Artem Bityutskiy wrote:
>> Artem Bityutskiy wrote:
>>> question is - should it? 'bdi_register()' a block device,
>>> but we do not have one.
>> Sorry, wanted to say: 'bdi_register()' registers a block
>> device.
> 
> BDI stands for backing device info and is not related to block devices
> other than that block devices can also be (ok, always are) backing
> devices.
> 
> If you want to do writeback, you need a backing device to write to. The
> BDI is the device abstraction for writeback.

I see, thanks. The below UBIFS patch fixes the issue. I'll
push it to ubifs-2.6.git tree, unless there are objections.

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] UBIFS: do not forget to register BDI device

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 2349e2c..d1ac967 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1929,6 +1929,9 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	err  = bdi_init(&c->bdi);
 	if (err)
 		goto out_close;
+	err = bdi_register(&c->bdi, NULL, "ubifs");
+	if (err)
+		goto out_close;
 
 	err = ubifs_parse_options(c, data, 0);
 	if (err)
-- 
1.6.0.6

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
