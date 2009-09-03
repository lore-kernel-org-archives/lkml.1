Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZICKuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZICKuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 06:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbZICKuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 06:50:12 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4843 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbZICKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 06:50:11 -0400
Message-ID: <4A9F9F64.5080305@aimvalley.nl>
Date: Thu, 03 Sep 2009 12:50:12 +0200
From: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: CONFIG_NO_HZ could cause software timeouts
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The problem occurs when e.g. drivers use time_after(jiffes, timeout).

CONFIG_NO_HZ could make jiffies advance by more than 1.
This is done by: tick_nohz_update_jiffies->tick_do_update_jiffies64->do_timer

If drivers use a timeout value of jiffies+1,
"time_after(jiffies, timeout)" will be true after 1 interrupt
(given that it advances jiffies by at least 2).

This is exactly what happens in cfi_cmdset_0002.c:do_write_buffer
for our case (Powerpc MPC8313, linux-2.6.28, CONFIG_HZ=250, CONFIG_NO_HZ=y).

do_write_buffer does the following:
  unsigned long uWriteTimeout = ( HZ / 1000 ) + 1;
  ...
  timeo = jiffies + uWriteTimeout;
  ...
  for (;;) {
   ...
   if (time_after(jiffies, timeo) && !chip_ready(map, adr))
    break;
   if (chip_ready(map, adr)) {
    xip_enable(map, chip, adr);
    goto op_done;
   }
   UDELAY(map, chip, adr, 1);
  }
  /* software timeout */
  ret = -EIO;
opdone:
  ...

I've seen a few software timeouts after the for-loop
looped only 13 times (= 13 us delay, i.s.o. the expected 1 ms). Typically
our NOR flash (S29GL01GP) may need upto ~ 200 us to be ready.

disabling CONFIG_NO_HZ fixes the problem.
replacing time_after by a for-loop counter to loop max 1000 times
also fixes the problem.

the latest kernel seems to have the same problem.

do I miss something here or is this a known problem of CONFIG_NO_HZ ?
