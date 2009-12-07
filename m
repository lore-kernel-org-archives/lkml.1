Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbZLGAZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbZLGAZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZLGANU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:20 -0500
Received: from kroah.org ([198.145.64.141]:34429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486AbZLGANL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:49 2009
Message-Id: <20091207000649.602354316@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [053/119] ASoC: Fix suspend with active audio streams
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=asoc-fix-suspend-with-active-audio-streams.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 50b6bce59d154b5db137907a5c0ed45a4e7a3829 upstream.

When we get a stream suspend event force the power down since otherwise
the stream would remain marked as active.  In future we'll probably want
to make this stream-specific and add an interface to make the power down
of other widgets optional in order to support leaving bypass paths
active while suspending the processor.

Reported-by: Joonyoung Shim <jy0922.shim@samsung.com>
Tested-by: Joonyoung Shim <jy0922.shim@samsung.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/soc-dapm.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -774,9 +774,19 @@ static int dapm_power_widgets(struct snd
 			if (!w->power_check)
 				continue;
 
-			power = w->power_check(w);
-			if (power)
-				sys_power = 1;
+			/* If we're suspending then pull down all the
+			 * power. */
+			switch (event) {
+			case SND_SOC_DAPM_STREAM_SUSPEND:
+				power = 0;
+				break;
+
+			default:
+				power = w->power_check(w);
+				if (power)
+					sys_power = 1;
+				break;
+			}
 
 			if (w->power == power)
 				continue;


