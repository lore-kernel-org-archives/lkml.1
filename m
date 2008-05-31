Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYEaQs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYEaQs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYEaQsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:48:46 -0400
Received: from c60.cesmail.net ([216.154.195.49]:65136 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbYEaQsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:48:45 -0400
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet
	transmit
From: Pavel Roskin <proski@gnu.org>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 31 May 2008 12:48:42 -0400
Message-Id: <1212252522.2766.8.camel@rd>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

You beat me at reporting it.  I was about to report the same thing.
Basically, my laptop with bcm4311 started crashing when using WEP in the
last weeks.  Its runs the current wireless-testing.

On Sat, 2008-05-31 at 16:23 +0200, Stefanik Gábor wrote:
>  #4 [c04619c8] b43_generate_txhdr at f8dd3a99

Yes, that's where it happens.  This patch prevents the panic, but it's
almost certainly not the right fix.

diff --git a/drivers/net/wireless/b43/xmit.c
b/drivers/net/wireless/b43/xmit.c
index f9e1cff..5ec8d86 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -234,11 +234,14 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
 	if (use_encryption) {
-		u8 key_idx = info->control.hw_key->hw_key_idx;
+		u8 key_idx;
 		struct b43_key *key;
 		int wlhdr_len;
 		size_t iv_len;
 
+		if (!info->control.hw_key)
+			return -ENOKEY;
+		key_idx = info->control.hw_key->hw_key_idx;
 		B43_WARN_ON(key_idx >= dev->max_nr_keys);
 		key = &(dev->key[key_idx]);
 
Another workaround is to use nohwcrypt=1 in the module options.

It's strange that other drivers (b43legacy, ath5k) use
info->control.hw_key->hw_key_idx under the same conditions (see how
use_encryption is calculated), but don't have any problems on the same
network (but I need to recheck).

I'm using 40-bit WEP with wpa_supplicant (because it's configured to
recognize many networks, some of which are with WPA).  I don't know if
it's relevant.  It's Fedora 9 for x86_64, but NetworkManager is
disabled.

-- 
Regards,
Pavel Roskin
