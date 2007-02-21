Return-Path: <linux-kernel-owner+w=401wt.eu-S1751098AbXBUBmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098AbXBUBmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXBUBmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:42:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:34721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbXBUBkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:40:01 -0500
Date: Tue, 20 Feb 2007 17:38:39 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dcbw@redhat.com>
Subject: [patch 18/21] prism54: correct assignment of DOT1XENABLE in WE-19 codepaths
Message-ID: <20070221013839.GS30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="prism54-correct-assignment-of-dot1xenable-in-we-19-codepaths.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

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

--- linux-2.6.19.4.orig/drivers/net/wireless/prism54/isl_ioctl.c
+++ linux-2.6.19.4/drivers/net/wireless/prism54/isl_ioctl.c
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
