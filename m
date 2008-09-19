Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYISSXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYISSXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYISSXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:23:37 -0400
Received: from mail.atheros.com ([12.36.123.2]:39202 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYISSXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:23:36 -0400
Date: Fri, 19 Sep 2008 11:23:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>
CC: Steven Noonan <steven@uplinklabs.net>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Ingo Molnar <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080919182322.GB7027@tesla>
References: <20080918220102.GE7408@tesla> <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com> <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com> <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com> <20080919030125.GG7408@tesla> <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com> <20080919142801.GA5816@senthil-lnx.users.atheros.com> <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net> <20080919175824.GA5626@senthil-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080919175824.GA5626@senthil-lnx.users.atheros.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 10:58:24AM -0700, Senthilkumar Balasubramanian wrote:
> 
> I am on 2.6.27-rc6 and this patch is on top of my earlier patch
> titled "[PATCH] ath9k: connectivity is lost after Group rekeying is
> done". However this patch can be applied on top of latest wireless testing
> too. I could apply this patch succesfully on top of wireless testing
> git tree.
> 
> My git-describe says v2.6.27-rc6-1378-g34e512f.
> 
> There is no sc_invalid flag in "struct ath_softc" today. Where did
> you get this variable from? It was removed in the following commit
> 
> -----------------------------------------------
> commit f2c9705a05ecbc0d94216a3b042d5641e8bf70b1
> Author: Sujith <Sujith.Manoharan@atheros.com>
> Date:   Mon Aug 11 14:05:08 2008 +0530
> 
>     ath9k: Use bitfields for sc operations
> 
>     Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> -----------------------------------------------
> 
> Which code base are you using?

Thanks for the patch Senthil. He is on Linus' v2.6.27-rc, you are on
wireless-testing so I've ported it (no changes, it just applies cleanly
now). This is also untested by me:

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index f6c4528..9a432e5 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1336,6 +1336,8 @@ void ath_deinit(struct ath_softc *sc)
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s\n", __func__);
 
+	tasklet_kill(&sc->intr_tq);
+	tasklet_kill(&sc->bcon_tasklet);
 	ath_stop(sc);
 	if (!sc->sc_invalid)
 		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c5107f2..75acf54 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1400,10 +1400,16 @@ static void ath_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
+	enum ath9k_int status;
 
-	if (pdev->irq)
+	if (pdev->irq) {
+		ath9k_hw_set_interrupts(sc->sc_ah, 0);
+		ath9k_hw_getisr(sc->sc_ah, &status);	/* NB: clears ISR too */
+		sc->sc_flags |= SC_OP_INVALID;
 		free_irq(pdev->irq, sc);
+	}
 	ath_detach(sc);
+
 	pci_iounmap(pdev, sc->mem);
 	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
