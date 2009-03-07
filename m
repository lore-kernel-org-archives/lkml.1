Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZCGNGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZCGNGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 08:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZCGNGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 08:06:10 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:33999 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZCGNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 08:06:04 -0500
Message-ID: <49B27134.2020103@numericable.fr>
Date: Sat, 07 Mar 2009 14:05:56 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>,
       LSM <linux-security-module@vger.kernel.org>,
       Dmitriy Romashkin <dmitriy.romashkin@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>
Subject: [PACH][RFC] SMACK : add  logging support V1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the following patch, against current 2.6.29-rc7, add logging of smack decisions. 
This is of course very useful to understand what your current smack policy does.
It borrows a lot from selinux;

It introduces a '/smack/logging' switch :
0: no logging
1: log denied (default)
2: log accepted 
3: log denied&accepted 


example of logs produced :

type=1400 audit(1236429348.858:5655879): SMACK[smack_task_kill]:  denied  pid=6521 comm="bash" subject:'toto' object:'_' requested:w pid=5757 comm="knetworkmanager"
type=1400 audit(1236429361.477:5655882): SMACK[smk_curacc_shm]:  denied  pid=6533 comm="ipcrm" subject:'toto' object:'_' requested:rw key=491521
type=1400 audit(1236429392.389:5655885): SMACK[smack_sb_mount]:  denied  pid=6536 comm="mount" subject:'toto' object:'_' requested:w  path="/debug" dev=sda5 ino=16161
type=1400 audit(1236429485.009:5655890): SMACK[smack_ptrace_may_access]:  denied  pid=6539 comm="strace" subject:'toto' object:'_' requested:rw pid=5634 comm="python"
type=1400 audit(1236429527.693:5655893): SMACK[smack_inode_getattr]:  denied  pid=6544 comm="ls" subject:'toto' object:'etienne' requested:r  path="/home/etienne/linux" dev=sda8 ino=2342913
type=1400 audit(1236429741.006:6006665): SMACK[smack_socket_sendmsg]:  granted  pid=6580 comm="ping" subject:'toto' object:'@' requested:w  daddr=192.168.0.10
type=1400 audit(1236429741.006:6006666): SMACK[smack_socket_sock_rcv_skb]:  granted  pid=6580 comm="ping" subject:'@' object:'toto' requested:w  saddr=192.168.0.10 daddr=192.168.0.10 netif=lo



Signed-off-by: <etienne.basset@numericable.fr>
---
 Documentation/Smack.txt        |   12 +
 security/smack/Kconfig         |    2 +-
 security/smack/Makefile        |    2 +-
 security/smack/smack_logging.c |  460 ++++++++++++++++++++++++++++++++++++++++
 security/smack/smack_logging.h |   97 +++++++++
 security/smack/smack_lsm.c     |  356 +++++++++++++++++++++++--------
 security/smack/smackfs.c       |   52 +++++
 7 files changed, 892 insertions(+), 89 deletions(-)
---
diff --git a/Documentation/Smack.txt b/Documentation/Smack.txt
index 989c2fc..81a6921 100644
--- a/Documentation/Smack.txt
+++ b/Documentation/Smack.txt
@@ -491,3 +491,15 @@ Smack supports some mount options:
 
 These mount options apply to all file system types.
 
+Smack logging support
+
+Smack supports logging of security accesses. It will log by default all denied
+requests. The interface to change this behavior is /smack/logging, where you
+can write the logging level you desire :
+0: no logging
+1: log denied (default)
+2: log accepted 
+3: log denied&accepted 
+
+Note that due to the rate-limit of audit messages, logging accepted request will
+drop a lot of messages.
diff --git a/security/smack/Kconfig b/security/smack/Kconfig
index 603b087..d83e708 100644
--- a/security/smack/Kconfig
+++ b/security/smack/Kconfig
@@ -1,6 +1,6 @@
 config SECURITY_SMACK
 	bool "Simplified Mandatory Access Control Kernel Support"
-	depends on NETLABEL && SECURITY_NETWORK
+	depends on NETLABEL && SECURITY_NETWORK && AUDIT
 	default n
 	help
 	  This selects the Simplified Mandatory Access Control Kernel.
diff --git a/security/smack/Makefile b/security/smack/Makefile
index 67a63aa..b562fba 100644
--- a/security/smack/Makefile
+++ b/security/smack/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_SECURITY_SMACK) := smack.o
 
