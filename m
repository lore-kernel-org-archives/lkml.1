Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYLHGbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYLHGbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 01:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYLHGbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 01:31:10 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:55509 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYLHGbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 01:31:09 -0500
X-Greylist: delayed 2064 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 01:31:09 EST
Message-ID: <493CB716.8070300@yucs.org>
Date: Mon, 08 Dec 2008 00:56:38 -0500
From: Shaya Potter <spotter@yucs.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: weird realtek gigabit ethernet issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please cc me in any response as not subscribed]

I have an Asus M3A78-EM motherboard with a "Realtek Semiconductor Co.,
Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)"
(per lspci)

which is using the r8169 module on ubuntu intrepid (specifically ubuntu
kernel 2.6.27-9-generic)

kernel reports

RTL8168c/8111c at 0xf88be000, 00:22:15:a1:d2:41, XID 3c4000c0 IRQ 222

well, what's the issue, its going crazy on the dropped packets, even
when the only thing connected to it is is an ssh session.

namely ifconfig shows

eth0 Link encap:Ethernet HWaddr 00:22:15:a1:d2:41
inet addr:192.168.0.41 Bcast:192.168.0.255 Mask:255.255.255.0
inet6 addr: fe80::222:15ff:fea1:d241/64 Scope:Link
UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
RX packets:499 errors:0 dropped:2867537736 overruns:0 frame:0
TX packets:538 errors:0 dropped:0 overruns:0 carrier:0
collisions:0 txqueuelen:1000
RX bytes:38995 (38.9 KB) TX bytes:87571 (87.5 KB)
Interrupt:222 Base address:0xe000

and the dropped count keeps on cycling through its entire space rapidly.

it's running in gigabit mode

root@nas:/home/spotter# mii-tool
eth0: negotiated 1000baseT-FD flow-control, link ok

I have no idea why.  never seen anything like this before.  been
wondering what could be doing it.

in investigating the driver

/*
 * The driver does not support incoming fragmented
 * frames. They are seen as a symptom of over-mtu
 * sized frames.
 */
if (unlikely(rtl8169_fragmented_frame(status))) {
 	dev->stats.rx_dropped++;
        dev->stats.rx_length_errors++;
        rtl8169_mark_to_asic(desc, tp->rx_buf_sz);
        continue;
}

so it would appear to be some issue relating to fragmented frames.

However, based on the amount of packets received, it seems to be very
strange.

I would have thought maybe it had something to do with jumbo packets,
but all the machines on the net are using an mtu of 1500 currently.

anyways, any explanation, if its not a bug, would be appreciated.
