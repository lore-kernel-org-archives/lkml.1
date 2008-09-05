Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYIEKY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYIEKY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYIEKVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:21:40 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36516 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbYIEKVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:21:32 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="59089267"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 7/9] ASoC: Blackfin: board driver for AD1980/1 audio codec
Date: Fri,  5 Sep 2008 18:21:40 +0800
Message-Id: <1220610102-7716-8-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-ad1980.c |  113 +++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/bf5xx-ad1980.c

diff --git a/sound/soc/blackfin/bf5xx-ad1980.c b/sound/soc/blackfin/bf5xx-ad1980.c
new file mode 100644
index 0000000..124425d
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ad1980.c
@@ -0,0 +1,113 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-ad1980.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Board driver for AD1980/1 audio codec
+ *
+ * Modified:
+ *               Copyright 2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <asm/dma.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+
+#include <linux/gpio.h>
+#include <asm/portmux.h>
+
+#include "../codecs/ad1980.h"
+#include "bf5xx-sport.h"
+#include "bf5xx-ac97-pcm.h"
+#include "bf5xx-ac97.h"
+
+static struct snd_soc_machine bf5xx_board;
+
+static int bf5xx_board_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
+
+	pr_debug("%s enter\n", __func__);
+	cpu_dai->private_data = sport_handle;
+	return 0;
+}
+
+static struct snd_soc_ops bf5xx_board_ops = {
+	.startup = bf5xx_board_startup,
+};
+
+static struct snd_soc_dai_link bf5xx_board_dai = {
+	.name = "AC97",
+	.stream_name = "AC97 HiFi",
+	.cpu_dai = &bfin_ac97_dai,
+	.codec_dai = &ad1980_dai,
+	.ops = &bf5xx_board_ops,
+};
+
+static struct snd_soc_machine bf5xx_board = {
+	.name = "bf5xx-board",
+	.dai_link = &bf5xx_board_dai,
+	.num_links = 1,
+};
+
+static struct snd_soc_device bf5xx_board_snd_devdata = {
+	.machine = &bf5xx_board,
+	.platform = &bf5xx_ac97_soc_platform,
+	.codec_dev = &soc_codec_dev_ad1980,
+};
+
+static struct platform_device *bf5xx_board_snd_device;
+
+static int __init bf5xx_board_init(void)
+{
+	int ret;
+
+	bf5xx_board_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!bf5xx_board_snd_device)
+		return -ENOMEM;
+
+	platform_set_drvdata(bf5xx_board_snd_device, &bf5xx_board_snd_devdata);
+	bf5xx_board_snd_devdata.dev = &bf5xx_board_snd_device->dev;
+	ret = platform_device_add(bf5xx_board_snd_device);
+
+	if (ret)
+		platform_device_put(bf5xx_board_snd_device);
+
+	return ret;
+}
+
+static void __exit bf5xx_board_exit(void)
+{
+	platform_device_unregister(bf5xx_board_snd_device);
+}
+
+module_init(bf5xx_board_init);
+module_exit(bf5xx_board_exit);
+
+/* Module information */
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("ALSA SoC AD1980/1 BF5xx board");
+MODULE_LICENSE("GPL");
-- 
1.5.6