-smack-y := smack_lsm.o smack_access.o smackfs.o
+smack-y := smack_lsm.o smack_access.o smackfs.o smack_logging.o
diff --git a/security/smack/smack_logging.c b/security/smack/smack_logging.c
new file mode 100644
index 0000000..1ff81c0
--- /dev/null
+++ b/security/smack/smack_logging.c
@@ -0,0 +1,460 @@
+/*
+ * Smack logging
+ *
+ * heavily inspired by security/selinux/avc.c
+ *
+ * All credits to :  Stephen Smalley, <sds@epoch.ncsc.mil>
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
+#include "smack.h"
+#include "smack_logging.h"
+
+/* what do we log
+ * can be overwrite at run-time by /smack/logging
+ */
+struct smack_log_policy log_policy = {
+	.log_accepted = 0,
+	.log_denied   = 1
+};
+
+
+
+/**
+ * ipv4_skb_to_auditdata : fill smack_auditdata from skb
+ * @skb : the skb
+ * @ad : the audit data to fill
+ * @proto : the layer 4 protocol
+ *
+ * return  0 on success
+ */
+int ipv4_skb_to_auditdata(struct sk_buff *skb,
+                        struct smack_audit_data *ad, u8 *proto)
+{
+        int ret = 0;
+        struct iphdr *ih;
+
+        ih = ip_hdr(skb);
+        if (ih == NULL)
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
+                struct dccp_hdr *dh = dccp_hdr(skb);
+                if (dh == NULL)
+                        break;
+
+                ad->u.net.sport = dh->dccph_sport;
+                ad->u.net.dport = dh->dccph_dport;
+                break;
+	}
+	case IPPROTO_SCTP: {
+		struct sctphdr *sh = sctp_hdr(skb);
+		if (sh == NULL)
+			break;
+		ad->u.net.sport = sh->source;
+		ad->u.net.dport = sh->dest;
+        	break;
+	}
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+/**
+ * ipv6_skb_to_auditdata : fill smack_auditdata from skb
+ * @skb : the skb
+ * @ad : the audit data to fill
+ * @proto : the layer 4 protocol
+ *
+ * return  0 on success
+ */
+int ipv6_skb_to_auditdata(struct sk_buff *skb,
+                        struct smack_audit_data *ad, u8 *proto)
+{
+        int offset, ret = 0;
+	struct ipv6hdr *ip6;
+	u8 nexthdr;
+
+        ip6 = ipv6_hdr(skb);
+        if (ip6 == NULL)
+		return -EINVAL;
+	ipv6_addr_copy(&ad->u.net.v6info.saddr, &ip6->saddr);
+        ipv6_addr_copy(&ad->u.net.v6info.daddr, &ip6->daddr);
+        ret = 0;
+	/* IPv6 can have several extension header before the Transport header
+	 * skip them */
+	offset = skb_network_offset(skb);
+        offset += sizeof(*ip6);
+	nexthdr = ip6->nexthdr;
+        offset = ipv6_skip_exthdr(skb, offset, &nexthdr);
+        if (offset < 0)
+                return 0;
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
+                if (uh == NULL)
+                        break;
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
+        	break;
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
+/**
+ * smack_str_from_perm : helper to transalate an int to a
+ * readable string
+ * @string : the string to fill
+ * @access : the int
+ *
+ */
+static inline void smack_str_from_perm(char *string, int access)
+{
+	int i = 0;
+	if (access & MAY_READ)
+		string[i++] = 'r';
+	if (access & MAY_WRITE)
+		string[i++] = 'w';
+	if (access & MAY_EXEC)
+		string[i++] = 'x';
+	if (access & MAY_APPEND)
+		string[i++] = 'a';
+	string[i] = '\0';
+}
+
+
+/**
+ * smack_log - Audit the granting or denial of permissions.
+ * @subject_label : smack label of the requester
+ * @object_label  : smack label of the object being accessed
+ * @request: requested permissions
+ * @result: result from smk_access
+ * @a:  auxiliary audit data
+ *
+ * Audit the granting or denial of permissions in accordance
+ * with the policy.
+ */
+void smack_log(char *subject_label, char *object_label, int request,
+		 int result, struct smack_audit_data *a)
+{
+	struct task_struct *tsk = current;
+	struct inode *inode = NULL;
+	struct audit_buffer *ab;
+	char request_buffer[5];
+	u32 denied;
+	u32 audited = 0;
+
+	/* check if we have to log the current event */
+	if (result != 0) {
+		denied = 1;
+		if  (log_policy.log_denied)
+			audited = 1;
+	} else {
+		denied = 0;
+		if (log_policy.log_accepted)
+			audited = 1;
+	}
+	if (audited == 0)
+		return;
+
+	/* we use GFP_ATOMIC so we won't sleep */
+	ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_AVC);
+	if (!ab)
+		return;
+	audit_log_format(ab, "SMACK[%s]:  %s ", a->function, denied ? "denied" : "granted");
+
+	if (a && a->tsk)
+		tsk = a->tsk;
+	if (tsk && tsk->pid) {
+		audit_log_format(ab, " pid=%d comm=", tsk->pid);
+		audit_log_untrustedstring(ab, tsk->comm);
+	}
+	smack_str_from_perm(request_buffer, request);
+	audit_log_format(ab, " subject:'%s' object:'%s' requested:%s ",
+			 subject_label, object_label, request_buffer);
+
+	if (a==NULL)
+		goto audit_log_end;
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
+				audit_log_untrustedstring(ab, dentry->d_name.name);
+			}
+			inode = dentry->d_inode;
+		} else if (a->u.fs.inode) {
+			struct dentry *dentry;
+			inode = a->u.fs.inode;
+			dentry = d_find_alias(inode);
+			if (dentry) {
+				audit_log_format(ab, "name=");
+				audit_log_untrustedstring(ab, dentry->d_name.name);
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
+			       struct inet_sock *inet = inet_sk(sk);
+			       struct ipv6_pinfo *inet6 = inet6_sk(sk);
+
+			       avc_print_ipv6_addr(ab, &inet6->rcv_saddr,
+					       inet->sport,
+					       "laddr", "lport");
+			       avc_print_ipv6_addr(ab, &inet6->daddr,
+					       inet->dport,
+					       "faddr", "fport");
+			       break;
+				       }
+			case AF_UNIX:
+			       u = unix_sk(sk);
+			       if (u->dentry) {
+				       struct path path = {
+					       .dentry = u->dentry,
+					       .mnt = u->mnt
+				       };
+				       audit_log_d_path(ab, "path=",
+						       &path);
+				       break;
+			       }
+			       if (!u->addr)
+				       break;
+			       len = u->addr->len-sizeof(short);
+			       p = &u->addr->name->sun_path[0];
+			       audit_log_format(ab, " path=");
+			       if (*p)
+				       audit_log_untrustedstring(ab, p);
+			       else
+				       audit_log_n_hex(ab, p, len);
+			       break;
+			}
+		}
+
+		switch (a->u.net.family) {
+			case AF_INET:
+				avc_print_ipv4_addr(ab, a->u.net.v4info.saddr,
+						a->u.net.sport,
+						"saddr", ":");
+				avc_print_ipv4_addr(ab, a->u.net.v4info.daddr,
+						a->u.net.dport,
+						"daddr", ":");
+				break;
+			case AF_INET6:
+				avc_print_ipv6_addr(ab, &a->u.net.v6info.saddr,
+						a->u.net.sport,
+						"saddr", ":");
+				avc_print_ipv6_addr(ab, &a->u.net.v6info.daddr,
+						a->u.net.dport,
+						"daddr", ":");
+				break;
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
+		audit_log_format(ab, " key serial=%u", a->u.key);
+		if (a->u.key_desc)
+			audit_log_format(ab, " key desc=%s", a->u.key_desc);
+		break;
+#endif
+	} /* switch (a->type) */
+
+audit_log_end:
+	audit_log_end(ab);
+}
+
+/**
+ * smk_curracc_log : check access of current on olabel
+ * @olabel : label being accessed
+ * @access : access requested
+ * @a	   : pointer to data
+ *
+ * return the same perm return by smk_curacc
+ */
+int smk_curacc_log(char *olabel, int access, struct smack_audit_data *a)
+{
+	int rc;
+	rc = smk_curacc(olabel, access);
+	smack_log(current_security(), olabel, access, rc, a);
+	return rc;
+}
+
+/**
+ * smk_access_log : check access of slabel on olabel
+ * @slabel : subjet label
+ * @olabel : label being accessed
+ * @access : access requested
+ * @a	   : pointer to data
+ *
+ * return the same perm return by smk_access
+ */
+int smk_access_log(char *slabel, char *olabel, int access,
+			struct smack_audit_data *a)
+{
+	int rc;
+	rc = smk_access(slabel, olabel, access);
+	smack_log(slabel, olabel, access, rc, a);
+	return rc;
+}
+
diff --git a/security/smack/smack_logging.h b/security/smack/smack_logging.h
new file mode 100644
index 0000000..1a01574
--- /dev/null
+++ b/security/smack/smack_logging.h
@@ -0,0 +1,97 @@
+/*
+ * Smack logging function
+ * Heavily borrowed from selinux/avc.h
+ *
+ * Author : Etienne BASSET  <etienne.basset@ensta.org>
+ *
+ * All credits to : Stephen Smalley, <sds@epoch.ncsc.mil>
+ * All BUGS to : Etienne BASSET  <etienne.basset@ensta.org>
+ */
+#ifndef _SMACK_LOGGING_
+#define _SMACK_LOGGING_
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
+
+
+struct smack_log_policy {
+	int log_accepted;
+	int log_denied;
+};
+extern struct smack_log_policy log_policy;
+
+
+/* Auxiliary data to use in generating the audit record. */
+struct smack_audit_data {
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
+		key_serial_t key;
+		char *key_desc;
+#endif
+	} u;
+	const char *function;
+};
+
+#define v4info fam.v4
+#define v6info fam.v6
+
+int ipv4_skb_to_auditdata(struct sk_buff *skb,
+                        struct smack_audit_data *ad, u8 *proto);
+
+int ipv6_skb_to_auditdata(struct sk_buff *skb,
+                        struct smack_audit_data *ad, u8 *proto);
+
+/* Initialize an AVC audit data structure. */
+#define SMACK_AUDIT_DATA_INIT(_d, _t) \
+	{ memset((_d), 0, sizeof(struct smack_audit_data)); (_d)->type = AVC_AUDIT_DATA_##_t; (_d)->function = __func__; }
+
+void smack_log(char *subject_label, char *object_label,
+		int request,
+		int result, struct smack_audit_data *auditdata);
+
+int smk_access_log(char *subjectlabel, char *olabel, int access,
+			 struct smack_audit_data *a);
+int smk_curacc_log(char *olabel, int access, struct smack_audit_data *a);
+
+#endif
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0278bc0..6e7af4e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -29,6 +29,7 @@
 #include <linux/audit.h>
 
 #include "smack.h"
+#include "smack_logging.h"
 
 #define task_security(task)	(task_cred_xxx((task), security))
 
@@ -99,14 +100,20 @@ struct inode_smack *new_inode_smack(char *smack)
 static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
 {
 	int rc;
+	struct smack_audit_data ad;
 
 	rc = cap_ptrace_may_access(ctp, mode);
 	if (rc != 0)
 		return rc;
 
+	SMACK_AUDIT_DATA_INIT(&ad, TASK);
+	ad.u.tsk = ctp;
+	/* we won't log here, because rc can be overriden */
 	rc = smk_access(current_security(), task_security(ctp), MAY_READWRITE);
 	if (rc != 0 && capable(CAP_MAC_OVERRIDE))
-		return 0;
+		rc = 0;
+
+	smack_log(current_security(), task_security(ctp), MAY_READWRITE, rc, &ad);
 	return rc;
 }
 
@@ -121,14 +128,20 @@ static int smack_ptrace_may_access(struct task_struct *ctp, unsigned int mode)
 static int smack_ptrace_traceme(struct task_struct *ptp)
 {
 	int rc;
-
+	struct smack_audit_data ad;
 	rc = cap_ptrace_traceme(ptp);
 	if (rc != 0)
 		return rc;
 
+	SMACK_AUDIT_DATA_INIT(&ad, TASK);
+	ad.u.tsk = ptp;
+
+	/* we won't log here, because rc can be overriden */
 	rc = smk_access(task_security(ptp), current_security(), MAY_READWRITE);
 	if (rc != 0 && has_capability(ptp, CAP_MAC_OVERRIDE))
-		return 0;
+		rc = 0;
+
+	smack_log(task_security(ptp), current_security(), MAY_READWRITE, rc, &ad);
 	return rc;
 }
 
@@ -324,8 +337,14 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 static int smack_sb_statfs(struct dentry *dentry)
 {
 	struct superblock_smack *sbp = dentry->d_sb->s_security;
+	struct smack_audit_data ad;
+	int rc;
+
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
 
-	return smk_curacc(sbp->smk_floor, MAY_READ);
+	rc = smk_curacc_log(sbp->smk_floor, MAY_READ, &ad);
+	return rc;
 }
 
 /**
@@ -343,8 +362,12 @@ static int smack_sb_mount(char *dev_name, struct path *path,
 			  char *type, unsigned long flags, void *data)
 {
 	struct superblock_smack *sbp = path->mnt->mnt_sb->s_security;
+	struct smack_audit_data ad;
 
-	return smk_curacc(sbp->smk_floor, MAY_WRITE);
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = path->dentry;
+	ad.u.fs.path.mnt = path->mnt;
+	return smk_curacc_log(sbp->smk_floor, MAY_WRITE, &ad);
 }
 
 /**
@@ -358,10 +381,14 @@ static int smack_sb_mount(char *dev_name, struct path *path,
 static int smack_sb_umount(struct vfsmount *mnt, int flags)
 {
 	struct superblock_smack *sbp;
+	struct smack_audit_data ad;
 
 	sbp = mnt->mnt_sb->s_security;
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = mnt->mnt_mountpoint;
+	ad.u.fs.path.mnt = mnt;
 
-	return smk_curacc(sbp->smk_floor, MAY_WRITE);
+	return smk_curacc_log(sbp->smk_floor, MAY_WRITE, &ad);
 }
 
 /*
@@ -438,15 +465,20 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
 			    struct dentry *new_dentry)
 {
-	int rc;
 	char *isp;
+	struct smack_audit_data ad;
+	int rc;
+
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = old_dentry;
 
 	isp = smk_of_inode(old_dentry->d_inode);
-	rc = smk_curacc(isp, MAY_WRITE);
+	rc = smk_curacc_log(isp, MAY_WRITE, &ad);
 
 	if (rc == 0 && new_dentry->d_inode != NULL) {
 		isp = smk_of_inode(new_dentry->d_inode);
-		rc = smk_curacc(isp, MAY_WRITE);
+		ad.u.fs.path.dentry = new_dentry;
+		rc = smk_curacc_log(isp, MAY_WRITE, &ad);
 	}
 
 	return rc;
@@ -463,18 +495,24 @@ static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
 static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *ip = dentry->d_inode;
+	struct smack_audit_data ad;
 	int rc;
 
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
+
 	/*
 	 * You need write access to the thing you're unlinking
 	 */
-	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE);
-	if (rc == 0)
+	rc = smk_curacc_log(smk_of_inode(ip), MAY_WRITE, &ad);
+	if (rc == 0) {
 		/*
 		 * You also need write access to the containing directory
 		 */
-		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
-
+		ad.u.fs.path.dentry = NULL;
+		ad.u.fs.inode = dir;
+		rc = smk_curacc_log(smk_of_inode(dir), MAY_WRITE, &ad);
+	}
 	return rc;
 }
 
