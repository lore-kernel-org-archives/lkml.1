Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0BFPuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 10:50:32 -0500
Received: from mout.perfora.net ([74.208.4.195]:54421 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0BFPub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 10:50:31 -0500
Message-ID: <4B6D8ED2.5060107@nctritech.com>
Date: Sat, 06 Feb 2010 10:46:26 -0500
From: "Jody@Tritech" <jody@nctritech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] hda-intel: Avoid divide by zero crash
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/52/hn0vgyGkiniOiGbx/rAffJiFUYn2NDWPs
 uezQ0Lwk3nRXlZKPT9OiXl29oe6zSPD2YNaFpkyydYFYt8CXMO
 9X/YXAeUOgHnYmIxNFevn/BxOWqgvQpHxR6ei6j9dI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my AMD780V chipset, hda_intel.c can crash the kernel with a divide by 
zero
for as-yet unknown reasons. A simple check for zero prevents it, though
the problem that causes it remains. Since the workaround is harmless and
won't affect anyone except victims of this bug, it should be safe; 
moreover,
because this crash can be triggered by a user-mode application, there are
denial of service implications on the systems affected by the bug without
the patch.
Signed-off-by: Jody Bruchon <jody@nctritech.com>
--- linux-2.6.33-rc6/sound/pci/hda/hda_intel.c  2010-01-29 
16:57:50.000000000 -0500
+++ linux-2.6.33-rc6-fix/sound/pci/hda/hda_intel.c      2010-02-06 
09:44:10.028348166 -0500
@@ -1878,6 +1878,12 @@

         if (!bdl_pos_adj[chip->dev_index])
                 return 1; /* no delayed ack */
+       if (azx_dev->period_bytes == 0) {
+               printk(KERN_WARNING
+                       "hda-intel: Divide by zero was avoided "
+                       "in azx_dev->period_bytes.\n");
+               return 0;
+       }
         if (pos % azx_dev->period_bytes > azx_dev->period_bytes / 2)
                 return 0; /* NG - it's below the period boundary */
         return 1; /* OK, it's fine */

