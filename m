Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab0CKCPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:15:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51656 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab0CKCPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:15:06 -0500
Date: Thu, 11 Mar 2010 13:15:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruno Randolf <br1@einfach.org>
Subject: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-Id: <20100311131500.1057b6c5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/ath/ath5k/phy.c between commit
86415d43efd4f7093979cfa8a80232114266f1a4 ("ath5k: fix I/Q calibration
(for real)") from the wireless-current tree and commit
49a85d211a63ad1d565842ebc535c5168d85d86a ("ath5k: IQ calibration for
AR5211 is slightly different") from the wireless tree.

I fixed it up (I think - see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/ath/ath5k/phy.c
index eff3323,20d562b..0000000
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@@ -1399,26 -1391,38 +1397,33 @@@ static int ath5k_hw_rf511x_calibrate(st
  	}
  
  	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
- 	q_coffd = q_pwr >> 7;
+ 
+ 	if (ah->ah_version == AR5K_AR5211)
+ 		q_coffd = q_pwr >> 6;
+ 	else
+ 		q_coffd = q_pwr >> 7;
  
 -	/* No correction */
 -	if (i_coffd == 0 || q_coffd == 0)
 +	/* protect against divide by 0 and loss of sign bits */
 +	if (i_coffd == 0 || q_coffd < 2)
  		goto done;
  
 -	i_coff = ((-iq_corr) / i_coffd);
 -
 -	/* Boundary check */
 -	if (i_coff > 31)
 -		i_coff = 31;
 -	if (i_coff < -32)
 -		i_coff = -32;
 +	i_coff = (-iq_corr) / i_coffd;
 +	i_coff = clamp(i_coff, -32, 31); /* signed 6 bit */
  
- 	q_coff = (i_pwr / q_coffd) - 128;
+ 	if (ah->ah_version == AR5K_AR5211)
+ 		q_coff = (i_pwr / q_coffd) - 64;
+ 	else
+ 		q_coff = (i_pwr / q_coffd) - 128;
 +	q_coff = clamp(q_coff, -16, 15); /* signed 5 bit */
  
 -	/* Boundary check */
 -	if (q_coff > 15)
 -		q_coff = 15;
 -	if (q_coff < -16)
 -		q_coff = -16;
 +	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
 +			"new I:%d Q:%d (i_coffd:%x q_coffd:%x)",
 +			i_coff, q_coff, i_coffd, q_coffd);
  
 -	/* Commit new I/Q value */
 -	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
 -		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
 +	/* Commit new I/Q values (set enable bit last to match HAL sources) */
 +	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_Q_I_COFF, i_coff);
 +	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_Q_Q_COFF, q_coff);
 +	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE);
  
  	/* Re-enable calibration -if we don't we'll commit
  	 * the same values again and again */
