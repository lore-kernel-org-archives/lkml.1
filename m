Return-Path: <linux-kernel-owner+w=401wt.eu-S1764407AbXKOGXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764407AbXKOGXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbXKOGQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51129 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762788AbXKOGQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:51 -0500
Date: Wed, 14 Nov 2007 22:15:22 -0800
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
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 17/19] x86 setup: sizeof() is unsigned, unbreak comparisons
Message-ID: <20071115061522.GR7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-setup-sizeof-is-unsigned-unbreak-comparisons.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: H. Peter Anvin <hpa@zytor.com>

patch e6e1ace9904b72478f0c5a5aa7bd174cb6f62561 in mainline.


We use signed values for limit checking since the values can go
negative under certain circumstances.  However, sizeof() is unsigned
and forces the comparison to be unsigned, so move the comparison into
the heap_free() macros so we can ensure it is a signed comparison.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/boot/boot.h       |    4 ++--
 arch/i386/boot/video-bios.c |    2 +-
 arch/i386/boot/video-vesa.c |    2 +-
 arch/i386/boot/video.c      |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/i386/boot/boot.h
+++ b/arch/i386/boot/boot.h
@@ -216,9 +216,9 @@ static inline char *__get_heap(size_t s,
 #define GET_HEAP(type, n) \
 	((type *)__get_heap(sizeof(type),__alignof__(type),(n)))
 
-static inline int heap_free(void)
+static inline bool heap_free(size_t n)
 {
-	return heap_end-HEAP;
+	return (int)(heap_end-HEAP) >= (int)n;
 }
 
 /* copy.S */
--- a/arch/i386/boot/video-bios.c
+++ b/arch/i386/boot/video-bios.c
@@ -79,7 +79,7 @@ static int bios_probe(void)
 	video_bios.modes = GET_HEAP(struct mode_info, 0);
 
 	for (mode = 0x14; mode <= 0x7f; mode++) {
-		if (heap_free() < sizeof(struct mode_info))
+		if (!heap_free(sizeof(struct mode_info)))
 			break;
 
 		if (mode_defined(VIDEO_FIRST_BIOS+mode))
--- a/arch/i386/boot/video-vesa.c
+++ b/arch/i386/boot/video-vesa.c
@@ -57,7 +57,7 @@ static int vesa_probe(void)
 	while ((mode = rdfs16(mode_ptr)) != 0xffff) {
 		mode_ptr += 2;
 
-		if (heap_free() < sizeof(struct mode_info))
+		if (!heap_free(sizeof(struct mode_info)))
 			break;	/* Heap full, can't save mode info */
 
 		if (mode & ~0x1ff)
--- a/arch/i386/boot/video.c
+++ b/arch/i386/boot/video.c
@@ -371,7 +371,7 @@ static void save_screen(void)
 	saved.curx = boot_params.screen_info.orig_x;
 	saved.cury = boot_params.screen_info.orig_y;
 
-	if (heap_free() < saved.x*saved.y*sizeof(u16)+512)
+	if (!heap_free(saved.x*saved.y*sizeof(u16)+512))
 		return;		/* Not enough heap to save the screen */
 
 	saved.data = GET_HEAP(u16, saved.x*saved.y);

-- 
