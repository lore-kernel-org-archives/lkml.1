Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbZHQHsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbZHQHsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZHQHsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:48:15 -0400
Received: from server1.wserver.cz ([82.113.45.157]:43099 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbZHQHsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:48:15 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, andi@firstfloor.org,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] VIDEO: console, use DIV_ROUND_UP
Date: Mon, 17 Aug 2009 09:48:13 +0200
Message-Id: <1250495293-13035-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090817073147.GA2967@localdomain.by>
References: <20090817073147.GA2967@localdomain.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 09:31 AM, Sergey Senozhatsky wrote:
> On (08/17/09 09:15), Jiri Slaby wrote:
>> Not at all. I was writing about about (X + 7) / 8 [or >> 3] which is
>> DIV_ROUND_UP(X, 8).
>>
> As far as I can understand: 
> DIV_ROUND_UP(61, 8):
> (111101 + 111) >> 3 -> 1000 == 8
> 
> (int)(61/8) == 7

Yeah, that's why there is the ROUND_UP keyword in the macro.

I mean this:
--
Use DIV_ROUND_UP explicitly instead of manual shifts and adds. It makes
the code more readable and consistent (sometimes there were shifts,
sometimes divs).

There is no change on the assembly level (compilers should do the right
job).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/video/console/bitblit.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 69864b1..6b7c8fb 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -25,7 +25,7 @@ static inline void update_attr(u8 *dst, u8 *src, int attribute,
 			       struct vc_data *vc)
 {
 	int i, offset = (vc->vc_font.height < 10) ? 1 : 2;
-	int width = (vc->vc_font.width + 7) >> 3;
+	int width = DIV_ROUND_UP(vc->vc_font.width, 8);
 	unsigned int cellsize = vc->vc_font.height * width;
 	u8 c;
 
@@ -144,7 +144,7 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 		      int fg, int bg)
 {
 	struct fb_image image;
-	u32 width = (vc->vc_font.width + 7)/8;
+	u32 width = DIV_ROUND_UP(vc->vc_font.width, 8);
 	u32 cellsize = width * vc->vc_font.height;
 	u32 maxcnt = info->pixmap.size/cellsize;
 	u32 scan_align = info->pixmap.scan_align - 1;
@@ -173,7 +173,7 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 			cnt = count;
 
 		image.width = vc->vc_font.width * cnt;
-		pitch = ((image.width + 7) >> 3) + scan_align;
+		pitch = DIV_ROUND_UP(image.width, 8) + scan_align;
 		pitch &= ~scan_align;
 		size = pitch * image.height + buf_align;
 		size &= ~buf_align;
@@ -239,7 +239,7 @@ static void bit_cursor(struct vc_data *vc, struct fb_info *info, int mode,
 	struct fb_cursor cursor;
 	struct fbcon_ops *ops = info->fbcon_par;
 	unsigned short charmask = vc->vc_hi_font_mask ? 0x1ff : 0xff;
-	int w = (vc->vc_font.width + 7) >> 3, c;
+	int w = DIV_ROUND_UP(vc->vc_font.width, 8), c;
 	int y = real_y(ops->p, vc->vc_y);
 	int attribute, use_sw = (vc->vc_cursor_type & 0x10);
 	int err = 1;
-- 
1.6.3.3

