Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZDEIrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZDEIrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZDEIrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:47:21 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:36223 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbZDEIrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:47:16 -0400
Message-ID: <49D87010.7050409@numericable.fr>
Date: Sun, 05 Apr 2009 10:47:12 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
CC: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] security/smack implement logging V2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates auditing functions usable by LSM to audit security
events. It provides standard dumping of FS, NET, task etc ... events
(code borrowed from SELinux)
and provides 2 callbacks to define LSM specific auditing, which should be 
flexible enough to convert SELinux too.


Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
---
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
new file mode 100644
index 0000000..df54ad6
--- /dev/null
+++ b/include/linux/lsm_audit.h
@@ -0,0 +1,111 @@
+/*
+ * Common LSM logging functions
+ * Heavily borrowed from selinux/avc.h
+ *
+ * Author : Etienne BASSET  <etienne.basset@ensta.org>
+ *
+ * All credits to : Stephen Smalley, <sds@epoch.ncsc.mil>
+ * All BUGS to : Etienne BASSET  <etienne.basset@ensta.org>
+ */
+#ifndef _LSM_COMMON_LOGGING_
+#define _LSM_COMMON_LOGGING_
+
+#include <linux/stddef.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/kdev_t.h>
+#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/audit.h>
+#include <linux/in6.h>
+#include <linux/path.h>
+#include <asm/system.h>
+#include <linux/key.h>
+#include <linux/skbuff.h>
+
+
+/* Auxiliary data to use in generating the audit record. */
+struct common_audit_data {
+	char    type;
+#define AVC_AUDIT_DATA_FS      1
+#define AVC_AUDIT_DATA_NET     2
+#define AVC_AUDIT_DATA_CAP     3
+#define AVC_AUDIT_DATA_IPC     4
+#define AVC_AUDIT_DATA_TASK    5
+#define AVC_AUDIT_DATA_KEY     6
+	struct task_struct *tsk;
+	union 	{
+		struct {
+			struct path path;
+			struct inode *inode;
+		} fs;
+		struct {
+			int netif;
+			struct sock *sk;
+			u16 family;
+			__be16 dport;
+			__be16 sport;
+			union {
+				struct {
+					__be32 daddr;
+					__be32 saddr;
+				} v4;
+				struct {
+					struct in6_addr daddr;
+					struct in6_addr saddr;
+				} v6;
+			} fam;
+		} net;
+		int cap;
+		int ipc_id;
+		struct task_struct *tsk;
+#ifdef CONFIG_KEYS
+		struct {
+			key_serial_t key;
+			char *key_desc;
+		} key_struct;
+#endif
+	} u;
+	const char *function;
+	/* this union contains LSM specific data */
+	union {
+		/* SMACK data */
+		struct {
+			char *subject;
+			char *object;
+			char *request;
+			int result;
+		} smack_audit_data;
+		/* SELinux data */
+		struct {
+			u32 ssid;
+			u32 tsid;
+			u16 tclass;
+			u32 requested;
+			u32 audited;
+			struct av_decision *avd;
+			int result;
+		} selinux_audit_data;
+	} lsm_priv;
+	/* these callback will be implemented by a specific LSM */
+	void (*lsm_pre_audit)(struct audit_buffer *, void *);
+	void (*lsm_post_audit)(struct audit_buffer *, void *);
+};
+
+#define v4info fam.v4
+#define v6info fam.v6
+
+int ipv4_skb_to_auditdata(struct sk_buff *skb,
+		struct common_audit_data *ad, u8 *proto);
+
+int ipv6_skb_to_auditdata(struct sk_buff *skb,
+		struct common_audit_data *ad, u8 *proto);
+
+/* Initialize an AVC audit data structure. */
+#define COMMON_AUDIT_DATA_INIT(_d, _t) \
+	{ memset((_d), 0, sizeof(struct common_audit_data)); \
+	 (_d)->type = AVC_AUDIT_DATA_##_t; (_d)->function = __func__; }
+
+void common_lsm_audit(struct common_audit_data *a);
+
+#endif
diff --git a/security/Makefile b/security/Makefile
index fa77021..bd208b8 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_SECURITY)			+= security.o capability.o
 obj-$(CONFIG_SECURITYFS)		+= inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
-obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
+obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
new file mode 100644
index 0000000..9056848
--- /dev/null
+++ b/security/lsm_audit.c
@@ -0,0 +1,390 @@
+/*
+ * common LSM auditing functions
+ *
+ * Based on code written for SELinux by :
+ *			Stephen Smalley, <sds@epoch.ncsc.mil>
+ * 			James Morris <jmorris@redhat.com>
+ * Author : Etienne Basset, <etienne.basset@ensta.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2,
+ * as published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <net/sock.h>
+#include <linux/un.h>
+#include <net/af_unix.h>
+#include <linux/audit.h>
+#include <linux/ipv6.h>
+#include <linux/ip.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <linux/dccp.h>
+#include <linux/sctp.h>
+#include <linux/lsm_audit.h>
+
+/**
+ * ipv4_skb_to_auditdata : fill auditdata from skb
+ * @skb : the skb
+ * @ad : the audit data to fill
+ * @proto : the layer 4 protocol
+ *
+ * return  0 on success
+ */
+int ipv4_skb_to_auditdata(struct sk_buff *skb,
+		struct common_audit_data *ad, u8 *proto)
+{
+	int ret = 0;
+	struct iphdr *ih;
+
+	ih = ip_hdr(skb);
+	if (ih == NULL)
+		return -EINVAL;
+
+	ad->u.net.v4info.saddr = ih->saddr;
+	ad->u.net.v4info.daddr = ih->daddr;
+
+	if (proto)
+		*proto = ih->protocol;
+	/* non initial fragment */
+	if (ntohs(ih->frag_off) & IP_OFFSET)
+		return 0;
+
+	switch (ih->protocol) {
+	case IPPROTO_TCP: {
+		struct tcphdr *th = tcp_hdr(skb);
+		if (th == NULL)
+			break;
+
+		ad->u.net.sport = th->source;
+		ad->u.net.dport = th->dest;
+		break;
+	}
+	case IPPROTO_UDP: {
+		struct udphdr *uh = udp_hdr(skb);
+		if (uh == NULL)
+			break;
+
+		ad->u.net.sport = uh->source;
+		ad->u.net.dport = uh->dest;
+		break;
+	}
+	case IPPROTO_DCCP: {
+		struct dccp_hdr *dh = dccp_hdr(skb);
+		if (dh == NULL)
+			break;
+
+		ad->u.net.sport = dh->dccph_sport;
+		ad->u.net.dport = dh->dccph_dport;
+		break;
+	}
+	case IPPROTO_SCTP: {
+		struct sctphdr *sh = sctp_hdr(skb);
+		if (sh == NULL)
+			break;
+		ad->u.net.sport = sh->source;
+		ad->u.net.dport = sh->dest;
+		break;
+	}
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+/**
+ * ipv6_skb_to_auditdata : fill auditdata from skb
+ * @skb : the skb
+ * @ad : the audit data to fill
+ * @proto : the layer 4 protocol
+ *
+ * return  0 on success
+ */
+int ipv6_skb_to_auditdata(struct sk_buff *skb,
+		struct common_audit_data *ad, u8 *proto)
+{
+	int offset, ret = 0;
+	struct ipv6hdr *ip6;
+	u8 nexthdr;
+
+	ip6 = ipv6_hdr(skb);
+	if (ip6 == NULL)
+		return -EINVAL;
+	ipv6_addr_copy(&ad->u.net.v6info.saddr, &ip6->saddr);
+	ipv6_addr_copy(&ad->u.net.v6info.daddr, &ip6->daddr);
+	ret = 0;
+	/* IPv6 can have several extension header before the Transport header
+	 * skip them */
+	offset = skb_network_offset(skb);
+	offset += sizeof(*ip6);
+	nexthdr = ip6->nexthdr;
+	offset = ipv6_skip_exthdr(skb, offset, &nexthdr);
+	if (offset < 0)
+		return 0;
+	if (proto)
+		*proto = nexthdr;
+	switch (nexthdr) {
+	case IPPROTO_TCP: {
+		struct tcphdr _tcph, *th;
+
+		th = skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
+		if (th == NULL)
+			break;
+
+		ad->u.net.sport = th->source;
+		ad->u.net.dport = th->dest;
+		break;
+	}
+	case IPPROTO_UDP: {
+		struct udphdr _udph, *uh;
+
+		uh = skb_header_pointer(skb, offset, sizeof(_udph), &_udph);
+		if (uh == NULL)
+			break;
+
+		ad->u.net.sport = uh->source;
+		ad->u.net.dport = uh->dest;
+		break;
+	}
+	case IPPROTO_DCCP: {
+		struct dccp_hdr _dccph, *dh;
+
+		dh = skb_header_pointer(skb, offset, sizeof(_dccph), &_dccph);
+		if (dh == NULL)
+			break;
+
+		ad->u.net.sport = dh->dccph_sport;
+		ad->u.net.dport = dh->dccph_dport;
+		break;
+	}
+	case IPPROTO_SCTP: {
+		struct sctphdr _sctph, *sh;
+
+		sh = skb_header_pointer(skb, offset, sizeof(_sctph), &_sctph);
+		if (sh == NULL)
+			break;
+		ad->u.net.sport = sh->source;
+		ad->u.net.dport = sh->dest;
+		break;
+	}
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+#endif
+
+
+static inline void avc_print_ipv6_addr(struct audit_buffer *ab,
+			struct in6_addr *addr, __be16 port,
+			char *name1, char *name2)
+{
+	if (!ipv6_addr_any(addr))
+		audit_log_format(ab, " %s=%pI6", name1, addr);
+	if (port)
+		audit_log_format(ab, " %s=%d", name2, ntohs(port));
+}
+
+static inline void avc_print_ipv4_addr(struct audit_buffer *ab, __be32 addr,
+			__be16 port, char *name1, char *name2)
+{
+	if (addr)
+		audit_log_format(ab, " %s=%pI4", name1, &addr);
+	if (port)
+		audit_log_format(ab, " %s=%d", name2, ntohs(port));
+}
+
+/**
+ * dump_common_audit_data - helper to dump common audit data
+ * @a : common audit data
+ *
+ */
+static void dump_common_audit_data(struct audit_buffer *ab,
+				 struct common_audit_data *a)
+{
+	struct inode *inode = NULL;
+	struct task_struct *tsk = current;
+
+	if (a->tsk)
+		tsk = a->tsk;
+	if (tsk && tsk->pid) {
+		audit_log_format(ab, " pid=%d comm=", tsk->pid);
+		audit_log_untrustedstring(ab, tsk->comm);
+	}
+
+	switch (a->type) {
+	case AVC_AUDIT_DATA_IPC:
+		audit_log_format(ab, "key=%d ", a->u.ipc_id);
+		break;
+	case AVC_AUDIT_DATA_CAP:
+		audit_log_format(ab, "capability=%d ", a->u.cap);
+		break;
+	case AVC_AUDIT_DATA_FS:
+		if (a->u.fs.path.dentry) {
+			struct dentry *dentry = a->u.fs.path.dentry;
+			if (a->u.fs.path.mnt) {
+				audit_log_d_path(ab, "path=", &a->u.fs.path);
+			} else {
+				audit_log_format(ab, "name=");
+				audit_log_untrustedstring(ab,
+						 dentry->d_name.name);
+			}
+			inode = dentry->d_inode;
+		} else if (a->u.fs.inode) {
+			struct dentry *dentry;
+			inode = a->u.fs.inode;
+			dentry = d_find_alias(inode);
+			if (dentry) {
+				audit_log_format(ab, "name=");
+				audit_log_untrustedstring(ab,
+						 dentry->d_name.name);
+				dput(dentry);
+			}
+		}
+		if (inode)
+			audit_log_format(ab, " dev=%s ino=%lu",
+					inode->i_sb->s_id,
+					inode->i_ino);
+		break;
+	case AVC_AUDIT_DATA_TASK:
+		tsk = a->u.tsk;
+		if (tsk && tsk->pid) {
+			audit_log_format(ab, "pid=%d comm=", tsk->pid);
+			audit_log_untrustedstring(ab, tsk->comm);
+		}
+		break;
+	case AVC_AUDIT_DATA_NET:
+		if (a->u.net.sk) {
+			struct sock *sk = a->u.net.sk;
+			struct unix_sock *u;
+			int len = 0;
+			char *p = NULL;
+
+			switch (sk->sk_family) {
+			case AF_INET: {
+				struct inet_sock *inet = inet_sk(sk);
+
+				avc_print_ipv4_addr(ab, inet->rcv_saddr,
+						inet->sport,
+						"laddr", "lport");
+				avc_print_ipv4_addr(ab, inet->daddr,
+						inet->dport,
+						"faddr", "fport");
+				break;
+			}
+			case AF_INET6: {
+				struct inet_sock *inet = inet_sk(sk);
+				struct ipv6_pinfo *inet6 = inet6_sk(sk);
+
+				avc_print_ipv6_addr(ab, &inet6->rcv_saddr,
+						inet->sport,
+						"laddr", "lport");
+				avc_print_ipv6_addr(ab, &inet6->daddr,
+						inet->dport,
+						"faddr", "fport");
+				break;
+			}
+			case AF_UNIX:
+				u = unix_sk(sk);
+				if (u->dentry) {
+					struct path path = {
+						.dentry = u->dentry,
+						.mnt = u->mnt
+					};
+					audit_log_d_path(ab, "path=",
+							&path);
+					break;
+				}
+				if (!u->addr)
+					break;
+				len = u->addr->len-sizeof(short);
+				p = &u->addr->name->sun_path[0];
+				audit_log_format(ab, " path=");
+				if (*p)
+					audit_log_untrustedstring(ab, p);
+				else
+					audit_log_n_hex(ab, p, len);
+				break;
+			}
+		}
+
+		switch (a->u.net.family) {
+		case AF_INET:
+			avc_print_ipv4_addr(ab, a->u.net.v4info.saddr,
+						a->u.net.sport,
+						"saddr", "src");
+			avc_print_ipv4_addr(ab, a->u.net.v4info.daddr,
+						a->u.net.dport,
+						"daddr", "dest");
+			break;
+		case AF_INET6:
+			avc_print_ipv6_addr(ab, &a->u.net.v6info.saddr,
+						a->u.net.sport,
+						"saddr", "src");
+			avc_print_ipv6_addr(ab, &a->u.net.v6info.daddr,
+						a->u.net.dport,
+						"daddr", "dest");
+			break;
+		}
+		if (a->u.net.netif > 0) {
+			struct net_device *dev;
+
+			/* NOTE: we always use init's namespace */
+			dev = dev_get_by_index(&init_net,
+					a->u.net.netif);
+			if (dev) {
+				audit_log_format(ab, " netif=%s",
+						dev->name);
+				dev_put(dev);
+			}
+		}
+		break;
+#ifdef CONFIG_KEYS
+	case AVC_AUDIT_DATA_KEY:
+		audit_log_format(ab, " key_serial=%u", a->u.key_struct.key);
+		if (a->u.key_struct.key_desc) {
+			audit_log_format(ab, " key_desc=");
+			audit_log_untrustedstring(ab, a->u.key_struct.key_desc);
+		}
+		break;
+#endif
+	} /* switch (a->type) */
+}
+
+/**
+ * common_lsm_audit - generic LSM auditing function
+ * @a:  auxiliary audit data
+ *
+ * setup the audit buffer for common security information
+ * uses callback to print LSM specific information
+ */
+void common_lsm_audit(struct common_audit_data *a)
+{
+	struct audit_buffer *ab;
+
+	if (a == NULL)
+		return;
+	/* we use GFP_ATOMIC so we won't sleep */
+	ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_AVC);
+
+	if (ab == NULL)
+		return;
+
+	if (a->lsm_pre_audit)
+		a->lsm_pre_audit(ab, a);
+
+	dump_common_audit_data(ab, a);
+
+	if (a->lsm_post_audit)
+		a->lsm_post_audit(ab, a);
+
+	audit_log_end(ab);
+}
+
+


