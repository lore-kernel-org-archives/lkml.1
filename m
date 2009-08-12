Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZHLRen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZHLRen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbZHLRen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:34:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZHLRem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:34:42 -0400
Subject: Re: Libertas: Association request to the driver failed
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, Daniel Mack <daniel@caiaq.de>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1250093737.31650.17.camel@localhost.localdomain>
References: <20090807191156.GS19257@buzzloop.caiaq.de>
	 <20090807193610.GK7545@tuxdriver.com>
	 <20090808123512.GZ19257@buzzloop.caiaq.de> <4A7D8AB6.9030707@gmail.com>
	 <4A7E9596.4070901@gmail.com> <20090809102417.GH13639@buzzloop.caiaq.de>
	 <4A7EAED8.9090900@gmail.com> <20090810175939.GH2733@tuxdriver.com>
	 <4A811776.8090003@gmail.com>  <20090811182426.GE2634@tuxdriver.com>
	 <1250093737.31650.17.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 12:34:17 -0500
Message-Id: <1250098457.31650.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 11:15 -0500, Dan Williams wrote:
> On Tue, 2009-08-11 at 14:24 -0400, John W. Linville wrote:
> > Comments from the libertas crowd?  This seems a bit long for this
> > part of the cycle.
> > 
> > Should we just revert the original patch, then reapply it with this
> > one for 2.6.32?
> 
> I'd feel more comfortable with that.  Roel did find a real problem, but
> we need to make sure the fix doesn't break stuff since it appears the
> rate code is more complicated than we thought.

Well, OK, it's not complicated, just obfuscated.
mrvl_ie_rates_param_set is a TLV structure, and the size of the overall
structure from 'header' will tell how many rates there actually are
following the header.  The [1] is left over from the vendor driver.  If
that's confusing things, can we just use [0] here or does the scanner
that found this need to be fixed?  We'll certainly be pointing past the
end of the mrvl_ie_rates_param_set, but we won't be accessing beyond
memory we don't control, since the mrvl_ie_rates_param_set will always
point into a buffer (from kzalloc) that's large enough.  Rates is also
never used late enough in the command spacing to be at risk of
overrunning the end of the command buffer into which it points.

The following (not runtime tested) should make it clearer what's going
on, though it doesn't address the [1]/[0] issue:

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 1902b6f..8c05388 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -35,7 +35,8 @@ static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
  *
  *  @param priv     A pointer to struct lbs_private structure
  *  @param rates       the buffer which keeps input and output
- *  @param rates_size  the size of rate1 buffer; new size of buffer on return
+ *  @param rates_size  the size of rates buffer; new size of buffer on return,
+ *                     which will be less than or equal to original rates_size
  *
  *  @return            0 on success, or -1 on error
  */
@@ -43,39 +44,42 @@ static int get_common_rates(struct lbs_private *priv,
 	u8 *rates,
 	u16 *rates_size)
 {
-	u8 *card_rates = lbs_bg_rates;
-	int ret = 0, i, j;
-	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
-	size_t tmp_size = 0;
-
-	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
-		for (j = 0; j < *rates_size && rates[j]; j++) {
-			if (rates[j] == card_rates[i])
-				tmp[tmp_size++] = card_rates[i];
+	int i, j;
+	u8 intersection[MAX_RATES];
+	u16 intersection_size;
+	u16 num_rates = 0;
+
+	intersection_size = min_t(u16, *rates_size, ARRAY_SIZE(intersection));
+
+	/* Allow each rate from 'rates' that is supported by the hardware */
+	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && lbs_bg_rates[i]; i++) {
+		for (j = 0; j < intersection_size && rates[j]; j++) {
+			if (rates[j] == lbs_bg_rates[i])
+				intersection[num_rates++] = rates[j];
 		}
 	}
 
 	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
-	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates,
+	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", lbs_bg_rates,
 			ARRAY_SIZE(lbs_bg_rates));
-	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
+	lbs_deb_hex(LBS_DEB_JOIN, "common rates", intersection, num_rates);
 	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
 
 	if (!priv->enablehwauto) {
-		for (i = 0; i < tmp_size; i++) {
-			if (tmp[i] == priv->cur_rate)
+		for (i = 0; i < num_rates; i++) {
+			if (intersection[i] == priv->cur_rate)
 				goto done;
 		}
 		lbs_pr_alert("Previously set fixed data rate %#x isn't "
 		       "compatible with the network.\n", priv->cur_rate);
-		ret = -1;
+		return -1;
 	}
+
 done:
 	memset(rates, 0, *rates_size);
-	*rates_size = min_t(int, tmp_size, *rates_size);
-	memcpy(rates, tmp, *rates_size);
-	return ret;
+	*rates_size = num_rates;
+	memcpy(rates, intersection, num_rates);
+	return 0;
 }
 
 
@@ -317,8 +321,8 @@ static int lbs_associate(struct lbs_private *priv,
 
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
-	memcpy(&rates->rates, &bss->rates, MAX_RATES);
-	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
+	tmplen = min_t(u16, ARRAY_SIZE(bss->rates), MAX_RATES);
+	memcpy(&rates->rates, &bss->rates, tmplen);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
@@ -592,7 +596,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
+	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), ARRAY_SIZE (bss->rates));
 	memcpy(cmd.bss.rates, bss->rates, ratesize);
 	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");


