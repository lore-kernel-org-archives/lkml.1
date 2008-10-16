Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbYJPRcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbYJPRcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbYJPRS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:18:57 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:35894 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757452AbYJPRS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:18:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAOsU90hR9dva/2dsb2JhbACBcsJIg2w
Date: Thu, 16 Oct 2008 19:18:49 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Zvonimir Rakamaric <zrakamar@cs.ubc.ca>
Subject: [WATCHDOG] v2.6.28-rc1 watchdog patches - part 2
Message-ID: <20081016171849.GH30246@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/ib700wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Oct 15 08:53:06 2008 +0000

    [WATCHDOG] ib700wdt.c - fix buffer_underflow bug
    
    This fixes Bug 11399:
    if ibwdt_set_heartbeat(int t) is called with value 30 then
    the check "if ((t < 0) || (t > 30))" in ibwdt_set_heartbeat
    is not going to fail because t == 30, but in the loop, the
    check wd_times[i] > t is never going to be true because
    none of the wd_times are greater than the value of t (i.e. 30).
    So we are exiting the loop with i == -1 and therefore setting
    wd_margin to -1 which is wrong.
    
    Reported-by: Zvonimir Rakamaric <zrakamar@cs.ubc.ca>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 05a2810..8782ec1 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -154,7 +154,7 @@ static int ibwdt_set_heartbeat(int t)
 		return -EINVAL;
 
 	for (i = 0x0F; i > -1; i--)
-		if (wd_times[i] > t)
+		if (wd_times[i] >= t)
 			break;
 	wd_margin = i;
 	return 0;
