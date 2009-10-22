Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZJVPjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZJVPjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbZJVPjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:39:15 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57543 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbZJVPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=GComwY8M1TVarEKfH29fEIRHSgRiQoyUVNsHYqdvZtfRkCj2LdPEMMA50bNEbT0OBN
         Nw9gjza5jtBcYpkXSVwvA6KTQgbkaOFwpOeVvBAiZtOLvSeR2xGv7UXVcDZ3h2UuZuOa
         beB7eZLaP3+PHciKN/7j3JcX4ytAv27itczNs=
Message-ID: <4AE07C90.2080901@gmail.com>
Date: Thu, 22 Oct 2009 08:38:56 -0700
From: "Eugene T. Bordenkircher" <eugebo@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: linux.nics@intel.com
Subject: Problem with MDI/MDI-X auto-switching in E100 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around line 1466 of e100.c (git master) is the following code to turn on 
MDI/MDI-X auto-switching if it is not already.

         } else if ((nic->mac >= mac_82550_D102) || ((nic->flags & ich) &&
             (mdio_read(netdev, nic->mii.phy_id, MII_TPISTATUS) & 0x8000) &&
                  !(nic->eeprom[eeprom_cnfg_mdix] & eeprom_mdix_enabled))) {
                  /* enable/disable MDI/MDI-X auto-switching. */
                  mdio_write(netdev, nic->mii.phy_id, MII_NCONFIG,
                                  nic->mii.force_media ? 0 : NCONFIG_AUTO_SWITCH);
         }

This code is broken in the case where an 8255x is used without magnetics.  Per 
Intel Application note 435, without the magnetics, auto switching is not 
possible.  The only way to turn this off without driver modifications is to set 
the force_media flag via ethtool, which has the side effect of turning off all 
auto-negotiation. This happens to be the case on a product I am currently 
working on.

It seems a better solution to this is to trust the eeprom's configuration 
rather than override it.  Am I missing something or does this sound reasonable?

Eugene T. Bordenkircher
