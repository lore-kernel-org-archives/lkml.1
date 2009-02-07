Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZBGW77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZBGW77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 17:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZBGW7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 17:59:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:15046 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZBGW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 17:59:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TmX2s2aKIoUyQ00IdCEMZhPHWWiTkHndhPWBWwpoBAQGGnyXNScX7hoPoSyypyusdk
         NMljfhk2S2yGxymTDVEA9ykhUfEXT6USVKWf9C8BSqs7kQGhWNGVrZiS4tmeCcJkV9Yq
         1eQfzl0dfiSYHkSnbl59WO84g6km83ucAAsPo=
Date: Sun, 8 Feb 2009 02:05:53 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sysctl: really empty ->strategy
Message-ID: <20090207230553.GB4067@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stub ->strategy hooks to NULL if SYSCTL_SYSCALL=n to save some space.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/sysctl.h     |   10 +++++++--
 include/net/ndisc.h        |    4 +++
 kernel/sysctl.c            |   48 ++++-----------------------------------------
 net/ipv4/route.c           |    4 +++
 net/ipv4/sysctl_net_ipv4.c |   13 +++++++++++-
 net/ipv6/ndisc.c           |    5 ++--
 6 files changed, 36 insertions(+), 48 deletions(-)

--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -999,13 +999,19 @@ extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 extern int do_sysctl (int __user *name, int nlen,
 		      void __user *oldval, size_t __user *oldlenp,
 		      void __user *newval, size_t newlen);
-
+#ifdef CONFIG_SYSCTL_SYSCALL
 extern ctl_handler sysctl_data;
 extern ctl_handler sysctl_string;
 extern ctl_handler sysctl_intvec;
 extern ctl_handler sysctl_jiffies;
 extern ctl_handler sysctl_ms_jiffies;
-
+#else
+#define sysctl_data		NULL
+#define sysctl_string		NULL
+#define sysctl_intvec		NULL
+#define sysctl_jiffies		NULL
+#define sysctl_ms_jiffies	NULL
+#endif
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -143,9 +143,13 @@ extern int 			ndisc_ifinfo_sysctl_change(struct ctl_table *ctl,
 							   void __user *buffer,
 							   size_t *lenp,
 							   loff_t *ppos);
+#ifdef CONFIG_SYSCTL_SYSCALL
 int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl,
 				 void __user *oldval, size_t __user *oldlenp,
 				 void __user *newval, size_t newlen);
+#else
+#define ndisc_ifinfo_sysctl_strategy NULL
+#endif
 #endif
 
 extern void 			inet6_ifinfo_notify(int event,
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2842,6 +2842,7 @@ int sysctl_data(struct ctl_table *table,
 	}
 	return 1;
 }
+EXPORT_SYMBOL(sysctl_data);
 
 /* The generic string strategy routine: */
 int sysctl_string(struct ctl_table *table,
@@ -2884,6 +2885,7 @@ int sysctl_string(struct ctl_table *table,
 	}
 	return 1;
 }
+EXPORT_SYMBOL(sysctl_string);
 
 /*
  * This function makes sure that all of the integers in the vector
@@ -2924,6 +2926,7 @@ int sysctl_intvec(struct ctl_table *table,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(sysctl_intvec);
 
 /* Strategy function to convert jiffies to seconds */ 
 int sysctl_jiffies(struct ctl_table *table,
@@ -2958,6 +2961,7 @@ int sysctl_jiffies(struct ctl_table *table,
 	}
 	return 1;
 }
+EXPORT_SYMBOL(sysctl_jiffies);
 
 /* Strategy function to convert jiffies to seconds */ 
 int sysctl_ms_jiffies(struct ctl_table *table,
@@ -2992,8 +2996,7 @@ int sysctl_ms_jiffies(struct ctl_table *table,
 	}
 	return 1;
 }
-
-
+EXPORT_SYMBOL(sysctl_ms_jiffies);
 
 #else /* CONFIG_SYSCTL_SYSCALL */
 
@@ -3014,42 +3017,6 @@ SYSCALL_DEFINE1(sysctl, struct __sysctl_args __user *, args)
 
 	return error;
 }
