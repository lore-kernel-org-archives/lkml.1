Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbXJSM5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbXJSM5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759789AbXJSM4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:56:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:48122 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759609AbXJSM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:56:40 -0400
Date: Fri, 19 Oct 2007 14:57:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: sound/pci/hda/patch_via.c: array overflow
Message-ID: <20071019125709.GZ3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sound/pci/hda/patch_via.c contains the following code:

<--  snip  -->

...
struct via_spec {
...
        hda_nid_t private_dac_nids[4];  
...                               ^^^
};
...
static int vt1709_auto_fill_dac_nids(struct via_spec *spec,
                                     const struct auto_pin_cfg *cfg)
{
...
       spec->multiout.dac_nids = spec->private_dac_nids;

        if (cfg->line_outs == 4) { /* 10 channels */   <------------------
                for (i = 0; i < cfg->line_outs; i++) {
                        nid = cfg->line_out_pins[i];
                        if (nid) {
                                /* config dac list */
                                switch (i) {
                                case AUTO_SEQ_FRONT:
                                        /* AOW0 */
                                        spec->multiout.dac_nids[i] = 0x10;
                                        break;
                                case AUTO_SEQ_CENLFE:
                                        /* AOW2 */
                                        spec->multiout.dac_nids[i] = 0x12;
                                        break;
                                case AUTO_SEQ_SURROUND:
                                        /* AOW3 */
                                        spec->multiout.dac_nids[i] = 0x27;
                                        break;
                                case AUTO_SEQ_SIDE:
                                        /* AOW1 */
                                        spec->multiout.dac_nids[i] = 0x11;
                                        break;
                                default:
                                        break;
                                }
                        }
                }
                spec->multiout.dac_nids[cfg->line_outs] = 0x28; /* AOW4 */
...                                     ^^^^^^^^^^^^^^

<--  snip  -->

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

