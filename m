Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYKGXZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYKGXZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYKGXW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:22:57 -0500
Received: from kroah.org ([198.145.64.141]:59210 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753566AbYKGXW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:22:56 -0500
Date: Fri, 7 Nov 2008 15:15:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 06/23] libertas: fix buffer overrun
Message-ID: <20081107231525.GG1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libertas-fix-buffer-overrun.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit 48735d8d8bd701b1e0cd3d49c21e5e385ddcb077 upstream

If somebody sends an invalid beacon/probe response, that can trash the
whole BSS descriptor. The descriptor is, luckily, large enough so that
it cannot scribble past the end of it; it's well above 400 bytes long.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/libertas/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -598,8 +598,8 @@ static int lbs_process_bss(struct bss_de
 
 		switch (elem->id) {
 		case MFIE_TYPE_SSID:
-			bss->ssid_len = elem->len;
-			memcpy(bss->ssid, elem->data, elem->len);
+			bss->ssid_len = min_t(int, 32, elem->len);
+			memcpy(bss->ssid, elem->data, bss->ssid_len);
 			lbs_deb_scan("got SSID IE: '%s', len %u\n",
 			             escape_essid(bss->ssid, bss->ssid_len),
 			             bss->ssid_len);

-- 
