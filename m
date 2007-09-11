Return-Path: <linux-kernel-owner+w=401wt.eu-S1764911AbXIKVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764911AbXIKVKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763527AbXIKVKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:10:33 -0400
Received: from 251.4.221.87.dynamic.jazztel.es ([87.221.4.251]:58199 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753176AbXIKVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:10:32 -0400
Date: Tue, 11 Sep 2007 23:10:35 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: perex@suse.cz, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/4] Intel HD Audio: Use list_for_each_entry(_safe)
Message-ID: <20070911211035.GI8592@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	perex@suse.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070911205632.GF8592@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911205632.GF8592@traven>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel HD Audio: Use list_for_each_entry(_safe) instead of
list_for_each(_safe)

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 000287f..5a96a8a 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -88,13 +88,12 @@ struct hda_gspec {
 static void snd_hda_generic_free(struct hda_codec *codec)
 {
 	struct hda_gspec *spec = codec->spec;
-	struct list_head *p, *n;
+	struct hda_gnode *node, *n;
 
 	if (! spec)
 		return;
 	/* free all widgets */
-	list_for_each_safe(p, n, &spec->nid_list) {
-		struct hda_gnode *node = list_entry(p, struct hda_gnode, list);
+	list_for_each_entry_safe(node, n, &spec->nid_list, list) {
 		if (node->conn_list != node->slist)
 			kfree(node->conn_list);
 		kfree(node);
@@ -196,11 +195,9 @@ static int build_afg_tree(struct hda_codec *codec)
 /* FIXME: should avoid the braindead linear search */
 static struct hda_gnode *hda_get_node(struct hda_gspec *spec, hda_nid_t nid)
 {
-	struct list_head *p;
 	struct hda_gnode *node;
 
-	list_for_each(p, &spec->nid_list) {
-		node = list_entry(p, struct hda_gnode, list);
+	list_for_each_entry(node, &spec->nid_list, list) {
 		if (node->nid == nid)
 			return node;
 	}
@@ -256,11 +253,9 @@ static int select_input_connection(struct hda_codec *codec, struct hda_gnode *no
  */
 static void clear_check_flags(struct hda_gspec *spec)
 {
-	struct list_head *p;
 	struct hda_gnode *node;
 
-	list_for_each(p, &spec->nid_list) {
-		node = list_entry(p, struct hda_gnode, list);
+	list_for_each_entry(node, &spec->nid_list, list) {
 		node->checked = 0;
 	}
 }
@@ -343,12 +338,10 @@ static struct hda_gnode *parse_output_jack(struct hda_codec *codec,
 					   struct hda_gspec *spec,
 					   int jack_type)
 {
-	struct list_head *p;
 	struct hda_gnode *node;
 	int err;
 
-	list_for_each(p, &spec->nid_list) {
-		node = list_entry(p, struct hda_gnode, list);
+	list_for_each_entry(node, &spec->nid_list, list) {
 		if (node->type != AC_WID_PIN)
 			continue;
 		/* output capable? */
@@ -659,7 +652,6 @@ static int parse_input_path(struct hda_codec *codec, struct hda_gnode *adc_node)
 static int parse_input(struct hda_codec *codec)
 {
 	struct hda_gspec *spec = codec->spec;
-	struct list_head *p;
 	struct hda_gnode *node;
 	int err;
 
@@ -668,8 +660,7 @@ static int parse_input(struct hda_codec *codec)
 	 * If it reaches to certain input PINs, we take it as the
 	 * input path.
 	 */
-	list_for_each(p, &spec->nid_list) {
-		node = list_entry(p, struct hda_gnode, list);
+	list_for_each_entry(node, &spec->nid_list, list) {
 		if (node->wid_caps & AC_WCAP_DIGITAL)
 			continue; /* skip SPDIF */
 		if (node->type == AC_WID_AUD_IN) {
@@ -911,7 +902,6 @@ static int parse_loopback_path(struct hda_codec *codec, struct hda_gspec *spec,
 static int build_loopback_controls(struct hda_codec *codec)
 {
 	struct hda_gspec *spec = codec->spec;
-	struct list_head *p;
 	struct hda_gnode *node;
 	int err;
 	const char *type;
@@ -919,8 +909,7 @@ static int build_loopback_controls(struct hda_codec *codec)
 	if (! spec->out_pin_node[0])
 		return 0;
 
-	list_for_each(p, &spec->nid_list) {
-		node = list_entry(p, struct hda_gnode, list);
+	list_for_each_entry(node, &spec->nid_list, list) {
 		if (node->type != AC_WID_PIN)
 			continue;
 		/* input capable? */
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 92bc8b3..f3ce158 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1322,7 +1322,6 @@ static int __devinit create_codec_pcm(struct azx *chip, struct hda_codec *codec,
 
 static int __devinit azx_pcm_create(struct azx *chip)
 {
-	struct list_head *p;
 	struct hda_codec *codec;
 	int c, err;
 	int pcm_dev;
@@ -1332,8 +1331,7 @@ static int __devinit azx_pcm_create(struct azx *chip)
 
 	/* create audio PCMs */
 	pcm_dev = 0;
-	list_for_each(p, &chip->bus->codec_list) {
-		codec = list_entry(p, struct hda_codec, list);
+	list_for_each_entry(codec, &chip->bus->codec_list, list) {
 		for (c = 0; c < codec->num_pcms; c++) {
 			if (codec->pcm_info[c].is_modem)
 				continue; /* create later */
@@ -1350,8 +1348,7 @@ static int __devinit azx_pcm_create(struct azx *chip)
 
 	/* create modem PCMs */
 	pcm_dev = AZX_MAX_AUDIO_PCMS;
-	list_for_each(p, &chip->bus->codec_list) {
-		codec = list_entry(p, struct hda_codec, list);
+	list_for_each_entry(codec, &chip->bus->codec_list, list) {
 		for (c = 0; c < codec->num_pcms; c++) {
 			if (! codec->pcm_info[c].is_modem)
 				continue; /* already created */


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    C treats you like a consenting adult. Pascal treats you like a
          naughty child. Ada treats you like a criminal
                      (Bruce Powel Douglass)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
