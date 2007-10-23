Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXJWVNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXJWVNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbXJWVMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:12:54 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:53523 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbXJWVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:12:51 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/4] sound: Use stringbuf
Date: Tue, 23 Oct 2007 17:12:45 -0400
Message-Id: <1193173966-3550-3-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193173966-3550-2-git-send-email-matthew@wil.cx>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
 <1193173966-3550-2-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sound/ had its own snd_info_buffer for doing proc reads, which can be
profitably replaced with stringbuf.  It actually finds a bug since ->read
and ->write now have a different signature.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/sound/info.h                    |    7 ++-
 sound/core/hwdep.c                      |    2 +-
 sound/core/info.c                       |   81 +++++--------------------------
 sound/core/info_oss.c                   |    6 +-
 sound/core/init.c                       |    8 ++--
 sound/core/oss/mixer_oss.c              |    2 +-
 sound/core/oss/pcm_oss.c                |    2 +-
 sound/core/pcm.c                        |   16 +++---
 sound/core/pcm_memory.c                 |    4 +-
 sound/core/rawmidi.c                    |    2 +-
 sound/core/seq/oss/seq_oss.c            |    2 +-
 sound/core/seq/oss/seq_oss_device.h     |    8 ++--
 sound/core/seq/oss/seq_oss_init.c       |    2 +-
 sound/core/seq/oss/seq_oss_midi.c       |    2 +-
 sound/core/seq/oss/seq_oss_readq.c      |    2 +-
 sound/core/seq/oss/seq_oss_synth.c      |    2 +-
 sound/core/seq/seq_clientmgr.c          |    8 ++--
 sound/core/seq/seq_device.c             |    2 +-
 sound/core/seq/seq_info.c               |    2 +-
 sound/core/seq/seq_info.h               |    6 +-
 sound/core/seq/seq_memory.c             |    2 +-
 sound/core/seq/seq_queue.c              |    2 +-
 sound/core/seq/seq_timer.c              |    2 +-
 sound/core/sound.c                      |    2 +-
 sound/core/sound_oss.c                  |    2 +-
 sound/core/timer.c                      |    2 +-
 sound/drivers/vx/vx_core.c              |    2 +-
 sound/i2c/l3/uda1341.c                  |    4 +-
 sound/isa/ad1848/ad1848_lib.c           |    2 +-
 sound/isa/gus/gus_irq.c                 |    2 +-
 sound/isa/gus/gus_mem.c                 |    4 +-
 sound/isa/opti9xx/miro.c                |    2 +-
 sound/isa/sb/sb16_csp.c                 |    4 +-
 sound/pci/ac97/ac97_proc.c              |   12 ++--
 sound/pci/ac97/ak4531_codec.c           |    2 +-
 sound/pci/ad1889.c                      |    2 +-
 sound/pci/ali5451/ali5451.c             |    2 +-
 sound/pci/atiixp.c                      |    2 +-
 sound/pci/atiixp_modem.c                |    2 +-
 sound/pci/ca0106/ca0106_proc.c          |   17 +++----
 sound/pci/cmipci.c                      |    2 +-
 sound/pci/cs4281.c                      |    2 +-
 sound/pci/cs46xx/dsp_spos.c             |   14 +++---
 sound/pci/cs46xx/dsp_spos_scb_lib.c     |    4 +-
 sound/pci/emu10k1/emu10k1x.c            |    2 +-
 sound/pci/emu10k1/emuproc.c             |   28 +++++-----
 sound/pci/ens1370.c                     |    2 +-
 sound/pci/hda/hda_proc.c                |   16 +++---
 sound/pci/ice1712/ice1712.c             |    2 +-
 sound/pci/ice1712/ice1724.c             |    2 +-
 sound/pci/ice1712/pontis.c              |    4 +-
 sound/pci/intel8x0.c                    |    2 +-
 sound/pci/intel8x0m.c                   |    2 +-
 sound/pci/korg1212/korg1212.c           |    2 +-
 sound/pci/mixart/mixart.c               |    2 +-
 sound/pci/pcxhr/pcxhr.c                 |    4 +-
 sound/pci/riptide/riptide.c             |    2 +-
 sound/pci/rme32.c                       |    2 +-
 sound/pci/rme96.c                       |    2 +-
 sound/pci/rme9652/hdsp.c                |    2 +-
 sound/pci/rme9652/hdspm.c               |    6 +-
 sound/pci/rme9652/rme9652.c             |    2 +-
 sound/pci/sonicvibes.c                  |    2 +-
 sound/pci/trident/trident_main.c        |    2 +-
 sound/pci/via82xx.c                     |    2 +-
 sound/pci/via82xx_modem.c               |    2 +-
 sound/pci/ymfpci/ymfpci_main.c          |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_core.c |    2 +-
 sound/sparc/dbri.c                      |    4 +-
 sound/synth/emux/emux_proc.c            |    2 +-
 sound/usb/usbaudio.c                    |   10 ++--
 sound/usb/usbmixer.c                    |    2 +-
 72 files changed, 158 insertions(+), 215 deletions(-)

diff --git a/include/sound/info.h b/include/sound/info.h
index fecbb1f..4066355 100644
--- a/include/sound/info.h
+++ b/include/sound/info.h
@@ -23,6 +23,7 @@
  */
 
 #include <linux/poll.h>
