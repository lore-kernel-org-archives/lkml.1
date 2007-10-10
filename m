Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXJJKqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXJJKqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXJJKqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:46:34 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1785 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbXJJKqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:46:32 -0400
Date: Wed, 10 Oct 2007 14:45:40 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk,
       Pierre Ossman <drzeus@drzeus.cx>, akpm@osdl.org,
       linux-sparse@vger.kernel.org
Subject: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
Message-ID: <20071010104540.GA6366@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

["if (!x & y)" patch from yanzheng@]
["if (!x & y)" patch from adobriyan@]
["if (!x & y)" patches from viro@]

While we're at it, below is somewhat ugly sparse patch for detecting
"&& 0x" typos.

diff --git a/evaluate.c b/evaluate.c
index c0e9d17..186756b 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -877,6 +877,13 @@ static struct symbol *evaluate_logical(struct expression *expr)
 	if (!evaluate_conditional(expr->right, 0))
 		return NULL;
 
+	if (expr->op == SPECIAL_LOGICAL_AND) {
+		if (expr->left->type == EXPR_VALUE && expr->left->orig_in_hex)
+			warning(expr->pos, "dubious && 0x");
+		if (expr->right->type == EXPR_VALUE && expr->right->orig_in_hex)
+			warning(expr->pos, "dubious && 0x");
+	}
+
 	expr->ctype = &bool_ctype;
 	if (expr->flags) {
 		if (!(expr->left->flags & expr->right->flags & Int_const_expr))
diff --git a/expression.c b/expression.c
index 289927a..9bcf586 100644
--- a/expression.c
+++ b/expression.c
@@ -361,6 +361,7 @@ got_it:
 	expr->flags = Int_const_expr;
         expr->ctype = ctype_integer(modifiers);
         expr->value = value;
+	expr->orig_in_hex = (str[0] == '0' && (str[1] == 'x' || str[1] == 'X'));
 	return;
 Eoverflow:
 	error_die(expr->pos, "constant %s is too big even for unsigned long long",
@@ -70,6 +70,7 @@ struct expression {
 		struct {
 			unsigned long long value;
 			unsigned taint;
+			unsigned int orig_in_hex:1;
 		};
 
 		// EXPR_FVALUE


Here are wonders that it found:

drivers/media/video/se401.c:1283:13: warning: dubious && 0x

	if (!cp[2] && SE401_FORMAT_BAYER) {
		err("Bayer format not supported!");
		return 1;
	}

	known issue, I sent a patch about it.


drivers/mmc/host/tifm_sd.c:183:9: warning: dubious && 0x

	if ((r_data->flags & MMC_DATA_WRITE)
            && DATA_CARRY)
		writel(host->bounce_buf_data[0],
		host->dev->addr
		+ SOCK_MMCSD_DATA);

	given that DATA_CARRY is always used together with ->cmd_flags,
	this place is asking for obvious fixlet:


[PATCH] tifm_sd.c: fix DATA_CARRY check

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/mmc/host/tifm_sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -180,7 +180,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 			host->sg_pos++;
 			if (host->sg_pos == host->sg_len) {
 				if ((r_data->flags & MMC_DATA_WRITE)
-				    && DATA_CARRY)
+				    && (host->cmd_flags & DATA_CARRY))
 					writel(host->bounce_buf_data[0],
 					       host->dev->addr
 					       + SOCK_MMCSD_DATA);



drivers/net/wireless/arlan-main.c:439:3: warning: dubious && 0x
drivers/net/wireless/arlan-main.c:439:3: warning: dubious && 0x
drivers/net/wireless/arlan-main.c:439:3: warning: dubious && 0x
drivers/net/wireless/arlan-main.c:439:3: warning: dubious && 0x

	#define setPowerOff(dev){\ 
	   writeControlRegister(dev,readControlRegister(dev) |
	   (ARLAN_POWER && ARLAN_ACCESS));
	   		^^^


[PATCH] arlan: fix "x && y" typo

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/net/wireless/arlan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/arlan.h
+++ b/drivers/net/wireless/arlan.h
@@ -485,7 +485,7 @@ struct arlan_private {
 #define clearClearInterrupt(dev){\
    writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_CLEAR_INTERRUPT);}
 #define setPowerOff(dev){\
-   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER && ARLAN_ACCESS));\
+   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER & ARLAN_ACCESS));\
    writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_ACCESS);}
 #define setPowerOn(dev){\
    writeControlRegister(dev,readControlRegister(dev) & ~(ARLAN_POWER));   }