@@ -488,17 +526,24 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
  */
 static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct smack_audit_data ad;
 	int rc;
 
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
+
 	/*
 	 * You need write access to the thing you're removing
 	 */
-	rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
-	if (rc == 0)
+	rc = smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
+	if (rc == 0) {
 		/*
 		 * You also need write access to the containing directory
 		 */
-		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE);
+		ad.u.fs.path.dentry = NULL;
+		ad.u.fs.inode = dir;
+		rc = smk_curacc_log(smk_of_inode(dir), MAY_WRITE, &ad);
+	}
 
 	return rc;
 }
@@ -522,15 +567,19 @@ static int smack_inode_rename(struct inode *old_inode,
 {
 	int rc;
 	char *isp;
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = old_dentry;
 
 	isp = smk_of_inode(old_dentry->d_inode);
-	rc = smk_curacc(isp, MAY_READWRITE);
+	rc = smk_curacc_log(isp, MAY_READWRITE, &ad);
 
 	if (rc == 0 && new_dentry->d_inode != NULL) {
 		isp = smk_of_inode(new_dentry->d_inode);
-		rc = smk_curacc(isp, MAY_READWRITE);
+		ad.u.fs.path.dentry = new_dentry;
+		rc = smk_curacc_log(isp, MAY_READWRITE, &ad);
 	}
-
 	return rc;
 }
 
@@ -546,14 +595,16 @@ static int smack_inode_rename(struct inode *old_inode,
  */
 static int smack_inode_permission(struct inode *inode, int mask)
 {
+	struct smack_audit_data ad;
 	/*
 	 * No permission to check. Existence test. Yup, it's there.
 	 */
 	if (mask == 0)
 		return 0;
-
-	return smk_curacc(smk_of_inode(inode), mask);
-}
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.inode = inode;
+	return smk_curacc_log(smk_of_inode(inode), mask, &ad);
+ }
 
 /**
  * smack_inode_setattr - Smack check for setting attributes
@@ -564,13 +615,15 @@ static int smack_inode_permission(struct inode *inode, int mask)
  */
 static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
+	struct smack_audit_data ad;
 	/*
 	 * Need to allow for clearing the setuid bit.
 	 */
 	if (iattr->ia_valid & ATTR_FORCE)
 		return 0;
-
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
+	return smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
 }
 
 /**
@@ -582,7 +635,12 @@ static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
  */
 static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
