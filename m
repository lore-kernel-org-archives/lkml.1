Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYGRTFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYGRTFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 15:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbYGRTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 15:05:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:2427 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYGRTFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 15:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=DPr/HPDsFugeTV64QZJ/UYyvSBfZeQHjhZH10quKe6NvR/YPF53Ft7vlSdhdeK6SwG
         attlZ5+n2FTwtOsO2dsrlFBCzavo1XhYldvdMM81S8ckKav0G1CNVprRRZCbPC6vETVo
         kLHHY79q7rjyBSTVicbtkHnFtDUbD5P2j6hXA=
Message-ID: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
Date: Fri, 18 Jul 2008 21:05:18 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
       "Tomas Winkler" <tomasw@gmail.com>,
       "Tomas Winkler" <tomas.winkler@intel.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Marco Schuster" <marco@harddisk.is-a-geek.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_58245_22700195.1216407918154"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_58245_22700195.1216407918154
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Handle station IDs of transmitted packets when in monitor mode, and
remove the various anti-injection checks from the iwl4965 driver.
This makes injection work on IWL4965 and hopefully IWL50xx. Tested on
IWL4965 with aircrack-ng, IWL50xx not tested because I don't have
access to an IWL50xx card.

Note: To inject management frames with this patch, HW crypto support
must be disabled using the "swcrypto=3D1" modparam (or "swcrypto50=3D1"
for IWL50xx). Otherwise most management frames won't be transmitted.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---

Patch also available as an attachment on this e-mail, as Gmail tends
to whitespace-damage patches.

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c
b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 6d1467d..78b1315 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -968,6 +968,11 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct
ieee80211_hdr *hdr)
 =09=09iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 =09=09return priv->hw_params.bcast_sta_id;

+=09/* If we are in monitor mode, use BCAST. This is required for
+=09 * packet injection. */
+=09case IEEE80211_IF_TYPE_MNTR:
+=09=09return priv->hw_params.bcast_sta_id;
+
 =09default:
 =09=09IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 =09=09return priv->hw_params.bcast_sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 032641d..55149d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -783,11 +783,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *=
skb)
 =09=09goto drop_unlock;
 =09}

-=09if (!priv->vif) {
-=09=09IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-=09=09goto drop_unlock;
-=09}
-
 =09if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) =3D=3D
 =09     IWL_INVALID_RATE) {
 =09=09IWL_ERROR("ERROR: No TX rate available.\n");
@@ -810,9 +805,11 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *=
skb)

 =09/* drop all data frame if we are not associated */
 =09if (ieee80211_is_data(fc) &&
-=09   (!iwl_is_associated(priv) ||
-=09    ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id) |=
|
-=09    !priv->assoc_station_added)) {
+=09    (priv->iw_mode !=3D IEEE80211_IF_TYPE_MNTR ||
+=09    !(info->flags & IEEE80211_TX_CTL_INJECTED)) && /* packet injection =
*/
+=09    (!iwl_is_associated(priv) ||
+=09     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id) =
||
+=09     !priv->assoc_station_added)) {
 =09=09IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
 =09=09goto drop_unlock;
 =09}
@@ -822,7 +819,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *=
skb)
 =09hdr_len =3D ieee80211_get_hdrlen(le16_to_cpu(fc));

 =09/* Find (or create) index into station table for destination station */
-=09sta_id =3D iwl_get_sta_id(priv, hdr);
+=09if (info->flags & IEEE80211_TX_CTL_INJECTED)
+=09=09sta_id =3D priv->hw_params.bcast_sta_id;
+=09else
+=09=09sta_id =3D iwl_get_sta_id(priv, hdr);
 =09if (sta_id =3D=3D IWL_INVALID_STATION) {
 =09=09DECLARE_MAC_BUF(mac);

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 60b7a64..380cc38 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2680,12 +2680,6 @@ static int iwl4965_mac_tx(struct ieee80211_hw
*hw, struct sk_buff *skb)

 =09IWL_DEBUG_MAC80211("enter\n");

-=09if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
-=09=09IWL_DEBUG_MAC80211("leave - monitor\n");
-=09=09dev_kfree_skb_any(skb);
-=09=09return 0;
-=09}
-
 =09IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 =09=09     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);

