Return-Path: <linux-kernel-owner+w=401wt.eu-S1764143AbYEFPfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764143AbYEFPfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYEFPfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:35:06 -0400
Received: from slow2-v.mail.gandi.net ([217.70.178.89]:51354 "EHLO
	slow2-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYEFPfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:35:04 -0400
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 11:35:04 EDT
Date: Tue, 6 May 2008 17:23:54 +0200
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: j@w1.fi
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH] hostap: procfs fix for hostap_fw.c
Message-ID: <20080506152354.GA3680@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>, j@w1.fi,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hello,

I've been toying with hostap_pci and found a bug that is triggered when
you unload/reload the module.

If you don't have PRISM2_NO_PROCFS_DEBUG defined (which is the default,
as per hostap_config.h), the driver creates a "registers" file in /proc
used to dump PRISM registers (function prism2_init_local_data):

#ifndef PRISM2_NO_PROCFS_DEBUG
        create_proc_read_entry("registers", 0, local->proc,
                               prism2_registers_proc_read, local);
#endif /* PRISM2_NO_PROCFS_DEBUG */

Note that create_proc_read_entry is being called with local->proc which
isn't defined at the time: "registers" ends up being created as
/proc/registers.

When hostap_pci is done initializing the hardware, it calls
hostap_hw_ready which in turns creates all the files in /proc through
hostap_init_proc (hostap_proc.c):

        local->proc = NULL;

        if (hostap_proc == NULL) {
                printk(KERN_WARNING "%s: hostap proc directory not created\n",
                       local->dev->name);
                return;
        }

        local->proc = proc_mkdir(local->ddev->name, hostap_proc);

So far so good, well sort of...  When you unload the module,
prism2_free_local_data does this:

#ifndef PRISM2_NO_PROCFS_DEBUG
        if (local->proc != NULL)
                remove_proc_entry("registers", local->proc);
#endif /* PRISM2_NO_PROCFS_DEBUG */
        hostap_remove_proc(local);

Problem is local->proc has now been overwritten by hostap_init_proc
meaning "registers" isn't removed.  When you reload the module you get
an error telling you "registers" already exists (and you then get
duplicate "registers" files in /proc).

So in a nutshell "registers" should be created after calling
hostap_init_proc (this way it'll be created where it belongs -
/proc/net/hostap/%s) making it removable at module unload.

Please apply the patch below which does just that: it creates "register"
in hostap_hw_ready right after creating all the proc entries.

Best,
Mathieu

Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>

diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 7be68db..454fcb4 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -3276,11 +3276,6 @@ while (0)
 	}
 	printk(KERN_INFO "%s: Registered netdevice %s\n", dev_info, dev->name);
 
-#ifndef PRISM2_NO_PROCFS_DEBUG
-	create_proc_read_entry("registers", 0, local->proc,
-			       prism2_registers_proc_read, local);
-#endif /* PRISM2_NO_PROCFS_DEBUG */
-
 	hostap_init_data(local);
 	return dev;
 
@@ -3307,6 +3302,10 @@ static int hostap_hw_ready(struct net_device *dev)
 			netif_carrier_off(local->ddev);
 		}
 		hostap_init_proc(local);
+#ifndef PRISM2_NO_PROCFS_DEBUG
+		create_proc_read_entry("registers", 0, local->proc,
+				prism2_registers_proc_read, local);
+#endif /* PRISM2_NO_PROCFS_DEBUG */
 		hostap_init_ap_proc(local);
 		return 0;
 	}
-- 
Mathieu Chouquet-Stringer                         mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