+	ad.u.fs.path.mnt = mnt;
+	return smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_READ, &ad);
 }
 
 /**
@@ -600,6 +658,7 @@ static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 				const void *value, size_t size, int flags)
 {
+	struct smack_audit_data ad;
 	int rc = 0;
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
@@ -610,8 +669,10 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
 
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
 	if (rc == 0)
-		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+		rc = smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
 
 	return rc;
 }
@@ -666,7 +727,11 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
  */
 static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 {
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
+	return smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_READ, &ad);
 }
 
 /*
@@ -680,6 +745,7 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
  */
 static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 {
+	struct smack_audit_data ad;
 	int rc = 0;
 
 	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
@@ -690,8 +756,10 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	} else
 		rc = cap_inode_removexattr(dentry, name);
 
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = dentry;
 	if (rc == 0)
-		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+		rc = smk_curacc_log(smk_of_inode(dentry->d_inode), MAY_WRITE, &ad);
 
 	return rc;
 }
@@ -851,12 +919,16 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
 	int rc = 0;
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path = file->f_path;
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-		rc = smk_curacc(file->f_security, MAY_WRITE);
+		rc = smk_curacc_log(file->f_security, MAY_WRITE, &ad);
 
 	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ))
-		rc = smk_curacc(file->f_security, MAY_READ);
+		rc = smk_curacc_log(file->f_security, MAY_READ, &ad);
 
 	return rc;
 }
