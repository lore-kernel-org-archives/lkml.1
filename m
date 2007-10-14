Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbXJNRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbXJNRxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbXJNRvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:51:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35258 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758644AbXJNRvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:51:12 -0400
Date: Sun, 14 Oct 2007 19:51:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: mb@bu3sch.de, st3@riseup.net, Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: b43{,legacy}_start can return uninitialized value
Message-ID: <20071014175142.GN4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/wireless/b43/main.c:b43_start() consists of the
following code:

<--  snip -->

static int b43_start(struct ieee80211_hw *hw)
{
        struct b43_wl *wl = hw_to_b43_wl(hw);
        struct b43_wldev *dev = wl->current_dev;
        int did_init = 0;
        int err;

        mutex_lock(&wl->mutex);

        if (b43_status(dev) < B43_STAT_INITIALIZED) {
                err = b43_wireless_core_init(dev);
                if (err)
                        goto out_mutex_unlock;
                did_init = 1;
        }

        if (b43_status(dev) < B43_STAT_STARTED) {
                err = b43_wireless_core_start(dev);
                if (err) {
                        if (did_init)
                                b43_wireless_core_exit(dev);
                        goto out_mutex_unlock;
                }
        }

 out_mutex_unlock:
        mutex_unlock(&wl->mutex);

        return err;
}

<--  snip  -->


If (b43_status(dev) == B43_STAT_STARTED) this function returns the value 
of an uninitialized variable.

drivers/net/wireless/b43legacy/main.c:b43legacy_start() has the same 
issue.

Spotted by the Coverity checker.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

