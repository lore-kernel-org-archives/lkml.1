Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbZFNFkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbZFNFkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 01:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZFNFkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 01:40:09 -0400
Received: from rrcs-71-43-195-114.se.biz.rr.com ([71.43.195.114]:41607 "EHLO
	mail.ultrawaves.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbZFNFkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 01:40:08 -0400
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jun 2009 01:40:07 EDT
X-Spam-Check-By: kermit
Message-ID: <4A348824.1030503@lammerts.org>
Date: Sun, 14 Jun 2009 01:18:28 -0400
From: Eric Lammerts <eric@lammerts.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: 2.6.30: tun losing ip
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I'm having problems with openvpn clients on 2.6.30. I get stuff like this:

TUN/TAP device tun0 opened
TUN/TAP TX queue length set to 100
/sbin/ifconfig tun0 10.2.222.50 pointopoint 10.2.222.49 mtu 1500
/sbin/route add -net 10.2.222.0 netmask 255.255.255.0 gw 10.2.222.49
SIOCADDRT: No such process

There is something strange going on with tun devices:

# tunctl -t tun1; ifconfig tun1 1.2.3.4; ifconfig tun1; sleep 1; ifconfig 
tun1
Set 'tun1' persistent and owned by uid 0
tun1      Link encap:Ethernet  HWaddr 1E:EF:79:F2:D9:67
           inet addr:1.2.3.4  Bcast:1.255.255.255  Mask:255.0.0.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:500
           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

tun1      Link encap:Ethernet  HWaddr 1E:EF:79:F2:D9:67
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:1 overruns:0 carrier:0
           collisions:0 txqueuelen:500
           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

First you see the ip, then you don't...

I traced it back to this commit:

$ git-bisect bad
05f54c13cd0c33694eec39a265475c5d6cf223cf is first bad commit
commit 05f54c13cd0c33694eec39a265475c5d6cf223cf
Author: Hugh Dickins <hugh@veritas.com>
Date:   Thu Apr 16 21:55:29 2009 +0100

     Revert "kobject: don't block for each kobject_uevent".


If I take 2.6.30 and revert that commit, the problem goes away.

Eric

