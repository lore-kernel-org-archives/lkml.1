Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYITDkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYITDkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 23:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbYITDkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 23:40:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:16383 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYITDkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 23:40:06 -0400
Message-ID: <f488382f0809192040k317660f3yb99806bbdce60449@mail.gmail.com>
Date: Fri, 19 Sep 2008 20:40:04 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Senthilkumar Balasubramanian" 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <20080919142801.GA5816@senthil-lnx.users.atheros.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 8:29 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> Anyway, there definitely is an interrupt storm here. Let me demonstrate...

Worth noting that this change (modified version of the patch by
Senthil from earlier) made it so it didn't give an 'IRQ 17: nobody
cared' when I reloaded ath9k during the IRQ storm...

---

    ath9k: flush pending IRQs before freeing IRQ

    Signed-off-by: Steven Noonan <steven@uplinklabs.net>

diff --git a/drivers/net/wireless/ath9k/main.c
b/drivers/net/wireless/ath9k/main.c
index 0997196..591eec1 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1411,10 +1411,17 @@ static void ath_pci_remove(struct pci_dev *pdev)
 {
        struct ieee80211_hw *hw = pci_get_drvdata(pdev);
        struct ath_softc *sc = hw->priv;
+       enum ath9k_int status;

        if (pdev->irq)
+       {
+               ath9k_hw_set_interrupts(sc->sc_ah, 0);
+               ath9k_hw_getisr(sc->sc_ah, &status);    /* NB: clears ISR too */
+               sc->sc_invalid = 1;
                free_irq(pdev->irq, sc);
+       }
        ath_detach(sc);
+
        pci_iounmap(pdev, sc->mem);
        pci_release_region(pdev, 0);
        pci_disable_device(pdev);
