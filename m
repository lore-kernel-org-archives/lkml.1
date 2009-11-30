Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZK3BKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZK3BKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 20:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZK3BKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 20:10:30 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:39031 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZK3BK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 20:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JQkAdKYMbhKvD6oEgm0bpW3UNafY3AK5w2fXYTmTm+/XXdbwQZelED7Rz24kX0DtnZ
         u5SGbbSQIg6f5TSUgcwCTN5TKulHOK+LGmgm/Kpn8ZghPNksFKaMEyjygwIhERHssDOD
         HTsHyUKPJxMDjExMmVAfNJyTUKn/IWnlciU0c=
Date: Sun, 29 Nov 2009 17:10:31 -0800
From: 640E9920 <640e9920@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com
Subject: [RFC] PM_QOS api update to use handles 4/5 (wireless updates)
Message-ID: <20091130011031.GD4732@mgross-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Updates to wireless clients to pm_qos associeated with api change to use
handles.

--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>


---
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 ++++++-----
 net/mac80211/mlme.c                    |    2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/=
ipw2x00/ipw2100.c
index 6e2fc0c..6fe87f0 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -174,6 +174,8 @@ that only one external action is invoked at a time.
 #define DRV_DESCRIPTION	"Intel(R) PRO/Wireless 2100 Network Driver"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
=20
+struct pm_qos_request_list *ipw2100_pm_qos_req;
+
 /* Debugging stuff */
 #ifdef CONFIG_IPW2100_DEBUG
 #define IPW2100_RX_DEBUG	/* Reception debugging */
@@ -1708,7 +1710,7 @@ static int ipw2100_up(struct ipw2100_priv *priv, int =
deferred)
 	/* the ipw2100 hardware really doesn't want power management delays
 	 * longer than 175usec
 	 */
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100", 175);
+	pm_qos_update_request(ipw2100_pm_qos_req, 175);
=20
 	/* If the interrupt is enabled, turn it off... */
 	spin_lock_irqsave(&priv->low_lock, flags);
@@ -1863,8 +1865,7 @@ static void ipw2100_down(struct ipw2100_priv *priv)
 	ipw2100_disable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->low_lock, flags);
=20
-	pm_qos_update_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
-			PM_QOS_DEFAULT_VALUE);
+	pm_qos_update_request(ipw2100_pm_qos_req, PM_QOS_DEFAULT_VALUE);
=20
 	/* We have to signal any supplicant if we are disassociating */
 	if (associated)
@@ -6572,7 +6573,7 @@ static int __init ipw2100_init(void)
 	if (ret)
 		goto out;
=20
-	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
+	ipw2100_pm_qos_req =3D pm_qos_add_request(PM_QOS_CPU_DMA_LATENCY,
 			PM_QOS_DEFAULT_VALUE);
 #ifdef CONFIG_IPW2100_DEBUG
 	ipw2100_debug_level =3D debug;
@@ -6595,7 +6596,7 @@ static void __exit ipw2100_exit(void)
 			   &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&ipw2100_pci_driver);
-	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100");
+	pm_qos_remove_request(ipw2100_pm_qos_req);
 }
=20
 module_init(ipw2100_init);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dc5049d..ed1d2dd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -696,7 +696,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local,=
 s32 latency)
 		s32 beaconint_us;
=20
 		if (latency < 0)
-			latency =3D pm_qos_requirement(PM_QOS_NETWORK_LATENCY);
+			latency =3D pm_qos_request(PM_QOS_NETWORK_LATENCY);
=20
 		beaconint_us =3D ieee80211_tu_to_usec(
 					found->vif.bss_conf.beacon_int);
--=20
1.6.3.3


--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksTG4cACgkQhK5OsmQOmSBTZQCfUQjnnX3yUjTjqsRa63YDmVM2
AkMAnjJHftWAnfnftIDdG0FXiBuWmFFr
=VXNx
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
