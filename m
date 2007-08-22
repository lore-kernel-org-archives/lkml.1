Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbXHVJNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbXHVJNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbXHVIx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:59 -0400
Received: from iona.labri.fr ([147.210.8.143]:52029 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759074AbXHVIx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:57 -0400
Date: Wed, 22 Aug 2007 10:53:55 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Console events and accessibility
Message-ID: <20070822085355.GB3359@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070821212939.GD3658@interface.famille.thibault.fr> <20070822054855.GB23336@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070822054855.GB23336@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH, le Tue 21 Aug 2007 22:48:55 -0700, a écrit :
> On Tue, Aug 21, 2007 at 11:29:39PM +0200, Samuel Thibault wrote:
> > Some external modules like Speakup need to monitor console output.
> > 
> > This adds a VT notifier that such modules can use to get console output events:
> > allocation, deallocation, writes, other updates (cursor position, switch, etc.)
> > 
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> Will speakup work with this kind of change?

Here are the last needed bits.

Samuel

Export inverse_translate, kd_mksound and screen_glyph for speakup. Also
reserve KT_SPKUP.

diff --git a/drivers/char/consolemap.c b/drivers/char/consolemap.c
index 4b3916f..37c7980 100644
--- a/drivers/char/consolemap.c
+++ b/drivers/char/consolemap.c
@@ -277,6 +277,7 @@
 			return p->inverse_translations[m][glyph];
 	}
 }
+EXPORT_SYMBOL_GPL(inverse_translate);
 
 static void update_user_maps(void)
 {
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -101,7 +101,7 @@
 const int max_vals[] = {
 	255, ARRAY_SIZE(func_table) - 1, ARRAY_SIZE(fn_handler) - 1, NR_PAD - 1,
 	NR_DEAD - 1, 255, 3, NR_SHIFT - 1, 255, NR_ASCII - 1, NR_LOCK - 1,
-	255, NR_LOCK - 1, 255, NR_BRL - 1
+	255, NR_LOCK - 1, 255, NR_BRL - 1, NR_SPKUP - 1
 };
 
 const int NR_TYPES = ARRAY_SIZE(max_vals);
@@ -240,6 +240,7 @@
 	} else
 		kd_nosound(0);
 }
+EXPORT_SYMBOL_GPL(kd_mksound);
 
 /*
  * Setting the keyboard rate.
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -3934,6 +3934,7 @@
 		c |= 0x100;
 	return c;
 }
+EXPORT_SYMBOL_GPL(screen_glyph);
 
 /* used by vcs - note the word offset */
 unsigned short *screen_pos(struct vc_data *vc, int w_offset, int viewed)
--- a/include/linux/keyboard.h
+++ b/include/linux/keyboard.h
@@ -45,6 +45,7 @@
 #define KT_LOCK		10
 #define KT_SLOCK	12
 #define KT_BRL		14
+#define KT_SPKUP	15
 
 #define K(t,v)		(((t)<<8)|(v))
 #define KTYP(x)		((x) >> 8)
@@ -442,5 +443,7 @@
 
 #define NR_BRL		11
 
+#define NR_SPKUP	0x56
+
 #define MAX_DIACR	256
 #endif
