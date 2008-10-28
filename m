Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYJ1EH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYJ1EH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYJ1EGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:06:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:60758 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYJ1EGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EruxtVpA5na6elElUAIWWCFPAM08U2iwKNFqapEatb3zHyeVmv/YSo1tl/CNCkqcNl
         w+zOwigq3YXHYIljodSj6XasdQsoSfGinDIMGte4rqGTA9I/eAR7Fs/St/Ybgi0aqhg9
         dX+DbConAs/0qapjWRyHwPlp1gHUAXymcYL30=
Subject: [RFC PATCH 5/5] misc: Add other users of %p6, %#p6
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>, Joe Perches <joe@perches.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 21:05:19 -0700
Message-Id: <1225166719.5526.20.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/iscsi_tcp.c                   |    2 +-
 fs/cifs/cifs_spnego.c                      |    3 +-
 fs/lockd/host.c                            |    2 +-
 fs/nfs/super.c                             |    3 +-
 include/linux/sunrpc/svc_xprt.h            |    4 +-
 include/net/ip_vs.h                        |    4 +-
 include/net/netfilter/nf_conntrack_tuple.h |    6 ++--
 include/net/sctp/sctp.h                    |    4 +-
 net/netlabel/netlabel_addrlist.c           |    2 +-
 net/sctp/ipv6.c                            |   35 +++++++++++----------------
 net/sctp/sm_statefuns.c                    |    5 +--
 net/sunrpc/clnt.c                          |    4 +-
 net/sunrpc/rpcb_clnt.c                     |    6 ++--
 net/sunrpc/svcauth_unix.c                  |    5 +--
 net/sunrpc/xprtsock.c                      |   28 +++++++++------------
 net/xfrm/xfrm_policy.c                     |    6 +---
 net/xfrm/xfrm_state.c                      |   12 +++------
 security/selinux/avc.c                     |    2 +-
 18 files changed, 56 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ed6c54c..ef929ae 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1608,7 +1608,7 @@ static int iscsi_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
 	case AF_INET6:
 		sin6 = (struct sockaddr_in6 *)addr;
 		spin_lock_bh(&conn->session->lock);
-		sprintf(buf, NIP6_FMT, NIP6(sin6->sin6_addr));
+		sprintf(buf, "%p6", &sin6->sin6_addr);
 		*port = be16_to_cpu(sin6->sin6_port);
 		spin_unlock_bh(&conn->session->lock);
 		break;
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index fcee929..ae4be82 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -124,8 +124,7 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
 		sprintf(dp, "ip4=" NIPQUAD_FMT,
 			NIPQUAD(server->addr.sockAddr.sin_addr));
 	else if (server->addr.sockAddr.sin_family == AF_INET6)
-		sprintf(dp, "ip6=" NIP6_SEQFMT,
-			NIP6(server->addr.sockAddr6.sin6_addr));
+		sprintf(dp, "ip6=%#p6", &server->addr.sockAddr6.sin6_addr);
 	else
 		goto out;
 
diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index 9fd8889..344e6b4 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -122,7 +122,7 @@ static void nlm_display_address(const struct sockaddr *sap,
 			snprintf(buf, len, NIPQUAD_FMT,
 				 NIPQUAD(sin6->sin6_addr.s6_addr32[3]));
 		else
-			snprintf(buf, len, NIP6_FMT, NIP6(sin6->sin6_addr));
+			snprintf(buf, len, "%p6", &sin6->sin6_addr);
 		break;
 	default:
 		snprintf(buf, len, "unsupported address family");
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index f48db67..5fe7721 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -468,8 +468,7 @@ static void nfs_show_mountd_options(struct seq_file *m, struct nfs_server *nfss,
 	}
 	case AF_INET6: {
 		struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)sap;
-		seq_printf(m, ",mountaddr=" NIP6_FMT,
-				NIP6(sin6->sin6_addr));
+		seq_printf(m, ",mountaddr=%p6", &sin6->sin6_addr);
 		break;
 	}
 	default:
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 6fd7b01..42e01c9 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -145,8 +145,8 @@ static inline char *__svc_print_addr(struct sockaddr *addr,
 		break;
 
 	case AF_INET6:
-		snprintf(buf, len, "%x:%x:%x:%x:%x:%x:%x:%x, port=%u",
-			NIP6(((struct sockaddr_in6 *) addr)->sin6_addr),
+		snprintf(buf, len, "%p6, port=%u",
+			 &((struct sockaddr_in6 *)addr)->sin6_addr,
 			ntohs(((struct sockaddr_in6 *) addr)->sin6_port));
 		break;
 
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index fe9fcf7..6a66920 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -87,8 +87,8 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
 	int len;
 #ifdef CONFIG_IP_VS_IPV6
 	if (af == AF_INET6)
-		len = snprintf(&buf[*idx], buf_len - *idx, "[" NIP6_FMT "]",
-			       NIP6(addr->in6)) + 1;
+		len = snprintf(&buf[*idx], buf_len - *idx, "[%p6]",
+			       &addr->in6) + 1;
 	else
 #endif
 		len = snprintf(&buf[*idx], buf_len - *idx, NIPQUAD_FMT,
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index a6874ba..303efaf 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -122,10 +122,10 @@ static inline void nf_ct_dump_tuple_ip(const struct nf_conntrack_tuple *t)
 static inline void nf_ct_dump_tuple_ipv6(const struct nf_conntrack_tuple *t)
 {
 #ifdef DEBUG
-	printk("tuple %p: %u " NIP6_FMT " %hu -> " NIP6_FMT " %hu\n",
+	printk("tuple %p: %u %p6 %hu -> %p6 %hu\n",
 	       t, t->dst.protonum,
-	       NIP6(*(struct in6_addr *)t->src.u3.all), ntohs(t->src.u.all),
-	       NIP6(*(struct in6_addr *)t->dst.u3.all), ntohs(t->dst.u.all));
+	       t->src.u3.all, ntohs(t->src.u.all),
+	       t->dst.u3.all, ntohs(t->dst.u.all));
 #endif
 }
 
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index ed71b11..85e9157 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -285,9 +285,9 @@ extern int sctp_debug_flag;
 	if (sctp_debug_flag) { \
 		if (saddr->sa.sa_family == AF_INET6) { \
 			printk(KERN_DEBUG \
-			       lead NIP6_FMT trail, \
+			       lead %p6 trail, \
 			       leadparm, \
-			       NIP6(saddr->v6.sin6_addr), \
+			       &saddr->v6.sin6_addr, \
 			       otherparms); \
 		} else { \
 			printk(KERN_DEBUG \
diff --git a/net/netlabel/netlabel_addrlist.c b/net/netlabel/netlabel_addrlist.c
index b0925a3..614c95e 100644
--- a/net/netlabel/netlabel_addrlist.c
+++ b/net/netlabel/netlabel_addrlist.c
@@ -370,7 +370,7 @@ void netlbl_af6list_audit_addr(struct audit_buffer *audit_buf,
 
 	if (dev != NULL)
 		audit_log_format(audit_buf, " netif=%s", dev);
-	audit_log_format(audit_buf, " %s=" NIP6_FMT, dir, NIP6(*addr));
+	audit_log_format(audit_buf, " %s=%p6", dir, addr);
 	if (ntohl(mask->s6_addr32[3]) != 0xffffffff) {
 		u32 mask_len = 0;
 		u32 mask_val;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 4124bbb..e82668b 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -223,10 +223,9 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *transport)
 		ipv6_addr_copy(&fl.fl6_dst, rt0->addr);
 	}
 
-	SCTP_DEBUG_PRINTK("%s: skb:%p, len:%d, "
-			  "src:" NIP6_FMT " dst:" NIP6_FMT "\n",
+	SCTP_DEBUG_PRINTK("%s: skb:%p, len:%d, src:%p6 dst:%p6\n",
 			  __func__, skb, skb->len,
-			  NIP6(fl.fl6_src), NIP6(fl.fl6_dst));
+			  &fl.fl6_src, &fl.fl6_dst);
 
 	SCTP_INC_STATS(SCTP_MIB_OUTSCTPPACKS);
 
@@ -252,23 +251,19 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
 		fl.oif = daddr->v6.sin6_scope_id;
 

-	SCTP_DEBUG_PRINTK("%s: DST=" NIP6_FMT " ",
-			  __func__, NIP6(fl.fl6_dst));
+	SCTP_DEBUG_PRINTK("%s: DST=%p6 ", __func__, &fl.fl6_dst);
 
 	if (saddr) {
 		ipv6_addr_copy(&fl.fl6_src, &saddr->v6.sin6_addr);
-		SCTP_DEBUG_PRINTK(
-			"SRC=" NIP6_FMT " - ",
-			NIP6(fl.fl6_src));
+		SCTP_DEBUG_PRINTK("SRC=%p6 - ", &fl.fl6_src);
 	}
 
 	dst = ip6_route_output(&init_net, NULL, &fl);
 	if (!dst->error) {
 		struct rt6_info *rt;
 		rt = (struct rt6_info *)dst;
-		SCTP_DEBUG_PRINTK(
-			"rt6_dst:" NIP6_FMT " rt6_src:" NIP6_FMT "\n",
-			NIP6(rt->rt6i_dst.addr), NIP6(rt->rt6i_src.addr));
+		SCTP_DEBUG_PRINTK("rt6_dst:%p6 rt6_src:%p6\n",
+			&rt->rt6i_dst.addr, &rt->rt6i_src.addr);
 		return dst;
 	}
 	SCTP_DEBUG_PRINTK("NO ROUTE\n");
@@ -314,9 +309,8 @@ static void sctp_v6_get_saddr(struct sctp_sock *sk,
 	__u8 matchlen = 0;
 	__u8 bmatchlen;
 
-	SCTP_DEBUG_PRINTK("%s: asoc:%p dst:%p "
-			  "daddr:" NIP6_FMT " ",
-			  __func__, asoc, dst, NIP6(daddr->v6.sin6_addr));
+	SCTP_DEBUG_PRINTK("%s: asoc:%p dst:%p daddr:%p6 ",
+			  __func__, asoc, dst, &daddr->v6.sin6_addr);
 
 	if (!asoc) {
 		ipv6_dev_get_saddr(sock_net(sctp_opt2sk(sk)),
@@ -324,8 +318,8 @@ static void sctp_v6_get_saddr(struct sctp_sock *sk,
 				   &daddr->v6.sin6_addr,
 				   inet6_sk(&sk->inet.sk)->srcprefs,
 				   &saddr->v6.sin6_addr);
-		SCTP_DEBUG_PRINTK("saddr from ipv6_get_saddr: " NIP6_FMT "\n",
-				  NIP6(saddr->v6.sin6_addr));
+		SCTP_DEBUG_PRINTK("saddr from ipv6_get_saddr: %p6\n",
+				  &saddr->v6.sin6_addr);
 		return;
 	}
 
@@ -353,12 +347,11 @@ static void sctp_v6_get_saddr(struct sctp_sock *sk,
 
 	if (baddr) {
 		memcpy(saddr, baddr, sizeof(union sctp_addr));
-		SCTP_DEBUG_PRINTK("saddr: " NIP6_FMT "\n",
-				  NIP6(saddr->v6.sin6_addr));
+		SCTP_DEBUG_PRINTK("saddr: %p6\n", &saddr->v6.sin6_addr);
 	} else {
 		printk(KERN_ERR "%s: asoc:%p Could not find a valid source "
-		       "address for the dest:" NIP6_FMT "\n",
-		       __func__, asoc, NIP6(daddr->v6.sin6_addr));
+		       "address for the dest:%p6\n",
+		       __func__, asoc, &daddr->v6.sin6_addr);
 	}
 
 	rcu_read_unlock();
@@ -727,7 +720,7 @@ static int sctp_v6_is_ce(const struct sk_buff *skb)
 /* Dump the v6 addr to the seq file. */
 static void sctp_v6_seq_dump_addr(struct seq_file *seq, union sctp_addr *addr)
 {
-	seq_printf(seq, NIP6_FMT " ", NIP6(addr->v6.sin6_addr));
+	seq_printf(seq, "%p6 ", &addr->v6.sin6_addr);
 }
 
 static void sctp_v6_ecn_capable(struct sock *sk)
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a6a0ea7..9f37096 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1123,11 +1123,10 @@ sctp_disposition_t sctp_sf_backbeat_8_3(const struct sctp_endpoint *ep,
 		if (from_addr.sa.sa_family == AF_INET6) {
 			if (net_ratelimit())
 				printk(KERN_WARNING
-				    "%s association %p could not find address "
-				    NIP6_FMT "\n",
+				    "%s association %p could not find address %p6\n",
 				    __func__,
 				    asoc,
-				    NIP6(from_addr.v6.sin6_addr));
+				    &from_addr.v6.sin6_addr);
 		} else {
 			if (net_ratelimit())
 				printk(KERN_WARNING
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 4895c34..26f61fd 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -278,8 +278,8 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *args)
 		case AF_INET6: {
 			struct sockaddr_in6 *sin =
 					(struct sockaddr_in6 *)args->address;
-			snprintf(servername, sizeof(servername), NIP6_FMT,
-				 NIP6(sin->sin6_addr));
+			snprintf(servername, sizeof(servername), "%p6",
+				 &sin->sin6_addr);
 			break;
 		}
 		default:
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 41013dd..968ec1f 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -305,9 +305,9 @@ static int rpcb_register_netid6(struct sockaddr_in6 *address_to_register,
 		snprintf(buf, sizeof(buf), "::.%u.%u",
 				port >> 8, port & 0xff);
 	else
-		snprintf(buf, sizeof(buf), NIP6_FMT".%u.%u",
-				NIP6(address_to_register->sin6_addr),
-				port >> 8, port & 0xff);
+		snprintf(buf, sizeof(buf), "%p6.%u.%u",
+			 &address_to_register->sin6_addr,
+			 port >> 8, port & 0xff);
 	map->r_addr = buf;
 
 	dprintk("RPC:       %sregistering [%u, %u, %s, '%s'] with "
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index f24800f..9a6d0cf 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -168,7 +168,7 @@ static void ip_map_request(struct cache_detail *cd,
 				ntohl(im->m_addr.s6_addr32[3]) >>  8 & 0xff,
 				ntohl(im->m_addr.s6_addr32[3]) >>  0 & 0xff);
 	} else {
-		snprintf(text_addr, 40, NIP6_FMT, NIP6(im->m_addr));
+		snprintf(text_addr, 40, "%p6", &im->m_addr);
 	}
 	qword_add(bpp, blen, im->m_class);
 	qword_add(bpp, blen, text_addr);
@@ -286,8 +286,7 @@ static int ip_map_show(struct seq_file *m,
 			ntohl(addr.s6_addr32[3]) >>  0 & 0xff,
 			dom);
 	} else {
-		seq_printf(m, "%s " NIP6_FMT " %s\n",
-			im->m_class, NIP6(addr), dom);
+		seq_printf(m, "%s %p6 %s\n", im->m_class, &addr, dom);
 	}
 	return 0;
 }
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 9a288d5..69584f6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -340,10 +340,9 @@ static void xs_format_ipv6_peer_addresses(struct rpc_xprt *xprt,
 	char *buf;
 
 	buf = kzalloc(40, GFP_KERNEL);
-	if (buf) {
-		snprintf(buf, 40, NIP6_FMT,
-				NIP6(addr->sin6_addr));
-	}
+	if (buf)
+		snprintf(buf, 40, "%p6", &addr->sin6_addr);
+
 	xprt->address_strings[RPC_DISPLAY_ADDR] = buf;
 
 	buf = kzalloc(8, GFP_KERNEL);
@@ -357,18 +356,15 @@ static void xs_format_ipv6_peer_addresses(struct rpc_xprt *xprt,
 
 	buf = kzalloc(64, GFP_KERNEL);
 	if (buf) {
-		snprintf(buf, 64, "addr="NIP6_FMT" port=%u proto=%s",
-				NIP6(addr->sin6_addr),
-				ntohs(addr->sin6_port),
-				protocol);
+		snprintf(buf, 64, "addr=%p6 port=%u proto=%s",
+			 &addr->sin6_addr, ntohs(addr->sin6_port), protocol);
 	}
 	xprt->address_strings[RPC_DISPLAY_ALL] = buf;
 
 	buf = kzalloc(36, GFP_KERNEL);
-	if (buf) {
-		snprintf(buf, 36, NIP6_SEQFMT,
-				NIP6(addr->sin6_addr));
-	}
+	if (buf)
+		snprintf(buf, 36, "%#p6", &addr->sin6_addr);
+
 	xprt->address_strings[RPC_DISPLAY_HEX_ADDR] = buf;
 
 	buf = kzalloc(8, GFP_KERNEL);
@@ -380,8 +376,8 @@ static void xs_format_ipv6_peer_addresses(struct rpc_xprt *xprt,
 
 	buf = kzalloc(50, GFP_KERNEL);
 	if (buf) {
-		snprintf(buf, 50, NIP6_FMT".%u.%u",
-				NIP6(addr->sin6_addr),
+		snprintf(buf, 50, "%p6.%u.%u",
+				&addr->sin6_addr,
 				ntohs(addr->sin6_port) >> 8,
 				ntohs(addr->sin6_port) & 0xff);
 	}
@@ -1409,8 +1405,8 @@ static int xs_bind6(struct sock_xprt *transport, struct socket *sock)
 		if (port > last)
 			nloop++;
 	} while (err == -EADDRINUSE && nloop != 2);
-	dprintk("RPC:       xs_bind6 "NIP6_FMT":%u: %s (%d)\n",
-		NIP6(myaddr.sin6_addr), port, err ? "failed" : "ok", err);
+	dprintk("RPC:       xs_bind6 %p6:%u: %s (%d)\n",
+		&myaddr.sin6_addr, port, err ? "failed" : "ok", err);
 	return err;
 }
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 832b47c..f052b06 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2467,13 +2467,11 @@ static void xfrm_audit_common_policyinfo(struct xfrm_policy *xp,
 					 sel->prefixlen_d);
 		break;
 	case AF_INET6:
-		audit_log_format(audit_buf, " src=" NIP6_FMT,
-				 NIP6(*(struct in6_addr *)sel->saddr.a6));
+		audit_log_format(audit_buf, " src=%p6", sel->saddr.a6);
 		if (sel->prefixlen_s != 128)
 			audit_log_format(audit_buf, " src_prefixlen=%d",
 					 sel->prefixlen_s);
-		audit_log_format(audit_buf, " dst=" NIP6_FMT,
-				 NIP6(*(struct in6_addr *)sel->daddr.a6));
+		audit_log_format(audit_buf, " dst=%p6", sel->daddr.a6);
 		if (sel->prefixlen_d != 128)
 			audit_log_format(audit_buf, " dst_prefixlen=%d",
 					 sel->prefixlen_d);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 508337f..7944861 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2115,10 +2115,8 @@ static void xfrm_audit_helper_sainfo(struct xfrm_state *x,
 				 NIPQUAD(x->id.daddr.a4));
 		break;
 	case AF_INET6:
-		audit_log_format(audit_buf,
-				 " src=" NIP6_FMT " dst=" NIP6_FMT,
-				 NIP6(*(struct in6_addr *)x->props.saddr.a6),
-				 NIP6(*(struct in6_addr *)x->id.daddr.a6));
+		audit_log_format(audit_buf, " src=%p6 dst=%p6",
+				 x->props.saddr.a6, x->id.daddr.a6);
 		break;
 	}
 
@@ -2142,10 +2140,8 @@ static void xfrm_audit_helper_pktinfo(struct sk_buff *skb, u16 family,
 	case AF_INET6:
 		iph6 = ipv6_hdr(skb);
 		audit_log_format(audit_buf,
-				 " src=" NIP6_FMT " dst=" NIP6_FMT
-				 " flowlbl=0x%x%02x%02x",
-				 NIP6(iph6->saddr),
-				 NIP6(iph6->daddr),
+				 " src=%p6 dst=%p6 flowlbl=0x%x%02x%02x",
+				 &iph6->saddr,&iph6->daddr,
 				 iph6->flow_lbl[0] & 0x0f,
 				 iph6->flow_lbl[1],
 				 iph6->flow_lbl[2]);
diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index cb30c7e..c91008f 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -495,7 +495,7 @@ static inline void avc_print_ipv6_addr(struct audit_buffer *ab,
 				       char *name1, char *name2)
 {
 	if (!ipv6_addr_any(addr))
-		audit_log_format(ab, " %s=" NIP6_FMT, name1, NIP6(*addr));
+		audit_log_format(ab, " %s=%p6", name1, addr);
 	if (port)
 		audit_log_format(ab, " %s=%d", name2, ntohs(port));
 }
-- 
1.6.0.3.729.g6ea410

