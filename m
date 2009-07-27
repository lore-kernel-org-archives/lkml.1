Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZG0Pb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZG0Pb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZG0Pb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:31:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52138 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZG0PbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:31:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=fAg3ouPGPP/jFeGpenqki4803ecVjG4pp0m7FbLy12l7yRtN5+9RT4MNXWg1DI4Ob
	ro5KGUNgMgsrawxEiSF+A==
Subject: [RFC][PATCH 0/5] IPVS full NAT support + netfilter 'ipvs' match support
To: lvs-devel@vger.kernel.org
From: Hannes Eder <heder@google.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 27 Jul 2009 15:46:11 +0200
Message-ID: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is aiming at adding full NAT support to IPVS.  The
approach is via a minimal change to IPVS (make friends with nf_conntrack)
and adding a netfilter matcher (xt_ipvs + libxt_ipvs).

Example usage:

% ipvsadm -A -t 192.168.100.30:8080 -s rr
% ipvsadm -a -t 192.168.100.30:8080 -r 192.168.10.20:8080 -m
# ...

# SNAT for VIP 192.168.100.30:8080
% iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 --vport 8080 \
> -j SNAT --to-source 192.168.10.10 

Comments?

Changes to the linux kernel:

Hannes Eder (4):
      IPVS: debugging output for ip_vs_update_conntrack
      IPVS: make friends with nf_conntrack
      netfilter: xt_ipvs (netfilter matcher for ipvs)
      IPVS: prefix EnterFunction and LeaveFunction msg with "IPVS:"

 include/linux/netfilter/xt_ipvs.h |   32 +++++++
 include/net/ip_vs.h               |   24 +++--
 net/netfilter/Kconfig             |    8 ++
 net/netfilter/Makefile            |    1 
 net/netfilter/ipvs/ip_vs_core.c   |   36 --------
 net/netfilter/ipvs/ip_vs_proto.c  |    1 
 net/netfilter/ipvs/ip_vs_xmit.c   |   54 ++++++++++++
 net/netfilter/xt_ipvs.c           |  171 +++++++++++++++++++++++++++++++++++++
 8 files changed, 279 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ipvs.h
 create mode 100644 net/netfilter/xt_ipvs.c


Changes to iptables:

Hannes Eder (1):
      libxt_ipvs: user space lib for netfilter matcher xt_ipvs

 extensions/libxt_ipvs.c           |  350 +++++++++++++++++++++++++++++++++++++
 extensions/libxt_ipvs.man         |    7 +
 include/linux/netfilter/xt_ipvs.h |   32 +++
 3 files changed, 389 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_ipvs.c
 create mode 100644 extensions/libxt_ipvs.man
 create mode 100644 include/linux/netfilter/xt_ipvs.h


Cheers,
-Hannes
