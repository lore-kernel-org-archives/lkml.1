Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652Ab0AJO6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0AJO6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447Ab0AJO6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:58:32 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:60054 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab0AJO6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:58:31 -0500
X-Greylist: delayed 1830 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 09:58:31 EST
Date: Sun, 10 Jan 2010 15:28:01 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.32.x socket(PF_INET6 hangs when ipv6 not yet initialized
Message-ID: <20100110142800.GA9855@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem when booting a Debian system (with a locally built
2.6.32.x kernel (x=1,2,3)) in virtualbox. I haven't yet tried to
reproduce this on a real machine.

Scenario A:
  - 2.6.32.x kernel
  - ipv6 as a module
  - sshd started from an init script
  - host system sniffing on the guest's network interface
  - dhcp client is started, dhcpv4 exchange visible on the network
  - _NO_ ipv6 negotiation visible on the network
  - system boot stops right at the sshd invocation. Ctrl-C results in
    "^C" being written to the console, other input is written to the
    console and ignored, no possibility to interact with the system as
    there are no gettys running yet

Scenario B:
  - As Scenario A, with an identically configured 2.6.31.6 kernel
  - sshd starts, after that, the ipv6 negotiation is visible on the
    network, then system boot completes as designed

Scenario C:
  - As Scenario A, with ipv6 blacklisted in /etc/modprobe.d/local.conf
  - system boot completes as designed

Scenario D:
  - As Scenario A, with a "sleep 10" in ssh's init script before the
    sshd invocation
  - ipv6 negotiation is visible after the DHCPv4 transaction, while
    the sshd init script sleeps
  - after that, system boot completes as designed

Scenario E:
  - As Scenario A, with the sshd invocation in the ssh init script
    replaced by
    timeout --signal=9 30 strace -f -o /var/tmp/strace.sshd /usr/sbin/sshd -d
  - System stops before a single line of sshd's debug output is
    written, after the timeout command killed strace and sshd, system
    boot completes. The --signal=9 is needed, just asking timeout to
    send a SIGTERM doesn't make the system complete its boot. A
    meaningful strace ending in
    socket(PF_INET6, SOCK_DGRAM, IPPROTO_IP
    [note the missing closing parenthesis] is found in
    /var/tmp/strace.sshd.

Scenario F:
  - As Scenario E, with kernel 2.6.31.6
  - sshd comes up with full debugging output written to the console,
    and one is able to actually ssh in before the sshd is killed by the
    timeout. The strace after the socket(PF_INET6 call continues as
    socket(PF_INET6, SOCK_DGRAM, IPPROTO_IP) = 3
    connect(3, {sa_family=AF_INET6, sin6_port=htons(22), inet_pton(AF_INET6, "::", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, 28) = 0
    getsockname(3, {sa_family=AF_INET6, sin6_port=htons(48854), inet_pton(AF_INET6, "::1", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [28]) = 0
    connect(3, {sa_family=AF_UNSPEC, sa_data="\0\0\0\0\0\0\0\0\0\0\0\0\0\0"}, 16) = 0
    connect(3, {sa_family=AF_INET, sin_port=htons(22), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
    getsockname(3, {sa_family=AF_INET6, sin6_port=htons(37777), inet_pton(AF_INET6, "::ffff:127.0.0.1", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [28]) = 0
    close(3)                          = 0

The stunt with the timeout sshd -d is needed to get a meaningful
strace _and_ the possibility to log in afterwards, sshd forking and
backgrounding itself confuses strace otherwise.

This looks to me that a 2.6.32.x kernel gets confused when an
appliation tries to create an IPv6 socket before IPv6 was fully
initializes. This is a regression compared to 2.6.31.6, where this
behavior was just fine and resulted in an operational system. The fact
that the sshd doesn't react to SIGTERM when wedged in this situation
makes me suspect that there is something wedged in kernel space which
only a SIGKILL can unwedge.

I'll work around this issue with a sleep 10 for the time being, but am
prepared to debug (or to send out the virtualbox virtual machine) if
you need more information.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
