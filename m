Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZFNJaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZFNJaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZFNJ35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:29:57 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:53682 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbZFNJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:29:56 -0400
X-Trace: 214934144/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.10.55/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.10.55
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmYFADJgNEpPRQo3/2dsb2JhbACBT88nhA0F
X-IronPort-AV: E=Sophos;i="4.42,217,1243810800"; 
   d="scan'208";a="214934144"
Date: Sun, 14 Jun 2009 10:28:59 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric Lammerts <eric@lammerts.org>
cc: kernel list <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       netdev@vger.kernel.org
Subject: Re: 2.6.30: tun losing ip
In-Reply-To: <4A348824.1030503@lammerts.org>
Message-ID: <Pine.LNX.4.64.0906141015130.11221@sister.anvils>
References: <4A348824.1030503@lammerts.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Eric Lammerts wrote:
> 
> Hi,
> I'm having problems with openvpn clients on 2.6.30. I get stuff like this:
> 
> TUN/TAP device tun0 opened
> TUN/TAP TX queue length set to 100
> /sbin/ifconfig tun0 10.2.222.50 pointopoint 10.2.222.49 mtu 1500
> /sbin/route add -net 10.2.222.0 netmask 255.255.255.0 gw 10.2.222.49
> SIOCADDRT: No such process
> 
> There is something strange going on with tun devices:
> 
> # tunctl -t tun1; ifconfig tun1 1.2.3.4; ifconfig tun1; sleep 1; ifconfig tun1
> Set 'tun1' persistent and owned by uid 0
> tun1      Link encap:Ethernet  HWaddr 1E:EF:79:F2:D9:67
>           inet addr:1.2.3.4  Bcast:1.255.255.255  Mask:255.0.0.0
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:500
>           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
> 
> tun1      Link encap:Ethernet  HWaddr 1E:EF:79:F2:D9:67
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:1 overruns:0 carrier:0
>           collisions:0 txqueuelen:500
>           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
> 
> First you see the ip, then you don't...
> 
> I traced it back to this commit:
> 
> $ git-bisect bad
> 05f54c13cd0c33694eec39a265475c5d6cf223cf is first bad commit
> commit 05f54c13cd0c33694eec39a265475c5d6cf223cf
> Author: Hugh Dickins <hugh@veritas.com>
> Date:   Thu Apr 16 21:55:29 2009 +0100
> 
>     Revert "kobject: don't block for each kobject_uevent".
> 
> If I take 2.6.30 and revert that commit, the problem goes away.

I'm mortified!  But it's rather odd, that's just a straight reversion
of an earlier, clearly buggy commit: I guess you have some other issue,
which reverting to a wait here now uncovers.

One likely workaround: I suspect your .config says something like
CONFIG_UEVENT_HELPER_PATH=/sbin/hotplug, but you've no /sbin/hotplug?
Please try changing that to CONFIG_UEVENT_HELPER_PATH="", and see if
the problem comes up with that resulting kernel.

But though that should be a good workaround, it doesn't shed light
on your underlying problem.  Sorry, I've no hope of helping with
ip/tun/tap questions - Cc'ed netdev.

Hugh
