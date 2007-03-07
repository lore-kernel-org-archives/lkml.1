Return-Path: <linux-kernel-owner+w=401wt.eu-S1422756AbXCGSA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422756AbXCGSA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422975AbXCGSA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:00:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:42682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422756AbXCGRNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:31 -0500
Message-Id: <20070307171129.642816571@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>
Subject: [patch 004/101] prism54: correct assignment of DOT1XENABLE in WE-19 codepaths
Content-Disposition: inline; filename=prism54-correct-assignment-of-dot1xenable-in-we-19-codepaths.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Correct assignment of DOT1XENABLE in WE-19 codepaths.
RX_UNENCRYPTED_EAPOL = 1 really means setting DOT1XENABLE _off_, and
vice versa.  The original WE-19 patch erroneously reversed that.  This
patch fixes association with unencrypted and WEP networks when using
wpa_supplicant.

It also adds two missing break statements that, left out, could result
in incorrect card configuration.

Applies to (I think) 2.6.19 and later.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/prism54/isl_ioctl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/net/wireless/prism54/isl_ioctl.c
+++ linux-2.6.20.1/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1395,11 +1395,16 @@ static int prism54_set_auth(struct net_d
 		break;
 
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-		dot1x = param->value ? 1 : 0;
+		/* dot1x should be the opposite of RX_UNENCRYPTED_EAPOL;
+		 * turn off dot1x when  allowing recepit of unencrypted eapol
+		 * frames, turn on dot1x when we disallow receipt
+		 */
+		dot1x = param->value ? 0x00 : 0x01;
 		break;
 
 	case IW_AUTH_PRIVACY_INVOKED:
 		privinvoked = param->value ? 1 : 0;
+		break;
 
 	case IW_AUTH_DROP_UNENCRYPTED:
 		exunencrypt = param->value ? 1 : 0;
@@ -1589,6 +1594,7 @@ static int prism54_set_encodeext(struct 
 			}
 			key.type = DOT11_PRIV_TKIP;
 			key.length = KEY_SIZE_TKIP;
+			break;
 		default:
 			return -EINVAL;
 		}

--
