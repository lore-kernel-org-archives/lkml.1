Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966817Ab0B0BYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 20:24:43 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:21508 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966797Ab0B0BYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 20:24:42 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
To: David Miller <davem@davemloft.net>
Cc: Octavian Purdila <opurdila@ixiacom.com>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <amwang@redhat.com>
Subject: [net-next PATCH v6 0/3] net: reserve ports for applications using fixed port numbers
Date: Sat, 27 Feb 2010 03:25:49 +0200
Message-Id: <1267233952-5856-1-git-send-email-opurdila@ixiacom.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 27 Feb 2010 01:24:40.0615 (UTC) FILETIME=[A2421370:01CAB74B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports which
allows users to reserve ports for third-party applications.

The reserved ports will not be used by automatic port assignments
(e.g. when calling connect() or bind() with port number 0). Explicit
port allocation behavior is unchanged.

Changes from the previous version:
- be more strict on accepted input (only comma separators, no spaces allowed)
- add to the docs a paragraph about ip_local_port_range and
  ip_local_reserved_ports relationship
- fix a few corner cases with parsing

There are still some miss behaviors with regard to proc parsing in odd
invalid cases (for "40000\0-40001" all is acknowledged but only 40000
is accepted) but they are not easy to fix without changing the current
"acknowledge how much we accepted" behavior.

Because of that and because the same issues are present in the
existing proc_dointvec code as well I don't think its worth holding
the actual feature (port reservation) after such petty error recovery
issues.

For the sake of discussion, I think Eric was right: the model we are
using is messy, we should only accept all input or none. If we can
(ABI implications) and you think its worth switching to this model I
can give it a try in a future patch.

Octavian Purdila (3):
  sysctl: refactor integer handling proc code
  sysctl: add proc_do_large_bitmap
  net: reserve ports for applications using fixed port numbers

 Documentation/networking/ip-sysctl.txt |   31 ++
 drivers/infiniband/core/cma.c          |    7 +-
 include/linux/sysctl.h                 |    2 +
 include/net/ip.h                       |    6 +
 kernel/sysctl.c                        |  504 ++++++++++++++++++++++----------
 net/ipv4/af_inet.c                     |    8 +-
 net/ipv4/inet_connection_sock.c        |    6 +
 net/ipv4/inet_hashtables.c             |    2 +
 net/ipv4/sysctl_net_ipv4.c             |   17 +
 net/ipv4/udp.c                         |    3 +-
 net/sctp/socket.c                      |    2 +
 11 files changed, 431 insertions(+), 157 deletions(-)

