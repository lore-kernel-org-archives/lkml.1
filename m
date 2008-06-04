Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYFDN4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYFDN4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYFDN4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:56:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYFDN4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:56:04 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080604125500.0fce2ea4@core>
References: <48447615.5050806@am.sony.com>
	 <1212500751.16924.322.camel@pmac.infradead.org>
	 <4845DB46.3020308@am.sony.com>  <20080604125500.0fce2ea4@core>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 14:55:53 +0100
Message-Id: <1212587753.32207.86.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 12:55 +0100, Alan Cox wrote:
> Can we please get the ifdefs tided up before this goes in.
> 
> For the moment this has a NAK from the tty maintainer but if the
> ifdefs
> turned went into headers where they belong and the code looked like
> say
> 
>                 tc = vc_translate(vc, c);
> 
> with two versions of vc_translate (one being vc_translate(x) (x)) it
> might be more reasonable.

Good point. I did think about that originally, but then just completely
forgot to process that hunk of the original patch altogether, which was
another way of avoiding the ifdefs :)

If I merge this incremental patch, does that address your objections?

(Note that I've changed the expression to evaluate (c) only once, just
because that's best practice in macro definitions. Wasn't really worth
doing it for (vc) though.)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index de52f99..18b7fb0 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2208,11 +2208,7 @@ rescan_last_byte:
 			c = 0xfffd;
 		    tc = c;
 		} else {	/* no utf or alternate charset mode */
-#ifdef CONFIG_CONSOLE_TRANSLATIONS
-		    tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
-#else
-		    tc = c;
-#endif
+		    tc = vc_translate(vc, c);
 		}
 
 		param.c = tc;
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 81ed155..929ee80 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -72,6 +72,9 @@ int con_set_default_unimap(struct vc_data *vc);
 void con_free_unimap(struct vc_data *vc);
 void con_protect_unimap(struct vc_data *vc, int rdonly);
 int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
+
+#define vc_translate(vc, c) ((vc)->vc_translate[(c) | \
+					(vc)->vc_toggle_meta ? 0x80 : 0])
 #else
 #define con_set_trans_old(arg) (0)
 #define con_get_trans_old(arg) (-EINVAL)
@@ -83,6 +86,8 @@ int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
 #define con_copy_unimap(d, s) (0)
 #define con_get_unimap(vc, ct, uct, list) (-EINVAL)
 #define con_free_unimap(vc) do { ; } while (0)
+
+#define vc_translate(vc, c) (c)
 #endif
 
 /* vt.c */

-- 
dwmw2