@@ -870,7 +942,11 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
  */
 static int smack_file_lock(struct file *file, unsigned int cmd)
 {
-	return smk_curacc(file->f_security, MAY_WRITE);
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path.dentry = file->f_path.dentry;
+	return smk_curacc_log(file->f_security, MAY_WRITE, &ad);
 }
 
 /**
@@ -884,8 +960,12 @@ static int smack_file_lock(struct file *file, unsigned int cmd)
 static int smack_file_fcntl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
+	struct smack_audit_data ad;
 	int rc;
 
+	SMACK_AUDIT_DATA_INIT(&ad, FS);
+	ad.u.fs.path = file->f_path;
+
 	switch (cmd) {
 	case F_DUPFD:
 	case F_GETFD:
@@ -893,7 +973,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 	case F_GETLK:
 	case F_GETOWN:
 	case F_GETSIG:
-		rc = smk_curacc(file->f_security, MAY_READ);
+		rc = smk_curacc_log(file->f_security, MAY_READ, &ad);
 		break;
 	case F_SETFD:
 	case F_SETFL:
@@ -901,10 +981,10 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 	case F_SETLKW:
 	case F_SETOWN:
 	case F_SETSIG:
-		rc = smk_curacc(file->f_security, MAY_WRITE);
+		rc = smk_curacc_log(file->f_security, MAY_WRITE, &ad);
 		break;
 	default:
-		rc = smk_curacc(file->f_security, MAY_READWRITE);
+		rc = smk_curacc_log(file->f_security, MAY_READWRITE, &ad);
 	}
 
 	return rc;
@@ -939,14 +1019,20 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 {
 	struct file *file;
 	int rc;
+	struct smack_audit_data ad;
 
 	/*
 	 * struct fown_struct is never outside the context of a struct file
 	 */
 	file = container_of(fown, struct file, f_owner);
+	/* we don't log here as rc can be overriden */
 	rc = smk_access(file->f_security, tsk->cred->security, MAY_WRITE);
 	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
 		return 0;
+
+	SMACK_AUDIT_DATA_INIT(&ad, TASK);
+	ad.u.tsk = tsk;
+	smack_log(file->f_security, tsk->cred->security, MAY_WRITE, rc, &ad);
 	return rc;
 }
 
@@ -959,7 +1045,10 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 static int smack_file_receive(struct file *file)
 {
 	int may = 0;
+	struct smack_audit_data ad;
 
+	SMACK_AUDIT_DATA_INIT(&ad, TASK);
+	ad.u.fs.path = file->f_path;
 	/*
 	 * This code relies on bitmasks.
 	 */
@@ -968,7 +1057,7 @@ static int smack_file_receive(struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		may |= MAY_WRITE;
 
-	return smk_curacc(file->f_security, may);
+	return smk_curacc_log(file->f_security, may, &ad);
 }
 
 /*
@@ -1048,6 +1137,22 @@ static int smack_kernel_create_files_as(struct cred *new,
 }
 
 /**
+ * smk_curacc_on_task - helper to log task related access
+ * @p: the task object
+ * @access : the access requested
+ *
+ * Return 0 if access is permitted
+ */
+static int smk_curacc_on_task(struct task_struct *p, int access)
+{
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, TASK);
+	ad.u.tsk = p;
+	return smk_curacc_log(task_security(p), access, &ad);
+}
+
+/**
  * smack_task_setpgid - Smack check on setting pgid
  * @p: the task object
  * @pgid: unused
@@ -1056,7 +1161,7 @@ static int smack_kernel_create_files_as(struct cred *new,
  */
 static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
 {
-	return smk_curacc(task_security(p), MAY_WRITE);
+	return smk_curacc_on_task(p, MAY_WRITE);
 }
 
 /**
@@ -1067,7 +1172,7 @@ static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
  */
 static int smack_task_getpgid(struct task_struct *p)
 {
-	return smk_curacc(task_security(p), MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ);
 }
 
 /**
@@ -1078,7 +1183,7 @@ static int smack_task_getpgid(struct task_struct *p)
  */
 static int smack_task_getsid(struct task_struct *p)
 {
-	return smk_curacc(task_security(p), MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ);
 }
 
 /**
@@ -1106,7 +1211,7 @@ static int smack_task_setnice(struct task_struct *p, int nice)
 
 	rc = cap_task_setnice(p, nice);
 	if (rc == 0)
-		rc = smk_curacc(task_security(p), MAY_WRITE);
+		rc = smk_curacc_on_task(p, MAY_WRITE);
 	return rc;
 }
 
@@ -1123,7 +1228,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
 
 	rc = cap_task_setioprio(p, ioprio);
 	if (rc == 0)
-		rc = smk_curacc(task_security(p), MAY_WRITE);
+		rc = smk_curacc_on_task(p, MAY_WRITE);
 	return rc;
 }
 
@@ -1135,7 +1240,7 @@ static int smack_task_setioprio(struct task_struct *p, int ioprio)
  */
 static int smack_task_getioprio(struct task_struct *p)
 {
-	return smk_curacc(task_security(p), MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ);
 }
 
 /**
@@ -1153,7 +1258,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
 
 	rc = cap_task_setscheduler(p, policy, lp);
 	if (rc == 0)
-		rc = smk_curacc(task_security(p), MAY_WRITE);
+		rc = smk_curacc_on_task(p, MAY_WRITE);
 	return rc;
 }
 
@@ -1165,7 +1270,7 @@ static int smack_task_setscheduler(struct task_struct *p, int policy,
  */
 static int smack_task_getscheduler(struct task_struct *p)
 {
-	return smk_curacc(task_security(p), MAY_READ);
+	return smk_curacc_on_task(p, MAY_READ);
 }
 
 /**
@@ -1176,7 +1281,7 @@ static int smack_task_getscheduler(struct task_struct *p)
  */
 static int smack_task_movememory(struct task_struct *p)
 {
-	return smk_curacc(task_security(p), MAY_WRITE);
+	return smk_curacc_on_task(p, MAY_WRITE);
 }
 
 /**
@@ -1194,18 +1299,23 @@ static int smack_task_movememory(struct task_struct *p)
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 			   int sig, u32 secid)
 {
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, TASK);
+	ad.u.tsk = p;
 	/*
 	 * Sending a signal requires that the sender
 	 * can write the receiver.
 	 */
 	if (secid == 0)
