Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXBRE7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXBRE7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 23:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933108AbXBRE7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 23:59:49 -0500
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:39971 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933106AbXBRE7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 23:59:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gEFK37QeLMbwAznOwRP/R1Fs7WdSlGxi8penGJDXp+LZGxsEgNuFXDfJRYKRv7qm5JCxeA6nMAn+0HsBT/B800xc3sHidonqXzW/PU4MKuXwq+6u4rCUX5QStIpNlBLel8rteyj+IEReDnXtX3uwm/R969xHAeBnvtJh8BnTaMQ=;
X-YMail-OSG: qi6FDfYVM1kz8z4cMZ_oQncr2B7c6U0fBd0rFJZpIqFbn3LkJvJEYcZFeVv2UdJZGbh2TbmP_JGik_pRvRPJ6ksnY5a3VXa4XI4O7AdE9FECTjRpDEji2l0qiaMBi8imu3ZbYNYeDm9kyT0-
Date: Sat, 17 Feb 2007 20:59:47 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D794E7.3000007@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <397934.24280.qm@web36702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't actually think that is what happening. The block errors tend to trail a
> bit behind, so the errors you are seeing are probably the result of the queue
> being flushed out as you remove the card. I don't see any mmc debug messages
> that indicate that is trying to send more mmc requests.

Yes, indeed - it does not issue new requests after remove. However, mmc_remove_host does not wait
for all issued requests to complete and it is a problem.
Here's my remove procedure:
1. cut off interrupt signaling call back - no tasklets will be coming from here
2. kill request completion tasklet
3. check if there's still an unfinished request - if yes, schedule a completion tasklet
3a. if I'll sleep here, just scheduled tasklet will have a chance to complete
3b. This is what happens if I don't sleep:
(this line is printed by completion tasklet: tifm_sd0:3: num_bl 7, b_s 512, bsh 443)
------
Feb 18 15:22:40 mortug tifm_sd0:3 : card failed to respond for a long period of time (12, 1)
Feb 18 15:22:40 mortug tifm_7xx1 0000:06:09.3: checking media set 8
Feb 18 15:22:40 mortug tifm0 : demand removing card from socket 0:3
Feb 18 15:22:40 mortug mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0
Feb 18 15:22:40 mortug tifm_sd tifm_sd0:3: ios: clock = 0, vdd = 0, bus_mode = 1, chip_select = 0,
power_mode = 0, bus_width = 0
Feb 18 15:22:40 mortug tifm_sd tifm_sd0:3: after remove
Feb 18 15:22:40 mortug tifm_sd tifm_sd0:3: num_bl 7, b_s 512, bsh 443
Feb 18 15:22:40 mortug mmc0: req done (CMD18): 1/0/1: 00000900 00000000 00000000 00000000
Feb 18 15:22:40 mortug mmcblk0: error 1 sending read/write command
Feb 18 15:22:40 mortug end_request: I/O error, dev mmcblk0, sector 0
Feb 18 15:22:40 mortug printk: 79 messages suppressed.
Feb 18 15:22:40 mortug Buffer I/O error on device mmcblk0, logical block 0
Feb 18 15:22:40 mortug divide error: 0000 [1] SMP 
Feb 18 15:22:40 mortug CPU 0 
......
Feb 18 15:22:40 mortug Call Trace:
Feb 18 15:22:40 mortug [<ffffffff88111280>] :mmc_block:mmc_blk_issue_rq+0xf0/0x600
Feb 18 15:22:40 mortug [<ffffffff8020f199>] __alloc_pages+0x69/0x2f0
Feb 18 15:22:40 mortug [<ffffffff802110f1>] do_wp_page+0x4b1/0x510
Feb 18 15:22:40 mortug [<ffffffff8028d690>] task_rq_lock+0x50/0x90
Feb 18 15:22:40 mortug [<ffffffff8028d958>] __activate_task+0x38/0x50
Feb 18 15:22:40 mortug [<ffffffff80248ebb>] try_to_wake_up+0x42b/0x440
Feb 18 15:22:40 mortug [<ffffffff8038d43d>] elv_rb_del+0x2d/0x50
Feb 18 15:22:40 mortug [<ffffffff8038de2d>] elv_next_request+0x15d/0x1e0
Feb 18 15:22:40 mortug [<ffffffff8821c9b8>] :mmc_core:mmc_queue_thread+0xd8/0x110
Feb 18 15:22:40 mortug [<ffffffff8821c8e0>] :mmc_core:mmc_queue_thread+0x0/0x110
Feb 18 15:22:40 mortug [<ffffffff802a4d30>] keventd_create_kthread+0x0/0x90
Feb 18 15:22:40 mortug [<ffffffff80233169>] kthread+0xd9/0x120
Feb 18 15:22:40 mortug [<ffffffff80262ec8>] child_rip+0xa/0x12
Feb 18 15:22:40 mortug [<ffffffff802a4d30>] keventd_create_kthread+0x0/0x90
Feb 18 15:22:40 mortug [<ffffffff80233090>] kthread+0x0/0x120
Feb 18 15:22:40 mortug [<ffffffff80262ebe>] child_rip+0x0/0x12
Feb 18 15:22:40 mortug 
Feb 18 15:22:40 mortug 
Feb 18 15:22:40 mortug Code: f7 f6 41 01 c1 41 83 f8 01 19 c0 25 10 b6 fd ff 05 90 d0 03 
Feb 18 15:22:40 mortug RIP  [<ffffffff8821a44c>] :mmc_core:mmc_set_data_timeout+0x7c/0xb0
Feb 18 15:22:40 mortug RSP <ffff81003ad97c98>



 
____________________________________________________________________________________
Don't get soaked.  Take a quick peak at the forecast
with the Yahoo! Search weather shortcut.
http://tools.search.yahoo.com/shortcuts/#loc_weather
