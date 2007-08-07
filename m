Return-Path: <linux-kernel-owner+w=401wt.eu-S936078AbXHGVBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936078AbXHGVBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964935AbXHGUuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:50:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56295 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930AbXHGUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:50:37 -0400
Date: Tue, 7 Aug 2007 13:45:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [2.6.22.2 review 29/84] V4L: ivtv: fix DMA timeout when capturing
	VBI + another stream
Message-ID: <20070807204510.GD23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-ivtv-fix-dma-timeout-when-capturing-vbi-another-stream.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hans Verkuil <hverkuil@xs4all.nl>

The VBI DMA is handled in a special way and is marked with a bit.
However, that bit was set at the wrong time and could be cleared
by mistake if a PCM (or other) DMA request would arrive before the
VBI DMA was completed. So on completion of the VBI DMA the driver
no longer knew that that DMA transfer was for VBI data. And this
in turn caused havoc with the card's DMA engine.

(cherry picked from commit dd1e729d63f74a0b6290ca417bafd3fd8665db50)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/ivtv/ivtv-irq.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/video/ivtv/ivtv-irq.c
+++ b/drivers/media/video/ivtv/ivtv-irq.c
@@ -403,6 +403,11 @@ static void ivtv_dma_enc_start(struct iv
 	/* Mark last buffer size for Interrupt flag */
 	s->SGarray[s->SG_length - 1].size |= cpu_to_le32(0x80000000);
 
+	if (s->type == IVTV_ENC_STREAM_TYPE_VBI)
+		set_bit(IVTV_F_I_ENC_VBI, &itv->i_flags);
+	else
+		clear_bit(IVTV_F_I_ENC_VBI, &itv->i_flags);
+
 	if (ivtv_use_pio(s)) {
 		for (i = 0; i < s->SG_length; i++) {
 			s->PIOarray[i].src = le32_to_cpu(s->SGarray[i].src);
@@ -597,7 +602,6 @@ static void ivtv_irq_enc_start_cap(struc
 				data[0], data[1], data[2]);
 		return;
 	}
-	clear_bit(IVTV_F_I_ENC_VBI, &itv->i_flags);
 	s = &itv->streams[ivtv_stream_map[data[0]]];
 	if (!stream_enc_dma_append(s, data)) {
 		set_bit(ivtv_use_pio(s) ? IVTV_F_S_PIO_PENDING : IVTV_F_S_DMA_PENDING, &s->s_flags);
@@ -634,7 +638,6 @@ static void ivtv_irq_enc_vbi_cap(struct 
 	   then start a DMA request for just the VBI data. */
 	if (!stream_enc_dma_append(s, data) &&
 			!test_bit(IVTV_F_S_STREAMING, &s_mpg->s_flags)) {
-		set_bit(IVTV_F_I_ENC_VBI, &itv->i_flags);
 		set_bit(ivtv_use_pio(s) ? IVTV_F_S_PIO_PENDING : IVTV_F_S_DMA_PENDING, &s->s_flags);
 	}
 }

-- 
