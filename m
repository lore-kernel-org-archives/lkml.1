Return-Path: <linux-kernel-owner+w=401wt.eu-S1765749AbYDOTyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765749AbYDOTyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbYDOTx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:53:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49116 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbYDOTxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:53:55 -0400
Date: Tue, 15 Apr 2008 21:54:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?K=E1roly?= Kasza <kaszak@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       kernel list <linux-kernel@vger.kernel.org>, lcostantino@gmail.com,
       someone@dunanet.hu
Subject: Re: w35und: add softmac interface
Message-ID: <20080415195426.GD4994@elf.ucw.cz>
References: <20080414224740.GA31431@elf.ucw.cz> <20080415002826.GC4270@tuxdriver.com> <20080415070923.GA13767@elf.ucw.cz> <544ab8580804150110x2f1841b4m7ebd43f1a6441458@mail.gmail.com> <20080415091403.GA32652@atrey.karlin.mff.cuni.cz> <544ab8580804150317k637118cp2cab91bfa1e37875@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544ab8580804150317k637118cp2cab91bfa1e37875@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  Really take a look at those patches. I believe I'm pretty close to
> >  dropping those upper layer code... Then, we'll be able to proceed
> >  incrementally.
> >
> I commited them after some changes, please send patches next time
> against the last revision :)

Sorry, will violate that once again (this is preview, not for
commiting, so perhaps you can forgive me :-).

Which this, I'm able to connect to my access point and ping, without
ifconfig-ing the original interface up. Only softmac interface is
active.

> However I still think we should focus on rewriting the whole thing
> instead of hacking this elder chaos.
> I created /branches/softmac for the new code, You should extend that
> maybe?

I don't believe rewrite like that is a good idea.

My plan is: 

1) remove duplicate 802.11 stack, making sure it still works as I
progress.

(at this point I have pretty small driver -- like 2000 lines -- but it
will be ugly)

2) either clean that one up, or rewrite it; making sure it still works
in the process.

(at this point we have mergeable driver)

								Pavel


diff --git a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
index de30a56..d128fc1 100644
--- a/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
+++ b/drivers/net/wireless/winbond/winbondport/linux/wbusb.c
@@ -126,6 +126,31 @@ static int wbsoft_start(struct ieee80211
 static int wbsoft_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
 	printk("wbsoft_config called\n");
+
+	ChanInfo ch;
+
+	ch.band = 1;
+	ch.ChanNo = 1;	/* Should use channel_num, or something, as that is already pre-translated */
+
+
+	hal_set_current_channel(&my_adapter->sHwData, ch);
+	hal_set_beacon_period(&my_adapter->sHwData, conf->beacon_int);
+//	hal_set_cap_info(&my_adapter->sHwData, ?? );
+// hal_set_ssid(phw_data_t pHwData,  PUCHAR pssid,  u8 ssid_len); ??
+	hal_set_accept_broadcast(&my_adapter->sHwData, 1);
+	hal_set_accept_promiscuous(&my_adapter->sHwData,  1);
+	hal_set_accept_multicast(&my_adapter->sHwData,  1);
+	hal_set_accept_beacon(&my_adapter->sHwData,  1);
+	hal_set_radio_mode(&my_adapter->sHwData,  0);
+	//hal_set_antenna_number(  phw_data_t pHwData, u8 number )
+	//hal_set_rf_power(phw_data_t pHwData, u8 PowerIndex)
+
+
+//	hal_start_bss(&my_adapter->sHwData, WLAN_BSSTYPE_INFRASTRUCTURE);	??
+
+//void hal_set_rates(phw_data_t pHwData, PUCHAR pbss_rates, 
+//		   u8 length, unsigned char basic_rate_set)
+
 	return 0;
 }
 
@@ -155,6 +180,7 @@ static const struct ieee80211_ops wbsoft
 	.get_stats		= wbsoft_nop,
 	.get_tx_stats		= wbsoft_nop,
 	.get_tsf		= wbsoft_get_tsf,
+// conf_tx: hal_set_cwmin()/hal_set_cwmax;
 };
 
 struct wbsoft_priv {
diff --git a/drivers/net/wireless/winbond/winbondport/wbhal.c b/drivers/net/wireless/winbond/winbondport/wbhal.c
index 6599538..0177bc0 100644
--- a/drivers/net/wireless/winbond/winbondport/wbhal.c
+++ b/drivers/net/wireless/winbond/winbondport/wbhal.c
@@ -418,7 +418,7 @@ u8 hal_init_hardware(phw_data_t pHwData,
 }
 
 
-void hal_halt( phw_data_t pHwData, void *ppa_data)
+void hal_halt(phw_data_t pHwData, void *ppa_data)
 {
 	switch( pHwData->InitialResource )
 	{
@@ -500,7 +500,7 @@ void hal_set_slot_time( phw_data_t pHwDa
 }
 //---------------------------------------------------------------------------------------------------
 void hal_set_rates(phw_data_t pHwData, PUCHAR pbss_rates, 
-		   u8 length, unsigned char basic_rate_set )
+		   u8 length, unsigned char basic_rate_set)
 {
 	PWB35REG	pWb35Reg = &pHwData->Wb35Reg;
 	u32		tmp, tmp1;
@@ -765,6 +765,8 @@ void hal_set_current_channel_ex(  phw_da
 	if( pHwData->SurpriseRemove )
 		return;
 
+	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
+
 	RFSynthesizer_SwitchingChannel( pHwData, channel );// Switch channel
 	pHwData->Channel = channel.ChanNo;
 	pHwData->band = channel.band;
diff --git a/drivers/net/wireless/winbond/winbondport/wblinux.c b/drivers/net/wireless/winbond/winbondport/wblinux.c
index 0b0b200..ebe8dbe 100644
--- a/drivers/net/wireless/winbond/winbondport/wblinux.c
+++ b/drivers/net/wireless/winbond/winbondport/wblinux.c
@@ -416,7 +416,7 @@ #endif
 		Adapter->sLocalPara.ShutDowned = FALSE;
 
 		//added by ws for wep key error detection
-		Adapter->sLocalPara.bWepKeyError= FALSE;//added by ws 02/02/04
+		Adapter->sLocalPara.bWepKeyError= FALSE;
 		Adapter->sLocalPara.bToSelfPacketReceived = FALSE;
 		Adapter->sLocalPara.WepKeyDetectTimerCount= 2 * 100; /// 2 seconds
 
@@ -534,7 +534,7 @@ #endif
 }
 
 // 20060802
-void WBLINUX_ConnectStatus(  PADAPTER Adapter,  u32 flag )
+void WBLINUX_ConnectStatus(PADAPTER Adapter, u32 flag)
 {
    PWBLINUX	pWbLinux = &Adapter->WbLinux;
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
