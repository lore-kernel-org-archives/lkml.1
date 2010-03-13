Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935622Ab0CMAdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:33:13 -0500
Received: from kroah.org ([198.145.64.141]:46919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935420Ab0CMAbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:32 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:10 2010
Message-Id: <20100313002710.124371847@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [056/145] rndis_wlan: fix buffer overflow in rndis_query_oid
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit c1f8ca1d837148bf061d6ffa2038366e3cf0e4d7 upstream.

rndis_query_oid overwrites *len which stores buffer size to return full size
of received command and then uses *len with memcpy to fill buffer with
command.

Ofcourse memcpy should be done before replacing buffer size.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rndis_wlan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -733,12 +733,13 @@ static int rndis_query_oid(struct usbnet
 			le32_to_cpu(u.get_c->status));
 
 	if (ret == 0) {
+		memcpy(data, u.buf + le32_to_cpu(u.get_c->offset) + 8, *len);
+
 		ret = le32_to_cpu(u.get_c->len);
 		if (ret > *len)
 			*len = ret;
-		memcpy(data, u.buf + le32_to_cpu(u.get_c->offset) + 8, *len);
-		ret = rndis_error_status(u.get_c->status);
 
+		ret = rndis_error_status(u.get_c->status);
 		if (ret < 0)
 			devdbg(dev, "rndis_query_oid(%s): device returned "
 				"error,  0x%08x (%d)", oid_to_string(oid),


