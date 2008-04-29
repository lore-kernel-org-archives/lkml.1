Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYD2BZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYD2BZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYD2BZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:25:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33307 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYD2BZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:25:14 -0400
Message-ID: <481678F5.7080504@jp.fujitsu.com>
Date: Tue, 29 Apr 2008 10:25:09 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] patches for stop_machine
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty and all,

This is a proposal of minor improvement for kernel/stop_machine.c

[PATCH 1/3] stop_machine: short exit path for if we cannot create enough threads
[PATCH 2/3] stop_machine: add timeout for child thread deployment
[PATCH 3/3] stop_machine: add stopmachine_timeout sysctl entry

The main topic is "how about adding timeout for stop_machine?"
I think it will act as a safety net.

For example (of silly situation), system can hung with following way:

  # ./silly.sh
  run an evil loop task on AP
   pid 6138's current affinity mask: ff
   pid 6138's new affinity mask: fe
   to pretend lock up, chrt -f -p 99 6138
   loop[6138] is on CPU #4
  to do stopmachine, try to off #7
  echo 0 > /sys/devices/system/cpu/cpu7/online
  (never return)

After applying patch set here, it can be prevented.

  # ./silly.sh
   :
  echo 0 > /sys/devices/system/cpu/cpu7/online
  stopmachine: Failed to stop machine in time(5s). Are there any CPUs on file?
  ./silly.sh: line 22: echo: write error: Device or resource busy
  offline is failed
  OK, kill evil loop[6138]
  try to off #7 again
  echo 0 > /sys/devices/system/cpu/cpu7/online
  CPU #7 is now offline
  done!

Please refer description of each patch for the detail.
All comments are welcomed.

Thanks,
H.Seto
