Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760056AbYLQAJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYLQAJb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759695AbYLQAGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:12 -0500
Received: from kroah.org ([198.145.64.141]:41340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758368AbYLQAGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:08 -0500
Date: Tue, 16 Dec 2008 16:04:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kadianakis George <desnacked@gmail.com>
Subject: [patch 15/22] key: fix setkey(8) policy set breakage
Message-ID: <20081217000429.GP4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="key-fix-setkey-policy-set-breakage.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 920da6923cf03c8a78fbaffa408f8ab37f6abfc1 upstream.

Steps to reproduce:

	#/usr/sbin/setkey -f
	flush;
	spdflush;

	add 192.168.0.42 192.168.0.1 ah 24500 -A hmac-md5 "1234567890123456";
	add 192.168.0.42 192.168.0.1 esp 24501 -E 3des-cbc "123456789012123456789012";

	spdadd 192.168.0.42 192.168.0.1 any -P out ipsec
		esp/transport//require
		ah/transport//require;

setkey: invalid keymsg length

Policy dump will bail out with the same message after that.

-recv(4, "\2\16\0\0\32\0\3\0\0\0\0\0\37\r\0\0\3\0\5\0\377 \0\0\2\0\0\0\300\250\0*\0"..., 32768, 0) = 208
+recv(4, "\2\16\0\0\36\0\3\0\0\0\0\0H\t\0\0\3\0\5\0\377 \0\0\2\0\0\0\300\250\0*\0"..., 32768, 0) = 208

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Kadianakis George <desnacked@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/key/af_key.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2051,7 +2051,6 @@ static int pfkey_xfrm_policy2msg(struct 
 			req_size += socklen * 2;
 		} else {
 			size -= 2*socklen;
-			socklen = 0;
 		}
 		rq = (void*)skb_put(skb, req_size);
 		pol->sadb_x_policy_len += req_size/8;

