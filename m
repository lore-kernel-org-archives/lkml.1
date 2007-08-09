Return-Path: <linux-kernel-owner+w=401wt.eu-S938292AbXHIQg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938292AbXHIQg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763860AbXHIQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:36:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbXHIQgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:36:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/14] CacheFiles: Get the SID under which the CacheFiles
	module should operate [try #2]
To: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no
Cc: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Aug 2007 17:05:40 +0100
Message-ID: <20070809160540.17906.72214.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
References: <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get the SID under which the CacheFiles module should operate so that the
SELinux security system can control the accesses it makes.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/security.h |   20 ++++++++++++++++++++
 security/dummy.c         |    7 +++++++
 security/selinux/hooks.c |    7 +++++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 21cadea..9cb417e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1164,6 +1164,14 @@ struct request_sock;
  *      owning security ID, and return the security ID as which the process was
  *      previously acting.
  *
+ * @cachefiles_get_secid:
+ *	Determine the security ID for the CacheFiles module to use when
+ *	accessing the filesystem containing the cache.
+ *	@secid contains the security ID under which cachefiles daemon is
+ *      running.
+ *	@modsecid contains the pointer to where the security ID for the module
+ *	is to be stored.
+ *
  * This is the main security structure.
  */
 struct security_operations {
@@ -1352,6 +1360,7 @@ struct security_operations {
 	u32 (*set_fscreate_secid)(u32 secid);
 	u32 (*act_as_secid)(u32 secid);
 	u32 (*act_as_self)(void);
+	int (*cachefiles_get_secid)(u32 secid, u32 *modsecid);
 
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect) (struct socket * sock,
@@ -2176,6 +2185,11 @@ static inline u32 security_act_as_self(void)
 	return security_ops->act_as_self();
 }
 
+static inline int security_cachefiles_get_secid(u32 secid, u32 *modsecid)
+{
+	return security_ops->cachefiles_get_secid(secid, modsecid);
+}
+
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
@@ -2883,6 +2897,12 @@ static inline u32 security_act_as_self(void)
 	return 0;
 }
 
+static inline int security_cachefiles_get_secid(u32 secid, u32 *modsecid)
+{
+	*modsecid = 0;
+	return 0;
+}
+
 #endif	/* CONFIG_SECURITY */
 
 #ifdef CONFIG_SECURITY_NETWORK
diff --git a/security/dummy.c b/security/dummy.c
index 6a7a317..2c1fd16 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -955,6 +955,12 @@ static u32 dummy_act_as_self(void)
 	return 0;
 }
 
+static int dummy_cachefiles_get_secid(u32 secid, u32 *modsecid)
+{
+	*modsecid = 0;
+	return 0;
+}
+
 #ifdef CONFIG_KEYS
 static inline int dummy_key_alloc(struct key *key, struct task_struct *ctx,
 				  unsigned long flags)
@@ -1114,6 +1120,7 @@ void security_fixup_ops (struct security_operations *ops)
  	set_to_dummy_if_null(ops, set_fscreate_secid);
  	set_to_dummy_if_null(ops, act_as_secid);
  	set_to_dummy_if_null(ops, act_as_self);
+ 	set_to_dummy_if_null(ops, cachefiles_get_secid);
 #ifdef CONFIG_SECURITY_NETWORK
 	set_to_dummy_if_null(ops, unix_stream_connect);
 	set_to_dummy_if_null(ops, unix_may_send);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c05d662..725f657 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4718,6 +4718,12 @@ static u32 selinux_act_as_self(void)
 	return oldactor_sid;
 }
 
+static int selinux_cachefiles_get_secid(u32 secid, u32 *modsecid)
+{
+	return security_transition_sid(secid, SECINITSID_KERNEL,
+				       SECCLASS_PROCESS, modsecid);
+}
+
 #ifdef CONFIG_KEYS
 
 static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
@@ -4905,6 +4911,7 @@ static struct security_operations selinux_ops = {
 	.set_fscreate_secid =		selinux_set_fscreate_secid,
 	.act_as_secid =			selinux_act_as_secid,
 	.act_as_self =			selinux_act_as_self,
+	.cachefiles_get_secid =		selinux_cachefiles_get_secid,
 
         .unix_stream_connect =		selinux_socket_unix_stream_connect,
 	.unix_may_send =		selinux_socket_unix_may_send,

