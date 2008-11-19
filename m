Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbYKSXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYKSXAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYKSXAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:00:21 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:19297 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbYKSXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:00:19 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAAMpJElR9dDu/2dsb2JhbACBbdEhgnk
Date: Thu, 20 Nov 2008 00:00:14 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [WATCHDOG] [hpwdt] Set the mapped BIOS address space as executable
Message-ID: <20081119230014.GC30873@infomag.infomag.iguana.be>
References: <1226674023-5374-1-git-send-email-bwalle@suse.de> <20081118143015.72af31d3.akpm@linux-foundation.org> <20081118233229.294270fb@kopernikus.site> <183C1D5A376DE343AA8F94FC2A1EC1493AA5CEE7AB@GVW1091EXB.americas.hpqcorp.net> <20081119093041.1af8fd7e.akpm@linux-foundation.org> <20081119183444.56b342cb@hale.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119183444.56b342cb@hale.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> * Andrew Morton [2008-11-19 09:30]:
> > > 
> > 
> > (top-posting repaired.  Please don't top-post!)
> > 
> > I haven't seen any patch which alters hpwdt_pretimeout() and there is
> > no such patch in linux-next.  Perhaps it got lost?

This was the patch (see below). It's in the linux-2.6-watchdog-next tree now,
so it should go into the linux-next tree soon.

The other patch is in the linux-2.6-watchdog-next tree also.

Kind regards,
Wim.

----------------------------------------------------------
commit ed22ea64f9efe4531be5130c0f77130c2ad74130
Author: Bernhard Walle <bwalle@suse.de>
Date:   Sun Oct 26 15:59:37 2008 +0100

    [WATCHDOG] hpwdt: Fix kdump when using hpwdt
    
    When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
    opened), then kdump does not work. The panic kernel either does not start at
    all or crash in various places.
    
    The problem is that hpwdt_pretimeout is registered with register_die_notifier()
    with the highest possible priority. Because it returns NOTIFY_STOP, the
    crash_nmi_callback which is also registered with register_die_notifier()
    is never executed. This causes the shutdown of other CPUs to fail.
    
    Reverting the order is no option: The crash_nmi_callback executes HLT
    and so never returns normally. Because of that, it must be executed as
    last notifier, which currently is done.
    
    So, that patch returns NOTIFY_OK in case allow_kdump is set as module parameter
    in the hpwdt module. Also, it changes the default of allow_kdump to 1. Kdump is
    quite common and should be working as default.
    
    Signed-off-by: Bernhard Walle <bwalle@suse.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Cc: Vivek Goyal <vgoyal@redhat.com>

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index f6cff7b..e83e1ac 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -117,7 +117,7 @@ static unsigned int reload;			/* the computed soft_margin */
 static int nowayout = WATCHDOG_NOWAYOUT;
 static char expect_release;
 static unsigned long hpwdt_is_open;
-static unsigned int allow_kdump;
+static unsigned int allow_kdump = 1;
 
 static void __iomem *pci_mem_addr;		/* the PCI-memory address */
 static unsigned long __iomem *hpwdt_timer_reg;
@@ -485,7 +485,11 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 			"Management Log for details.\n");
 	}
 
-	return NOTIFY_STOP;
+	/*
+	 * for kdump, we must return NOTIFY_OK here to execute the
+	 * crash_nmi_callback afterwards, see arch/x86/kernel/crash.c
+	 */
+	return allow_kdump ? NOTIFY_OK : NOTIFY_STOP;
 }
 
 /*
