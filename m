Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729Ab0AHKQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0AHKQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482Ab0AHKQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:16:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:17253 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0AHKQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:16:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=Vnr2HMvhqKHHIG/mHiJbtAfmLsDYiyp95pliWzGk4Vi+J2eH1zSyQfzdqBYgPHZIQl
         reMJY4KefbXZoySYcKTcxt1NWd3cemqRHdnrjpKUT1JMHAKV93xXJ5NL2Omdbdtw1ZJB
         h1XmCa429OWcQGfMfZvfbrFjvP+/j0dOMFKRU=
Message-ID: <4B470606.7090409@gmail.com>
Date: Fri, 08 Jan 2010 11:16:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: bonding: potential null dereference?
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at Stanse errors and it detected a suspected behaviour in
bonding. In bond_slave_netdev_event, bond_dev is passed down to
netdev_priv, but due to 'if (bond_dev)' test later, it deduced it can be
also NULL.

I can see, that passing NULL to netdev_priv is OK nowadays, as it just
returns NULL + some offset. But what if this changes in the future?

I would bake a patch, but I don't know if bond_dev may be NULL at all
(i.e. superfluous test) or may not (wrong netdev_priv(bond_dev)).

static int (unsigned long event,
                                   struct net_device *slave_dev)
{
        struct net_device *bond_dev = slave_dev->master;
        struct bonding *bond = netdev_priv(bond_dev);

        switch (event) {
        case NETDEV_UNREGISTER:
                if (bond_dev) {
                        if (bond->setup_by_slave)
                                bond_release_and_destroy(bond_dev,
slave_dev);
                        else
                                bond_release(bond_dev, slave_dev);
                }
                break;

-- 
js
