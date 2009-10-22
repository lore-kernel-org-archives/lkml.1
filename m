Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZJVRQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZJVRQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 13:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbZJVRQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:16:48 -0400
Received: from mail-yx0-f153.google.com ([209.85.210.153]:48904 "EHLO
	mail-yx0-f153.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZJVRQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:16:48 -0400
MIME-Version: 1.0
Date: Thu, 22 Oct 2009 09:31:22 -0700 (PDT)
In-Reply-To: <fa.m+C2fWYS5YaBJWumU8brEOeSqVA@ifi.uio.no>
X-IP: 64.126.182.14
References: <fa.m+C2fWYS5YaBJWumU8brEOeSqVA@ifi.uio.no>
User-Agent: G2/1.0
X-HTTP-Via: 1.1 webwasher (Webwasher 6.8.5.5330)
X-HTTP-UserAgent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.3) 
	Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729),gzip(gfe),gzip(gfe)
Message-ID: <23b20494-1cea-41b6-a6ae-2b5f21fe5db8@g1g2000pra.googlegroups.com>
Subject: Problem with MDI/MDI-X auto-switching in E100 driver
From: Eugene Bordenkircher <eugebo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




---------- Forwarded message ----------
From: "Eugene T. Bordenkircher" <eug...@gmail.com>
Date: Oct 22, 8:39 am
Subject: Problem with MDI/MDI-X auto-switching in E100 driver
To: fa.linux.kernel


Around line 1466 of e100.c (git master) is the following code to turn
on
MDI/MDI-X auto-switching if it is not already.

         } else if ((nic->mac >= mac_82550_D102) || ((nic->flags &
ich) &&
             (mdio_read(netdev, nic->mii.phy_id, MII_TPISTATUS) &
0x8000) &&
                  !(nic->eeprom[eeprom_cnfg_mdix] &
eeprom_mdix_enabled))) {
                  /* enable/disable MDI/MDI-X auto-switching. */
                  mdio_write(netdev, nic->mii.phy_id, MII_NCONFIG,
                                  nic->mii.force_media ? 0 :
NCONFIG_AUTO_SWITCH);
         }

This code is broken in the case where an 8255x is used without
magnetics.  Per
Intel Application note 435, without the magnetics, auto switching is
not
possible.  The only way to turn this off without driver modifications
is to set
the force_media flag via ethtool, which has the side effect of turning
off all
auto-negotiation. This happens to be the case on a product I am
currently
working on.

It seems a better solution to this is to trust the eeprom's
configuration
rather than override it.  Am I missing something or does this sound
reasonable?

Eugene T. Bordenkircher
--
To unsubscribe from this list: send the line "unsubscribe linux-
kernel" in
the body of a message to majord...@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