-		return smk_curacc(task_security(p), MAY_WRITE);
+		return smk_curacc_log(task_security(p), MAY_WRITE, &ad);
 	/*
 	 * If the secid isn't 0 we're dealing with some USB IO
 	 * specific behavior. This is not clean. For one thing
 	 * we can't take privilege into account.
 	 */
-	return smk_access(smack_from_secid(secid), task_security(p), MAY_WRITE);
+	return smk_access_log(smack_from_secid(secid), task_security(p),
+				 MAY_WRITE, &ad);
 }
 
 /**
@@ -1216,12 +1326,13 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
  */
 static int smack_task_wait(struct task_struct *p)
 {
+	struct smack_audit_data ad;
 	int rc;
 
+	/* we don't log here, we can be overriden */
 	rc = smk_access(current_security(), task_security(p), MAY_WRITE);
 	if (rc == 0)
-		return 0;
-
+		goto out_log;
 	/*
 	 * Allow the operation to succeed if either task
 	 * has privilege to perform operations that might
@@ -1235,7 +1346,11 @@ static int smack_task_wait(struct task_struct *p)
 	 */
 	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
 		return 0;
-
+	/* we log only if we didn't get overriden */
+ out_log:
+	SMACK_AUDIT_DATA_INIT(&ad, TASK);
+	ad.u.tsk = p;
+	smack_log(current_security(), task_security(p), MAY_WRITE, rc, &ad);
 	return rc;
 }
 
@@ -1567,22 +1682,30 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 {
 	struct socket_smack *ssp = sock->sk->sk_security;
 	char *hostsp;
+	struct smack_audit_data ad;
+	struct sockaddr_in *sin;
 	int rc;
 
+
 	if (sock->sk == NULL || sock->sk->sk_family != PF_INET)
 		return 0;
 
 	if (addrlen < sizeof(struct sockaddr_in))
 		return -EINVAL;
-
-	hostsp = smack_host_label((struct sockaddr_in *)sap);
+	sin = (struct sockaddr_in *)sap;
+	hostsp = smack_host_label(sin);
 	if (hostsp == NULL) {
 		if (ssp->smk_labeled != SMACK_CIPSO_SOCKET)
 			return smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
 		return 0;
 	}
+	SMACK_AUDIT_DATA_INIT(&ad, NET);
+	ad.u.net.family = sock->sk->sk_family;
+	ad.u.net.v4info.daddr = sin->sin_addr.s_addr;
+	ad.u.net.dport  = sin->sin_port;
+
+	rc = smk_access_log(ssp->smk_out, hostsp, MAY_WRITE, &ad);
 
-	rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE);
 	if (rc != 0)
 		return rc;
 
