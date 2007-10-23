Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbXJWVNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbXJWVNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbXJWVM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:12:57 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:53510 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbXJWVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:12:51 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/4] isdn: Use stringbuf
Date: Tue, 23 Oct 2007 17:12:44 -0400
Message-Id: <1193173966-3550-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the _cdebbuf structure that was used to accumulate strings
for a debug printk and use the stringbuf instead.  Allocate the stringbuf
on the stack instead of with kmalloc.  Return a char * to the callers
rather than a stringbuf.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/isdn/capi/capidrv.c   |   18 ++--
 drivers/isdn/capi/capiutil.c  |  220 ++++++++++-------------------------------
 drivers/isdn/capi/kcapi.c     |   35 +++----
 include/linux/isdn/capiutil.h |   16 +---
 4 files changed, 83 insertions(+), 206 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 476012b..ba6645c 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -995,7 +995,7 @@ static void handle_plci(_cmsg * cmsg)
 	capidrv_contr *card = findcontrbynumber(cmsg->adr.adrController & 0x7f);
 	capidrv_plci *plcip;
 	isdn_ctrl cmd;
-	_cdebbuf *cdb;
+	char *s;
 
 	if (!card) {
 		printk(KERN_ERR "capidrv: %s from unknown controller 0x%x\n",
@@ -1128,11 +1128,11 @@ static void handle_plci(_cmsg * cmsg)
 				break;
 			}
 		}
-		cdb = capi_cmsg2str(cmsg);
-		if (cdb) {
+		s = capi_cmsg2str(cmsg);
+		if (s) {
 			printk(KERN_WARNING "capidrv-%d: %s\n",
-				card->contrnr, cdb->buf);
-			cdebbuf_free(cdb);
+				card->contrnr, s);
+			kfree(s);
 		} else
 			printk(KERN_WARNING "capidrv-%d: CAPI_INFO_IND InfoNumber %x not handled\n",
 				card->contrnr, cmsg->InfoNumber);
