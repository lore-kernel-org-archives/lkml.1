Return-Path: <linux-kernel-owner+w=401wt.eu-S965154AbXCAPDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbXCAPDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965158AbXCAPDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:03:46 -0500
Received: from ajx114.rev.netart.pl ([85.128.128.114]:34704 "EHLO
	tech.serwery.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154AbXCAPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:03:46 -0500
X-Greylist: delayed 2072 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 10:03:45 EST
Date: Thu, 1 Mar 2007 15:29:11 +0100
From: NetArt - Grzegorz Nosek <grzegorz.nosek@netart.pl>
To: linux-kernel@vger.kernel.org
Subject: Very slow routing table modification if RTA_FLOW is set
Message-ID: <20070301142911.GA8187@tech.serwery.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have noticed that using realm patch for quagga
<http://vcalinus.gemenii.ro/quaggarealms.html> causes the kernel to
spend a lot more time processing rtnetlink messages.

If routes added to the kernel are not tagged with a realm number, the
time from sending a netlink cmd to receiving an ack is mostly stable
at several dozen microseconds or less.

However, if I add route tagging with 'neighbor X.X.X.X realm
origin-as', the time spent in kernel:
1. seems to increase with the numer of FIB entries
2. is much more jittery

The net result is that after adding about 100k routes, the time between
cmd and ack is usually around 4 _milli_seconds, but sometimes the
route is added immediately (i.e. after 20 us or so), just like when
the table is nearly empty. Overall, the process of receiving a full
routing table slows down from a minute to about 11.

The kernel is 2.6.18.6. I have tried using both FIB_HASH and FIB_TRIE.
I'll try to collect dome results from oprofile next and if anything
pops out at me, I'll let you know.

The core of the quagga patch with regard to the kernel is:

  if (rib->realmto)
      addattr32 (&req.n, sizeof req, RTA_FLOW, rib->realmto);

while constructing the netlink packet.

Is this a known problem? Can anything be done about it?

Please CC as I'm not subscribed to the list.

Best regards,
 Grzegorz Nosek