+#include <linux/stringbuf.h>
 
 /* buffer for information */
 struct snd_info_buffer {
@@ -40,7 +41,7 @@ struct snd_info_buffer {
 struct snd_info_entry;
 
 struct snd_info_entry_text {
-	void (*read) (struct snd_info_entry *entry, struct snd_info_buffer *buffer);
+	void (*read) (struct snd_info_entry *entry, struct stringbuf *buffer);
 	void (*write) (struct snd_info_entry *entry, struct snd_info_buffer *buffer);
 };
 
@@ -104,7 +105,7 @@ extern struct snd_info_entry *snd_oss_root;
 #define snd_oss_root NULL
 #endif
 
-int snd_iprintf(struct snd_info_buffer * buffer, char *fmt,...) __attribute__ ((format (printf, 2, 3)));
+#define snd_iprintf(buffer, fmt, args...) sb_printf(buffer, fmt , ## args)
 int snd_info_init(void);
 int snd_info_done(void);
 
@@ -131,7 +132,7 @@ int snd_card_proc_new(struct snd_card *card, const char *name, struct snd_info_e
 
 static inline void snd_info_set_text_ops(struct snd_info_entry *entry, 
 					 void *private_data,
-					 void (*read)(struct snd_info_entry *, struct snd_info_buffer *))
+					 void (*read)(struct snd_info_entry *, struct stringbuf *))
 {
 	entry->private_data = private_data;
 	entry->c.text.read = read;
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index bfd9d18..908e6ca 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -463,7 +463,7 @@ static int snd_hwdep_dev_disconnect(struct snd_device *device)
  */
 
 static void snd_hwdep_proc_read(struct snd_info_entry *entry,
-				struct snd_info_buffer *buffer)
+				struct stringbuf *buffer)
 {
 	struct snd_hwdep *hwdep;
 
diff --git a/sound/core/info.c b/sound/core/info.c
index 1ffd29b..f3562e8 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -70,7 +70,7 @@ int snd_info_check_reserved_words(const char *str)
 static DEFINE_MUTEX(info_mutex);
 
 struct snd_info_private_data {
-	struct snd_info_buffer *rbuffer;
+	struct stringbuf rbuffer;
 	struct snd_info_buffer *wbuffer;
 	struct snd_info_entry *entry;
 	void *file_private_data;
@@ -99,49 +99,6 @@ static int resize_info_buffer(struct snd_info_buffer *buffer,
 	return 0;
 }
 
-/**
- * snd_iprintf - printf on the procfs buffer
- * @buffer: the procfs buffer
- * @fmt: the printf format
- *
- * Outputs the string on the procfs buffer just like printf().
- *
- * Returns the size of output string.
- */
-int snd_iprintf(struct snd_info_buffer *buffer, char *fmt,...)
-{
-	va_list args;
-	int len, res;
-	int err = 0;
-
-	might_sleep();
-	if (buffer->stop || buffer->error)
-		return 0;
-	len = buffer->len - buffer->size;
-	va_start(args, fmt);
-	for (;;) {
-		va_list ap;
-		va_copy(ap, args);
-		res = vsnprintf(buffer->buffer + buffer->curr, len, fmt, ap);
-		va_end(ap);
-		if (res < len)
-			break;
-		err = resize_info_buffer(buffer, buffer->len + PAGE_SIZE);
-		if (err < 0)
-			break;
-		len = buffer->len - buffer->size;
-	}
-	va_end(args);
-
-	if (err < 0)
-		return err;
-	buffer->curr += res;
-	buffer->size += res;
-	return res;
-}
-
-EXPORT_SYMBOL(snd_iprintf);
-
 /*
 
  */
@@ -212,7 +169,7 @@ static ssize_t snd_info_entry_read(struct file *file, char __user *buffer,
 {
 	struct snd_info_private_data *data;
 	struct snd_info_entry *entry;
-	struct snd_info_buffer *buf;
+	struct stringbuf *buf;
 	size_t size = 0;
 	loff_t pos;
 
@@ -226,14 +183,13 @@ static ssize_t snd_info_entry_read(struct file *file, char __user *buffer,
 	entry = data->entry;
 	switch (entry->content) {
 	case SNDRV_INFO_CONTENT_TEXT:
-		buf = data->rbuffer;
-		if (buf == NULL)
-			return -EIO;
-		if (pos >= buf->size)
+		buf = &data->rbuffer;
+		size = sb_len(buf);
+		if (pos >= size)
 			return 0;
-		size = buf->size - pos;
+		size -= pos;
 		size = min(count, size);
-		if (copy_to_user(buffer, buf->buffer + pos, size))
+		if (copy_to_user(buffer, sb_string(buf) + pos, size))
 			return -EFAULT;
 		break;
 	case SNDRV_INFO_CONTENT_DATA:
@@ -340,14 +296,7 @@ static int snd_info_entry_open(struct inode *inode, struct file *file)
 	switch (entry->content) {
 	case SNDRV_INFO_CONTENT_TEXT:
 		if (mode == O_RDONLY || mode == O_RDWR) {
-			buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
-			if (buffer == NULL)
-				goto __nomem;
-			data->rbuffer = buffer;
-			buffer->len = PAGE_SIZE;
-			buffer->buffer = kmalloc(buffer->len, GFP_KERNEL);
-			if (buffer->buffer == NULL)
-				goto __nomem;
+			sb_init(&data->rbuffer);
 		}
 		if (mode == O_WRONLY || mode == O_RDWR) {
 			buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
@@ -376,17 +325,14 @@ static int snd_info_entry_open(struct inode *inode, struct file *file)
 	    (mode == O_RDONLY || mode == O_RDWR)) {
 		if (entry->c.text.read) {
 			mutex_lock(&entry->access);
-			entry->c.text.read(entry, data->rbuffer);
+			entry->c.text.read(entry, &data->rbuffer);
 			mutex_unlock(&entry->access);
 		}
 	}
 	return 0;
 
  __nomem:
-	if (data->rbuffer) {
-		kfree(data->rbuffer->buffer);
-		kfree(data->rbuffer);
-	}
+	sb_free(&data->rbuffer);
 	if (data->wbuffer) {
 		kfree(data->wbuffer->buffer);
 		kfree(data->wbuffer);
@@ -411,10 +357,7 @@ static int snd_info_entry_release(struct inode *inode, struct file *file)
 	entry = data->entry;
 	switch (entry->content) {
 	case SNDRV_INFO_CONTENT_TEXT:
-		if (data->rbuffer) {
-			kfree(data->rbuffer->buffer);
-			kfree(data->rbuffer);
-		}
+		sb_free(&data->rbuffer);
 		if (data->wbuffer) {
 			if (entry->c.text.write) {
 				entry->c.text.write(entry, data->wbuffer);
@@ -975,7 +918,7 @@ EXPORT_SYMBOL(snd_info_register);
 
 static struct snd_info_entry *snd_info_version_entry;
 
-static void snd_info_version_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void snd_info_version_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	snd_iprintf(buffer,
 		    "Advanced Linux Sound Architecture Driver Version "
diff --git a/sound/core/info_oss.c b/sound/core/info_oss.c
index 435c939..15d3f43 100644
--- a/sound/core/info_oss.c
+++ b/sound/core/info_oss.c
@@ -66,9 +66,9 @@ int snd_oss_info_register(int dev, int num, char *string)
 
 EXPORT_SYMBOL(snd_oss_info_register);
 
-extern void snd_card_info_read_oss(struct snd_info_buffer *buffer);
+extern void snd_card_info_read_oss(struct stringbuf *buffer);
 
-static int snd_sndstat_show_strings(struct snd_info_buffer *buf, char *id, int dev)
+static int snd_sndstat_show_strings(struct stringbuf *buf, char *id, int dev)
 {
 	int idx, ok = -1;
 	char *str;
@@ -92,7 +92,7 @@ static int snd_sndstat_show_strings(struct snd_info_buffer *buf, char *id, int d
 }
 
 static void snd_sndstat_proc_read(struct snd_info_entry *entry,
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	snd_iprintf(buffer, "Sound Driver:3.8.1a-980706 (ALSA v" CONFIG_SND_VERSION " emulation code)\n");
 	snd_iprintf(buffer, "Kernel: %s %s %s %s %s\n",
diff --git a/sound/core/init.c b/sound/core/init.c
index 2cb7099..241bb94 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -50,7 +50,7 @@ EXPORT_SYMBOL(snd_mixer_oss_notify_callback);
 
 #ifdef CONFIG_PROC_FS
 static void snd_card_id_read(struct snd_info_entry *entry,
-			     struct snd_info_buffer *buffer)
+			     struct stringbuf *buffer)
 {
 	snd_iprintf(buffer, "%s\n", entry->card->id);
 }
@@ -538,7 +538,7 @@ EXPORT_SYMBOL(snd_card_register);
 static struct snd_info_entry *snd_card_info_entry;
 
 static void snd_card_info_read(struct snd_info_entry *entry,
-			       struct snd_info_buffer *buffer)
+			       struct stringbuf *buffer)
 {
 	int idx, count;
 	struct snd_card *card;
@@ -563,7 +563,7 @@ static void snd_card_info_read(struct snd_info_entry *entry,
 
 #ifdef CONFIG_SND_OSSEMUL
 
-void snd_card_info_read_oss(struct snd_info_buffer *buffer)
+void snd_card_info_read_oss(struct stringbuf *buffer)
 {
 	int idx, count;
 	struct snd_card *card;
@@ -586,7 +586,7 @@ void snd_card_info_read_oss(struct snd_info_buffer *buffer)
 #ifdef MODULE
 static struct snd_info_entry *snd_card_module_info_entry;
 static void snd_card_module_info_read(struct snd_info_entry *entry,
-				      struct snd_info_buffer *buffer)
+				      struct stringbuf *buffer)
 {
 	int idx;
 	struct snd_card *card;
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 3ace4a5..2510eab 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1088,7 +1088,7 @@ static char *oss_mixer_names[SNDRV_OSS_MAX_MIXERS] = {
  */
 
 static void snd_mixer_oss_proc_read(struct snd_info_entry *entry,
-				    struct snd_info_buffer *buffer)
+				    struct stringbuf *buffer)
 {
 	struct snd_mixer_oss *mixer = entry->private_data;
 	int i;
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index d0c4ceb..50644ee 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2768,7 +2768,7 @@ static int snd_pcm_oss_mmap(struct file *file, struct vm_area_struct *area)
  */
 
 static void snd_pcm_oss_proc_read(struct snd_info_entry *entry,
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct snd_pcm_str *pstr = entry->private_data;
 	struct snd_pcm_oss_setup *setup = pstr->oss.setup_list;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index cf9b949..ab19818 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -291,7 +291,7 @@ static const char *snd_pcm_oss_format_name(int format)
 #endif
 
 static void snd_pcm_proc_info_read(struct snd_pcm_substream *substream,
-				   struct snd_info_buffer *buffer)
+				   struct stringbuf *buffer)
 {
 	struct snd_pcm_info *info;
 	int err;
@@ -326,21 +326,21 @@ static void snd_pcm_proc_info_read(struct snd_pcm_substream *substream,
 }
 
 static void snd_pcm_stream_proc_info_read(struct snd_info_entry *entry,
-					  struct snd_info_buffer *buffer)
+					  struct stringbuf *buffer)
 {
 	snd_pcm_proc_info_read(((struct snd_pcm_str *)entry->private_data)->substream,
 			       buffer);
 }
 
 static void snd_pcm_substream_proc_info_read(struct snd_info_entry *entry,
-					     struct snd_info_buffer *buffer)
+					     struct stringbuf *buffer)
 {
 	snd_pcm_proc_info_read((struct snd_pcm_substream *)entry->private_data,
 			       buffer);
 }
 
 static void snd_pcm_substream_proc_hw_params_read(struct snd_info_entry *entry,
-						  struct snd_info_buffer *buffer)
+						  struct stringbuf *buffer)
 {
 	struct snd_pcm_substream *substream = entry->private_data;
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -373,7 +373,7 @@ static void snd_pcm_substream_proc_hw_params_read(struct snd_info_entry *entry,
 }
 
 static void snd_pcm_substream_proc_sw_params_read(struct snd_info_entry *entry,
-						  struct snd_info_buffer *buffer)
+						  struct stringbuf *buffer)
 {
 	struct snd_pcm_substream *substream = entry->private_data;
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -398,7 +398,7 @@ static void snd_pcm_substream_proc_sw_params_read(struct snd_info_entry *entry,
 }
 
 static void snd_pcm_substream_proc_status_read(struct snd_info_entry *entry,
-					       struct snd_info_buffer *buffer)
+					       struct stringbuf *buffer)
 {
 	struct snd_pcm_substream *substream = entry->private_data;
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -429,7 +429,7 @@ static void snd_pcm_substream_proc_status_read(struct snd_info_entry *entry,
 
 #ifdef CONFIG_SND_PCM_XRUN_DEBUG
 static void snd_pcm_xrun_debug_read(struct snd_info_entry *entry,
-				    struct snd_info_buffer *buffer)
+				    struct stringbuf *buffer)
 {
 	struct snd_pcm_str *pstr = entry->private_data;
 	snd_iprintf(buffer, "%d\n", pstr->xrun_debug);
@@ -1058,7 +1058,7 @@ EXPORT_SYMBOL(snd_pcm_notify);
  */
 
 static void snd_pcm_proc_read(struct snd_info_entry *entry,
-			      struct snd_info_buffer *buffer)
+			      struct stringbuf *buffer)
 {
 	struct snd_pcm *pcm;
 
diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index a13e38c..754720f 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -137,7 +137,7 @@ EXPORT_SYMBOL(snd_pcm_lib_preallocate_free_for_all);
  * prints the current allocated size in kB.
  */
 static void snd_pcm_lib_preallocate_proc_read(struct snd_info_entry *entry,
-					      struct snd_info_buffer *buffer)
+					      struct stringbuf *buffer)
 {
 	struct snd_pcm_substream *substream = entry->private_data;
 	snd_iprintf(buffer, "%lu\n", (unsigned long) substream->dma_buffer.bytes / 1024);
@@ -149,7 +149,7 @@ static void snd_pcm_lib_preallocate_proc_read(struct snd_info_entry *entry,
  * prints the maximum allowed size in kB.
  */
 static void snd_pcm_lib_preallocate_max_proc_read(struct snd_info_entry *entry,
-						  struct snd_info_buffer *buffer)
+						  struct stringbuf *buffer)
 {
 	struct snd_pcm_substream *substream = entry->private_data;
 	snd_iprintf(buffer, "%lu\n", (unsigned long) substream->dma_max / 1024);
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index b8e700b..2bc574f 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1299,7 +1299,7 @@ static unsigned int snd_rawmidi_poll(struct file *file, poll_table * wait)
  */
 
 static void snd_rawmidi_proc_info_read(struct snd_info_entry *entry,
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct snd_rawmidi *rmidi;
 	struct snd_rawmidi_substream *substream;
diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index bc09923..00b357b 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -268,7 +268,7 @@ unregister_device(void)
 static struct snd_info_entry *info_entry;
 
 static void
-info_read(struct snd_info_entry *entry, struct snd_info_buffer *buf)
+info_read(struct snd_info_entry *entry, struct stringbuf *buf)
 {
 	mutex_lock(&register_mutex);
 	snd_iprintf(buf, "OSS sequencer emulation version %s\n", SNDRV_SEQ_OSS_VERSION_STR);
diff --git a/sound/core/seq/oss/seq_oss_device.h b/sound/core/seq/oss/seq_oss_device.h
index 9a8567c..d1c2939 100644
--- a/sound/core/seq/oss/seq_oss_device.h
+++ b/sound/core/seq/oss/seq_oss_device.h
@@ -139,10 +139,10 @@ void snd_seq_oss_process_queue(struct seq_oss_devinfo *dp, abstime_t time);
 
 
 /* proc interface */
-void snd_seq_oss_system_info_read(struct snd_info_buffer *buf);
-void snd_seq_oss_midi_info_read(struct snd_info_buffer *buf);
-void snd_seq_oss_synth_info_read(struct snd_info_buffer *buf);
-void snd_seq_oss_readq_info_read(struct seq_oss_readq *q, struct snd_info_buffer *buf);
+void snd_seq_oss_system_info_read(struct stringbuf *buf);
+void snd_seq_oss_midi_info_read(struct stringbuf *buf);
+void snd_seq_oss_synth_info_read(struct stringbuf *buf);
+void snd_seq_oss_readq_info_read(struct seq_oss_readq *q, struct stringbuf *buf);
 
 /* file mode macros */
 #define is_read_mode(mode)	((mode) & SNDRV_SEQ_OSS_FILE_READ)
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index d0d721c..b32af27 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -515,7 +515,7 @@ filemode_str(int val)
  * proc interface
  */
 void
-snd_seq_oss_system_info_read(struct snd_info_buffer *buf)
+snd_seq_oss_system_info_read(struct stringbuf *buf)
 {
 	int i;
 	struct seq_oss_devinfo *dp;
diff --git a/sound/core/seq/oss/seq_oss_midi.c b/sound/core/seq/oss/seq_oss_midi.c
index 0a711d2..959e88e 100644
--- a/sound/core/seq/oss/seq_oss_midi.c
+++ b/sound/core/seq/oss/seq_oss_midi.c
@@ -687,7 +687,7 @@ capmode_str(int val)
 }
 
 void
-snd_seq_oss_midi_info_read(struct snd_info_buffer *buf)
+snd_seq_oss_midi_info_read(struct stringbuf *buf)
 {
 	int i;
 	struct seq_oss_midi *mdev;
diff --git a/sound/core/seq/oss/seq_oss_readq.c b/sound/core/seq/oss/seq_oss_readq.c
index f5de79f..6fcd892 100644
--- a/sound/core/seq/oss/seq_oss_readq.c
+++ b/sound/core/seq/oss/seq_oss_readq.c
@@ -227,7 +227,7 @@ snd_seq_oss_readq_put_timestamp(struct seq_oss_readq *q, unsigned long curt, int
  * proc interface
  */
 void
-snd_seq_oss_readq_info_read(struct seq_oss_readq *q, struct snd_info_buffer *buf)
+snd_seq_oss_readq_info_read(struct seq_oss_readq *q, struct stringbuf *buf)
 {
 	snd_iprintf(buf, "  read queue [%s] length = %d : tick = %ld\n",
 		    (waitqueue_active(&q->midi_sleep) ? "sleeping":"running"),
diff --git a/sound/core/seq/oss/seq_oss_synth.c b/sound/core/seq/oss/seq_oss_synth.c
index ab570a0..b9f216f 100644
--- a/sound/core/seq/oss/seq_oss_synth.c
+++ b/sound/core/seq/oss/seq_oss_synth.c
@@ -626,7 +626,7 @@ snd_seq_oss_synth_make_info(struct seq_oss_devinfo *dp, int dev, struct synth_in
  * proc interface
  */
 void
-snd_seq_oss_synth_info_read(struct snd_info_buffer *buf)
+snd_seq_oss_synth_info_read(struct stringbuf *buf)
 {
 	int i;
 	struct seq_oss_synth *rec;
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 2e3fa25..5283017 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2427,7 +2427,7 @@ EXPORT_SYMBOL(snd_seq_kernel_client_write_poll);
 /*
  *  /proc interface
  */
-static void snd_seq_info_dump_subscribers(struct snd_info_buffer *buffer,
+static void snd_seq_info_dump_subscribers(struct stringbuf *buffer,
 					  struct snd_seq_port_subs_info *group,
 					  int is_src, char *msg)
 {
@@ -2466,7 +2466,7 @@ static void snd_seq_info_dump_subscribers(struct snd_info_buffer *buffer,
 
 #define FLAG_PERM_DUPLEX(perm) ((perm) & SNDRV_SEQ_PORT_CAP_DUPLEX ? 'X' : '-')
 
-static void snd_seq_info_dump_ports(struct snd_info_buffer *buffer,
+static void snd_seq_info_dump_ports(struct stringbuf *buffer,
 				    struct snd_seq_client *client)
 {
 	struct snd_seq_client_port *p;
@@ -2486,12 +2486,12 @@ static void snd_seq_info_dump_ports(struct snd_info_buffer *buffer,
 }
 
 
-void snd_seq_info_pool(struct snd_info_buffer *buffer,
+void snd_seq_info_pool(struct stringbuf *buffer,
 		       struct snd_seq_pool *pool, char *space);
 
 /* exported to seq_info.c */
 void snd_seq_info_clients_read(struct snd_info_entry *entry, 
-			       struct snd_info_buffer *buffer)
+			       struct stringbuf *buffer)
 {
 	int c;
 	struct snd_seq_client *client;
diff --git a/sound/core/seq/seq_device.c b/sound/core/seq/seq_device.c
index 37852cd..193ce08 100644
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -104,7 +104,7 @@ static void remove_drivers(void);
 
 #ifdef CONFIG_PROC_FS
 static void snd_seq_device_info(struct snd_info_entry *entry,
-				struct snd_info_buffer *buffer)
+				struct stringbuf *buffer)
 {
 	struct ops_list *ops;
 
diff --git a/sound/core/seq/seq_info.c b/sound/core/seq/seq_info.c
index 8a7fe5c..2e490b3 100644
--- a/sound/core/seq/seq_info.c
+++ b/sound/core/seq/seq_info.c
@@ -35,7 +35,7 @@ static struct snd_info_entry *timer_entry;
 
 static struct snd_info_entry * __init
 create_info_entry(char *name, void (*read)(struct snd_info_entry *,
-					   struct snd_info_buffer *))
+					   struct stringbuf *))
 {
 	struct snd_info_entry *entry;
 
diff --git a/sound/core/seq/seq_info.h b/sound/core/seq/seq_info.h
index 4892a7f..79bce50 100644
--- a/sound/core/seq/seq_info.h
+++ b/sound/core/seq/seq_info.h
@@ -24,9 +24,9 @@
 #include <sound/info.h>
 #include <sound/seq_kernel.h>
 
-void snd_seq_info_clients_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer);
-void snd_seq_info_timer_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer);
-void snd_seq_info_queues_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer);
+void snd_seq_info_clients_read(struct snd_info_entry *entry, struct stringbuf *buffer);
+void snd_seq_info_timer_read(struct snd_info_entry *entry, struct stringbuf *buffer);
+void snd_seq_info_queues_read(struct snd_info_entry *entry, struct stringbuf *buffer);
 
 
 #ifdef CONFIG_PROC_FS
diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index a72a194..4a7e7ba 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -504,7 +504,7 @@ void __exit snd_sequencer_memory_done(void)
 
 
 /* exported to seq_clientmgr.c */
-void snd_seq_info_pool(struct snd_info_buffer *buffer,
+void snd_seq_info_pool(struct stringbuf *buffer,
 		       struct snd_seq_pool *pool, char *space)
 {
 	if (pool == NULL)
diff --git a/sound/core/seq/seq_queue.c b/sound/core/seq/seq_queue.c
index 9b87bb0..47dee4f 100644
--- a/sound/core/seq/seq_queue.c
+++ b/sound/core/seq/seq_queue.c
@@ -759,7 +759,7 @@ int snd_seq_control_queue(struct snd_seq_event *ev, int atomic, int hop)
 #ifdef CONFIG_PROC_FS
 /* exported to seq_info.c */
 void snd_seq_info_queues_read(struct snd_info_entry *entry, 
-			      struct snd_info_buffer *buffer)
+			      struct stringbuf *buffer)
 {
 	int i, bpm;
 	struct snd_seq_queue *q;
diff --git a/sound/core/seq/seq_timer.c b/sound/core/seq/seq_timer.c
index 8716352..eeff0d3 100644
--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -428,7 +428,7 @@ snd_seq_tick_time_t snd_seq_timer_get_cur_tick(struct snd_seq_timer *tmr)
 #ifdef CONFIG_PROC_FS
 /* exported to seq_info.c */
 void snd_seq_info_timer_read(struct snd_info_entry *entry,
-			     struct snd_info_buffer *buffer)
+			     struct stringbuf *buffer)
 {
 	int idx;
 	struct snd_seq_queue *q;
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 7b486c4..b48b686 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -379,7 +379,7 @@ static const char *snd_device_type_name(int type)
 	}
 }
 
-static void snd_minor_info_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void snd_minor_info_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	int minor;
 	struct snd_minor *mptr;
diff --git a/sound/core/sound_oss.c b/sound/core/sound_oss.c
index dc73313..96d503e 100644
--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -229,7 +229,7 @@ static const char *snd_oss_device_type_name(int type)
 }
 
 static void snd_minor_info_oss_read(struct snd_info_entry *entry,
-				    struct snd_info_buffer *buffer)
+				    struct stringbuf *buffer)
 {
 	int minor;
 	struct snd_minor *mptr;
diff --git a/sound/core/timer.c b/sound/core/timer.c
index e7dc56c..05bca6f 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1026,7 +1026,7 @@ static int snd_timer_register_system(void)
  */
 
 static void snd_timer_proc_read(struct snd_info_entry *entry,
-				struct snd_info_buffer *buffer)
+				struct stringbuf *buffer)
 {
 	struct snd_timer *timer;
 	struct snd_timer_instance *ti;
diff --git a/sound/drivers/vx/vx_core.c b/sound/drivers/vx/vx_core.c
index ed19bc1..433a288 100644
--- a/sound/drivers/vx/vx_core.c
+++ b/sound/drivers/vx/vx_core.c
@@ -592,7 +592,7 @@ static void vx_reset_board(struct vx_core *chip, int cold_reset)
  * proc interface
  */
 
-static void vx_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void vx_proc_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct vx_core *chip = entry->private_data;
 	static char *audio_src_vxp[] = { "Line", "Mic", "Digital" };
diff --git a/sound/i2c/l3/uda1341.c b/sound/i2c/l3/uda1341.c
index b074fdd..83f16a3 100644
--- a/sound/i2c/l3/uda1341.c
+++ b/sound/i2c/l3/uda1341.c
@@ -428,7 +428,7 @@ static const char *peak_value[] = {
 };
 
 static void snd_uda1341_proc_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct l3_client *clnt = entry->private_data;
 	struct uda1341 *uda = clnt->driver_data;
@@ -493,7 +493,7 @@ static void snd_uda1341_proc_read(struct snd_info_entry *entry,
 }
 
 static void snd_uda1341_proc_regs_read(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct l3_client *clnt = entry->private_data;
 	struct uda1341 *uda = clnt->driver_data;		
diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
index a901cd1..9a64035 100644
--- a/sound/isa/ad1848/ad1848_lib.c
+++ b/sound/isa/ad1848/ad1848_lib.c
@@ -213,7 +213,7 @@ static void snd_ad1848_mce_down(struct snd_ad1848 *chip)
 	for (timeout = 12000; timeout > 0 && (inb(AD1848P(chip, REGSEL)) & AD1848_INIT); timeout--)
 		udelay(100);
 
-	snd_printdd("(1) timeout = %d\n", timeout);
+	snd_printdd("(1) timeout = %ld\n", timeout);
 
 #ifdef CONFIG_SND_DEBUG
 	if (inb(AD1848P(chip, REGSEL)) & AD1848_INIT)
diff --git a/sound/isa/gus/gus_irq.c b/sound/isa/gus/gus_irq.c
index cd9a6f1..035d9fc 100644
--- a/sound/isa/gus/gus_irq.c
+++ b/sound/isa/gus/gus_irq.c
@@ -114,7 +114,7 @@ __again:
 
 #ifdef CONFIG_SND_DEBUG
 static void snd_gus_irq_info_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct snd_gus_card *gus;
 	struct snd_gus_voice *pvoice;
diff --git a/sound/isa/gus/gus_mem.c b/sound/isa/gus/gus_mem.c
index bcf4656..d47b2d0 100644
--- a/sound/isa/gus/gus_mem.c
+++ b/sound/isa/gus/gus_mem.c
@@ -28,7 +28,7 @@
 
 #ifdef CONFIG_SND_DEBUG
 static void snd_gf1_mem_info_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer);
+				  struct stringbuf *buffer);
 #endif
 
 void snd_gf1_mem_lock(struct snd_gf1_mem * alloc, int xup)
@@ -286,7 +286,7 @@ int snd_gf1_mem_done(struct snd_gus_card * gus)
 
 #ifdef CONFIG_SND_DEBUG
 static void snd_gf1_mem_info_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct snd_gus_card *gus;
 	struct snd_gf1_mem *alloc;
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index d295936..dd91018 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -842,7 +842,7 @@ static void snd_miro_write(struct snd_miro *chip, unsigned char reg,
  */
 
 static void snd_miro_proc_read(struct snd_info_entry * entry, 
-			       struct snd_info_buffer *buffer)
+			       struct stringbuf *buffer)
 {
 	struct snd_miro *miro = (struct snd_miro *) entry->private_data;
 	char* model = "unknown";
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 3682059..5dfe4b9 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -110,7 +110,7 @@ static void snd_sb_qsound_destroy(struct snd_sb_csp * p);
 static int snd_sb_csp_qsound_transfer(struct snd_sb_csp * p);
 
 static int init_proc_entry(struct snd_sb_csp * p, int device);
-static void info_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer);
+static void info_read(struct snd_info_entry *entry, struct stringbuf *buffer);
 
 /*
  * Detect CSP chip and create a new instance
@@ -1149,7 +1149,7 @@ static int init_proc_entry(struct snd_sb_csp * p, int device)
 	return 0;
 }
 
-static void info_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void info_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_sb_csp *p = entry->private_data;
 
diff --git a/sound/pci/ac97/ac97_proc.c b/sound/pci/ac97/ac97_proc.c
index fed4a2c..5bd3cd5 100644
--- a/sound/pci/ac97/ac97_proc.c
+++ b/sound/pci/ac97/ac97_proc.c
@@ -36,7 +36,7 @@
  * proc interface
  */
 
-static void snd_ac97_proc_read_functions(struct snd_ac97 *ac97, struct snd_info_buffer *buffer)
+static void snd_ac97_proc_read_functions(struct snd_ac97 *ac97, struct stringbuf *buffer)
 {
 	int header = 0, function;
 	unsigned short info, sense_info;
@@ -106,7 +106,7 @@ static const char *snd_ac97_stereo_enhancements[] =
   /*  31 */ "Reserved 31"
 };
 
-static void snd_ac97_proc_read_main(struct snd_ac97 *ac97, struct snd_info_buffer *buffer, int subidx)
+static void snd_ac97_proc_read_main(struct snd_ac97 *ac97, struct stringbuf *buffer, int subidx)
 {
 	char name[64];
 	unsigned short val, tmp, ext, mext;
@@ -340,7 +340,7 @@ static void snd_ac97_proc_read_main(struct snd_ac97 *ac97, struct snd_info_buffe
 	}
 }
 
-static void snd_ac97_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void snd_ac97_proc_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_ac97 *ac97 = entry->private_data;
 	
@@ -375,7 +375,7 @@ static void snd_ac97_proc_read(struct snd_info_entry *entry, struct snd_info_buf
 
 #ifdef CONFIG_SND_DEBUG
 /* direct register write for debugging */
-static void snd_ac97_proc_regs_write(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void snd_ac97_proc_regs_write(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_ac97 *ac97 = entry->private_data;
 	char line[64];
@@ -392,7 +392,7 @@ static void snd_ac97_proc_regs_write(struct snd_info_entry *entry, struct snd_in
 }
 #endif
 
-static void snd_ac97_proc_regs_read_main(struct snd_ac97 *ac97, struct snd_info_buffer *buffer, int subidx)
+static void snd_ac97_proc_regs_read_main(struct snd_ac97 *ac97, struct stringbuf *buffer, int subidx)
 {
 	int reg, val;
 
@@ -403,7 +403,7 @@ static void snd_ac97_proc_regs_read_main(struct snd_ac97 *ac97, struct snd_info_
 }
 
 static void snd_ac97_proc_regs_read(struct snd_info_entry *entry, 
-				    struct snd_info_buffer *buffer)
+				    struct stringbuf *buffer)
 {
 	struct snd_ac97 *ac97 = entry->private_data;
 
diff --git a/sound/pci/ac97/ak4531_codec.c b/sound/pci/ac97/ak4531_codec.c
index 722de45..52275b0 100644
--- a/sound/pci/ac97/ak4531_codec.c
+++ b/sound/pci/ac97/ak4531_codec.c
@@ -466,7 +466,7 @@ void snd_ak4531_resume(struct snd_ak4531 *ak4531)
  */
 
 static void snd_ak4531_proc_read(struct snd_info_entry *entry, 
-				 struct snd_info_buffer *buffer)
+				 struct stringbuf *buffer)
 {
 	struct snd_ak4531 *ak4531 = entry->private_data;
 
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index 98970d4..8a01490 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -665,7 +665,7 @@ snd_ad1889_pcm_init(struct snd_ad1889 *chip, int device, struct snd_pcm **rpcm)
 }
 
 static void
-snd_ad1889_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+snd_ad1889_proc_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_ad1889 *chip = entry->private_data;
 	u16 reg;
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 4c2bd7a..a986ea8 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2126,7 +2126,7 @@ static int snd_ali_chip_init(struct snd_ali *codec)
 
 /* proc for register dump */
 static void snd_ali_proc_read(struct snd_info_entry *entry,
-			      struct snd_info_buffer *buf)
+			      struct stringbuf *buf)
 {
 	struct snd_ali *codec = entry->private_data;
 	int i;
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 89184a4..737d31e 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1524,7 +1524,7 @@ static int snd_atiixp_resume(struct pci_dev *pci)
  */
 
 static void snd_atiixp_proc_read(struct snd_info_entry *entry,
-				 struct snd_info_buffer *buffer)
+				 struct stringbuf *buffer)
 {
 	struct atiixp *chip = entry->private_data;
 	int i;
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index ce752f8..e273674 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1168,7 +1168,7 @@ static int snd_atiixp_resume(struct pci_dev *pci)
  */
 
 static void snd_atiixp_proc_read(struct snd_info_entry *entry,
-				 struct snd_info_buffer *buffer)
+				 struct stringbuf *buffer)
 {
 	struct atiixp_modem *chip = entry->private_data;
 	int i;
diff --git a/sound/pci/ca0106/ca0106_proc.c b/sound/pci/ca0106/ca0106_proc.c
index ae80f51..2e8be6a 100644
--- a/sound/pci/ca0106/ca0106_proc.c
+++ b/sound/pci/ca0106/ca0106_proc.c
@@ -99,7 +99,7 @@ static struct snd_ca0106_category_str snd_ca0106_con_category[] = {
 };
 
 
-static void snd_ca0106_proc_dump_iec958( struct snd_info_buffer *buffer, u32 value)
+static void snd_ca0106_proc_dump_iec958(struct stringbuf *buffer, u32 value)
 {
 	int i;
 	u32 status[4];
@@ -274,7 +274,7 @@ static void snd_ca0106_proc_dump_iec958( struct snd_info_buffer *buffer, u32 val
 }
 
 static void snd_ca0106_proc_iec958(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct snd_ca0106 *emu = entry->private_data;
 	u32 value;
@@ -314,7 +314,7 @@ static void snd_ca0106_proc_reg_write32(struct snd_info_entry *entry,
 }
 
 static void snd_ca0106_proc_reg_read32(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct snd_ca0106 *emu = entry->private_data;
 	unsigned long value;
@@ -330,7 +330,7 @@ static void snd_ca0106_proc_reg_read32(struct snd_info_entry *entry,
 }
 
 static void snd_ca0106_proc_reg_read16(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct snd_ca0106 *emu = entry->private_data;
         unsigned int value;
@@ -346,7 +346,7 @@ static void snd_ca0106_proc_reg_read16(struct snd_info_entry *entry,
 }
 
 static void snd_ca0106_proc_reg_read8(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct snd_ca0106 *emu = entry->private_data;
 	unsigned int value;
@@ -362,7 +362,7 @@ static void snd_ca0106_proc_reg_read8(struct snd_info_entry *entry,
 }
 
 static void snd_ca0106_proc_reg_read1(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct snd_ca0106 *emu = entry->private_data;
 	unsigned long value;
@@ -380,7 +380,7 @@ static void snd_ca0106_proc_reg_read1(struct snd_info_entry *entry,
 }
 
 static void snd_ca0106_proc_reg_read2(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct snd_ca0106 *emu = entry->private_data;
 	unsigned long value;
@@ -448,10 +448,9 @@ int __devinit snd_ca0106_proc_init(struct snd_ca0106 * emu)
 //		entry->private_data = emu;
 	}
 	if(! snd_card_proc_new(emu->card, "ca0106_i2c", &entry)) {
-		snd_info_set_text_ops(entry, emu, snd_ca0106_proc_i2c_write);
+		entry->private_data = emu;
 		entry->c.text.write = snd_ca0106_proc_i2c_write;
 		entry->mode |= S_IWUSR;
-//		entry->private_data = emu;
 	}
 	if(! snd_card_proc_new(emu->card, "ca0106_regs2", &entry)) 
 		snd_info_set_text_ops(entry, emu, snd_ca0106_proc_reg_read2);
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 6832649..4abef9e 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2706,7 +2706,7 @@ static int __devinit snd_cmipci_mixer_new(struct cmipci *cm, int pcm_spdif_devic
 
 #ifdef CONFIG_PROC_FS
 static void snd_cmipci_proc_read(struct snd_info_entry *entry, 
-				 struct snd_info_buffer *buffer)
+				 struct stringbuf *buffer)
 {
 	struct cmipci *cm = entry->private_data;
 	int i, v;
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 9a55f4a..a60649b 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1127,7 +1127,7 @@ static int __devinit snd_cs4281_mixer(struct cs4281 * chip)
  */
 
 static void snd_cs4281_proc_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct cs4281 *chip = entry->private_data;
 
diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index 590b35d..ea9367c 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -484,8 +484,8 @@ cs46xx_dsp_lookup_symbol_addr (struct snd_cs46xx * chip, u32 address, int symbol
 }
 
 
-static void cs46xx_dsp_proc_symbol_table_read (struct snd_info_entry *entry,
-					       struct snd_info_buffer *buffer)
+static void cs46xx_dsp_proc_symbol_table_read(struct snd_info_entry *entry,
+					      struct stringbuf *buffer)
 {
 	struct snd_cs46xx *chip = entry->private_data;
 	struct dsp_spos_instance * ins = chip->dsp_spos_instance;
@@ -513,7 +513,7 @@ static void cs46xx_dsp_proc_symbol_table_read (struct snd_info_entry *entry,
 
 
 static void cs46xx_dsp_proc_modules_read (struct snd_info_entry *entry,
-					  struct snd_info_buffer *buffer)
+					  struct stringbuf *buffer)
 {
 	struct snd_cs46xx *chip = entry->private_data;
 	struct dsp_spos_instance * ins = chip->dsp_spos_instance;
@@ -536,7 +536,7 @@ static void cs46xx_dsp_proc_modules_read (struct snd_info_entry *entry,
 }
 
 static void cs46xx_dsp_proc_task_tree_read (struct snd_info_entry *entry,
-					    struct snd_info_buffer *buffer)
+					    struct stringbuf *buffer)
 {
 	struct snd_cs46xx *chip = entry->private_data;
 	struct dsp_spos_instance * ins = chip->dsp_spos_instance;
@@ -564,7 +564,7 @@ static void cs46xx_dsp_proc_task_tree_read (struct snd_info_entry *entry,
 }
 
 static void cs46xx_dsp_proc_scb_read (struct snd_info_entry *entry,
-				      struct snd_info_buffer *buffer)
+				      struct stringbuf *buffer)
 {
 	struct snd_cs46xx *chip = entry->private_data;
 	struct dsp_spos_instance * ins = chip->dsp_spos_instance;
@@ -597,7 +597,7 @@ static void cs46xx_dsp_proc_scb_read (struct snd_info_entry *entry,
 }
 
 static void cs46xx_dsp_proc_parameter_dump_read (struct snd_info_entry *entry,
-						 struct snd_info_buffer *buffer)
+						 struct stringbuf *buffer)
 {
 	struct snd_cs46xx *chip = entry->private_data;
 	/*struct dsp_spos_instance * ins = chip->dsp_spos_instance; */
@@ -625,7 +625,7 @@ static void cs46xx_dsp_proc_parameter_dump_read (struct snd_info_entry *entry,
 }
 
 static void cs46xx_dsp_proc_sample_dump_read (struct snd_info_entry *entry,
-					      struct snd_info_buffer *buffer)
+					      struct stringbuf *buffer)
 {
 	struct snd_cs46xx *chip = entry->private_data;
 	int i,col = 0;
diff --git a/sound/pci/cs46xx/dsp_spos_scb_lib.c b/sound/pci/cs46xx/dsp_spos_scb_lib.c
index eded4df..8efe52c 100644
--- a/sound/pci/cs46xx/dsp_spos_scb_lib.c
+++ b/sound/pci/cs46xx/dsp_spos_scb_lib.c
@@ -66,8 +66,8 @@ static void remove_symbol (struct snd_cs46xx * chip, struct dsp_symbol_entry * s
 }
 
 #ifdef CONFIG_PROC_FS
-static void cs46xx_dsp_proc_scb_info_read (struct snd_info_entry *entry,
-					   struct snd_info_buffer *buffer)
+static void cs46xx_dsp_proc_scb_info_read(struct snd_info_entry *entry,
+					  struct stringbuf *buffer)
 {
 	struct proc_scb_info * scb_info  = entry->private_data;
 	struct dsp_scb_descriptor * scb = scb_info->scb_desc;
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 1ec7eba..faf0c7a 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -1004,7 +1004,7 @@ static int __devinit snd_emu10k1x_create(struct snd_card *card,
 }
 
 static void snd_emu10k1x_proc_reg_read(struct snd_info_entry *entry, 
-				       struct snd_info_buffer *buffer)
+				       struct stringbuf *buffer)
 {
 	struct emu10k1x *emu = entry->private_data;
 	unsigned long value,value1,value2;
diff --git a/sound/pci/emu10k1/emuproc.c b/sound/pci/emu10k1/emuproc.c
index c3fb10e..53b7b11 100644
--- a/sound/pci/emu10k1/emuproc.c
+++ b/sound/pci/emu10k1/emuproc.c
@@ -37,7 +37,7 @@
 
 #ifdef CONFIG_PROC_FS
 static void snd_emu10k1_proc_spdif_status(struct snd_emu10k1 * emu,
-					  struct snd_info_buffer *buffer,
+					  struct stringbuf *buffer,
 					  char *title,
 					  int status_reg,
 					  int rate_reg)
@@ -80,7 +80,7 @@ static void snd_emu10k1_proc_spdif_status(struct snd_emu10k1 * emu,
 }
 
 static void snd_emu10k1_proc_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	/* FIXME - output names are in emufx.c too */
 	static char *creative_outs[32] = {
@@ -237,7 +237,7 @@ static void snd_emu10k1_proc_read(struct snd_info_entry *entry,
 }
 
 static void snd_emu10k1_proc_spdif_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct snd_emu10k1 *emu = entry->private_data;
 	u32 value;
@@ -285,7 +285,7 @@ static void snd_emu10k1_proc_spdif_read(struct snd_info_entry *entry,
 }
 
 static void snd_emu10k1_proc_rates_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	static int samplerate[8] = { 44100, 48000, 96000, 192000, 4, 5, 6, 7 };
 	struct snd_emu10k1 *emu = entry->private_data;
@@ -300,7 +300,7 @@ static void snd_emu10k1_proc_rates_read(struct snd_info_entry *entry,
 }
 
 static void snd_emu10k1_proc_acode_read(struct snd_info_entry *entry, 
-				        struct snd_info_buffer *buffer)
+				        struct stringbuf *buffer)
 {
 	u32 pc;
 	struct snd_emu10k1 *emu = entry->private_data;
@@ -389,7 +389,7 @@ static long snd_emu10k1_fx8010_read(struct snd_info_entry *entry,
 }
 
 static void snd_emu10k1_proc_voices_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct snd_emu10k1 *emu = entry->private_data;
 	struct snd_emu10k1_voice *voice;
@@ -410,7 +410,7 @@ static void snd_emu10k1_proc_voices_read(struct snd_info_entry *entry,
 
 #ifdef CONFIG_SND_DEBUG
 static void snd_emu_proc_emu1010_reg_read(struct snd_info_entry *entry,
-				     struct snd_info_buffer *buffer)
+				     struct stringbuf *buffer)
 {
 	struct snd_emu10k1 *emu = entry->private_data;
 	int value;
@@ -427,7 +427,7 @@ static void snd_emu_proc_emu1010_reg_read(struct snd_info_entry *entry,
 }
 
 static void snd_emu_proc_io_reg_read(struct snd_info_entry *entry,
-				     struct snd_info_buffer *buffer)
+				     struct stringbuf *buffer)
 {
 	struct snd_emu10k1 *emu = entry->private_data;
 	unsigned long value;
@@ -496,7 +496,7 @@ static void snd_ptr_write(struct snd_emu10k1 *emu,
 
 
 static void snd_emu_proc_ptr_reg_read(struct snd_info_entry *entry,
-				      struct snd_info_buffer *buffer, int iobase, int offset, int length, int voices)
+				      struct stringbuf *buffer, int iobase, int offset, int length, int voices)
 {
 	struct snd_emu10k1 *emu = entry->private_data;
 	unsigned long value;
@@ -547,31 +547,31 @@ static void snd_emu_proc_ptr_reg_write20(struct snd_info_entry *entry,
 	
 
 static void snd_emu_proc_ptr_reg_read00a(struct snd_info_entry *entry,
-					 struct snd_info_buffer *buffer)
+					 struct stringbuf *buffer)
 {
 	snd_emu_proc_ptr_reg_read(entry, buffer, 0, 0, 0x40, 64);
 }
 
 static void snd_emu_proc_ptr_reg_read00b(struct snd_info_entry *entry,
-					 struct snd_info_buffer *buffer)
+					 struct stringbuf *buffer)
 {
 	snd_emu_proc_ptr_reg_read(entry, buffer, 0, 0x40, 0x40, 64);
 }
 
 static void snd_emu_proc_ptr_reg_read20a(struct snd_info_entry *entry,
-					 struct snd_info_buffer *buffer)
+					 struct stringbuf *buffer)
 {
 	snd_emu_proc_ptr_reg_read(entry, buffer, 0x20, 0, 0x40, 4);
 }
 
 static void snd_emu_proc_ptr_reg_read20b(struct snd_info_entry *entry,
-					 struct snd_info_buffer *buffer)
+					 struct stringbuf *buffer)
 {
 	snd_emu_proc_ptr_reg_read(entry, buffer, 0x20, 0x40, 0x40, 4);
 }
 
 static void snd_emu_proc_ptr_reg_read20c(struct snd_info_entry *entry,
-					 struct snd_info_buffer * buffer)
+					 struct stringbuf * buffer)
 {
 	snd_emu_proc_ptr_reg_read(entry, buffer, 0x20, 0x80, 0x20, 4);
 }
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index b958f86..41b1349 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -1865,7 +1865,7 @@ static inline void snd_ensoniq_free_gameport(struct ensoniq *ensoniq) { }
  */
 
 static void snd_ensoniq_proc_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct ensoniq *ensoniq = entry->private_data;
 
diff --git a/sound/pci/hda/hda_proc.c b/sound/pci/hda/hda_proc.c
index e94944f..55532c3 100644
--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -47,7 +47,7 @@ static const char *get_wid_type_name(unsigned int wid_value)
 		return "UNKNOWN Widget";
 }
 
-static void print_amp_caps(struct snd_info_buffer *buffer,
+static void print_amp_caps(struct stringbuf *buffer,
 			   struct hda_codec *codec, hda_nid_t nid, int dir)
 {
 	unsigned int caps;
@@ -66,7 +66,7 @@ static void print_amp_caps(struct snd_info_buffer *buffer,
 		    (caps & AC_AMPCAP_MUTE) >> AC_AMPCAP_MUTE_SHIFT);
 }
 
-static void print_amp_vals(struct snd_info_buffer *buffer,
+static void print_amp_vals(struct stringbuf *buffer,
 			   struct hda_codec *codec, hda_nid_t nid,
 			   int dir, int stereo, int indices)
 {
@@ -90,7 +90,7 @@ static void print_amp_vals(struct snd_info_buffer *buffer,
 	snd_iprintf(buffer, "\n");
 }
 
-static void print_pcm_rates(struct snd_info_buffer *buffer, unsigned int pcm)
+static void print_pcm_rates(struct stringbuf *buffer, unsigned int pcm)
 {
 	static unsigned int rates[] = {
 		8000, 11025, 16000, 22050, 32000, 44100, 48000, 88200,
@@ -106,7 +106,7 @@ static void print_pcm_rates(struct snd_info_buffer *buffer, unsigned int pcm)
 	snd_iprintf(buffer, "\n");
 }
 
-static void print_pcm_bits(struct snd_info_buffer *buffer, unsigned int pcm)
+static void print_pcm_bits(struct stringbuf *buffer, unsigned int pcm)
 {
 	static unsigned int bits[] = { 8, 16, 20, 24, 32 };
 	int i;
@@ -119,7 +119,7 @@ static void print_pcm_bits(struct snd_info_buffer *buffer, unsigned int pcm)
 	snd_iprintf(buffer, "\n");
 }
 
-static void print_pcm_formats(struct snd_info_buffer *buffer,
+static void print_pcm_formats(struct stringbuf *buffer,
 			      unsigned int streams)
 {
 	snd_iprintf(buffer, "    formats [0x%x]:", streams & 0xf);
@@ -132,7 +132,7 @@ static void print_pcm_formats(struct snd_info_buffer *buffer,
 	snd_iprintf(buffer, "\n");
 }
 
-static void print_pcm_caps(struct snd_info_buffer *buffer,
+static void print_pcm_caps(struct stringbuf *buffer,
 			   struct hda_codec *codec, hda_nid_t nid)
 {
 	unsigned int pcm = snd_hda_param_read(codec, nid, AC_PAR_PCM);
@@ -202,7 +202,7 @@ static const char *get_jack_color(u32 cfg)
 		return "UNKNOWN";
 }
 
-static void print_pin_caps(struct snd_info_buffer *buffer,
+static void print_pin_caps(struct stringbuf *buffer,
 			   struct hda_codec *codec, hda_nid_t nid)
 {
 	static char *jack_conns[4] = { "Jack", "N/A", "Fixed", "Both" };
@@ -241,7 +241,7 @@ static void print_pin_caps(struct snd_info_buffer *buffer,
 
 
 static void print_codec_info(struct snd_info_entry *entry,
-			     struct snd_info_buffer *buffer)
+			     struct stringbuf *buffer)
 {
 	struct hda_codec *codec = entry->private_data;
 	char buf[32];
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 052fc3c..24752c2 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -1543,7 +1543,7 @@ static inline unsigned int eeprom_double(struct snd_ice1712 *ice, int idx)
 }
 
 static void snd_ice1712_proc_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct snd_ice1712 *ice = entry->private_data;
 	unsigned int idx;
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 0b0bbb0..6350e2d 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -1248,7 +1248,7 @@ static inline unsigned int eeprom_triple(struct snd_ice1712 *ice, int idx)
 }
 
 static void snd_vt1724_proc_read(struct snd_info_entry *entry, 
-				 struct snd_info_buffer *buffer)
+				 struct stringbuf *buffer)
 {
 	struct snd_ice1712 *ice = entry->private_data;
 	unsigned int idx;
diff --git a/sound/pci/ice1712/pontis.c b/sound/pci/ice1712/pontis.c
index faefd52..e4b857c 100644
--- a/sound/pci/ice1712/pontis.c
+++ b/sound/pci/ice1712/pontis.c
@@ -651,7 +651,7 @@ static void wm_proc_regs_write(struct snd_info_entry *entry, struct snd_info_buf
 	mutex_unlock(&ice->gpio_mutex);
 }
 
-static void wm_proc_regs_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void wm_proc_regs_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_ice1712 *ice = (struct snd_ice1712 *)entry->private_data;
 	int reg, val;
@@ -674,7 +674,7 @@ static void wm_proc_init(struct snd_ice1712 *ice)
 	}
 }
 
-static void cs_proc_regs_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void cs_proc_regs_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_ice1712 *ice = (struct snd_ice1712 *)entry->private_data;
 	int reg, val;
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index b4a38a3..0114f98 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2655,7 +2655,7 @@ static void __devinit intel8x0_measure_ac97_clock(struct intel8x0 *chip)
 
 #ifdef CONFIG_PROC_FS
 static void snd_intel8x0_proc_read(struct snd_info_entry * entry,
-				   struct snd_info_buffer *buffer)
+				   struct stringbuf *buffer)
 {
 	struct intel8x0 *chip = entry->private_data;
 	unsigned int tmp;
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index fad806e..9f6bdd1 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1060,7 +1060,7 @@ static int intel8x0m_resume(struct pci_dev *pci)
 
 #ifdef CONFIG_PROC_FS
 static void snd_intel8x0m_proc_read(struct snd_info_entry * entry,
-				   struct snd_info_buffer *buffer)
+				   struct stringbuf *buffer)
 {
 	struct intel8x0m *chip = entry->private_data;
 	unsigned int tmp;
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index c4af57f..983b04b 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2051,7 +2051,7 @@ static struct snd_kcontrol_new snd_korg1212_controls[] = {
  */
 
 static void snd_korg1212_proc_read(struct snd_info_entry *entry,
-				   struct snd_info_buffer *buffer)
+				   struct stringbuf *buffer)
 {
 	int n;
 	struct snd_korg1212 *korg1212 = entry->private_data;
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index 880b824..194b765 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1202,7 +1202,7 @@ static struct snd_info_entry_ops snd_mixart_proc_ops_BA1 = {
 
 
 static void snd_mixart_proc_read(struct snd_info_entry *entry, 
-                                 struct snd_info_buffer *buffer)
+                                 struct stringbuf *buffer)
 {
 	struct snd_mixart *chip = entry->private_data;        
 	u32 ref; 
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 2d618bd..7677969 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1059,7 +1059,7 @@ static int __devinit pcxhr_create(struct pcxhr_mgr *mgr, struct snd_card *card,
 }
 
 /* proc interface */
-static void pcxhr_proc_info(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void pcxhr_proc_info(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_pcxhr *chip = entry->private_data;
 	struct pcxhr_mgr *mgr = chip->mgr;
@@ -1120,7 +1120,7 @@ static void pcxhr_proc_info(struct snd_info_entry *entry, struct snd_info_buffer
 		snd_iprintf(buffer, "no firmware loaded\n");
 	snd_iprintf(buffer, "\n");
 }
-static void pcxhr_proc_sync(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void pcxhr_proc_sync(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_pcxhr *chip = entry->private_data;
 	struct pcxhr_mgr *mgr = chip->mgr;
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 8e54104..0074e97 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -1928,7 +1928,7 @@ snd_riptide_create(struct snd_card *card, struct pci_dev *pci,
 
 static void
 snd_riptide_proc_read(struct snd_info_entry *entry,
-		      struct snd_info_buffer *buffer)
+		      struct stringbuf *buffer)
 {
 	struct snd_riptide *chip = entry->private_data;
 	struct pcmhw *data;
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 1475912..fef422a 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1463,7 +1463,7 @@ static int __devinit snd_rme32_create(struct rme32 * rme32)
  */
 
 static void
-snd_rme32_proc_read(struct snd_info_entry * entry, struct snd_info_buffer *buffer)
+snd_rme32_proc_read(struct snd_info_entry * entry, struct stringbuf *buffer)
 {
 	int n;
 	struct rme32 *rme32 = (struct rme32 *) entry->private_data;
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 0b3c532..3ce41db 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -1663,7 +1663,7 @@ snd_rme96_create(struct rme96 *rme96)
  */
 
 static void 
-snd_rme96_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+snd_rme96_proc_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	int n;
 	struct rme96 *rme96 = (struct rme96 *)entry->private_data;
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index ff26a36..c6de4b7 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3242,7 +3242,7 @@ static int snd_hdsp_create_controls(struct snd_card *card, struct hdsp *hdsp)
  ------------------------------------------------------------*/
 
 static void
-snd_hdsp_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+snd_hdsp_proc_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct hdsp *hdsp = (struct hdsp *) entry->private_data;
 	unsigned int status;
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index f1bdda6..93310d9 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -2938,7 +2938,7 @@ static int snd_hdspm_create_controls(struct snd_card *card, struct hdspm * hdspm
 
 static void
 snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
-			 struct snd_info_buffer *buffer)
+			 struct stringbuf *buffer)
 {
 	struct hdspm *hdspm = entry->private_data;
 	unsigned int status;
@@ -3133,7 +3133,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 
 static void
 snd_hdspm_proc_read_aes32(struct snd_info_entry * entry,
-			  struct snd_info_buffer *buffer)
+			  struct stringbuf *buffer)
 {
 	struct hdspm *hdspm = entry->private_data;
 	unsigned int status;
@@ -3305,7 +3305,7 @@ snd_hdspm_proc_read_aes32(struct snd_info_entry * entry,
 #ifdef CONFIG_SND_DEBUG
 static void
 snd_hdspm_proc_read_debug(struct snd_info_entry * entry,
-			  struct snd_info_buffer *buffer)
+			  struct stringbuf *buffer)
 {
 	struct hdspm *hdspm = entry->private_data;
 
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 34f96f1..2a0b7da 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -1589,7 +1589,7 @@ static int snd_rme9652_create_controls(struct snd_card *card, struct snd_rme9652
  ------------------------------------------------------------*/
 
 static void
-snd_rme9652_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+snd_rme9652_proc_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_rme9652 *rme9652 = (struct snd_rme9652 *) entry->private_data;
 	u32 thru_bits = rme9652->thru_bits;
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 44a7f5f..09b09b7 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1110,7 +1110,7 @@ static int __devinit snd_sonicvibes_mixer(struct sonicvibes * sonic)
  */
 
 static void snd_sonicvibes_proc_read(struct snd_info_entry *entry, 
-				     struct snd_info_buffer *buffer)
+				     struct stringbuf *buffer)
 {
 	struct sonicvibes *sonic = entry->private_data;
 	unsigned char tmp;
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index a235e03..7013581 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -3281,7 +3281,7 @@ static int snd_trident_sis_reset(struct snd_trident *trident)
  */
 
 static void snd_trident_proc_read(struct snd_info_entry *entry, 
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct snd_trident *trident = entry->private_data;
 	char *s;
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index cf62d2a..2b96eca 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2017,7 +2017,7 @@ static int __devinit snd_via686_init_misc(struct via82xx *chip)
  * proc interface
  */
 static void snd_via82xx_proc_read(struct snd_info_entry *entry,
-				  struct snd_info_buffer *buffer)
+				  struct stringbuf *buffer)
 {
 	struct via82xx *chip = entry->private_data;
 	int i;
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 57fb9ae..ca2c73b 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -913,7 +913,7 @@ static int __devinit snd_via82xx_mixer_new(struct via82xx_modem *chip)
 /*
  * proc interface
  */
-static void snd_via82xx_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void snd_via82xx_proc_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct via82xx_modem *chip = entry->private_data;
 	int i;
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index 1fe39ed..731d3a1 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -1929,7 +1929,7 @@ int __devinit snd_ymfpci_timer(struct snd_ymfpci *chip, int device)
  */
 
 static void snd_ymfpci_proc_read(struct snd_info_entry *entry, 
-				 struct snd_info_buffer *buffer)
+				 struct stringbuf *buffer)
 {
 	struct snd_ymfpci *chip = entry->private_data;
 	int i;
diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf_core.c b/sound/pcmcia/pdaudiocf/pdaudiocf_core.c
index 484c8f9..e533beb 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf_core.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf_core.c
@@ -128,7 +128,7 @@ void pdacf_reinit(struct snd_pdacf *chip, int resume)
 }
 
 static void pdacf_proc_read(struct snd_info_entry * entry,
-                            struct snd_info_buffer *buffer)
+                            struct stringbuf *buffer)
 {
 	struct snd_pdacf *chip = entry->private_data;
 	u16 tmp;
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index 376b986..339f22c 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -2446,7 +2446,7 @@ static int __devinit snd_dbri_mixer(struct snd_card *card)
 			/proc interface
 ****************************************************************************/
 static void dbri_regs_read(struct snd_info_entry *entry,
-			   struct snd_info_buffer *buffer)
+			   struct stringbuf *buffer)
 {
 	struct snd_dbri *dbri = entry->private_data;
 
@@ -2458,7 +2458,7 @@ static void dbri_regs_read(struct snd_info_entry *entry,
 
 #ifdef DBRI_DEBUG
 static void dbri_debug_read(struct snd_info_entry *entry,
-			    struct snd_info_buffer *buffer)
+			    struct stringbuf *buffer)
 {
 	struct snd_dbri *dbri = entry->private_data;
 	int pipe;
diff --git a/sound/synth/emux/emux_proc.c b/sound/synth/emux/emux_proc.c
index 680f2b7..06e0783 100644
--- a/sound/synth/emux/emux_proc.c
+++ b/sound/synth/emux/emux_proc.c
@@ -30,7 +30,7 @@
 
 static void
 snd_emux_proc_info_read(struct snd_info_entry *entry, 
-			struct snd_info_buffer *buf)
+			struct stringbuf *buf)
 {
 	struct snd_emux *emu;
 	int i;
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 967b823..bb1e0ac 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -2101,7 +2101,7 @@ static struct usb_driver usb_audio_driver = {
 /*
  * proc interface for list the supported pcm formats
  */
-static void proc_dump_substream_formats(struct snd_usb_substream *subs, struct snd_info_buffer *buffer)
+static void proc_dump_substream_formats(struct snd_usb_substream *subs, struct stringbuf *buffer)
 {
 	struct list_head *p;
 	static char *sync_types[4] = {
@@ -2137,7 +2137,7 @@ static void proc_dump_substream_formats(struct snd_usb_substream *subs, struct s
 	}
 }
 
-static void proc_dump_substream_status(struct snd_usb_substream *subs, struct snd_info_buffer *buffer)
+static void proc_dump_substream_status(struct snd_usb_substream *subs, struct stringbuf *buffer)
 {
 	if (subs->running) {
 		unsigned int i;
@@ -2159,7 +2159,7 @@ static void proc_dump_substream_status(struct snd_usb_substream *subs, struct sn
 	}
 }
 
-static void proc_pcm_format_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void proc_pcm_format_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_usb_stream *stream = entry->private_data;
 
@@ -3327,14 +3327,14 @@ static int snd_usb_create_quirk(struct snd_usb_audio *chip,
 /*
  * common proc files to show the usb device info
  */
-static void proc_audio_usbbus_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void proc_audio_usbbus_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_usb_audio *chip = entry->private_data;
 	if (! chip->shutdown)
 		snd_iprintf(buffer, "%03d/%03d\n", chip->dev->bus->busnum, chip->dev->devnum);
 }
 
-static void proc_audio_usbid_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
+static void proc_audio_usbid_read(struct snd_info_entry *entry, struct stringbuf *buffer)
 {
 	struct snd_usb_audio *chip = entry->private_data;
 	if (! chip->shutdown)
diff --git a/sound/usb/usbmixer.c b/sound/usb/usbmixer.c
index 5e32969..05a152f 100644
--- a/sound/usb/usbmixer.c
+++ b/sound/usb/usbmixer.c
@@ -1961,7 +1961,7 @@ static int snd_audigy2nx_controls_create(struct usb_mixer_interface *mixer)
 }
 
 static void snd_audigy2nx_proc_read(struct snd_info_entry *entry,
-				    struct snd_info_buffer *buffer)
+				    struct stringbuf *buffer)
 {
 	static const struct {
 		int unitid;
-- 
1.5.3.4

