Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbYI1LAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbYI1LAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 07:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYI1LAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 07:00:15 -0400
Received: from ns1.dnstelecom.co.za ([196.44.87.201]:50393 "EHLO
	pbx.dnstelecom.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751729AbYI1LAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 07:00:13 -0400
X-Greylist: delayed 876 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2008 07:00:10 EDT
X-pbx.dnstelecom.co.za-MailScanner-Watermark: 1223203486.63355@Nis5+qp4jH3rmLPhVIgl/Q
Message-ID: <48DF601C.9060406@dnstelecom.co.za>
Date: Sun, 28 Sep 2008 12:44:44 +0200
From: Gregory Nietsky <gregory@dnstelecom.co.za>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH 1/1] Ath5k: add AP mode
References: <1222519728-14989-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1222519728-14989-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-pbx.dnstelecom.co.za-MailScanner-Information: Please contact Network Sentry  for more information (www.networksentry.co.za)
X-pbx.dnstelecom.co.za-MailScanner: Found to be clean
X-pbx.dnstelecom.co.za-MailScanner-From: gregory@dnstelecom.co.za
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gents it is great to see this happen one snippet more and you will be 
able to set the interface into AP mode from userspace hostapd and friends.


diff --git a/drivers/net/wireless/ath5k/base.c 
b/drivers/net/wireless/ath5k/base.c
index e09ed2c..69aad6e 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -488,6 +488,7 @@ ath5k_pci_probe(struct pci_dev *pdev,

        hw->wiphy->interface_modes =
                BIT(NL80211_IFTYPE_STATION) |
+               BIT(NL80211_IFTYPE_AP) |
                BIT(NL80211_IFTYPE_ADHOC) |
                BIT(NL80211_IFTYPE_MESH_POINT);


i have had it working and no complaints so far.

please note that as with mac80211_hwsim it is dependent on a patch

Documentation/networking/mac80211_hwsim/README

Please note that the current Linux kernel does not enable AP mode, so a
simple patch is needed to enable AP mode selection:
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/006-allow-ap-vlan-modes.patch

-->

Subject: mac80211: allow AP and VLAN modes

This patch allows switching interfaces into AP/VLAN modes using
cfg80211 (nl80211). Don't allow doing it with wext because then
people will just attempt to do it manually (without hostapd) and
complain that it doesn't work.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |    2 ++
 1 file changed, 2 insertions(+)

--- everything.orig/net/mac80211/cfg.c	2008-09-26 15:07:22.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-26 15:09:06.000000000 +0200
@@ -33,6 +33,8 @@ static bool nl80211_type_check(enum nl80
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
 #endif
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 		return true;
 	default:


<--


Regards Greg

Jiri Slaby wrote:
> Add support for AP mode. This involves:
> - enablement in ath5k_beacon_config -- initialize beacon timer
> - add AP to the supported modes in ath5k_add_interface
> - handle beacon change even for AP in ath5k_config_interface
> - remove useless test for IBSS in ath5k_beacon_update
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   42 +++++++++++++++----------------------
>  1 files changed, 17 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index e09ed2c..d5d8e2d 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
>   

--
This message has been scanned for viruses and
dangerous content by Network Sentry, and 
is believed to be clean.
http://www.dialandsave.co.za

