Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYB1A6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYB1A6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761659AbYB1A42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:28 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:41507 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761567AbYB1A41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HJaJNl4HvRP8EkD8xkrhzSLvqOKFA+rB7LotMuFvShWwSzUovFngBiRjSSs2tWrlUzJbIaUWigm4RMmYN8uPCq8chh46i0i/67H2xhzPGH/yQUEBxBv0/OgKEmZkMs/2+PUjysMD1bYqZGmCp/DBcrmym+cHS6AXeNNNSuUAZ1Q=
Subject: [PATCH 09/12] sound: ali5451.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:08 -0800
Message-Id: <1204160168.20280.57.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable is used to test for whether or not spdif should be enabled,
change to spdif_enable.

sound/pci/ali5451/ali5451.c:1812:15: warning: symbol 'enable' shadows an earlier one
sound/pci/ali5451/ali5451.c:63:12: originally declared here
sound/pci/ali5451/ali5451.c:1840:27: warning: symbol 'enable' shadows an earlier one
sound/pci/ali5451/ali5451.c:63:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ali5451/ali5451.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 6a905ed..fc04d3d 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -1809,26 +1809,26 @@ static int snd_ali5451_spdif_get(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_ali *codec = kcontrol->private_data;
-	unsigned int enable;
+	unsigned int spdif_enable;
 
-	enable = ucontrol->value.integer.value[0] ? 1 : 0;
+	spdif_enable = ucontrol->value.integer.value[0] ? 1 : 0;
 
 	spin_lock_irq(&codec->reg_lock);
 	switch (kcontrol->private_value) {
 	case 0:
-		enable = (codec->spdif_mask & 0x02) ? 1 : 0;
+		spdif_enable = (codec->spdif_mask & 0x02) ? 1 : 0;
 		break;
 	case 1:
-		enable = ((codec->spdif_mask & 0x02) &&
+		spdif_enable = ((codec->spdif_mask & 0x02) &&
 			  (codec->spdif_mask & 0x04)) ? 1 : 0;
 		break;
 	case 2:
-		enable = (codec->spdif_mask & 0x01) ? 1 : 0;
+		spdif_enable = (codec->spdif_mask & 0x01) ? 1 : 0;
 		break;
 	default:
 		break;
 	}
-	ucontrol->value.integer.value[0] = enable;
+	ucontrol->value.integer.value[0] = spdif_enable;
 	spin_unlock_irq(&codec->reg_lock);
 	return 0;
 }
@@ -1837,17 +1837,17 @@ static int snd_ali5451_spdif_put(struct snd_kcontrol *kcontrol,
 				 struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_ali *codec = kcontrol->private_data;
-	unsigned int change = 0, enable = 0;
+	unsigned int change = 0, spdif_enable = 0;
 
-	enable = ucontrol->value.integer.value[0] ? 1 : 0;
+	spdif_enable = ucontrol->value.integer.value[0] ? 1 : 0;
 
 	spin_lock_irq(&codec->reg_lock);
 	switch (kcontrol->private_value) {
 	case 0:
 		change = (codec->spdif_mask & 0x02) ? 1 : 0;
-		change = change ^ enable;
+		change = change ^ spdif_enable;
 		if (change) {
-			if (enable) {
+			if (spdif_enable) {
 				codec->spdif_mask |= 0x02;
 				snd_ali_enable_spdif_out(codec);
 			} else {
@@ -1859,9 +1859,9 @@ static int snd_ali5451_spdif_put(struct snd_kcontrol *kcontrol,
 		break;
 	case 1: 
 		change = (codec->spdif_mask & 0x04) ? 1 : 0;
-		change = change ^ enable;
+		change = change ^ spdif_enable;
 		if (change && (codec->spdif_mask & 0x02)) {
-			if (enable) {
+			if (spdif_enable) {
 				codec->spdif_mask |= 0x04;
 				snd_ali_enable_spdif_chnout(codec);
 			} else {
@@ -1872,9 +1872,9 @@ static int snd_ali5451_spdif_put(struct snd_kcontrol *kcontrol,
 		break;
 	case 2:
 		change = (codec->spdif_mask & 0x01) ? 1 : 0;
-		change = change ^ enable;
+		change = change ^ spdif_enable;
 		if (change) {
-			if (enable) {
+			if (spdif_enable) {
 				codec->spdif_mask |= 0x01;
 				snd_ali_enable_spdif_in(codec);
 			} else {
-- 
1.5.4.3.342.g99e8