@@ -1673,6 +1796,23 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
 }
 
 /**
+ * smk_curacc_shm : check if current has access on shm
+ * @shp : the object
+ * @access : access requested
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smk_curacc_shm(struct shmid_kernel *shp, int access)
+{
+	char *ssp = smack_of_shm(shp);
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, IPC);
+	ad.u.ipc_id = shp->shm_perm.id;
+	return smk_curacc_log(ssp, access, &ad);
+}
+
+/**
  * smack_shm_associate - Smack access check for shm
  * @shp: the object
  * @shmflg: access requested
@@ -1681,11 +1821,10 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
  */
 static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
 {
-	char *ssp = smack_of_shm(shp);
 	int may;
 
 	may = smack_flags_to_may(shmflg);
-	return smk_curacc(ssp, may);
+	return smk_curacc_shm(shp, may);
 }
 
 /**
@@ -1697,7 +1836,6 @@ static int smack_shm_associate(struct shmid_kernel *shp, int shmflg)
  */
 static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 {
-	char *ssp;
 	int may;
 
 	switch (cmd) {
@@ -1720,9 +1858,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 	default:
 		return -EINVAL;
 	}
-
-	ssp = smack_of_shm(shp);
-	return smk_curacc(ssp, may);
+	return smk_curacc_shm(shp, may);
 }
 
 /**
@@ -1736,11 +1872,10 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
 			   int shmflg)
 {
-	char *ssp = smack_of_shm(shp);
 	int may;
 
 	may = smack_flags_to_may(shmflg);
-	return smk_curacc(ssp, may);
+	return smk_curacc_shm(shp, may);
 }
 
 /**
@@ -1782,6 +1917,23 @@ static void smack_sem_free_security(struct sem_array *sma)
 }
 
 /**
+ * smk_curacc_sem : check if current has access on sem
+ * @sma : the object
+ * @access : access requested
+ *
+ * Returns 0 if current has the requested access, error code otherwise
+ */
+static int smk_curacc_sem(struct sem_array *sma, int access)
+{
+	char *ssp = smack_of_sem(sma);
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, IPC);
+	ad.u.ipc_id = sma->sem_perm.id;
+	return smk_curacc_log(ssp, access, &ad);
+}
+
+/**
  * smack_sem_associate - Smack access check for sem
  * @sma: the object
  * @semflg: access requested
@@ -1790,11 +1942,10 @@ static void smack_sem_free_security(struct sem_array *sma)
  */
 static int smack_sem_associate(struct sem_array *sma, int semflg)
 {
-	char *ssp = smack_of_sem(sma);
 	int may;
 
 	may = smack_flags_to_may(semflg);
-	return smk_curacc(ssp, may);
+	return smk_curacc_sem(sma, may);
 }
 
 /**
@@ -1806,7 +1957,6 @@ static int smack_sem_associate(struct sem_array *sma, int semflg)
  */
 static int smack_sem_semctl(struct sem_array *sma, int cmd)
 {
-	char *ssp;
 	int may;
 
 	switch (cmd) {
@@ -1835,8 +1985,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
 		return -EINVAL;
 	}
 
-	ssp = smack_of_sem(sma);
-	return smk_curacc(ssp, may);
+	return smk_curacc_sem(sma, may);
 }
 
 /**
@@ -1853,9 +2002,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
 static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
 			   unsigned nsops, int alter)
 {
-	char *ssp = smack_of_sem(sma);
-
-	return smk_curacc(ssp, MAY_READWRITE);
+	return smk_curacc_sem(sma, MAY_READWRITE);
 }
 
 /**
@@ -1897,6 +2044,23 @@ static char *smack_of_msq(struct msg_queue *msq)
 }
 
 /**
+ * smk_curacc_msq : helper to check if current has access on msq
+ * @msq : the msq
+ * @access : access requested
+ *
+ * return 0 if current has access, error otherwise
+ */
+static int smk_curacc_msq(struct msg_queue *msq, int access)
+{
+	char *msp = smack_of_msq(msq);
+	struct smack_audit_data ad;
+
+	SMACK_AUDIT_DATA_INIT(&ad, IPC);
+	ad.u.ipc_id = msq->q_perm.id;
+	return smk_curacc_log(msp, access, &ad);
+}
+
+/**
  * smack_msg_queue_associate - Smack access check for msg_queue
  * @msq: the object
  * @msqflg: access requested
@@ -1905,11 +2069,10 @@ static char *smack_of_msq(struct msg_queue *msq)
  */
 static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
 {
-	char *msp = smack_of_msq(msq);
 	int may;
 
 	may = smack_flags_to_may(msqflg);
-	return smk_curacc(msp, may);
+	return smk_curacc_msq(msq, may);
 }
 
 /**
@@ -1921,7 +2084,6 @@ static int smack_msg_queue_associate(struct msg_queue *msq, int msqflg)
  */
 static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 {
-	char *msp;
 	int may;
 
 	switch (cmd) {
@@ -1943,8 +2105,7 @@ static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 		return -EINVAL;
 	}
 
-	msp = smack_of_msq(msq);
-	return smk_curacc(msp, may);
+	return smk_curacc_msq(msq, may);
 }
 
 /**
@@ -1958,11 +2119,10 @@ static int smack_msg_queue_msgctl(struct msg_queue *msq, int cmd)
 static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 				  int msqflg)
 {
-	char *msp = smack_of_msq(msq);
-	int rc;
+	int may;
 
-	rc = smack_flags_to_may(msqflg);
-	return smk_curacc(msp, rc);
+	may = smack_flags_to_may(msqflg);
+	return smk_curacc_msq(msq, may);
 }
 
 /**
@@ -1978,9 +2138,7 @@ static int smack_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
 static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 			struct task_struct *target, long type, int mode)
 {
-	char *msp = smack_of_msq(msq);
-
-	return smk_curacc(msp, MAY_READWRITE);
+	return smk_curacc_msq(msq, MAY_READWRITE);
 }
 
 /**
@@ -1993,10 +2151,13 @@ static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
 static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 {
 	char *isp = ipp->security;
+	struct smack_audit_data ad;
 	int may;
+	SMACK_AUDIT_DATA_INIT(&ad, IPC);
+	ad.u.ipc_id = ipp->id;
 
 	may = smack_flags_to_may(flag);
-	return smk_curacc(isp, may);
+	return smk_curacc_log(isp, may, &ad);
 }
 
 /**
@@ -2255,8 +2416,12 @@ static int smack_unix_stream_connect(struct socket *sock,
 {
 	struct inode *sp = SOCK_INODE(sock);
 	struct inode *op = SOCK_INODE(other);
+	struct smack_audit_data ad;
 
-	return smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_READWRITE);
+	SMACK_AUDIT_DATA_INIT(&ad, NET);
+	ad.u.net.sk = other->sk;
+	return smk_access_log(smk_of_inode(sp), smk_of_inode(op),
+				 MAY_READWRITE, &ad);
 }
 
 /**
@@ -2271,8 +2436,12 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 {
 	struct inode *sp = SOCK_INODE(sock);
 	struct inode *op = SOCK_INODE(other);
+	struct smack_audit_data ad;
 
-	return smk_access(smk_of_inode(sp), smk_of_inode(op), MAY_WRITE);
+	SMACK_AUDIT_DATA_INIT(&ad, NET);
+	ad.u.net.sk = other->sk;
+	return smk_access_log(smk_of_inode(sp), smk_of_inode(op),
+				 MAY_WRITE, &ad);
 }
 
 /**
@@ -2292,6 +2461,7 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct socket_smack *ssp = sock->sk->sk_security;
 	char *hostsp;
 	int rc;
+	struct smack_audit_data ad;
 
 	/*
 	 * Perfectly reasonable for this to be NULL
@@ -2305,8 +2475,12 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 			return smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
 		return 0;
 	}
+	SMACK_AUDIT_DATA_INIT(&ad, NET);
+	ad.u.net.family = sip->sin_family;
+	ad.u.net.dport = sip->sin_port;
+	ad.u.net.v4info.daddr = sip->sin_addr.s_addr;
 
-	rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE);
+	rc = smk_access_log(ssp->smk_out, hostsp, MAY_WRITE, &ad);
 	if (rc != 0)
 		return rc;
 
@@ -2314,7 +2488,6 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 		return smack_netlabel(sock->sk, SMACK_UNLABELED_SOCKET);
 
 	return 0;
-
 }
 
 
@@ -2405,6 +2578,7 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	struct socket_smack *ssp = sk->sk_security;
 	char smack[SMK_LABELLEN];
 	char *csp;
+	struct smack_audit_data ad;
 	int rc;
 
 	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
@@ -2424,13 +2598,17 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	netlbl_secattr_destroy(&secattr);
 
+	SMACK_AUDIT_DATA_INIT(&ad, NET);
+	ad.u.net.family = sk->sk_family;
+	ad.u.net.netif = skb->iif;
+	ipv4_skb_to_auditdata(skb, &ad, NULL);
 	/*
 	 * Receiving a packet requires that the other end
 	 * be able to write here. Read access is not required.
 	 * This is the simplist possible security model
 	 * for networking.
 	 */
