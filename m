Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZCGMDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZCGMDp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 07:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZCGMDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 07:03:34 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:61703 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZCGMDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 07:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AEkc5bqz62cthnVnaFTt9gNy8KaXhxPkJk7IK5jf1NMZkrWmLqdQ8gOAc2MTvRrefB
         aaZaknDSJynl8SLogUdJhzRzZ4Nuc2IiPtxB0WNsd3lGIw3xWoURtejHeZGFf6MAX5hH
         7CNF0+9RdGWHjyC6y/BmVjHpJ0jq1gX1H30tc=
MIME-Version: 1.0
In-Reply-To: <1236418002-2189-1-git-send-email-jirislaby@gmail.com>
References: <1236418002-2189-1-git-send-email-jirislaby@gmail.com>
Date: Sat, 7 Mar 2009 14:03:29 +0200
Message-ID: <40f31dec0903070403t20ee10d8y8ef43a622987d519@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath5k: constify stuff
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/7 Jiri Slaby <jirislaby@gmail.com>:
> Make some structures const to place them in .rodata, since we won't
> change them.
>
> Most important parts of objdump -h:
> -  0 .text         00011170
> +  0 .text         00011140
> -  5 .rodata       0000828e
> +  5 .rodata       0000895e
> - 13 .data         00000560
> + 13 .data         00000110
> - 14 .devinit.data 00000260
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
> Cc: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/attach.c |   13 ++++++-------
>  drivers/net/wireless/ath5k/base.c   |    8 ++++----
>  drivers/net/wireless/ath5k/debug.c  |   10 +++++-----
>  drivers/net/wireless/ath5k/reset.c  |    2 +-
>  4 files changed, 16 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath5k/attach.c
> index 05bc5cb..656cb9d 100644
> --- a/drivers/net/wireless/ath5k/attach.c
> +++ b/drivers/net/wireless/ath5k/attach.c
> @@ -34,14 +34,14 @@
>  static int ath5k_hw_post(struct ath5k_hw *ah)
>  {
>
> -       int i, c;
> -       u16 cur_reg;
> -       u16 regs[2] = {AR5K_STA_ID0, AR5K_PHY(8)};
> -       u32 var_pattern;
> -       u32 static_pattern[4] = {
> +       static const u32 static_pattern[4] = {
>                0x55555555,     0xaaaaaaaa,
>                0x66666666,     0x99999999
>        };
> +       static const u16 regs[2] = { AR5K_STA_ID0, AR5K_PHY(8) };
> +       int i, c;
> +       u16 cur_reg;
> +       u32 var_pattern;
>        u32 init_val;
>        u32 cur_val;
>
> @@ -106,7 +106,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>  {
>        struct ath5k_hw *ah;
>        struct pci_dev *pdev = sc->pdev;
> -       u8 mac[ETH_ALEN] = {};
>        int ret;
>        u32 srev;
>
> @@ -312,7 +311,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>        }
>
>        /* MAC address is cleared until add_interface */
> -       ath5k_hw_set_lladdr(ah, mac);
> +       ath5k_hw_set_lladdr(ah, (u8[ETH_ALEN]){});
>
>        /* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
>        memset(ah->ah_bssid, 0xff, ETH_ALEN);
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 08d691d..780fe6c 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -79,7 +79,7 @@ MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
>
>
>  /* Known PCI ids */
> -static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
> +static const struct pci_device_id ath5k_pci_id_table[] = {
>        { PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
>        { PCI_VDEVICE(ATHEROS, 0x0007), .driver_data = AR5K_AR5210 }, /* 5210 */
>        { PCI_VDEVICE(ATHEROS, 0x0011), .driver_data = AR5K_AR5211 }, /* 5311 - this is on AHB bus !*/
> @@ -103,7 +103,7 @@ static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
>  MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
>
>  /* Known SREVs */
> -static struct ath5k_srev_name srev_names[] = {
> +static const struct ath5k_srev_name srev_names[] = {
>        { "5210",       AR5K_VERSION_MAC,       AR5K_SREV_AR5210 },
>        { "5311",       AR5K_VERSION_MAC,       AR5K_SREV_AR5311 },
>        { "5311A",      AR5K_VERSION_MAC,       AR5K_SREV_AR5311A },
> @@ -142,7 +142,7 @@ static struct ath5k_srev_name srev_names[] = {
>        { "xxxxx",      AR5K_VERSION_RAD,       AR5K_SREV_UNKNOWN },
>  };
>
> -static struct ieee80211_rate ath5k_rates[] = {
> +static const struct ieee80211_rate ath5k_rates[] = {
>        { .bitrate = 10,
>          .hw_value = ATH5K_RATE_CODE_1M, },
>        { .bitrate = 20,
> @@ -248,7 +248,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
>                struct ieee80211_bss_conf *bss_conf,
>                u32 changes);
>
> -static struct ieee80211_ops ath5k_hw_ops = {
> +static const struct ieee80211_ops ath5k_hw_ops = {
>        .tx             = ath5k_tx,
>        .start          = ath5k_start,
>        .stop           = ath5k_stop,
> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
> index 413ed68..9770bb3 100644
> --- a/drivers/net/wireless/ath5k/debug.c
> +++ b/drivers/net/wireless/ath5k/debug.c
> @@ -82,14 +82,14 @@ static int ath5k_debugfs_open(struct inode *inode, struct file *file)
>  /* debugfs: registers */
>
>  struct reg {
> -       char *name;
> +       const char *name;
>        int addr;
>  };
>
>  #define REG_STRUCT_INIT(r) { #r, r }
>
>  /* just a few random registers, might want to add more */
> -static struct reg regs[] = {
> +static const struct reg regs[] = {
>        REG_STRUCT_INIT(AR5K_CR),
>        REG_STRUCT_INIT(AR5K_RXDP),
>        REG_STRUCT_INIT(AR5K_CFG),
> @@ -142,7 +142,7 @@ static struct reg regs[] = {
>
>  static void *reg_start(struct seq_file *seq, loff_t *pos)
>  {
> -       return *pos < ARRAY_SIZE(regs) ? &regs[*pos] : NULL;
> +       return *pos < ARRAY_SIZE(regs) ? (void *)&regs[*pos] : NULL;
>  }
>
>  static void reg_stop(struct seq_file *seq, void *p)
> @@ -153,7 +153,7 @@ static void reg_stop(struct seq_file *seq, void *p)
>  static void *reg_next(struct seq_file *seq, void *p, loff_t *pos)
>  {
>        ++*pos;
> -       return *pos < ARRAY_SIZE(regs) ? &regs[*pos] : NULL;
> +       return *pos < ARRAY_SIZE(regs) ? (void *)&regs[*pos] : NULL;
>  }
>
>  static int reg_show(struct seq_file *seq, void *p)
> @@ -290,7 +290,7 @@ static const struct file_operations fops_reset = {
>
>  /* debugfs: debug level */
>
> -static struct {
> +static const struct {
>        enum ath5k_debug_level level;
>        const char *name;
>        const char *desc;
> diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
> index 1531ccd..685dc21 100644
> --- a/drivers/net/wireless/ath5k/reset.c
> +++ b/drivers/net/wireless/ath5k/reset.c
> @@ -102,7 +102,7 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
>  * index into rates for control rates, we can set it up like this because
>  * this is only used for AR5212 and we know it supports G mode
>  */
> -static int control_rates[] =
> +static const unsigned int control_rates[] =
>        { 0, 1, 1, 1, 4, 4, 6, 6, 8, 8, 8, 8 };
>
>  /**

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
