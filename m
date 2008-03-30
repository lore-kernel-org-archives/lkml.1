Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbYC3WDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbYC3WDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYC3WDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:03:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbYC3WDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:03:02 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Deomid Ryabkov <myself@rojer.pp.ru>
Subject: Re: Send-Q on UDP socket growing steadily - why?
Date: Mon, 31 Mar 2008 00:01:18 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <47EF2890.9010704@rojer.pp.ru>
In-Reply-To: <47EF2890.9010704@rojer.pp.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803310001.18120.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 March 2008 07:43, Deomid Ryabkov wrote:
> This has started recently and i'm at a loss as to why.
> Send-Q on a moderately active UDP socket keeps growing steadily until it 
> reaches ~128K (wmem_max?) at which point socket writes start failing.
> The application in question is standard ntpd from Fedora 7, kernel is 
> the latest available for the distro, that is
> 2.6.23.15-80.fc7 #1 SMP Sun Feb 10 16:52:18 EST 2008 x86_64
> 
> BIND, running on the same machine, does not exhibit this problem, but 
> that may be because it does not get nearly as much load as ntpd,
> which is part of the pool.ntp.org. That said, load is really not very 
> high, on the order of 10 QPS, and machine is 99+% idle.
> ntpd seems to be doing its usual select-recvmsg-sendto routine, nothing 
> out of the ordinary.

Wher does it (tries to) send these packets?

I managed to reproduced something like this if I try to send
UDPs to nonexistent host on local subnet. Kernel tries to find it,
it emits ARP probes but no reply is coming. As long as kernel
doesn't know how to send queued UDP packet, I see nonempty
queue.

However, in my simple case kernel decides that it is a lost case
in a few seconds, and drops packets (queue len 0).

I imagine whit routing table tricks and/or iptables/arptables
you may end up with situation where kernel is stuck in
"I don't know how to send these packets" mode forever.

You can strace ntpd, get a list of IPs it is trying to send packets
to, and then do "echo TEST | nc -u <ip> 123" for each of these.
will nc's queue become nonempty (at least for some IP)?
--
vda