-
-int sysctl_data(struct ctl_table *table,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_string(struct ctl_table *table,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_intvec(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_jiffies(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
-int sysctl_ms_jiffies(struct ctl_table *table,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
 static int deprecated_sysctl_warning(struct __sysctl_args *args)
@@ -3097,9 +3064,4 @@ EXPORT_SYMBOL(proc_doulongvec_minmax);
 EXPORT_SYMBOL(proc_doulongvec_ms_jiffies_minmax);
 EXPORT_SYMBOL(register_sysctl_table);
 EXPORT_SYMBOL(register_sysctl_paths);
-EXPORT_SYMBOL(sysctl_intvec);
-EXPORT_SYMBOL(sysctl_jiffies);
-EXPORT_SYMBOL(sysctl_ms_jiffies);
-EXPORT_SYMBOL(sysctl_string);
-EXPORT_SYMBOL(sysctl_data);
 EXPORT_SYMBOL(unregister_sysctl_table);
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3095,6 +3095,7 @@ static int ipv4_sysctl_rt_secret_interval(ctl_table *ctl, int write,
 	return ret;
 }
 
+#ifdef CONFIG_SYSCTL_SYSCALL
 static int ipv4_sysctl_rt_secret_interval_strategy(ctl_table *table,
 						   void __user *oldval,
 						   size_t __user *oldlenp,
@@ -3108,6 +3109,9 @@ static int ipv4_sysctl_rt_secret_interval_strategy(ctl_table *table,
 
 	return ret;
 }
+#else
+#define ipv4_sysctl_rt_secret_interval_strategy NULL
+#endif
 
 static ctl_table ipv4_route_table[] = {
 	{
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -63,6 +63,7 @@ static int ipv4_local_port_range(ctl_table *table, int write, struct file *filp,
 	return ret;
 }
 
+#ifdef CONFIG_SYSCTL_SYSCALL
 /* Validate changes from sysctl interface. */
 static int ipv4_sysctl_local_port_range(ctl_table *table,
 					 void __user *oldval,
@@ -89,7 +90,9 @@ static int ipv4_sysctl_local_port_range(ctl_table *table,
 	}
 	return ret;
 }
-
+#else
+#define ipv4_sysctl_local_port_range NULL
+#endif
 
 static int proc_tcp_congestion_control(ctl_table *ctl, int write, struct file * filp,
 				       void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -109,6 +112,7 @@ static int proc_tcp_congestion_control(ctl_table *ctl, int write, struct file *
 	return ret;
 }
 
+#ifdef CONFIG_SYSCTL_SYSCALL
 static int sysctl_tcp_congestion_control(ctl_table *table,
 					 void __user *oldval,
 					 size_t __user *oldlenp,
@@ -127,6 +131,9 @@ static int sysctl_tcp_congestion_control(ctl_table *table,
 		ret = tcp_set_default_congestion_control(val);
 	return ret;
 }
+#else
+#define sysctl_tcp_congestion_control NULL
+#endif
 
 static int proc_tcp_available_congestion_control(ctl_table *ctl,
 						 int write, struct file * filp,
@@ -165,6 +172,7 @@ static int proc_allowed_congestion_control(ctl_table *ctl,
 	return ret;
 }
 
+#ifdef CONFIG_SYSCTL_SYSCALL
 static int strategy_allowed_congestion_control(ctl_table *table,
 					       void __user *oldval,
 					       size_t __user *oldlenp,
@@ -187,6 +195,9 @@ static int strategy_allowed_congestion_control(ctl_table *table,
 	return ret;
 
 }
+#else
+#define strategy_allowed_congestion_control NULL
+#endif
 
 static struct ctl_table ipv4_table[] = {
 	{
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1770,6 +1770,7 @@ int ndisc_ifinfo_sysctl_change(struct ctl_table *ctl, int write, struct file * f
 	return ret;
 }
 
+#ifdef CONFIG_SYSCTL_SYSCALL
 int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl,
 				 void __user *oldval, size_t __user *oldlenp,
 				 void __user *newval, size_t newlen)
@@ -1806,7 +1807,7 @@ int ndisc_ifinfo_sysctl_strategy(ctl_table *ctl,
 
 	return ret;
 }
-
+#endif
 #endif
 
 static int ndisc_net_init(struct net *net)
@@ -1860,7 +1861,7 @@ int __init ndisc_init(void)
 	err = neigh_sysctl_register(NULL, &nd_tbl.parms, NET_IPV6,
 				    NET_IPV6_NEIGH, "ipv6",
 				    &ndisc_ifinfo_sysctl_change,
-				    &ndisc_ifinfo_sysctl_strategy);
+				    ndisc_ifinfo_sysctl_strategy);
 	if (err)
 		goto out_unregister_pernet;
 #endif
-- 
1.5.6.5