@@ -1385,12 +1385,12 @@ static void capidrv_recv_message(struct capi20_appl *ap, struct sk_buff *skb)
 {
 	capi_message2cmsg(&s_cmsg, skb->data);
 	if (debugmode > 3) {
-		_cdebbuf *cdb = capi_cmsg2str(&s_cmsg);
+		char *s = capi_cmsg2str(&s_cmsg);
 
-		if (cdb) {
+		if (s) {
 			printk(KERN_DEBUG "%s: applid=%d %s\n", __FUNCTION__,
-				ap->applid, cdb->buf);
-			cdebbuf_free(cdb);
+				ap->applid, s);
+			kfree(s);
 		} else
 			printk(KERN_DEBUG "%s: applid=%d %s not traced\n",
 				__FUNCTION__, ap->applid,
diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
index 22379b9..c8df3f0 100644
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/stddef.h>
+#include <linux/stringbuf.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/init.h>
@@ -705,75 +706,28 @@ static char *pnames[] =
     /*2f */ "Useruserdata"
 };
 
-
-
-#include <stdarg.h>
-
-/*-------------------------------------------------------*/
-static _cdebbuf *bufprint(_cdebbuf *cdb, char *fmt,...)
-{
-	va_list f;
-	size_t n,r;
-
-	if (!cdb)
-		return NULL;
-	va_start(f, fmt);
-	r = cdb->size - cdb->pos;
-	n = vsnprintf(cdb->p, r, fmt, f);
-	va_end(f);
-	if (n >= r) {
-		/* truncated, need bigger buffer */
-		size_t ns = 2 * cdb->size;
-		u_char *nb;
-
-		while ((ns - cdb->pos) <= n)
-			ns *= 2;
-		nb = kmalloc(ns, GFP_ATOMIC);
-		if (!nb) {
-			cdebbuf_free(cdb);
-			return NULL;
-		}
-		memcpy(nb, cdb->buf, cdb->pos);
-		kfree(cdb->buf);
-		nb[cdb->pos] = 0;
-		cdb->buf = nb;
-		cdb->p = cdb->buf + cdb->pos;
-		cdb->size = ns;
-		va_start(f, fmt);
-		r = cdb->size - cdb->pos;
-		n = vsnprintf(cdb->p, r, fmt, f);
-		va_end(f);
-	}
-	cdb->p += n;
-	cdb->pos += n;
-	return cdb;
-}
-
-static _cdebbuf *printstructlen(_cdebbuf *cdb, u8 * m, unsigned len)
+static void printstructlen(struct stringbuf *sb, u8 *m, unsigned len)
 {
 	unsigned hex = 0;
 
-	if (!cdb)
-		return NULL;
 	for (; len; len--, m++)
 		if (isalnum(*m) || *m == ' ') {
 			if (hex)
-				cdb = bufprint(cdb, ">");
-			cdb = bufprint(cdb, "%c", *m);
+				sb_printf(sb, ">");
+			sb_printf(sb, "%c", *m);
 			hex = 0;
 		} else {
 			if (!hex)
-				cdb = bufprint(cdb, "<%02x", *m);
+				sb_printf(sb, "<%02x", *m);
 			else
-				cdb = bufprint(cdb, " %02x", *m);
+				sb_printf(sb, " %02x", *m);
 			hex = 1;
 		}
 	if (hex)
-		cdb = bufprint(cdb, ">");
-	return cdb;
+		sb_printf(sb, ">");
 }
 
-static _cdebbuf *printstruct(_cdebbuf *cdb, u8 * m)
+static void printstruct(struct stringbuf *sb, u8 *m)
 {
 	unsigned len;
 
@@ -784,45 +738,42 @@ static _cdebbuf *printstruct(_cdebbuf *cdb, u8 * m)
 		len = ((u16 *) (m + 1))[0];
 		m += 3;
 	}
-	cdb = printstructlen(cdb, m, len);
-	return cdb;
+	printstructlen(sb, m, len);
 }
 
 /*-------------------------------------------------------*/
 #define NAME (pnames[cmsg->par[cmsg->p]])
 
-static _cdebbuf *protocol_message_2_pars(_cdebbuf *cdb, _cmsg *cmsg, int level)
+static void protocol_message_2_pars(struct stringbuf *sb, _cmsg *cmsg, int level)
 {
 	for (; TYP != _CEND; cmsg->p++) {
 		int slen = 29 + 3 - level;
 		int i;
 
-		if (!cdb)
-			return NULL;
-		cdb = bufprint(cdb, "  ");
+		sb_printf(sb, "  ");
 		for (i = 0; i < level - 1; i++)
-			cdb = bufprint(cdb, " ");
+			sb_printf(sb, " ");
 
 		switch (TYP) {
 		case _CBYTE:
-			cdb = bufprint(cdb, "%-*s = 0x%x\n", slen, NAME, *(u8 *) (cmsg->m + cmsg->l));
+			sb_printf(sb, "%-*s = 0x%x\n", slen, NAME, *(u8 *) (cmsg->m + cmsg->l));
 			cmsg->l++;
 			break;
 		case _CWORD:
-			cdb = bufprint(cdb, "%-*s = 0x%x\n", slen, NAME, *(u16 *) (cmsg->m + cmsg->l));
+			sb_printf(sb, "%-*s = 0x%x\n", slen, NAME, *(u16 *) (cmsg->m + cmsg->l));
 			cmsg->l += 2;
 			break;
 		case _CDWORD:
-			cdb = bufprint(cdb, "%-*s = 0x%lx\n", slen, NAME, *(u32 *) (cmsg->m + cmsg->l));
+			sb_printf(sb, "%-*s = 0x%x\n", slen, NAME, *(u32 *) (cmsg->m + cmsg->l));
 			cmsg->l += 4;
 			break;
 		case _CSTRUCT:
-			cdb = bufprint(cdb, "%-*s = ", slen, NAME);
+			sb_printf(sb, "%-*s = ", slen, NAME);
 			if (cmsg->m[cmsg->l] == '\0')
-				cdb = bufprint(cdb, "default");
+				sb_printf(sb, "default");
 			else
-				cdb = printstruct(cdb, cmsg->m + cmsg->l);
-			cdb = bufprint(cdb, "\n");
+				printstruct(sb, cmsg->m + cmsg->l);
+			sb_printf(sb, "\n");
 			if (cmsg->m[cmsg->l] != 0xff)
 				cmsg->l += 1 + cmsg->m[cmsg->l];
 			else
@@ -833,164 +784,102 @@ static _cdebbuf *protocol_message_2_pars(_cdebbuf *cdb, _cmsg *cmsg, int level)
 		case _CMSTRUCT:
 /*----- Metastruktur 0 -----*/
 			if (cmsg->m[cmsg->l] == '\0') {
-				cdb = bufprint(cdb, "%-*s = default\n", slen, NAME);
+				sb_printf(sb, "%-*s = default\n", slen, NAME);
 				cmsg->l++;
 				jumpcstruct(cmsg);
 			} else {
 				char *name = NAME;
 				unsigned _l = cmsg->l;
-				cdb = bufprint(cdb, "%-*s\n", slen, name);
+				sb_printf(sb, "%-*s\n", slen, name);
 				cmsg->l = (cmsg->m + _l)[0] == 255 ? cmsg->l + 3 : cmsg->l + 1;
 				cmsg->p++;
-				cdb = protocol_message_2_pars(cdb, cmsg, level + 1);
+				protocol_message_2_pars(sb, cmsg, level + 1);
 			}
 			break;
 		}
 	}
-	return cdb;
 }
 /*-------------------------------------------------------*/
 
-static _cdebbuf *g_debbuf;
-static u_long g_debbuf_lock;
+static unsigned long g_debbuf_lock;
 static _cmsg *g_cmsg;
 
-static _cdebbuf *cdebbuf_alloc(void)
+static _cmsg *cmsg_alloc(void)
 {
-	_cdebbuf *cdb;
-
-	if (likely(!test_and_set_bit(1, &g_debbuf_lock))) {
-		cdb = g_debbuf;
-		goto init;
-	} else
-		cdb = kmalloc(sizeof(_cdebbuf), GFP_ATOMIC);
-	if (!cdb)
-		return NULL;
-	cdb->buf = kmalloc(CDEBUG_SIZE, GFP_ATOMIC);
-	if (!cdb->buf) {
-		kfree(cdb);
-		return NULL;
-	}
-	cdb->size = CDEBUG_SIZE;
-init:
-	cdb->buf[0] = 0;
-	cdb->p = cdb->buf;
-	cdb->pos = 0;
-	return cdb;
+	if (likely(!test_and_set_bit(1, &g_debbuf_lock)))
+		return g_cmsg;
+	else
+		return kmalloc(sizeof(_cmsg), GFP_ATOMIC);
 }
 
-void cdebbuf_free(_cdebbuf *cdb)
+void cmsg_free(_cmsg *cmsg)
 {
-	if (likely(cdb == g_debbuf)) {
-		test_and_clear_bit(1, &g_debbuf_lock);
-		return;
-	}
-	if (likely(cdb))
-		kfree(cdb->buf);
-	kfree(cdb);
+	if (likely(cmsg == g_cmsg))
+		clear_bit(1, &g_debbuf_lock);
+	else
+		kfree(cmsg);
 }
 
-
-_cdebbuf *capi_message2str(u8 * msg)
+char *capi_message2str(u8 *msg)
 {
-	_cdebbuf *cdb;
-	_cmsg	*cmsg;
-
-	cdb = cdebbuf_alloc();
-	if (unlikely(!cdb))
+	char *s;
+	_cmsg *cmsg = cmsg_alloc();
+	if (unlikely(!cmsg))
 		return NULL;
-	if (likely(cdb == g_debbuf))
-		cmsg = g_cmsg;
-	else
-		cmsg = kmalloc(sizeof(_cmsg), GFP_ATOMIC);
-	if (unlikely(!cmsg)) {
-		cdebbuf_free(cdb);
-		return NULL;
-	}
+
 	cmsg->m = msg;
-	cmsg->l = 8;
-	cmsg->p = 0;
 	byteTRcpy(cmsg->m + 4, &cmsg->Command);
 	byteTRcpy(cmsg->m + 5, &cmsg->Subcommand);
 	cmsg->par = cpars[command_2_index(cmsg->Command, cmsg->Subcommand)];
 
-	cdb = bufprint(cdb, "%-26s ID=%03d #0x%04x LEN=%04d\n",
-		 mnames[command_2_index(cmsg->Command, cmsg->Subcommand)],
-		 ((unsigned short *) msg)[1],
-		 ((unsigned short *) msg)[3],
-		 ((unsigned short *) msg)[0]);
+	s = capi_cmsg2str(cmsg);
+	cmsg_free(cmsg);
 
-	cdb = protocol_message_2_pars(cdb, cmsg, 1);
-	if (unlikely(cmsg != g_cmsg))
-		kfree(cmsg);
-	return cdb;
+	return s;
 }
 
-_cdebbuf *capi_cmsg2str(_cmsg * cmsg)
+char *capi_cmsg2str(_cmsg *cmsg)
 {
-	_cdebbuf *cdb;
+	struct stringbuf sb;
+
+	sb_init(&sb);
 
-	cdb = cdebbuf_alloc();
-	if (!cdb)
-		return NULL;
 	cmsg->l = 8;
 	cmsg->p = 0;
-	cdb = bufprint(cdb, "%s ID=%03d #0x%04x LEN=%04d\n",
+	sb_printf(&sb, "%s ID=%03d #0x%04x LEN=%04d\n",
 		 mnames[command_2_index(cmsg->Command, cmsg->Subcommand)],
 		 ((u16 *) cmsg->m)[1],
 		 ((u16 *) cmsg->m)[3],
 		 ((u16 *) cmsg->m)[0]);
-	cdb = protocol_message_2_pars(cdb, cmsg, 1);
-	return cdb;
+	protocol_message_2_pars(&sb, cmsg, 1);
+	return sb_to_string(&sb);
 }
 
 int __init cdebug_init(void)
 {
-	g_cmsg= kmalloc(sizeof(_cmsg), GFP_KERNEL);
+	g_cmsg = kmalloc(sizeof(_cmsg), GFP_KERNEL);
 	if (!g_cmsg)
 		return ENOMEM;
-	g_debbuf = kmalloc(sizeof(_cdebbuf), GFP_KERNEL);
-	if (!g_debbuf) {
-		kfree(g_cmsg);
-		return ENOMEM;
-	}
-	g_debbuf->buf = kmalloc(CDEBUG_GSIZE, GFP_KERNEL);
-	if (!g_debbuf->buf) {
-		kfree(g_cmsg);
-		kfree(g_debbuf);
-		return ENOMEM;;
-	}
-	g_debbuf->size = CDEBUG_GSIZE;
-	g_debbuf->buf[0] = 0;
-	g_debbuf->p = g_debbuf->buf;
-	g_debbuf->pos = 0;
 	return 0;
 }
 
 void __exit cdebug_exit(void)
 {
-	if (g_debbuf)
-		kfree(g_debbuf->buf);
-	kfree(g_debbuf);
 	kfree(g_cmsg);
 }
 
 #else /* !CONFIG_CAPI_TRACE */
 
-static _cdebbuf g_debbuf = {"CONFIG_CAPI_TRACE not enabled", NULL, 0, 0};
-
-_cdebbuf *capi_message2str(u8 * msg)
-{
-	return &g_debbuf;
-}
+static const char *g_debbuf = "CONFIG_CAPI_TRACE not enabled";
 
-_cdebbuf *capi_cmsg2str(_cmsg * cmsg)
+char *capi_message2str(u8 * msg)
 {
-	return &g_debbuf;
+	return kstrdup(g_debbuf, GFP_ATOMIC);
 }
 
-void cdebbuf_free(_cdebbuf *cdb)
+char *capi_cmsg2str(_cmsg * cmsg)
 {
+	return kstrdup(g_debbuf, GFP_ATOMIC);
 }
 
 int __init cdebug_init(void)
@@ -1004,7 +893,6 @@ void __exit cdebug_exit(void)
 
 #endif
 
-EXPORT_SYMBOL(cdebbuf_free);
 EXPORT_SYMBOL(capi_cmsg2message);
 EXPORT_SYMBOL(capi_message2cmsg);
 EXPORT_SYMBOL(capi_cmsg_header);
diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index f555318..3905331 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -276,14 +276,13 @@ void capi_ctr_handle_message(struct capi_ctr * card, u16 appl, struct sk_buff *s
 	int showctl = 0;
 	u8 cmd, subcmd;
 	unsigned long flags;
-	_cdebbuf *cdb;
 
 	if (card->cardstate != CARD_RUNNING) {
-		cdb = capi_message2str(skb->data);
-		if (cdb) {
+		char *s = capi_message2str(skb->data);
+		if (s) {
 			printk(KERN_INFO "kcapi: controller [%03d] not active, got: %s",
-				card->cnr, cdb->buf);
-			cdebbuf_free(cdb);
+				card->cnr, s);
+			kfree(s);
 		} else
 			printk(KERN_INFO "kcapi: controller [%03d] not active, cannot trace\n",
 				card->cnr);
@@ -307,11 +306,11 @@ void capi_ctr_handle_message(struct capi_ctr * card, u16 appl, struct sk_buff *s
 			       capi_cmd2str(cmd, subcmd),
 			       CAPIMSG_LEN(skb->data));
 		} else {
-			cdb = capi_message2str(skb->data);
-			if (cdb) {
+			char *s = capi_message2str(skb->data);
+			if (s) {
 				printk(KERN_DEBUG "kcapi: got [%03d] %s\n",
-					card->cnr, cdb->buf);
-				cdebbuf_free(cdb);
+					card->cnr, s);
+				kfree(s);
 			} else
 				printk(KERN_DEBUG "kcapi: got [%03d] id#%d %s len=%u, cannot trace\n",
 					card->cnr, CAPIMSG_APPID(skb->data),
@@ -324,12 +323,13 @@ void capi_ctr_handle_message(struct capi_ctr * card, u16 appl, struct sk_buff *s
 	read_lock_irqsave(&application_lock, flags);
 	ap = get_capi_appl_by_nr(CAPIMSG_APPID(skb->data));
 	if ((!ap) || (ap->release_in_progress)) {
+		char *s;
 		read_unlock_irqrestore(&application_lock, flags);
-		cdb = capi_message2str(skb->data);
-		if (cdb) {
+		s = capi_message2str(skb->data);
+		if (s) {
 			printk(KERN_ERR "kcapi: handle_message: applid %d state released (%s)\n",
-			CAPIMSG_APPID(skb->data), cdb->buf);
-			cdebbuf_free(cdb);
+			CAPIMSG_APPID(skb->data), s);
+			kfree(s);
 		} else
 			printk(KERN_ERR "kcapi: handle_message: applid %d state released (%s) cannot trace\n",
 				CAPIMSG_APPID(skb->data),
@@ -649,12 +649,11 @@ u16 capi20_put_message(struct capi20_appl *ap, struct sk_buff *skb)
 			       capi_cmd2str(cmd, subcmd),
 			       CAPIMSG_LEN(skb->data));
 		} else {
-			_cdebbuf *cdb = capi_message2str(skb->data);
-			if (cdb) {
+			char *s = capi_message2str(skb->data);
+			if (s) {
 				printk(KERN_DEBUG "kcapi: put [%03d] %s\n",
-					CAPIMSG_CONTROLLER(skb->data),
-					cdb->buf);
-				cdebbuf_free(cdb);
+					CAPIMSG_CONTROLLER(skb->data), s);
+				kfree(s);
 			} else
 				printk(KERN_DEBUG "kcapi: put [%03d] id#%d %s len=%u cannot trace\n",
 					CAPIMSG_CONTROLLER(skb->data),
diff --git a/include/linux/isdn/capiutil.h b/include/linux/isdn/capiutil.h
index 5a52f2c..bd48c51 100644
--- a/include/linux/isdn/capiutil.h
+++ b/include/linux/isdn/capiutil.h
@@ -177,22 +177,12 @@ char *capi_info2str(__u16 reason);
 
 char *capi_cmd2str(__u8 cmd, __u8 subcmd);
 
-typedef struct {
-	u_char	*buf;
-	u_char	*p;
-	size_t	size;
-	size_t	pos;
-} _cdebbuf;
-
-#define	CDEBUG_SIZE	1024
-#define	CDEBUG_GSIZE	4096
-
-void cdebbuf_free(_cdebbuf *cdb);
 int cdebug_init(void);
 void cdebug_exit(void);
 
-_cdebbuf *capi_cmsg2str(_cmsg *cmsg);
-_cdebbuf *capi_message2str(__u8 *msg);
+/* Callers must kfree the strings returned from these functions */
+char *capi_cmsg2str(_cmsg *cmsg);
+char *capi_message2str(__u8 *msg);
 
 /*-----------------------------------------------------------------------*/
 
-- 
1.5.3.4

