Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbYLXWOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbYLXWOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYLXWOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:14:15 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:17502 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYLXWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:14:14 -0500
Message-ID: <4952ACF2.9010502@oracle.com>
Date: Wed, 24 Dec 2008 13:43:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mmotm 2008-12-24-01-20 uploaded (ath9k)
References: <200812240930.mBO9U3e6030301@imap1.linux-foundation.org> <495279BB.1090703@oracle.com> <20081224192132.GO5944@tesla>
In-Reply-To: <20081224192132.GO5944@tesla>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4952B429.0013:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Wed, Dec 24, 2008 at 10:04:43AM -0800, Randy Dunlap wrote:
>> akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2008-12-24-01-20 has been uploaded to
>>>
>>>    http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>    git://git.zen-sources.org/zen/mmotm.git
>>
>> ath9k build fails with:
>>
>> drivers/built-in.o: In function `ath_detach':
>> main.c:(.text+0xee655): undefined reference to `rfkill_unregister'
>> drivers/built-in.o: In function `ath_rfkill_poll':
>> main.c:(.text+0xeedfa): undefined reference to `rfkill_force_state'
>> drivers/built-in.o: In function `ath9k_start':
>> main.c:(.text+0xefe79): undefined reference to `rfkill_register'
>> main.c:(.text+0xeff20): undefined reference to `rfkill_free'
>> drivers/built-in.o: In function `ath_pci_probe':
>> main.c:(.text+0xf0f73): undefined reference to `rfkill_allocate'
>>
>> when ath9k is built-in and CONFIG_RFKILL=m.
>>
>> config attached.
> 
> <-- snip -->
> 
>> # CONFIG_MAC80211_DEBUGFS is not set
>> # CONFIG_MAC80211_DEBUG_MENU is not set
>> CONFIG_RFKILL=m
>> CONFIG_RFKILL_INPUT=m
>> CONFIG_RFKILL_LEDS=y
> 
> Try this (already merged into wireless-testing):

This seems to be already merged/used in mmotm and that's where the
build failure happened.

And this patch does not address how to call rfkill interfaces when
CONFIG_RFKILL=m and ath9k is built into the kernel image...


> commit bb2476392c584a769f88421fcc9de3408656d05d
> Author: Senthil Balasubramanian <senthilkumar@atheros.com>
> Date:   Thu Nov 13 18:00:02 2008 +0530
> 
>     ath9k: Build RFKILL feature even when RFKILL subsystem is a MODULE
>     
>     Currently, ath9k builds RFKILL feature only when the RFKILL subsystem
>     is built part of the kernel. Build RFKILL feature regardless of whether
>     RFKILL subsystem is built as a MODULE or part of the kernel.
>     
>     Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
> index 3a180ce..6be2b94 100644
> --- a/drivers/net/wireless/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath9k/ath9k.h
> @@ -904,7 +904,7 @@ u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio);
>  void ath9k_hw_cfg_output(struct ath_hal *ah, u32 gpio,
>  			 u32 ah_signal_type);
>  void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val);
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  void ath9k_enable_rfkill(struct ath_hal *ah);
>  #endif
>  int ath9k_hw_select_antconfig(struct ath_hal *ah, u32 cfg);
> diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
> index 5f5184a..3e94dab 100644
> --- a/drivers/net/wireless/ath9k/core.c
> +++ b/drivers/net/wireless/ath9k/core.c
> @@ -705,7 +705,7 @@ void ath_stop(struct ath_softc *sc)
>  	} else
>  		sc->sc_rxlink = NULL;
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
>  		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
>  #endif
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
> index 7ca2efa..dc30703 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -2341,7 +2341,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
>  	ath9k_hw_init_interrupt_masks(ah, ah->ah_opmode);
>  	ath9k_hw_init_qos(ah);
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
>  		ath9k_enable_rfkill(ah);
>  #endif
> @@ -3516,7 +3516,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
>  
>  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	ah->ah_rfsilent = ath9k_hw_get_eeprom(ah, EEP_RF_SILENT);
>  	if (ah->ah_rfsilent & EEP_RFSILENT_ENABLED) {
>  		ah->ah_rfkill_gpio =
> @@ -3773,7 +3773,7 @@ void ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio, u32 val)
>  		AR_GPIO_BIT(gpio));
>  }
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  void ath9k_enable_rfkill(struct ath_hal *ah)
>  {
>  	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index 04342ec..97f0b47 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -595,7 +595,7 @@ fail:
>  	ath_deinit_leds(sc);
>  }
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  
>  /*******************/
>  /*	Rfkill	   */
> @@ -839,7 +839,7 @@ static void ath_detach(struct ath_softc *sc)
>  
>  	ath_deinit_leds(sc);
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	ath_deinit_rfkill(sc);
>  #endif
>  	ath_rate_control_unregister();
> @@ -922,7 +922,7 @@ static int ath_attach(u16 devid, struct ath_softc *sc)
>  	/* Initialize LED control */
>  	ath_init_leds(sc);
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	/* Initialze h/w Rfkill */
>  	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
>  		INIT_DELAYED_WORK(&sc->rf_kill.rfkill_poll, ath_rfkill_poll);
> @@ -979,7 +979,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
>  		goto exit;
>  	}
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	error = ath_start_rfkill_poll(sc);
>  #endif
>  
> @@ -1724,7 +1724,7 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  
>  	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
>  		cancel_delayed_work_sync(&sc->rf_kill.rfkill_poll);
>  #endif
> @@ -1761,7 +1761,7 @@ static int ath_pci_resume(struct pci_dev *pdev)
>  			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
>  	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
>  
> -#ifdef CONFIG_RFKILL
> +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
>  	/*
>  	 * check the h/w rfkill state on resume
>  	 * and start the rfkill poll timer


-- 
~Randy
