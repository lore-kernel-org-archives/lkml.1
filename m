Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbXESDMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbXESDMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 23:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXESDM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 23:12:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbXESDM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 23:12:26 -0400
Message-ID: <464E6A60.2070204@redhat.com>
Date: Sat, 19 May 2007 11:09:20 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/fw.c: fix use-before-check
References: <464DDD29.3000009@redhat.com> <20070518181355.GD3492@tuxdriver.com>
In-Reply-To: <20070518181355.GD3492@tuxdriver.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

John W. Linville wrote:
> On Sat, May 19, 2007 at 01:06:49AM +0800, Eugene Teo wrote:
>> NULL checks should be performed before the dereference.
>>
>> Spotted by the Coverity checker.
>>
>> Signed-off-by: Eugene Teo <eteo@redhat.com>
> 
> This does not apply against 2.6.22-rc1.  Please rediff and repost.

Ok. Here's a rediff against 2.6.22-rc1. Thanks.
--

NULL checks should be performed before the dereference.

Spotted by the Coverity checker.

Signed-off-by: Eugene Teo <eteo@redhat.com>

diff -uprN -X 2.6.22-rc1/Documentation/dontdiff
2.6.22-rc1.orig/drivers/net/wireless/libertas/fw.c 2.6.22-rc1/drivers/net/wireless/libertas/fw.c
--- 2.6.22-rc1.orig/drivers/net/wireless/libertas/fw.c  2007-05-19 10:48:02.000000000 +0800
+++ 2.6.22-rc1/drivers/net/wireless/libertas/fw.c       2007-05-19 11:01:26.000000000 +0800
@@ -333,18 +333,22 @@ static void command_timer_fn(unsigned lo
        unsigned long flags;

        ptempnode = adapter->cur_cmd;
+       if (ptempnode == NULL) {
+               lbs_pr_debug(1, "PTempnode Empty\n");
+               return;
+       }
+
        cmd = (struct cmd_ds_command *)ptempnode->bufvirtualaddr;
+       if (!cmd) {
+               lbs_pr_debug(1, "cmd is NULL\n");
+               return;
+       }

        lbs_pr_info("command_timer_fn fired (%x)\n", cmd->command);

        if (!adapter->fw_ready)
                return;

-       if (ptempnode == NULL) {
-               lbs_pr_debug(1, "PTempnode Empty\n");
-               return;
-       }
-
        spin_lock_irqsave(&adapter->driver_lock, flags);
        adapter->cur_cmd = NULL;
        spin_unlock_irqrestore(&adapter->driver_lock, flags);
