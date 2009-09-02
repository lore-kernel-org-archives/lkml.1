Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbZIBOir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbZIBOir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZIBOir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:38:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45187 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZIBOip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:38:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:cc:cc:cc:cc:cc:cc:cc:cc:cc:cc:cc:cc:from:
	message-id:user-agent:mime-version:content-type:
	content-transfer-encoding:date:x-system-of-record;
	b=au845RxgVAnJKt2/m/Ds6AHCGAGJTb5WKJ3cWBLhxdcXS3uQWckrK8FaREjZAEUQk
	c+FcfcT9/cPxBuDwpb1sw==
Subject: [PATCH 0/3] IPVS full NAT support + netfilter 'ipvs' match support
To: lvs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Cc: =?ISO-8859-1?Q?Fabien_Duch=EAne?= <mad_fab@skynet.be>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jean-Luc Fortemaison <jl.fortemaison@uclouvain.be>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Julius Volz <julius.volz@gmail.com>
Cc: Laurent Grawet <laurent.grawet@uclouvain.be>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Simon Horman <horms@verge.net.au>
Cc: Wensong Zhang <wensong@linux-vs.org>
From: Hannes Eder <heder@google.com>
Message-ID: <20090902101417.11561.45663.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.15-rc1-9-gd8846-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Date: Wed,  2 Sep 2009 16:38:12 +0200 (CEST)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements full NAT support for IPVS.  The
approach is via a minimal change to IPVS (make friends with
nf_conntrack) and adding a netfilter matcher, kernel- and user-space
part, i.e. xt_ipvs and libxt_ipvs.

Example usage:

% ipvsadm -A -t 192.168.100.30:8080 -s rr
% ipvsadm -a -t 192.168.100.30:8080 -r 192.168.10.20:8080 -m
# ...

# Source NAT for VIP 192.168.100.30:8080
% iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 --vport 8080 \
> -j SNAT --to-source 192.168.10.10


Changes to the linux kernel (rebased to next-20090831):

Hannes Eder (2):
      netfilter: xt_ipvs (netfilter matcher for IPVS)
      IPVS: make friends with nf_conntrack


 include/linux/netfilter/xt_ipvs.h |   23 +++++
 net/netfilter/Kconfig             |    9 ++
 net/netfilter/Makefile            |    1 
 net/netfilter/ipvs/Kconfig        |    2 
 net/netfilter/ipvs/ip_vs_core.c   |   36 -------
 net/netfilter/ipvs/ip_vs_proto.c  |    1 
 net/netfilter/ipvs/ip_vs_xmit.c   |   27 +++++
 net/netfilter/xt_ipvs.c           |  183 +++++++++++++++++++++++++++++++++++++
 8 files changed, 245 insertions(+), 37 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ipvs.h
 create mode 100644 net/netfilter/xt_ipvs.c


Changs to iptables:

Hannes Eder (1):
      libxt_ipvs: user space lib for netfilter matcher xt_ipvs


 configure.ac                      |   11 +
 extensions/libxt_ipvs.c           |  349 +++++++++++++++++++++++++++++++++++++
 extensions/libxt_ipvs.man         |   21 ++
 include/linux/netfilter/xt_ipvs.h |   23 ++
 4 files changed, 401 insertions(+), 3 deletions(-)
 create mode 100644 extensions/libxt_ipvs.c
 create mode 100644 extensions/libxt_ipvs.man
 create mode 100644 include/linux/netfilter/xt_ipvs.h