-	rc = smk_access(csp, ssp->smk_in, MAY_WRITE);
+	rc = smk_access_log(csp, ssp->smk_in, MAY_WRITE, &ad);
 	if (rc != 0)
 		netlbl_skbuff_err(skb, rc, 0);
 	return rc;
@@ -2638,6 +2816,7 @@ static int smack_key_permission(key_ref_t key_ref,
 				const struct cred *cred, key_perm_t perm)
 {
 	struct key *keyp;
+	struct smack_audit_data ad;
 
 	keyp = key_ref_to_ptr(key_ref);
 	if (keyp == NULL)
@@ -2653,8 +2832,11 @@ static int smack_key_permission(key_ref_t key_ref,
 	 */
 	if (cred->security == NULL)
 		return -EACCES;
+	SMACK_AUDIT_DATA_INIT(&ad, KEY);
+	ad.u.key = keyp->serial;
+	ad.u.key_desc = keyp->description;
 
-	return smk_access(cred->security, keyp->security, MAY_READWRITE);
+	return smk_access_log(cred->security, keyp->security, MAY_READWRITE, &ad);
 }
 #endif /* CONFIG_KEYS */
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 8e42800..923223f 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <linux/audit.h>
 #include "smack.h"
+#include "smack_logging.h"
 
 /*
  * smackfs pseudo filesystem.
@@ -41,6 +42,7 @@ enum smk_inos {
 	SMK_AMBIENT	= 7,	/* internet ambient label */
 	SMK_NETLBLADDR	= 8,	/* single label hosts */
 	SMK_ONLYCAP	= 9,	/* the only "capable" label */
+	SMK_LOGGING	= 10,	/* logging */
 };
 
 /*
@@ -1112,6 +1114,54 @@ static const struct file_operations smk_onlycap_ops = {
 	.write		= smk_write_onlycap,
 };
 
+
+static ssize_t smk_read_logging(struct file *filp, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char temp[32];
+	ssize_t rc;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(temp, "%d\n",
+		 log_policy.log_denied + log_policy.log_accepted*2);
+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+	return rc;
+}
+
+static ssize_t smk_write_logging(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char temp[32];
+	int i;
+
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	if (count >= sizeof(temp) || count == 0)
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	temp[count] = '\0';
+
+	if (sscanf(temp, "%d", &i) != 1)
+		return -EINVAL;
+	if (i < 0 || i > 3)
+		return -EINVAL;
+	log_policy.log_denied   = i & 1;
+	log_policy.log_accepted = (i & 2) >> 1 ;
+	return count;
+}
+
+
+
+static const struct file_operations smk_logging_ops = {
+	.read		= smk_read_logging,
+	.write		= smk_write_logging,
+};
 /**
  * smk_fill_super - fill the /smackfs superblock
  * @sb: the empty superblock
@@ -1142,6 +1192,8 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 			{"netlabel", &smk_netlbladdr_ops, S_IRUGO|S_IWUSR},
 		[SMK_ONLYCAP]	=
 			{"onlycap", &smk_onlycap_ops, S_IRUGO|S_IWUSR},
+		[SMK_LOGGING]	=
+			{"logging", &smk_logging_ops, S_IRUGO|S_IWUSR},
 		/* last one */ {""}
 	};
 

