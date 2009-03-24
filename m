Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZCXW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZCXW6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZCXW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:58:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37294
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbZCXW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:58:09 -0400
Date: Tue, 24 Mar 2009 15:57:56 -0700 (PDT)
Message-Id: <20090324.155756.214460004.davem@davemloft.net>
To: Matt_Domsch@dell.com
Cc: netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090324154617.GA16332@auslistsprd01.us.dell.com>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Domsch <Matt_Domsch@dell.com>
Date: Tue, 24 Mar 2009 10:46:17 -0500

> Problem: Users expect on-motherboard NICs to be named eth0..ethN.
> This can be difficult to achieve.

I learned a long time ago that eth0 et al. have zero meaning.

If the system firmware folks gave us topology information with respect
to these things, we could export something that tools such as
NetworkManager, iproute2, etc. could use.

For example, if we were told that PCI device "domain:bus:dev:fn" has
string label "Onboard Ethernet 0" then we could present that to the
user.

Changing how the actual network device name is determined is going to
have zero traction.

So, please, put mapping tables into the ACPI or similar and then
programs can go:

	for_each_network_device(name) {
		fd = open(name);
		label = get_system_label(fd, name);
		present_to_user(label, name);
	}

This "get_system_label()" thing can be an ethtool ioctl, some
rtnetlink call, or similar.  In the kernel, a generic routine would
exist for major bus types to make the mapping translation, and drivers
would call these.

For PCI it might take the PCI device pointer and try to fish
out a string from the ACPI layer.

For OpenFirmware we might just simply give the full device path,
or a matching device alias name.

That's the only model which allows a smooth transition and
no major infrastructure changes.

I guess it's easier to spew about MAC addresses and other
irrelevant topics than try to solve this problem properly. :-)
