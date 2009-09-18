Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZIRFc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZIRFc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbZIRFc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:32:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46085 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZIRFcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:32:55 -0400
Message-ID: <4AB31B87.2040007@np.css.fujitsu.com>
Date: Fri, 18 Sep 2009 14:32:55 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [BUG? -next] login prompt of tty2~6 displayed slowly
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

I have a trouble on tty of -next.
After the system booted and login prompt of tty1 was displayed, I tried to
change tty1 to tty2 or other console with Ctrl+Alt+FN(N:2~6). The changed screen
was black and there was not login prompt. After a few(2~3) minutes the prompt
was displayed. I checked the message of klog and there were some errors of tty
listed as following:

Sep 15 10:02:44 iridium /sbin/mingetty[3062]: tty2: cannot open tty: Input/output error
Sep 15 10:02:44 iridium /sbin/mingetty[3063]: tty3: cannot open tty: Input/output error
Sep 15 10:02:44 iridium /sbin/mingetty[3060]: tty4: cannot open tty: Input/output error
Sep 15 10:02:44 iridium /sbin/mingetty[3061]: tty5: cannot open tty: Input/output error
Sep 15 10:02:44 iridium /sbin/mingetty[3066]: tty6: cannot open tty: Input/output error
Sep 15 10:02:49 iridium init: tty2 main process (3062) terminated with status 1
Sep 15 10:02:49 iridium init: tty2 main process ended, respawning
Sep 15 10:02:49 iridium init: tty3 main process (3063) terminated with status 1
Sep 15 10:02:49 iridium init: tty3 main process ended, respawning
Sep 15 10:02:49 iridium /sbin/mingetty[3107]: tty3: cannot open tty: Input/output error
Sep 15 10:02:49 iridium init: tty4 main process (3060) terminated with status 1
Sep 15 10:02:49 iridium init: tty4 main process ended, respawning
Sep 15 10:02:49 iridium /sbin/mingetty[3106]: tty2: cannot open tty: Input/output error
Sep 15 10:02:49 iridium /sbin/mingetty[3108]: tty4: cannot open tty: Input/output error
Sep 15 10:02:49 iridium init: tty5 main process (3061) terminated with status 1
Sep 15 10:02:49 iridium init: tty5 main process ended, respawning
Sep 15 10:02:49 iridium /sbin/mingetty[3109]: tty5: cannot open tty: Input/output error
Sep 15 10:02:49 iridium init: tty6 main process (3066) terminated with status 1
Sep 15 10:02:49 iridium init: tty6 main process ended, respawning
Sep 15 10:02:49 iridium /sbin/mingetty[3110]: tty6: cannot open tty: Input/output error


And I find out that the root cause of this problem is the following patch:
    commit 236cce0066f9c6a4856bc0404e541d3db3b0255e
    Titled "tty: make the kref destructor occur asynchronously"

When the tty is closed, the content of tty is not released immediately. And the
flag of tty is set with TTY_CLOSING. So when the tty is reopened, the tty may
not be released yet. Because the TTY_CLOSING in flag of tty is still valid. The
kernel returns "-EIO" error. And the message
    "/sbin/mingetty[3062]: tty2: cannot open tty: Input/output error"
is displayed at the user land.

Best Regards
Jin Dongming
