Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917Ab0ARStq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0ARStq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885Ab0ARStp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:49:45 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50310 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab0ARSto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:49:44 -0500
Date: Mon, 18 Jan 2010 19:49:42 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Julia Lawall <julia@diku.dk>
Subject: mcs7830 usb net: "scheduling while atomic" danger?
Message-ID: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

drivers/net/usb/mcs7830.c does several:

        mutex_lock(&dev->phy_mutex);
        /* write the MII command */
        ret = mcs7830_set_reg(dev, HIF_REG_PHY_CMD1, 2, cmd);
        if (ret < 0)
                goto out;

        /* wait for the data to become valid, should be within < 1ms */
        for (i = 0; i < 10; i++) {
                ret = mcs7830_get_reg(dev, HIF_REG_PHY_CMD1, 2, cmd);
                if ((ret < 0) || (cmd[1] &
HIF_REG_PHY_CMD2_READY_FLAG_BIT))
                        break;
                ret = -EIO;
                msleep(1);
        }


Forgive me, but doesn't that mutex_lock()/msleep() (ab)use mean
risking a "scheduling while atomic"?
(such as discussed in e.g.
http://search.luky.org/linux-kernel.2004/msg92817.html )


And, if that is the case, shouldn't all such cases simply be killed for
good via a capable semantic patch?

Thanks,

Andreas Mohr