------=_Part_58245_22700195.1216407918154
Content-Type: application/mbox; name=iwl4965-injection.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fit5uscy0
Content-Disposition: attachment; filename=iwl4965-injection.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXN0YS5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtc3RhLmMKaW5kZXggNmQxNDY3ZC4uNzhiMTMx
NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtc3RhLmMKKysr
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtc3RhLmMKQEAgLTk2OCw2ICs5Njgs
MTEgQEAgaW50IGl3bF9nZXRfc3RhX2lkKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgc3RydWN0IGll
ZWU4MDIxMV9oZHIgKmhkcikKIAkJaXdsX3ByaW50X2hleF9kdW1wKHByaXYsIElXTF9ETF9EUk9Q
LCAodTggKikgaGRyLCBzaXplb2YoKmhkcikpOwogCQlyZXR1cm4gcHJpdi0+aHdfcGFyYW1zLmJj
YXN0X3N0YV9pZDsKIAorCS8qIElmIHdlIGFyZSBpbiBtb25pdG9yIG1vZGUsIHVzZSBCQ0FTVC4g
VGhpcyBpcyByZXF1aXJlZCBmb3IKKwkgKiBwYWNrZXQgaW5qZWN0aW9uLiAqLworCWNhc2UgSUVF
RTgwMjExX0lGX1RZUEVfTU5UUjoKKwkJcmV0dXJuIHByaXYtPmh3X3BhcmFtcy5iY2FzdF9zdGFf
aWQ7CisKIAlkZWZhdWx0OgogCQlJV0xfV0FSTklORygiVW5rbm93biBtb2RlIG9mIG9wZXJhdGlv
bjogJWQiLCBwcml2LT5pd19tb2RlKTsKIAkJcmV0dXJuIHByaXYtPmh3X3BhcmFtcy5iY2FzdF9z
dGFfaWQ7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10eC5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtdHguYwppbmRleCAwMzI2NDFkLi41
NTE0OWQ0IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10eC5j
CisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXR4LmMKQEAgLTc4MywxMSAr
NzgzLDYgQEAgaW50IGl3bF90eF9za2Ioc3RydWN0IGl3bF9wcml2ICpwcml2LCBzdHJ1Y3Qgc2tf
YnVmZiAqc2tiKQogCQlnb3RvIGRyb3BfdW5sb2NrOwogCX0KIAotCWlmICghcHJpdi0+dmlmKSB7
Ci0JCUlXTF9ERUJVR19EUk9QKCJEcm9wcGluZyAtICFwcml2LT52aWZcbiIpOwotCQlnb3RvIGRy
b3BfdW5sb2NrOwotCX0KLQogCWlmICgoaWVlZTgwMjExX2dldF90eF9yYXRlKHByaXYtPmh3LCBp
bmZvKS0+aHdfdmFsdWUgJiAweEZGKSA9PQogCSAgICAgSVdMX0lOVkFMSURfUkFURSkgewogCQlJ
V0xfRVJST1IoIkVSUk9SOiBObyBUWCByYXRlIGF2YWlsYWJsZS5cbiIpOwpAQCAtODEwLDkgKzgw
NSwxMSBAQCBpbnQgaXdsX3R4X3NrYihzdHJ1Y3QgaXdsX3ByaXYgKnByaXYsIHN0cnVjdCBza19i
dWZmICpza2IpCiAKIAkvKiBkcm9wIGFsbCBkYXRhIGZyYW1lIGlmIHdlIGFyZSBub3QgYXNzb2Np
YXRlZCAqLwogCWlmIChpZWVlODAyMTFfaXNfZGF0YShmYykgJiYKLQkgICAoIWl3bF9pc19hc3Nv
Y2lhdGVkKHByaXYpIHx8Ci0JICAgICgocHJpdi0+aXdfbW9kZSA9PSBJRUVFODAyMTFfSUZfVFlQ
RV9TVEEpICYmICFwcml2LT5hc3NvY19pZCkgfHwKLQkgICAgIXByaXYtPmFzc29jX3N0YXRpb25f
YWRkZWQpKSB7CisJICAgIChwcml2LT5pd19tb2RlICE9IElFRUU4MDIxMV9JRl9UWVBFX01OVFIg
fHwKKwkgICAgIShpbmZvLT5mbGFncyAmIElFRUU4MDIxMV9UWF9DVExfSU5KRUNURUQpKSAmJiAv
KiBwYWNrZXQgaW5qZWN0aW9uICovCisJICAgICghaXdsX2lzX2Fzc29jaWF0ZWQocHJpdikgfHwK
KwkgICAgICgocHJpdi0+aXdfbW9kZSA9PSBJRUVFODAyMTFfSUZfVFlQRV9TVEEpICYmICFwcml2
LT5hc3NvY19pZCkgfHwKKwkgICAgICFwcml2LT5hc3NvY19zdGF0aW9uX2FkZGVkKSkgewogCQlJ
V0xfREVCVUdfRFJPUCgiRHJvcHBpbmcgLSAhaXdsX2lzX2Fzc29jaWF0ZWRcbiIpOwogCQlnb3Rv
IGRyb3BfdW5sb2NrOwogCX0KQEAgLTgyMiw3ICs4MTksMTAgQEAgaW50IGl3bF90eF9za2Ioc3Ry
dWN0IGl3bF9wcml2ICpwcml2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCWhkcl9sZW4gPSBpZWVl
ODAyMTFfZ2V0X2hkcmxlbihsZTE2X3RvX2NwdShmYykpOwogCiAJLyogRmluZCAob3IgY3JlYXRl
KSBpbmRleCBpbnRvIHN0YXRpb24gdGFibGUgZm9yIGRlc3RpbmF0aW9uIHN0YXRpb24gKi8KLQlz
dGFfaWQgPSBpd2xfZ2V0X3N0YV9pZChwcml2LCBoZHIpOworCWlmIChpbmZvLT5mbGFncyAmIElF
RUU4MDIxMV9UWF9DVExfSU5KRUNURUQpCisJCXN0YV9pZCA9IHByaXYtPmh3X3BhcmFtcy5iY2Fz
dF9zdGFfaWQ7CisJZWxzZQorCQlzdGFfaWQgPSBpd2xfZ2V0X3N0YV9pZChwcml2LCBoZHIpOwog
CWlmIChzdGFfaWQgPT0gSVdMX0lOVkFMSURfU1RBVElPTikgewogCQlERUNMQVJFX01BQ19CVUYo
bWFjKTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2w0OTY1
LWJhc2UuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsNDk2NS1iYXNlLmMKaW5k
ZXggNjBiN2E2NC4uMzgwY2MzOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXds
d2lmaS9pd2w0OTY1LWJhc2UuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3
bDQ5NjUtYmFzZS5jCkBAIC0yNjgwLDEyICsyNjgwLDYgQEAgc3RhdGljIGludCBpd2w0OTY1X21h
Y190eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IHNrX2J1ZmYgKnNrYikKIAogCUlX
TF9ERUJVR19NQUM4MDIxMSgiZW50ZXJcbiIpOwogCi0JaWYgKHByaXYtPml3X21vZGUgPT0gSUVF
RTgwMjExX0lGX1RZUEVfTU5UUikgewotCQlJV0xfREVCVUdfTUFDODAyMTEoImxlYXZlIC0gbW9u
aXRvclxuIik7Ci0JCWRldl9rZnJlZV9za2JfYW55KHNrYik7Ci0JCXJldHVybiAwOwotCX0KLQog
CUlXTF9ERUJVR19UWCgiZGV2LT54bWl0KCVkIGJ5dGVzKSBhdCByYXRlIDB4JTAyeFxuIiwgc2ti
LT5sZW4sCiAJCSAgICAgaWVlZTgwMjExX2dldF90eF9yYXRlKGh3LCBJRUVFODAyMTFfU0tCX0NC
KHNrYikpLT5iaXRyYXRlKTsKIAo=
------=_Part_58245_22700195.1216407918154--
