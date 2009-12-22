Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZLVQVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZLVQVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbZLVQU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:20:58 -0500
Received: from mail.atheros.com ([12.36.123.2]:38098 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbZLVQU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:20:56 -0500
Date: Tue, 22 Dec 2009 08:20:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner
 case
Message-ID: <20091222162055.GC4385@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <19248.19829.293087.367661@gargle.gargle.HOWL>
 <20091222155005.GA4385@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20091222155005.GA4385@tux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 07:50:05AM -0800, Luis Rodriguez wrote:
> On Mon, Dec 21, 2009 at 08:39:17PM -0800, Sujith Manoharan wrote:
> > Luis Rodriguez wrote:
> > > That log can be found here:
> > >
> > > http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless/irq-disabled.txt
> >
> > Thanks for the log.
> > It's a bug in ath9k, related to PowerSave.
> >
> > Can you test this patch ?
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index 3f5b887..419c382 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -2504,6 +2504,9 @@ static void ath9k_stop(struct ieee80211_hw *hw)
> >                 return; /* another wiphy still in use */
> >         }
> >
> > +       /* Ensure HW is awake when we try to shut it down. */
> > +       ath9k_ps_wakeup(sc);
> > +
> >         if (ah->btcoex_hw.enabled) {
> >                 ath9k_hw_btcoex_disable(ah);
> >                 if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
> > @@ -2524,8 +2527,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
> >         /* disable HAL and put h/w to sleep */
> >         ath9k_hw_disable(ah);
> >         ath9k_hw_configpcipowersave(ah, 1, 1);
> > -       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
> > +       ath9k_ps_restore(sc);
> >
> > +       /* Finally, put the chip in FULL SLEEP mode */
> > +       ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
> >         sc->sc_flags |= SC_OP_INVALID;
> >
> >         mutex_unlock(&sc->mutex);
> 
> 
> Thanks for the patch, doesn't cure it though. Below is the log
> with debug=0xa00 (CONFIG | PS), you can see some successes prior to
> the failure.

Here's the new log with 0x601, with a few pm-suspend successes above.

[  230.291057] ath9k: NETWORK SLEEP -> AWAKE
[  230.501901] ath9k: AWAKE -> NETWORK SLEEP
[  230.598294] ath9k: NETWORK SLEEP -> AWAKE
[  230.610304] ath9k: AWAKE -> NETWORK SLEEP
[  230.700688] ath9k: NETWORK SLEEP -> AWAKE
[  230.707386] ath9k: AWAKE -> NETWORK SLEEP
[  230.803081] ath9k: NETWORK SLEEP -> AWAKE
[  231.016430] ath9k: AWAKE -> NETWORK SLEEP
[  231.110303] ath9k: NETWORK SLEEP -> AWAKE
[  231.116346] ath9k: AWAKE -> NETWORK SLEEP
[  231.212720] ath9k: NETWORK SLEEP -> AWAKE
[  231.218898] ath9k: AWAKE -> NETWORK SLEEP
[  231.315118] ath9k: NETWORK SLEEP -> AWAKE
[  231.321157] ath9k: AWAKE -> NETWORK SLEEP
[  231.417543] ath9k: NETWORK SLEEP -> AWAKE
[  231.427228] ath9k: AWAKE -> NETWORK SLEEP
[  231.519935] ath9k: NETWORK SLEEP -> AWAKE
[  231.526496] ath9k: AWAKE -> NETWORK SLEEP
[  231.622328] ath9k: NETWORK SLEEP -> AWAKE
[  231.629912] ath9k: AWAKE -> NETWORK SLEEP
[  231.724753] ath9k: NETWORK SLEEP -> AWAKE
[  231.730773] ath9k: AWAKE -> NETWORK SLEEP
[  231.827147] ath9k: NETWORK SLEEP -> AWAKE
[  231.833176] ath9k: AWAKE -> NETWORK SLEEP
[  231.929541] ath9k: NETWORK SLEEP -> AWAKE
[  231.940075] ath9k: AWAKE -> NETWORK SLEEP
[  232.031968] ath9k: NETWORK SLEEP -> AWAKE
[  232.041398] ath9k: AWAKE -> NETWORK SLEEP
[  232.134364] ath9k: NETWORK SLEEP -> AWAKE
[  232.144893] ath9k: AWAKE -> NETWORK SLEEP
[  232.236790] ath9k: NETWORK SLEEP -> AWAKE
[  232.242808] ath9k: AWAKE -> NETWORK SLEEP
[  232.339183] ath9k: NETWORK SLEEP -> AWAKE
[  232.346675] ath9k: AWAKE -> NETWORK SLEEP
[  232.441577] ath9k: NETWORK SLEEP -> AWAKE
[  232.447621] ath9k: AWAKE -> NETWORK SLEEP
[  232.543998] ath9k: NETWORK SLEEP -> AWAKE
[  232.551040] ath9k: AWAKE -> NETWORK SLEEP
[  232.630348] ath9k: NETWORK SLEEP -> AWAKE
[  232.821147] ath9k: AWAKE -> NETWORK SLEEP
[  232.851209] ath9k: NETWORK SLEEP -> AWAKE
[  232.858137] ath9k: AWAKE -> NETWORK SLEEP
[  232.953605] ath9k: NETWORK SLEEP -> AWAKE
[  232.959647] ath9k: AWAKE -> NETWORK SLEEP
[  233.056033] ath9k: NETWORK SLEEP -> AWAKE
[  233.267729] ath9k: AWAKE -> NETWORK SLEEP
[  233.302127] ath9k: NETWORK SLEEP -> AWAKE
[  233.425646] ath9k: AWAKE -> NETWORK SLEEP
[  233.465642] ath9k: NETWORK SLEEP -> AWAKE
[  233.574250] ath9k: AWAKE -> NETWORK SLEEP
[  233.670460] ath9k: NETWORK SLEEP -> AWAKE
[  233.683240] ath9k: AWAKE -> NETWORK SLEEP
[  233.772853] ath9k: NETWORK SLEEP -> AWAKE
[  233.779182] ath9k: AWAKE -> NETWORK SLEEP
[  233.875280] ath9k: NETWORK SLEEP -> AWAKE
[  233.881299] ath9k: AWAKE -> NETWORK SLEEP
[  233.977672] ath9k: NETWORK SLEEP -> AWAKE
[  233.986397] ath9k: AWAKE -> NETWORK SLEEP
[  234.080059] ath9k: NETWORK SLEEP -> AWAKE
[  234.086942] ath9k: AWAKE -> NETWORK SLEEP
[  234.162736] ath9k: NETWORK SLEEP -> AWAKE
[  234.162840] ath9k: AWAKE -> NETWORK SLEEP
[  234.162851] ath9k: Set HW RX filter: 0x607
[  234.182494] ath9k: NETWORK SLEEP -> AWAKE
[  234.192203] ath9k: AWAKE -> NETWORK SLEEP
[  234.284887] ath9k: NETWORK SLEEP -> AWAKE
[  234.393325] ath9k: AWAKE -> NETWORK SLEEP
[  234.489707] ath9k: NETWORK SLEEP -> AWAKE
[  234.495950] ath9k: AWAKE -> NETWORK SLEEP
[  234.592087] ath9k: NETWORK SLEEP -> AWAKE
[  234.610548] ath9k: AWAKE -> NETWORK SLEEP
[  234.694526] ath9k: NETWORK SLEEP -> AWAKE
[  234.700856] ath9k: AWAKE -> NETWORK SLEEP
[  234.796918] ath9k: NETWORK SLEEP -> AWAKE
[  234.803175] ath9k: AWAKE -> NETWORK SLEEP
[  234.899313] ath9k: NETWORK SLEEP -> AWAKE
[  234.905352] ath9k: AWAKE -> NETWORK SLEEP
[  235.001735] ath9k: NETWORK SLEEP -> AWAKE
[  235.008164] ath9k: AWAKE -> NETWORK SLEEP
[  235.104133] ath9k: NETWORK SLEEP -> AWAKE
[  235.110377] ath9k: AWAKE -> NETWORK SLEEP
[  235.206557] ath9k: NETWORK SLEEP -> AWAKE
[  235.212696] ath9k: AWAKE -> NETWORK SLEEP
[  235.308953] ath9k: NETWORK SLEEP -> AWAKE
[  235.326431] ath9k: AWAKE -> NETWORK SLEEP
[  235.411345] ath9k: NETWORK SLEEP -> AWAKE
[  235.418223] ath9k: AWAKE -> NETWORK SLEEP
[  235.513772] ath9k: NETWORK SLEEP -> AWAKE
[  235.622198] ath9k: AWAKE -> NETWORK SLEEP
[  235.718560] ath9k: NETWORK SLEEP -> AWAKE
[  235.725249] ath9k: AWAKE -> NETWORK SLEEP
[  235.820984] ath9k: NETWORK SLEEP -> AWAKE
[  235.830516] ath9k: AWAKE -> NETWORK SLEEP
[  235.923380] ath9k: NETWORK SLEEP -> AWAKE
[  235.931702] ath9k: AWAKE -> NETWORK SLEEP
[  236.025804] ath9k: NETWORK SLEEP -> AWAKE
[  236.134230] ath9k: AWAKE -> NETWORK SLEEP
[  236.230592] ath9k: NETWORK SLEEP -> AWAKE
[  236.239172] ath9k: AWAKE -> NETWORK SLEEP
[  236.333017] ath9k: NETWORK SLEEP -> AWAKE
[  236.340680] ath9k: AWAKE -> NETWORK SLEEP
[  236.435411] ath9k: NETWORK SLEEP -> AWAKE
[  236.442458] ath9k: AWAKE -> NETWORK SLEEP
[  236.537802] ath9k: NETWORK SLEEP -> AWAKE
[  236.545238] ath9k: AWAKE -> NETWORK SLEEP
[  236.640230] ath9k: NETWORK SLEEP -> AWAKE
[  236.647491] ath9k: AWAKE -> NETWORK SLEEP
[  236.742624] ath9k: NETWORK SLEEP -> AWAKE
[  236.761241] ath9k: AWAKE -> NETWORK SLEEP
[  236.845049] ath9k: NETWORK SLEEP -> AWAKE
[  236.851557] ath9k: AWAKE -> NETWORK SLEEP
[  236.947442] ath9k: NETWORK SLEEP -> AWAKE
[  236.953910] ath9k: AWAKE -> NETWORK SLEEP
[  237.049837] ath9k: NETWORK SLEEP -> AWAKE
[  237.056854] ath9k: AWAKE -> NETWORK SLEEP
[  237.152265] ath9k: NETWORK SLEEP -> AWAKE
[  237.161850] Rx A-MPDU request on tid 0 result 0
[  237.246151] ath9k: Set HW RX filter: 0x607
[  237.250758] Open BA session requested for 00:22:6b:56:fd:e8 tid 6
[  237.250807] activated addBA response timer on tid 6
[  237.254103] switched off addBA timer for tid 6 
[  237.254111] Aggregation is on for tid 6 
[  237.512023] ath9k: AWAKE -> NETWORK SLEEP
[  237.561870] ath9k: NETWORK SLEEP -> AWAKE
[  237.567906] ath9k: AWAKE -> NETWORK SLEEP
[  237.609757] ath9k: NETWORK SLEEP -> AWAKE
[  237.761536] ath9k: AWAKE -> NETWORK SLEEP
[  237.766668] ath9k: NETWORK SLEEP -> AWAKE
[  237.773174] ath9k: AWAKE -> NETWORK SLEEP
[  237.860751] ath9k: NETWORK SLEEP -> AWAKE
[  237.990912] ath9k: AWAKE -> NETWORK SLEEP
[  238.060984] ath9k: NETWORK SLEEP -> AWAKE
[  238.247736] ath9k: AWAKE -> NETWORK SLEEP
[  238.278694] ath9k: NETWORK SLEEP -> AWAKE
[  238.288052] ath9k: AWAKE -> NETWORK SLEEP
[  238.302049] wlan0: no IPv6 routers present
[  238.346606] ath9k: NETWORK SLEEP -> AWAKE
[  238.726554] ath9k: AWAKE -> NETWORK SLEEP
[  238.790756] ath9k: NETWORK SLEEP -> AWAKE
[  238.798264] ath9k: AWAKE -> NETWORK SLEEP
[  238.893151] ath9k: NETWORK SLEEP -> AWAKE
[  238.899188] ath9k: AWAKE -> NETWORK SLEEP
[  238.995545] ath9k: NETWORK SLEEP -> AWAKE
[  239.001594] ath9k: AWAKE -> NETWORK SLEEP
[  239.097971] ath9k: NETWORK SLEEP -> AWAKE
[  239.105098] ath9k: AWAKE -> NETWORK SLEEP
[  239.124090] ath9k: NETWORK SLEEP -> AWAKE
[  239.321395] ath9k: AWAKE -> NETWORK SLEEP
[  239.405180] ath9k: NETWORK SLEEP -> AWAKE
[  239.414369] ath9k: AWAKE -> NETWORK SLEEP
[  239.507579] ath9k: NETWORK SLEEP -> AWAKE
[  239.513625] ath9k: AWAKE -> NETWORK SLEEP
[  239.609999] ath9k: NETWORK SLEEP -> AWAKE
[  239.617122] ath9k: AWAKE -> NETWORK SLEEP
[  239.712397] ath9k: NETWORK SLEEP -> AWAKE
[  239.720678] ath9k: AWAKE -> NETWORK SLEEP
[  239.814789] ath9k: NETWORK SLEEP -> AWAKE
[  239.824492] ath9k: AWAKE -> NETWORK SLEEP
[  239.917215] ath9k: NETWORK SLEEP -> AWAKE
[  239.923244] ath9k: AWAKE -> NETWORK SLEEP
[  240.019608] ath9k: NETWORK SLEEP -> AWAKE
[  240.130542] ath9k: AWAKE -> NETWORK SLEEP
[  240.224429] ath9k: NETWORK SLEEP -> AWAKE
[  240.230466] ath9k: AWAKE -> NETWORK SLEEP
[  240.326823] ath9k: NETWORK SLEEP -> AWAKE
[  240.332868] ath9k: AWAKE -> NETWORK SLEEP
[  240.348444] ath9k: NETWORK SLEEP -> AWAKE
[  240.594660] ath9k: AWAKE -> NETWORK SLEEP
[  240.595764] ath9k: NETWORK SLEEP -> AWAKE
[  240.595848] ath9k: AWAKE -> NETWORK SLEEP
[  240.628964] ath9k: NETWORK SLEEP -> AWAKE
[  240.629062] ath9k: AWAKE -> NETWORK SLEEP
[  240.629104] ath9k: NETWORK SLEEP -> AWAKE
[  240.629182] ath9k: AWAKE -> NETWORK SLEEP
[  240.634032] ath9k: NETWORK SLEEP -> AWAKE
[  240.887286] ath9k: AWAKE -> NETWORK SLEEP
[  240.941281] ath9k: NETWORK SLEEP -> AWAKE
[  240.947301] ath9k: AWAKE -> NETWORK SLEEP
[  241.043673] ath9k: NETWORK SLEEP -> AWAKE
[  241.050536] ath9k: AWAKE -> NETWORK SLEEP
[  241.146068] ath9k: NETWORK SLEEP -> AWAKE
[  241.157875] ath9k: AWAKE -> NETWORK SLEEP
[  241.187352] ath9k: NETWORK SLEEP -> AWAKE
[  241.349573] ath9k: AWAKE -> NETWORK SLEEP
[  241.350871] ath9k: NETWORK SLEEP -> AWAKE
[  241.459328] ath9k: AWAKE -> NETWORK SLEEP
[  241.555705] ath9k: NETWORK SLEEP -> AWAKE
[  241.666106] ath9k: AWAKE -> NETWORK SLEEP
[  241.745084] ath9k: NETWORK SLEEP -> AWAKE
[  241.971677] ath9k: AWAKE -> NETWORK SLEEP
[  242.067739] ath9k: NETWORK SLEEP -> AWAKE
[  242.073781] ath9k: AWAKE -> NETWORK SLEEP
[  242.170131] ath9k: NETWORK SLEEP -> AWAKE
[  242.176647] ath9k: AWAKE -> NETWORK SLEEP
[  242.272551] ath9k: NETWORK SLEEP -> AWAKE
[  242.278906] ath9k: AWAKE -> NETWORK SLEEP
[  242.374962] ath9k: NETWORK SLEEP -> AWAKE
[  242.394167] ath9k: AWAKE -> NETWORK SLEEP
[  242.477343] ath9k: NETWORK SLEEP -> AWAKE
[  242.585884] ath9k: AWAKE -> NETWORK SLEEP
[  242.682160] ath9k: NETWORK SLEEP -> AWAKE
[  242.688191] ath9k: AWAKE -> NETWORK SLEEP
[  242.747363] ath9k: NETWORK SLEEP -> AWAKE
[  242.883222] ath9k: AWAKE -> NETWORK SLEEP
[  242.886979] ath9k: NETWORK SLEEP -> AWAKE
[  242.893011] ath9k: AWAKE -> NETWORK SLEEP
[  242.989372] ath9k: NETWORK SLEEP -> AWAKE
[  242.995406] ath9k: AWAKE -> NETWORK SLEEP
[  243.091801] ath9k: NETWORK SLEEP -> AWAKE
[  243.097883] ath9k: AWAKE -> NETWORK SLEEP
[  243.114354] ath9k: NETWORK SLEEP -> AWAKE
[  243.240232] ath9k: AWAKE -> NETWORK SLEEP
[  243.296588] ath9k: NETWORK SLEEP -> AWAKE
[  243.302634] ath9k: AWAKE -> NETWORK SLEEP
[  243.399012] ath9k: NETWORK SLEEP -> AWAKE
[  243.405119] ath9k: AWAKE -> NETWORK SLEEP
[  243.501405] ath9k: NETWORK SLEEP -> AWAKE
[  243.714300] ath9k: AWAKE -> NETWORK SLEEP
[  243.754416] ath9k: NETWORK SLEEP -> AWAKE
[  243.878344] ath9k: AWAKE -> NETWORK SLEEP
[  243.911050] ath9k: NETWORK SLEEP -> AWAKE
[  243.918049] ath9k: AWAKE -> NETWORK SLEEP
[  244.013447] ath9k: NETWORK SLEEP -> AWAKE
[  244.020296] ath9k: AWAKE -> NETWORK SLEEP
[  244.115844] ath9k: NETWORK SLEEP -> AWAKE
[  244.224376] ath9k: AWAKE -> NETWORK SLEEP
[  244.320663] ath9k: NETWORK SLEEP -> AWAKE
[  244.531612] ath9k: AWAKE -> NETWORK SLEEP
[  244.627874] ath9k: NETWORK SLEEP -> AWAKE
[  244.637811] ath9k: AWAKE -> NETWORK SLEEP
[  244.730296] ath9k: NETWORK SLEEP -> AWAKE
[  244.736431] ath9k: AWAKE -> NETWORK SLEEP
[  244.756146] ath9k: NETWORK SLEEP -> AWAKE
[  244.861664] ath9k: AWAKE -> NETWORK SLEEP
[  244.935088] ath9k: NETWORK SLEEP -> AWAKE
[  244.945855] ath9k: AWAKE -> NETWORK SLEEP
[  245.037509] ath9k: NETWORK SLEEP -> AWAKE
[  245.044897] ath9k: AWAKE -> NETWORK SLEEP
[  245.139905] ath9k: NETWORK SLEEP -> AWAKE
[  245.248343] ath9k: AWAKE -> NETWORK SLEEP
[  245.344726] ath9k: NETWORK SLEEP -> AWAKE
[  245.350755] ath9k: AWAKE -> NETWORK SLEEP
[  245.447116] ath9k: NETWORK SLEEP -> AWAKE
[  245.453151] ath9k: AWAKE -> NETWORK SLEEP
[  245.549544] ath9k: NETWORK SLEEP -> AWAKE
[  245.555803] ath9k: AWAKE -> NETWORK SLEEP
[  245.651936] ath9k: NETWORK SLEEP -> AWAKE
[  245.666568] ath9k: AWAKE -> NETWORK SLEEP
[  245.754327] ath9k: NETWORK SLEEP -> AWAKE
[  245.925685] ath9k: AWAKE -> NETWORK SLEEP
[  245.959149] ath9k: NETWORK SLEEP -> AWAKE
[  245.966223] ath9k: AWAKE -> NETWORK SLEEP
[  246.061575] ath9k: NETWORK SLEEP -> AWAKE
[  246.068154] ath9k: AWAKE -> NETWORK SLEEP
[  246.163974] ath9k: NETWORK SLEEP -> AWAKE
[  246.170608] ath9k: AWAKE -> NETWORK SLEEP
[  246.266363] ath9k: NETWORK SLEEP -> AWAKE
[  246.272511] ath9k: AWAKE -> NETWORK SLEEP
[  246.368790] ath9k: NETWORK SLEEP -> AWAKE
[  246.380986] ath9k: AWAKE -> NETWORK SLEEP
[  246.471185] ath9k: NETWORK SLEEP -> AWAKE
[  246.477750] ath9k: AWAKE -> NETWORK SLEEP
[  246.573580] ath9k: NETWORK SLEEP -> AWAKE
[  246.682024] ath9k: AWAKE -> NETWORK SLEEP
[  246.759409] ath9k: NETWORK SLEEP -> AWAKE
[  246.967195] ath9k: AWAKE -> NETWORK SLEEP
[  246.983216] ath9k: NETWORK SLEEP -> AWAKE
[  246.992405] ath9k: AWAKE -> NETWORK SLEEP
[  247.085612] ath9k: NETWORK SLEEP -> AWAKE
[  247.093153] ath9k: AWAKE -> NETWORK SLEEP
[  247.188037] ath9k: NETWORK SLEEP -> AWAKE
[  247.198612] ath9k: AWAKE -> NETWORK SLEEP
[  247.290432] ath9k: NETWORK SLEEP -> AWAKE
[  247.296463] ath9k: AWAKE -> NETWORK SLEEP
[  247.392821] ath9k: NETWORK SLEEP -> AWAKE
[  247.398874] ath9k: AWAKE -> NETWORK SLEEP
[  247.495250] ath9k: NETWORK SLEEP -> AWAKE
[  247.501426] ath9k: AWAKE -> NETWORK SLEEP
[  247.597636] ath9k: NETWORK SLEEP -> AWAKE
[  247.607789] ath9k: AWAKE -> NETWORK SLEEP
[  247.700061] ath9k: NETWORK SLEEP -> AWAKE
[  247.706663] ath9k: AWAKE -> NETWORK SLEEP
[  247.760163] ath9k: NETWORK SLEEP -> AWAKE
[  247.935376] ath9k: AWAKE -> NETWORK SLEEP
[  248.007275] ath9k: NETWORK SLEEP -> AWAKE
[  248.019496] ath9k: AWAKE -> NETWORK SLEEP
[  248.109678] ath9k: NETWORK SLEEP -> AWAKE
[  248.116733] ath9k: AWAKE -> NETWORK SLEEP
[  248.212057] ath9k: NETWORK SLEEP -> AWAKE
[  248.218163] ath9k: AWAKE -> NETWORK SLEEP
[  248.314489] ath9k: NETWORK SLEEP -> AWAKE
[  248.322736] ath9k: AWAKE -> NETWORK SLEEP
[  248.416888] ath9k: NETWORK SLEEP -> AWAKE
[  248.422929] ath9k: AWAKE -> NETWORK SLEEP
[  248.519316] ath9k: NETWORK SLEEP -> AWAKE
[  248.525617] ath9k: AWAKE -> NETWORK SLEEP
[  248.621708] ath9k: NETWORK SLEEP -> AWAKE
[  248.894350] ath9k: AWAKE -> NETWORK SLEEP
[  248.894435] ath9k: NETWORK SLEEP -> AWAKE
[  248.894515] ath9k: AWAKE -> NETWORK SLEEP
[  248.909766] ath9k: NETWORK SLEEP -> AWAKE
[  248.909856] ath9k: AWAKE -> NETWORK SLEEP
[  248.909892] ath9k: NETWORK SLEEP -> AWAKE
[  248.909966] ath9k: AWAKE -> NETWORK SLEEP
[  248.925353] ath9k: NETWORK SLEEP -> AWAKE
[  248.925442] ath9k: AWAKE -> NETWORK SLEEP
[  248.926743] ath9k: NETWORK SLEEP -> AWAKE
[  248.926824] ath9k: AWAKE -> NETWORK SLEEP
[  248.928906] ath9k: NETWORK SLEEP -> AWAKE
[  248.934618] ath9k: AWAKE -> NETWORK SLEEP
[  248.934894] ath9k: NETWORK SLEEP -> AWAKE
[  248.934969] ath9k: AWAKE -> NETWORK SLEEP
[  248.935414] ath9k: NETWORK SLEEP -> AWAKE
[  248.935501] ath9k: AWAKE -> NETWORK SLEEP
[  248.935547] ath9k: NETWORK SLEEP -> AWAKE
[  248.935621] ath9k: AWAKE -> NETWORK SLEEP
[  248.935872] ath9k: NETWORK SLEEP -> AWAKE
[  248.935952] ath9k: AWAKE -> NETWORK SLEEP
[  248.935988] ath9k: NETWORK SLEEP -> AWAKE
[  248.936088] ath9k: AWAKE -> NETWORK SLEEP
[  248.936097] ath9k: NETWORK SLEEP -> AWAKE
[  248.936198] ath9k: AWAKE -> NETWORK SLEEP
[  248.936210] ath9k: NETWORK SLEEP -> AWAKE
[  248.936292] ath9k: AWAKE -> NETWORK SLEEP
[  248.936692] ath9k: NETWORK SLEEP -> AWAKE
[  248.936819] ath9k: AWAKE -> NETWORK SLEEP
[  248.940131] ath9k: NETWORK SLEEP -> AWAKE
[  249.061727] ath9k: AWAKE -> NETWORK SLEEP
[  249.133741] ath9k: NETWORK SLEEP -> AWAKE
[  249.142554] ath9k: AWAKE -> NETWORK SLEEP
[  249.236138] ath9k: NETWORK SLEEP -> AWAKE
[  249.242164] ath9k: AWAKE -> NETWORK SLEEP
[  249.338563] ath9k: NETWORK SLEEP -> AWAKE
[  249.344678] ath9k: AWAKE -> NETWORK SLEEP
[  249.440959] ath9k: NETWORK SLEEP -> AWAKE
[  249.447605] ath9k: AWAKE -> NETWORK SLEEP
[  249.543348] ath9k: NETWORK SLEEP -> AWAKE
[  249.549393] ath9k: AWAKE -> NETWORK SLEEP
[  249.577650] PM: Syncing filesystems ... 
[  249.645775] ath9k: NETWORK SLEEP -> AWAKE
[  249.651822] ath9k: AWAKE -> NETWORK SLEEP
[  249.677281] done.
[  249.677291] PM: Preparing system for mem sleep
[  249.748159] ath9k: NETWORK SLEEP -> AWAKE
[  249.754256] ath9k: AWAKE -> NETWORK SLEEP
[  249.765132] ath9k: NETWORK SLEEP -> AWAKE
[  249.824923] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  249.826762] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  249.826830] PM: Entering mem sleep
[  249.826853] Suspending console(s) (use no_console_suspend to debug)
[  249.832057] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  249.832077] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  249.832110] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  249.832130] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 6
[  249.832141] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 6
[  249.832166] ath9k: Detach Interface
[  249.834435] ath9k: AWAKE -> FULL-SLEEP
[  249.834446] ath9k: Driver halt
[  249.858079] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  249.858457] sd 0:0:0:0: [sda] Stopping disk
[  250.781437] ath9k 0000:01:00.0: PCI INT A disabled
[  250.805619] ACPI handle has no context!
[  250.805632] atl1c 0000:02:00.0: PME# disabled
[  250.805645] atl1c 0000:02:00.0: PCI INT A disabled
[  250.805654] ACPI handle has no context!
[  250.849209] ata6: port disabled. ignoring.
[  250.849279] ata_piix 0000:00:1f.1: PCI INT A disabled
[  250.849297] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  250.849310] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  250.849320] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  250.849331] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  250.849342] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  250.867856] i915 0000:00:02.0: PCI INT A disabled
[  250.878415] ehci_hcd 0000:00:1d.7: PME# disabled
[  250.889462] ACPI: Preparing to enter system sleep state S3
[  250.979768] Disabling non-boot CPUs ...
[  251.083028] CPU 1 is now offline
[  251.083033] SMP alternatives: switching to UP code
[  251.087065] CPU1 is down
[  251.087088] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  251.087088] Back to C!
[  251.087088] Enabling non-boot CPUs ...
[  251.087088] SMP alternatives: switching to SMP code
[  251.090663] Booting processor 1 APIC 0x1 ip 0x6000
[  251.086421] Initializing CPU#1
[  251.086421] Calibrating delay using timer specific routine.. 3329.63 BogoMIPS (lpj=1664818)
[  251.086421] CPU: L1 I cache: 32K, L1 D cache: 24K
[  251.086421] CPU: L2 cache: 512K
[  251.086421] CPU: Physical Processor ID: 0
[  251.086421] CPU: Processor Core ID: 0
[  251.086421] mce: CPU supports 5 MCE banks
[  251.086421] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  251.161902] CPU1: Intel(R) Atom(TM) CPU N280   @ 1.66GHz stepping 02
[  251.162270] Switched to high resolution mode on CPU 1
[  251.167037] CPU1 is up
[  251.167044] ACPI: Waking up from system sleep state S3
[  251.513515] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  251.513536] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[  251.513622] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  251.513697] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
[  251.513717] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  251.513790] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  251.513834] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  251.513877] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  251.513920] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  251.513973] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[  251.513998] ehci_hcd 0000:00:1d.7: PME# disabled
[  251.514185] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  251.891087] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  251.891096] i915 0000:00:02.0: setting latency timer to 64
[  251.952686] [drm] LVDS-8: set mode 1024x600 e
[  251.972895] pci 0000:00:02.1: PME# disabled
[  251.972904] pci 0000:00:1b.0: PME# disabled
[  251.972931] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  251.972941] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  251.972970] usb usb2: root hub lost power or was reset
[  251.972995] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[  251.973017] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  251.973044] usb usb3: root hub lost power or was reset
[  251.973069] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[  251.973079] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  251.973105] usb usb4: root hub lost power or was reset
[  251.973129] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[  251.973139] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  251.973165] usb usb5: root hub lost power or was reset
[  251.973202] ehci_hcd 0000:00:1d.7: PME# disabled
[  251.973211] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  251.973220] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  251.973259] pci 0000:00:1e.0: setting latency timer to 64
[  251.973280] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  251.973295] ata_piix 0000:00:1f.1: setting latency timer to 64
[  251.974930] ata6: port disabled. ignoring.
[  251.974958] ahci 0000:00:1f.2: setting latency timer to 64
[  251.975038] atl1c 0000:02:00.0: PME# disabled
[  251.975046] atl1c 0000:02:00.0: PME# disabled
[  252.000065] Clocksource tsc unstable (delta = -500035026 ns)
[  252.038615] atl1c 0000:02:00.0: irq 28 for MSI/MSI-X
[  252.038696] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  252.280096] ata3: SATA link down (SStatus 0 SControl 300)
[  252.510608] sd 0:0:0:0: [sda] Starting disk
[  252.535086] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  252.537198] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  252.539942] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  252.540377] ata1.00: configured for UDMA/133
[  252.551076] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[  252.551085] ata1: irq_stat 0x00400040, connection status changed
[  252.551103] ata1: hard resetting link
[  253.274077] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  253.363507] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  253.366212] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  253.366627] ata1.00: configured for UDMA/133
[  253.366637] ata1: EH complete
[  253.525070] usb 1-8: reset high speed USB device using ehci_hcd and address 3
[  253.805064] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[  254.521068] ath9k: Starting driver with initial channel: 2437 MHz
[  254.522086] ath9k: FULL-SLEEP -> AWAKE
[  254.533094] ath9k: ah->misc_mode 0x4
[  254.535214] ath9k: Attach a VIF of type: 2
[  254.535248] ath9k: Set channel: 2437 MHz
[  254.535252] ath9k: tx chmask: 1, rx chmask: 1
[  254.535373] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  254.541929] ath9k: ah->misc_mode 0x4
[  254.544052] ath9k: Set HW RX filter: 0x607
[  254.544058] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  254.544065] ath9k: BSS Changed PREAMBLE 1
[  254.544068] ath9k: BSS Changed CTS PROT 0
[  254.544072] ath9k: BSS Changed ASSOC 1
[  254.544076] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  254.546454] PM: Finishing wakeup.
[  254.546458] Restarting tasks ... done.
[  254.589051] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  254.589095] activated addBA response timer on tid 0
[  254.615144] Rx A-MPDU request on tid 0 result 0
[  254.717357] switched off addBA timer for tid 0 
[  254.717366] Aggregation is on for tid 0 
[  254.718297] switched off addBA timer for tid 0 
[  255.170649] ath9k: AWAKE -> NETWORK SLEEP
[  255.259366] ath9k: NETWORK SLEEP -> AWAKE
[  255.267232] ath9k: AWAKE -> NETWORK SLEEP
[  255.362310] ath9k: NETWORK SLEEP -> AWAKE
[  255.367505] ath9k: AWAKE -> NETWORK SLEEP
[  255.463747] ath9k: NETWORK SLEEP -> AWAKE
[  255.472573] ath9k: AWAKE -> NETWORK SLEEP
[  255.566148] ath9k: NETWORK SLEEP -> AWAKE
[  255.572445] ath9k: AWAKE -> NETWORK SLEEP
[  255.579315] ath9k: NETWORK SLEEP -> AWAKE
[  255.716166] ath9k: AWAKE -> NETWORK SLEEP
[  255.770968] ath9k: NETWORK SLEEP -> AWAKE
[  255.914369] ath9k: AWAKE -> NETWORK SLEEP
[  255.975786] ath9k: NETWORK SLEEP -> AWAKE
[  255.989251] ath9k: AWAKE -> NETWORK SLEEP
[  256.078177] ath9k: NETWORK SLEEP -> AWAKE
[  256.089350] ath9k: AWAKE -> NETWORK SLEEP
[  256.180575] ath9k: NETWORK SLEEP -> AWAKE
[  256.186818] ath9k: AWAKE -> NETWORK SLEEP
[  256.282999] ath9k: NETWORK SLEEP -> AWAKE
[  256.289584] ath9k: AWAKE -> NETWORK SLEEP
[  256.385395] ath9k: NETWORK SLEEP -> AWAKE
[  256.392602] ath9k: AWAKE -> NETWORK SLEEP
[  256.487815] ath9k: NETWORK SLEEP -> AWAKE
[  256.495918] ath9k: AWAKE -> NETWORK SLEEP
[  256.581243] ath9k: NETWORK SLEEP -> AWAKE
[  256.752936] ath9k: AWAKE -> NETWORK SLEEP
[  256.795032] ath9k: NETWORK SLEEP -> AWAKE
[  256.808386] ath9k: AWAKE -> NETWORK SLEEP
[  256.897427] ath9k: NETWORK SLEEP -> AWAKE
[  256.905851] ath9k: AWAKE -> NETWORK SLEEP
[  256.999823] ath9k: NETWORK SLEEP -> AWAKE
[  257.007478] ath9k: AWAKE -> NETWORK SLEEP
[  257.102240] ath9k: NETWORK SLEEP -> AWAKE
[  257.109563] ath9k: AWAKE -> NETWORK SLEEP
[  257.204636] ath9k: NETWORK SLEEP -> AWAKE
[  257.218321] ath9k: AWAKE -> NETWORK SLEEP
[  257.307067] ath9k: NETWORK SLEEP -> AWAKE
[  257.320752] ath9k: AWAKE -> NETWORK SLEEP
[  257.409459] ath9k: NETWORK SLEEP -> AWAKE
[  257.415526] ath9k: AWAKE -> NETWORK SLEEP
[  257.511849] ath9k: NETWORK SLEEP -> AWAKE
[  257.522702] ath9k: AWAKE -> NETWORK SLEEP
[  257.583206] ath9k: NETWORK SLEEP -> AWAKE
[  257.736613] ath9k: AWAKE -> NETWORK SLEEP
[  257.819066] ath9k: NETWORK SLEEP -> AWAKE
[  257.825107] ath9k: AWAKE -> NETWORK SLEEP
[  257.921492] ath9k: NETWORK SLEEP -> AWAKE
[  258.031682] ath9k: AWAKE -> NETWORK SLEEP
[  258.126312] ath9k: NETWORK SLEEP -> AWAKE
[  258.133191] ath9k: AWAKE -> NETWORK SLEEP
[  258.228705] ath9k: NETWORK SLEEP -> AWAKE
[  258.234750] ath9k: AWAKE -> NETWORK SLEEP
[  258.331101] ath9k: NETWORK SLEEP -> AWAKE
[  258.439544] ath9k: AWAKE -> NETWORK SLEEP
[  258.535916] ath9k: NETWORK SLEEP -> AWAKE
[  258.545161] ath9k: AWAKE -> NETWORK SLEEP
[  258.585117] ath9k: NETWORK SLEEP -> AWAKE
[  258.800412] ath9k: AWAKE -> NETWORK SLEEP
[  258.843128] ath9k: NETWORK SLEEP -> AWAKE
[  258.854426] ath9k: AWAKE -> NETWORK SLEEP
[  258.945557] ath9k: NETWORK SLEEP -> AWAKE
[  259.056202] ath9k: AWAKE -> NETWORK SLEEP
[  259.150342] ath9k: NETWORK SLEEP -> AWAKE
[  259.164096] ath9k: AWAKE -> NETWORK SLEEP
[  259.252754] ath9k: NETWORK SLEEP -> AWAKE
[  259.268592] ath9k: AWAKE -> NETWORK SLEEP
[  259.355152] ath9k: NETWORK SLEEP -> AWAKE
[  259.364883] ath9k: AWAKE -> NETWORK SLEEP
[  259.457558] ath9k: NETWORK SLEEP -> AWAKE
[  259.463747] ath9k: AWAKE -> NETWORK SLEEP
[  259.559975] ath9k: NETWORK SLEEP -> AWAKE
[  259.566046] ath9k: AWAKE -> NETWORK SLEEP
[  259.586374] ath9k: NETWORK SLEEP -> AWAKE
[  259.708679] ath9k: AWAKE -> NETWORK SLEEP
[  259.764796] ath9k: NETWORK SLEEP -> AWAKE
[  259.775523] ath9k: AWAKE -> NETWORK SLEEP
[  259.867193] ath9k: NETWORK SLEEP -> AWAKE
[  259.873841] ath9k: AWAKE -> NETWORK SLEEP
[  259.969575] ath9k: NETWORK SLEEP -> AWAKE
[  259.976974] ath9k: AWAKE -> NETWORK SLEEP
[  260.072013] ath9k: NETWORK SLEEP -> AWAKE
[  260.078410] ath9k: AWAKE -> NETWORK SLEEP
[  260.174434] ath9k: NETWORK SLEEP -> AWAKE
[  260.182442] ath9k: AWAKE -> NETWORK SLEEP
[  260.276805] ath9k: NETWORK SLEEP -> AWAKE
[  260.385257] ath9k: AWAKE -> NETWORK SLEEP
[  260.481624] ath9k: NETWORK SLEEP -> AWAKE
[  260.489597] ath9k: AWAKE -> NETWORK SLEEP
[  260.493661] PM: Syncing filesystems ... 
[  260.584050] ath9k: NETWORK SLEEP -> AWAKE
[  260.702871] ath9k: AWAKE -> NETWORK SLEEP
[  260.788838] ath9k: NETWORK SLEEP -> AWAKE
[  260.800819] ath9k: AWAKE -> NETWORK SLEEP
[  260.891260] ath9k: NETWORK SLEEP -> AWAKE
[  260.900646] ath9k: AWAKE -> NETWORK SLEEP
[  260.993657] ath9k: NETWORK SLEEP -> AWAKE
[  261.031443] done.
[  261.031450] PM: Preparing system for mem sleep
[  261.102081] ath9k: AWAKE -> NETWORK SLEEP
[  261.177037] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  261.178420] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  261.178507] PM: Entering mem sleep
[  261.178529] Suspending console(s) (use no_console_suspend to debug)
[  261.183334] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  261.183354] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  261.183393] ath9k: 
[  261.183402] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  261.183411] NETWORK SLEEP -> AWAKE
[  261.183507] ath9k: Detach Interface
[  261.185808] ath9k: AWAKE -> FULL-SLEEP
[  261.185818] ath9k: Driver halt
[  261.209077] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  261.209436] sd 0:0:0:0: [sda] Stopping disk
[  262.135172] ath9k 0000:01:00.0: PCI INT A disabled
[  262.159620] ACPI handle has no context!
[  262.159632] atl1c 0000:02:00.0: PME# disabled
[  262.159641] ACPI handle has no context!
[  262.203159] ata6: port disabled. ignoring.
[  262.203249] ata_piix 0000:00:1f.1: PCI INT A disabled
[  262.203267] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  262.203279] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  262.203290] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  262.203301] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  262.203311] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  262.217293] i915 0000:00:02.0: PCI INT A disabled
[  262.228409] ehci_hcd 0000:00:1d.7: PME# disabled
[  262.239465] ACPI: Preparing to enter system sleep state S3
[  262.323768] Disabling non-boot CPUs ...
[  262.326104] CPU 1 is now offline
[  262.326110] SMP alternatives: switching to UP code
[  262.330136] CPU1 is down
[  262.330160] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  262.330160] Back to C!
[  262.330160] Enabling non-boot CPUs ...
[  262.330160] SMP alternatives: switching to SMP code
[  262.333739] Booting processor 1 APIC 0x1 ip 0x6000
[  262.329484] Initializing CPU#1
[  262.329484] Calibrating delay using timer specific routine.. 3329.65 BogoMIPS (lpj=1664826)
[  262.329484] CPU: L1 I cache: 32K, L1 D cache: 24K
[  262.329484] CPU: L2 cache: 512K
[  262.329484] CPU: Physical Processor ID: 0
[  262.329484] CPU: Processor Core ID: 0
[  262.329484] mce: CPU supports 5 MCE banks
[  262.329484] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  262.404875] CPU1: Intel(R) Atom(TM) CPU N280   @ 1.66GHz stepping 02
[  262.405269] Switched to high resolution mode on CPU 1
[  262.408033] CPU1 is up
[  262.408040] ACPI: Waking up from system sleep state S3
[  262.754531] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[  262.754619] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  262.754703] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  262.754776] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  262.754820] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  262.754863] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  262.754906] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  262.754959] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[  262.754984] ehci_hcd 0000:00:1d.7: PME# disabled
[  262.755170] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  263.119684] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  263.119693] i915 0000:00:02.0: setting latency timer to 64
[  263.181289] [drm] LVDS-8: set mode 1024x600 e
[  263.201499] pci 0000:00:02.1: PME# disabled
[  263.201508] pci 0000:00:1b.0: PME# disabled
[  263.201536] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  263.201546] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  263.201575] usb usb2: root hub lost power or was reset
[  263.201600] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[  263.201609] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  263.201636] usb usb3: root hub lost power or was reset
[  263.201660] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[  263.201670] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  263.201696] usb usb4: root hub lost power or was reset
[  263.201720] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[  263.201730] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  263.201756] usb usb5: root hub lost power or was reset
[  263.201793] ehci_hcd 0000:00:1d.7: PME# disabled
[  263.201801] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  263.201811] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  263.201845] pci 0000:00:1e.0: setting latency timer to 64
[  263.201861] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  263.201869] ata_piix 0000:00:1f.1: setting latency timer to 64
[  263.203529] ahci 0000:00:1f.2: setting latency timer to 64
[  263.203606] atl1c 0000:02:00.0: PME# disabled
[  263.203618] atl1c 0000:02:00.0: PME# disabled
[  263.205173] ata6: port disabled. ignoring.
[  263.266615] atl1c 0000:02:00.0: irq 28 for MSI/MSI-X
[  263.266697] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  263.509085] ata3: SATA link down (SStatus 0 SControl 300)
[  263.744225] sd 0:0:0:0: [sda] Starting disk
[  263.815074] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  263.817183] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  263.819960] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  263.820379] ata1.00: configured for UDMA/133
[  263.831076] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  263.831085] ata1: irq_stat 0x00000040, connection status changed
[  263.835194] ata1.00: configured for UDMA/133
[  263.835203] ata1: EH complete
[  263.990069] usb 1-8: reset high speed USB device using ehci_hcd and address 3
[  264.270065] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[  264.985093] ath9k: Starting driver with initial channel: 2437 MHz
[  264.986112] ath9k: FULL-SLEEP -> AWAKE
[  264.997044] ath9k: ah->misc_mode 0x4
[  264.999170] ath9k: Attach a VIF of type: 2
[  264.999204] ath9k: Set channel: 2437 MHz
[  264.999208] ath9k: tx chmask: 1, rx chmask: 1
[  264.999329] ath9k: (2437 MHz) -> (2437 MHz), chanwidth: 1
[  265.005872] ath9k: ah->misc_mode 0x4
[  265.007985] ath9k: Set HW RX filter: 0x607
[  265.007991] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  265.007998] ath9k: BSS Changed PREAMBLE 1
[  265.008015] ath9k: BSS Changed CTS PROT 0
[  265.008019] ath9k: BSS Changed ASSOC 1
[  265.008022] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  265.010482] PM: Finishing wakeup.
[  265.010486] Restarting tasks ... done.
[  265.073219] Open BA session requested for 00:22:6b:56:fd:e8 tid 0
[  265.073260] activated addBA response timer on tid 0
[  265.079559] Rx A-MPDU request on tid 0 result 0
[  265.080333] switched off addBA timer for tid 0 
[  265.080340] Aggregation is on for tid 0 
[  265.183979] ath9k: AWAKE -> NETWORK SLEEP
[  265.216135] ath9k: NETWORK SLEEP -> AWAKE
[  265.257061] ath9k: AWAKE -> NETWORK SLEEP
[  265.351346] ath9k: NETWORK SLEEP -> AWAKE
[  265.358516] ath9k: AWAKE -> NETWORK SLEEP
[  265.453746] ath9k: NETWORK SLEEP -> AWAKE
[  265.566082] ath9k: AWAKE -> NETWORK SLEEP
[  265.658575] ath9k: NETWORK SLEEP -> AWAKE
[  265.664594] ath9k: AWAKE -> NETWORK SLEEP
[  265.761426] ath9k: NETWORK SLEEP -> AWAKE
[  265.766991] ath9k: AWAKE -> NETWORK SLEEP
[  265.863359] ath9k: NETWORK SLEEP -> AWAKE
[  265.870216] ath9k: AWAKE -> NETWORK SLEEP
[  265.965785] ath9k: NETWORK SLEEP -> AWAKE
[  266.155285] ath9k: AWAKE -> NETWORK SLEEP
[  266.170609] ath9k: NETWORK SLEEP -> AWAKE
[  266.176629] ath9k: AWAKE -> NETWORK SLEEP
[  266.273004] ath9k: NETWORK SLEEP -> AWAKE
[  266.290227] ath9k: AWAKE -> NETWORK SLEEP
[  266.375397] ath9k: NETWORK SLEEP -> AWAKE
[  266.390555] ath9k: AWAKE -> NETWORK SLEEP
[  266.477821] ath9k: NETWORK SLEEP -> AWAKE
[  266.483838] ath9k: AWAKE -> NETWORK SLEEP
[  266.580212] ath9k: NETWORK SLEEP -> AWAKE
[  266.592311] ath9k: AWAKE -> NETWORK SLEEP
[  266.682609] ath9k: NETWORK SLEEP -> AWAKE
[  266.689742] ath9k: AWAKE -> NETWORK SLEEP
[  266.785034] ath9k: NETWORK SLEEP -> AWAKE
[  266.791060] ath9k: AWAKE -> NETWORK SLEEP
[  266.887430] ath9k: NETWORK SLEEP -> AWAKE
[  266.893463] ath9k: AWAKE -> NETWORK SLEEP
[  266.989851] ath9k: NETWORK SLEEP -> AWAKE
[  266.996265] ath9k: AWAKE -> NETWORK SLEEP
[  267.041821] ath9k: NETWORK SLEEP -> AWAKE
[  267.149699] ath9k: AWAKE -> NETWORK SLEEP
[  267.149746] ath9k: NETWORK SLEEP -> AWAKE
[  267.149826] ath9k: AWAKE -> NETWORK SLEEP
[  267.156269] ath9k: NETWORK SLEEP -> AWAKE
[  267.156401] ath9k: AWAKE -> NETWORK SLEEP
[  267.156431] ath9k: NETWORK SLEEP -> AWAKE
[  267.263985] ath9k: AWAKE -> NETWORK SLEEP
[  267.297068] ath9k: NETWORK SLEEP -> AWAKE
[  267.303088] ath9k: AWAKE -> NETWORK SLEEP
[  267.399463] ath9k: NETWORK SLEEP -> AWAKE
[  267.509124] ath9k: AWAKE -> NETWORK SLEEP
[  267.604281] ath9k: NETWORK SLEEP -> AWAKE
[  267.610935] ath9k: AWAKE -> NETWORK SLEEP
[  267.706676] ath9k: NETWORK SLEEP -> AWAKE
[  267.712885] ath9k: AWAKE -> NETWORK SLEEP
[  267.809099] ath9k: NETWORK SLEEP -> AWAKE
[  267.815119] ath9k: AWAKE -> NETWORK SLEEP
[  267.911494] ath9k: NETWORK SLEEP -> AWAKE
[  267.922560] ath9k: AWAKE -> NETWORK SLEEP
[  268.013888] ath9k: NETWORK SLEEP -> AWAKE
[  268.024162] ath9k: AWAKE -> NETWORK SLEEP
[  268.043685] ath9k: NETWORK SLEEP -> AWAKE
[  268.327988] ath9k: AWAKE -> NETWORK SLEEP
[  268.423524] ath9k: NETWORK SLEEP -> AWAKE
[  268.430287] ath9k: AWAKE -> NETWORK SLEEP
[  268.525922] ath9k: NETWORK SLEEP -> AWAKE
[  268.531956] ath9k: AWAKE -> NETWORK SLEEP
[  268.628342] ath9k: NETWORK SLEEP -> AWAKE
[  268.634355] ath9k: AWAKE -> NETWORK SLEEP
[  268.730741] ath9k: NETWORK SLEEP -> AWAKE
[  268.736772] ath9k: AWAKE -> NETWORK SLEEP
[  268.833132] ath9k: NETWORK SLEEP -> AWAKE
[  268.839698] ath9k: AWAKE -> NETWORK SLEEP
[  268.935560] ath9k: NETWORK SLEEP -> AWAKE
[  268.941811] ath9k: AWAKE -> NETWORK SLEEP
[  269.037953] ath9k: NETWORK SLEEP -> AWAKE
[  269.364463] ath9k: AWAKE -> NETWORK SLEEP
[  269.447561] ath9k: NETWORK SLEEP -> AWAKE
[  269.659769] ath9k: AWAKE -> NETWORK SLEEP
[  269.667818] ath9k: NETWORK SLEEP -> AWAKE
[  270.183772] ath9k: AWAKE -> NETWORK SLEEP
[  270.266796] ath9k: NETWORK SLEEP -> AWAKE
[  270.274056] ath9k: AWAKE -> NETWORK SLEEP
[  270.369199] ath9k: NETWORK SLEEP -> AWAKE
[  270.380323] ath9k: AWAKE -> NETWORK SLEEP
[  270.471615] ath9k: NETWORK SLEEP -> AWAKE
[  270.477675] ath9k: AWAKE -> NETWORK SLEEP
[  270.574054] ath9k: NETWORK SLEEP -> AWAKE
[  270.582421] ath9k: AWAKE -> NETWORK SLEEP
[  270.676431] ath9k: NETWORK SLEEP -> AWAKE
[  270.682643] ath9k: AWAKE -> NETWORK SLEEP
[  270.778860] ath9k: NETWORK SLEEP -> AWAKE
[  270.989686] ath9k: AWAKE -> NETWORK SLEEP
[  271.049041] ath9k: NETWORK SLEEP -> AWAKE
[  271.304833] PM: Syncing filesystems ... done.
[  271.307636] PM: Preparing system for mem sleep
[  271.399307] ath9k: AWAKE -> NETWORK SLEEP
[  271.448580] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  271.450215] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  271.450296] PM: Entering mem sleep
[  271.450321] Suspending console(s) (use no_console_suspend to debug)
[  271.456054] Tx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  271.456073] Stopping Tx BA session for 00:22:6b:56:fd:e8 tid 0
[  271.456112] Rx BA session stop requested for 00:22:6b:56:fd:e8 tid 0
[  271.456141] ath9k: Detach Interface
[  271.456161] ath9k: NETWORK SLEEP -> AWAKE
[  271.458525] ath9k: AWAKE -> NETWORK SLEEP
[  271.458533] ath9k: NETWORK SLEEP -> FULL-SLEEP
[  271.458544] ath9k: 
[  271.458547] ath9k: Driver halt
[  271.458552] FULL-SLEEP -> AWAKE
[  271.485081] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  271.485444] sd 0:0:0:0: [sda] Stopping disk
[  272.348209] ath9k 0000:01:00.0: PCI INT A disabled
[  272.372613] ACPI handle has no context!
[  272.372624] atl1c 0000:02:00.0: PME# disabled
[  272.372634] ACPI handle has no context!
[  272.416210] ata6: port disabled. ignoring.
[  272.416281] ata_piix 0000:00:1f.1: PCI INT A disabled
[  272.416299] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  272.416311] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  272.416321] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  272.416332] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  272.416343] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  272.430411] i915 0000:00:02.0: PCI INT A disabled
[  272.441409] ehci_hcd 0000:00:1d.7: PME# disabled
[  272.452467] ACPI: Preparing to enter system sleep state S3
[  272.545771] Disabling non-boot CPUs ...
[  272.548103] CPU 1 is now offline
[  272.548109] SMP alternatives: switching to UP code
[  272.552115] CPU1 is down
[  272.552139] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  272.552139] Back to C!
[  272.552139] Enabling non-boot CPUs ...
[  272.552139] SMP alternatives: switching to SMP code
[  272.555716] Booting processor 1 APIC 0x1 ip 0x6000
[  272.551463] Initializing CPU#1
[  272.551463] Calibrating delay using timer specific routine.. 3329.63 BogoMIPS (lpj=1664817)
[  272.551463] CPU: L1 I cache: 32K, L1 D cache: 24K
[  272.551463] CPU: L2 cache: 512K
[  272.551463] CPU: Physical Processor ID: 0
[  272.551463] CPU: Processor Core ID: 0
[  272.551463] mce: CPU supports 5 MCE banks
[  272.551463] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  272.626857] CPU1: Intel(R) Atom(TM) CPU N280   @ 1.66GHz stepping 02
[  272.627269] Switched to high resolution mode on CPU 1
[  272.630035] CPU1 is up
[  272.630041] ACPI: Waking up from system sleep state S3
[  272.996533] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100504)
[  272.996621] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
[  272.996706] pcieport-driver 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100106, writing 0x100506)
[  272.996779] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  272.996823] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  272.996866] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  272.996910] uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
[  272.996962] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
[  272.996988] ehci_hcd 0000:00:1d.7: PME# disabled
[  272.997173] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  273.375286] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  273.375297] i915 0000:00:02.0: setting latency timer to 64
[  273.436889] [drm] LVDS-8: set mode 1024x600 e
[  273.457098] pci 0000:00:02.1: PME# disabled
[  273.457107] pci 0000:00:1b.0: PME# disabled
[  273.457134] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  273.457145] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  273.457173] usb usb2: root hub lost power or was reset
[  273.457198] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[  273.457208] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  273.457235] usb usb3: root hub lost power or was reset
[  273.457266] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[  273.457279] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  273.457309] usb usb4: root hub lost power or was reset
[  273.457334] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[  273.457344] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  273.457371] usb usb5: root hub lost power or was reset
[  273.457408] ehci_hcd 0000:00:1d.7: PME# disabled
[  273.457417] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  273.457426] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  273.457460] pci 0000:00:1e.0: setting latency timer to 64
[  273.457476] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  273.457485] ata_piix 0000:00:1f.1: setting latency timer to 64
[  273.459135] ata6: port disabled. ignoring.
[  273.459162] ahci 0000:00:1f.2: setting latency timer to 64
[  273.459227] atl1c 0000:02:00.0: PME# disabled
[  273.459236] atl1c 0000:02:00.0: PME# disabled
[  273.522615] atl1c 0000:02:00.0: irq 28 for MSI/MSI-X
[  273.522696] ath9k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  273.764086] ata3: SATA link down (SStatus 0 SControl 300)
[  273.764099] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  273.766234] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  273.768992] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  273.769428] ata1.00: configured for UDMA/133
[  273.780077] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[  273.780086] ata1: irq_stat 0x00400040, connection status changed
[  273.780104] ata1: hard resetting link
[  273.993975] sd 0:0:0:0: [sda] Starting disk
[  274.503082] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  274.585102] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  274.587713] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  274.588112] ata1.00: configured for UDMA/133
[  274.588123] ata1: EH complete
[  274.747070] usb 1-8: reset high speed USB device using ehci_hcd and address 3
[  275.026064] usb 5-1: reset full speed USB device using uhci_hcd and address 2
[  275.742070] ath9k: Starting driver with initial channel: 2437 MHz
[  275.891791] ath9k: timeout (100000 us) on reg 0x7000: 0xdeadbeef & 0x00000003 != 0x00000000
[  275.891799] ath9k: RTC stuck in MAC reset
[  275.891803] ath9k: Chip reset failed
[  275.891807] ath9k: Unable to reset hardware; reset status -22 (freq 2437 MHz)
[  275.891827] ath9k: Attach a VIF of type: 2
[  275.891867] ath9k: Set channel: 2437 MHz
[  275.891873] ath9k: tx chmask: 1, rx chmask: 1
[  275.891880] ath9k: Unable to set channel
[  275.891894] ath9k: Set HW RX filter: 0x2707
[  275.891901] ath9k: RX filter 0x0 bssid 00:22:6b:56:fd:e8 aid 0x0
[  275.891910] ath9k: BSS Changed PREAMBLE 1
[  275.891915] ath9k: BSS Changed CTS PROT 0
[  275.891919] ath9k: BSS Changed ASSOC 1
[  275.891924] ath9k: Bss Info ASSOC 1, bssid: 00:22:6b:56:fd:e8
[  275.894481] PM: Finishing wakeup.
[  275.894486] Restarting tasks ... done.
[  276.835592] irq 18: nobody cared (try booting with the "irqpoll" option)
[  276.835609] Pid: 1710, comm: Xorg Not tainted 2.6.31.4-intel-menlow #14
[  276.835616] Call Trace:
[  276.835636]  [<c105ca3e>] __report_bad_irq+0x2e/0x6f
[  276.835646]  [<c105cb74>] note_interrupt+0xf5/0x14d
[  276.835656]  [<c105d0a4>] handle_fasteoi_irq+0x7d/0x9b
[  276.835668]  [<c10048c1>] handle_irq+0x3b/0x46
[  276.835677]  [<c1004103>] do_IRQ+0x41/0x95
[  276.835687]  [<c1003189>] common_interrupt+0x29/0x30
[  276.835693] handlers:
[  276.835698] [<f89a3d03>] (ath_isr+0x0/0x12f [ath9k])
[  276.835739] Disabling IRQ #18
