Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYERM6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYERM6B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYERM5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:57:51 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:33226 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbYERM5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:57:50 -0400
Date: Sun, 18 May 2008 14:57:15 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Message-ID: <20080518125715.GA19229@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series fixes hibernate/wake-on-lan for my
System (Asus M2N-SLI Deluxe, Dual MCP55 Gigabit Ethernet).

See also http://bugzilla.kernel.org/show_bug.cgi?id=8381
"(net forcedeth) doesn't wol on suspend".

Note that so far this is only tested on my system with hibernate
using the 'shutdown' method.

The local setup combines the two onboard nforce gigabit interfaces
eth0 and eth1 into a bridge br0, so it doesn't matter which port I
plug the cable into.  The bridging means eth0 and eth1 normally
operate in promiscous mode.

The initial situation (unpatched driver) was as follows:
After a normal boot, turning on wol and sending the system into
hibernate, waking it up with etherwake works as expected.
However, after waking up (be it via wol or via manual poweron)
from hibernate network connectivity is down.

This is because 1) the mac address is now swapped and 2) promiscous
mode is not restored.

The first patch addresses 2)

After this patch wake-on-lan stops working, since in 'shutdown' mode
the suspend callback of the device does not get called again before
poweroff and promiscous mode is apparently incompatible with wol.

So the second patch introduces a shutdown handler, which prepares
the device for wake-on-lan before the system is powered off.

Now waking the system up works again, but the 'swapped mac' problem
is still there.

The reason for this is that in my case the MCP55 is not flagged as
'DEV_HAS_CORRECT_MACADDR' and 'NVREG_TRANSMITPOLL_MAC_ADDR_REV' is
not set by the bios, so in nv_probe during the initial loading of
the driver the MAC address is read in reversed order and
NVREG_TRANSMITPOLL_MAC_ADDR_REV is set.
However during hibernate the device configuration space is lost
(reset do BIOS defaults) and so we get the reversed MAC again, but
resume unconditionally sets NVREG_TRANSMITPOLL_MAC_ADDR_REV, which
means we now have effectively swapped the MAC.

The third patch fixes this by saving and restoring the
configuration space between suspend and resume.

The fourth (optional) patch reorders the code in suspend/resume to
match the order in e100/e1000e more closely, since I think the
latter order is more correct.
For example the configuration space should be saved on suspend even
for devices that are not up.

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
