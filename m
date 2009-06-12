Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZFLSr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZFLSr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbZFLSrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:47:41 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:46109 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469AbZFLSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:47:41 -0400
Message-ID: <4A32A1E4.8080708@oracle.com>
Date: Fri, 12 Jun 2009 11:43:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: -git tree build failure in drivers/net/cnic.c: undefined reference
 to `ip6_route_output'
References: <20090612184343.GA11900@elte.hu>
In-Reply-To: <20090612184343.GA11900@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A32A2B9.022C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> today's -git fails to build with ipv6 disabled (x86):
> 
>   drivers/built-in.o: In function `cnic_get_v6_route':
>   cnic.c:(.text+0x104c42): undefined reference to `ip6_route_output'
> 
> introduced by this new driver:
> 
>   a463696: [SCSI] cnic: Add new Broadcom CNIC driver.

I just posted a patch for this to netdev and it was acked by its maintainer.
Patch is below.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix cnic build for case of CONFIG_INET=n.
Fix cnic build for case of CONFIG_IPV6=m and CONFIG_CNIC=y.

Fixes these build errors:

cnic.c:(.text+0x236a1d): undefined reference to `ip_route_output_key'
cnic.c:(.text+0x15a8e8): undefined reference to `ip6_route_output'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/cnic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-next-20090612.orig/drivers/net/cnic.c
+++ linux-next-20090612/drivers/net/cnic.c
@@ -1454,6 +1454,7 @@ static inline u16 cnic_get_vlan(struct n
 static int cnic_get_v4_route(struct sockaddr_in *dst_addr,
 			     struct dst_entry **dst)
 {
+#if defined(CONFIG_INET)
 	struct flowi fl;
 	int err;
 	struct rtable *rt;
@@ -1465,12 +1466,15 @@ static int cnic_get_v4_route(struct sock
 	if (!err)
 		*dst = &rt->u.dst;
 	return err;
+#else
+	return -ENETUNREACH;
+#endif
 }
 
 static int cnic_get_v6_route(struct sockaddr_in6 *dst_addr,
 			     struct dst_entry **dst)
 {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MODULE))
 	struct flowi fl;
 
 	memset(&fl, 0, sizeof(fl));
@@ -1550,7 +1554,7 @@ static int cnic_get_route(struct cnic_so
 	clear_bit(SK_F_IPV6, &csk->flags);
 
 	if (is_v6) {
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || (defined(CONFIG_IPV6_MODULE) && defined(MODULE))
 		set_bit(SK_F_IPV6, &csk->flags);
 		err = cnic_get_v6_route(&saddr->remote.v6, &dst);
 		if (err)
