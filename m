Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbXH2Ppg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbXH2Ppg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXH2Pp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:45:28 -0400
Received: from hydra.rus.uni-stuttgart.de ([129.69.1.55]:9881 "EHLO
	hydra.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbXH2Pp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:45:27 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2007 11:45:26 EDT
X-Spam-Flag: NO
X-Spam-Score: -2.599
Date: Wed, 29 Aug 2007 17:34:19 +0200
From: Thomas Richter <rusricht@po2.uni-stuttgart.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] snd_hda_intel for F/S T4210
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Message-ID: <auto-000088556249@uni-stuttgart.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

the patch below, to be applied to sound/pci/hda/patch_sigmatel.c fixes the audio
output on the Fujiutsu/Siemens lifebook T4210 (and probably on others). It is
suitable for the kernel 2.6.23-rc4 (and probably others).

Without the patch, audio fails and the hda driver fails to load with

No available DAC for pin 0x0

However, the indicated pin has no connections in first place and thus should be ignored.
With the patch applied audio output works fine.

Here's the patch:

/* snip */
--- patch_sigmatel_old.c        2007-08-29 17:17:51.000000000 +0200
+++ patch_sigmatel.c    2007-08-29 17:21:25.000000000 +0200
@@ -1250,6 +1250,16 @@
                nid = cfg->line_out_pins[i];
                conn_len = snd_hda_get_connections(codec, nid, conn,
                                                   HDA_MAX_CONNECTIONS);
+               /* FIX THOR: For some hardware (notably the Fujiutsu/Siemens T4210
+               ** lifebook), we have nids with no pins whatsoever. Ignore
+               ** them.
+               */
+               if (conn_len == 0) {
+                 snd_printk(KERN_ERR "%s: Found zero connections for pin 0x%0x "
+                            "ignoring it.\n",__func__,nid);
+                 continue;
+               }
+
                for (j = 0; j < conn_len; j++) {
                        wcaps = snd_hda_param_read(codec, conn[j],
                                                   AC_PAR_AUDIO_WIDGET_CAP);
/* snip */

Greetings,
	Thomas
