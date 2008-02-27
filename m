Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbYB0V0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbYB0V0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759720AbYB0VWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:22:35 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:49185 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760574AbYB0VWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:22:34 -0500
Date: Wed, 27 Feb 2008 23:21:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Michael Krufky <mkrufky@linuxtv.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: video/tda8290.c: possibly uninitialized variables used
Message-ID: <20080227212124.GT29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/video/tda8290.c contains the following code:

<--  snip  -->

...
static void tda8290_set_params(struct dvb_frontend *fe,
                               struct analog_parameters *params)
{
...
        unsigned char adc_sat, agc_stat,
                      pll_stat;
        int i;

        set_audio(fe, params);

        if (priv->cfg.config)
                tuner_dbg("tda827xa config is 0x%02x\n", *priv->cfg.config);
        tuner_i2c_xfer_send(&priv->i2c_props, easy_mode, 2);
        tuner_i2c_xfer_send(&priv->i2c_props, agc_out_on, 2);
        tuner_i2c_xfer_send(&priv->i2c_props, soft_reset, 2);
        msleep(1);

        expert_mode[1] = priv->tda8290_easy_mode + 0x80;
        tuner_i2c_xfer_send(&priv->i2c_props, expert_mode, 2);
        tuner_i2c_xfer_send(&priv->i2c_props, gainset_off, 2);
        tuner_i2c_xfer_send(&priv->i2c_props, if_agc_spd, 2);
        if (priv->tda8290_easy_mode & 0x60)
                tuner_i2c_xfer_send(&priv->i2c_props, adc_head_9, 2);
        else
                tuner_i2c_xfer_send(&priv->i2c_props, adc_head_6, 2);
        tuner_i2c_xfer_send(&priv->i2c_props, pll_bw_nom, 2);

        tda8290_i2c_bridge(fe, 1);

        if (fe->ops.tuner_ops.set_analog_params)
                fe->ops.tuner_ops.set_analog_params(fe, params);

        for (i = 0; i < 3; i++) {
                tuner_i2c_xfer_send(&priv->i2c_props, &addr_pll_stat, 1);
                tuner_i2c_xfer_recv(&priv->i2c_props, &pll_stat, 1);
                if (pll_stat & 0x80) {
                        tuner_i2c_xfer_send(&priv->i2c_props, &addr_adc_sat, 1);
                        tuner_i2c_xfer_recv(&priv->i2c_props, &adc_sat, 1);
                        tuner_i2c_xfer_send(&priv->i2c_props, &addr_agc_stat, 1);
                        tuner_i2c_xfer_recv(&priv->i2c_props, &agc_stat, 1);
                        tuner_dbg("tda8290 is locked, AGC: %d\n", agc_stat);
                        break;
                } else {
                        tuner_dbg("tda8290 not locked, no signal?\n");
                        msleep(100);
                }
        }
        /* adjust headroom resp. gain */
        if ((agc_stat > 115) || (!(pll_stat & 0x80) && (adc_sat < 20))) 
...

<--  snip  -->

When we got four times "tda8290 not locked, no signal?" the variables 
agc_stat and adc_sat are used uninitialized here.

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

