Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZGUOGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZGUOGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 10:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZGUOGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 10:06:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34547 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZGUOGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 10:06:15 -0400
From: "A, Raghu" <raghu.a@ti.com>
To: "pierre@ossman.eu" <pierre@ossman.eu>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Dasgupta, Romit" <romit@ti.com>
Date: Tue, 21 Jul 2009 19:35:55 +0530
Subject: Restoring back the system state from MMC after a successful
 hibernation
Thread-Topic: Restoring back the system state from MMC after a successful
 hibernation
Thread-Index: AcoKDF1gLwtznDWFTOmjlTMBpvE+mQ==
Message-ID: <2A3DCF3DA181AD40BDE86A3150B27B6B02F1B9BF4C@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I am trying a hibernate-restore procedure on my system, wherein I store the context image on a swap partition on a MMC device (/dev/mmcblk0). The hibernation process happens smoothly. However, when I try to restore back, after including "resume = /dev/mmcblk0" in the bootargs, I find that the MMC card does not get detected by the time late_initcall(software_resume) is called, as a result of which the restore does not happen.

To resolve the problem, I have included a mmc_flush_scheduled_work() call immediately after the mmc_detect_change(host, 0) call in mmc_start_host(struct mmc_host *host) function defined in linux/drivers/mmc/core/core.c, so that instead of mmc_rescan happening sometime later, it now happens right away, and the MMC card gets detected at the end of the host's .probe() callback itself.

/*****

void mmc_start_host(struct mmc_host *host)

{
        mmc_power_off(host);
        mmc_detect_change(host, 0);
        mmc_flush_scheduled_work();
}

The host's probe() routine calls mmc_add_host , which in turn calls mmc_start_host.

*****/

Is this approach correct? Or is there any other way I can get the MMC card detected before late_initcall(software_resume) happens?

Kindly CC the reply to me as I am not a part of the linux kernel mailing list.

Thanks and Regards
Raghu A.
