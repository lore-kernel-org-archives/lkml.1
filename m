Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZDXCkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZDXCkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 22:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZDXCkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 22:40:06 -0400
Received: from main.gmane.org ([80.91.229.2]:60187 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbZDXCkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 22:40:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Chei-yol Kim <gauri@etri.re.kr>
Subject: [PATCH] =?utf-8?b?dGNfY2dyb3Vw?= : enabling live socket to change its cgroup in a runtime
Date: Fri, 24 Apr 2009 02:34:34 +0000 (UTC)
Message-ID: <loom.20090424T023405-7@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 129.254.186.210 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; IPMS/D2BAFE81-149EFE5E919; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; .NET CLR 1.0.3705; .NET CLR 1.1.4322; Media Center PC 4.0; InfoPath.2))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ranjit’s tc cgroup subsystem patch is useful as a network controller of 
container.
But when the task having a socket connection changes its cgroup, the socket 
will not be affected by changed cgroup, because there are not a permanent 
linkage between the task and its socket.
I fixed this disadvantage, so when the tasks move among groups, their socket’s 
classid will be changed according to their owner task.
 
I am planning to put the additional function to tc cgroup, monitoring each 
group’s network bandwidth usage with res_count facility. 
I don’t think this job could be possible to every traffic control policies at 
the same time. 
First, I’m going to work in the HTB, because HTB is the most useful and 
efficient policy to control network bandwidth.
 
Any comments and suggestions are very welcom.
 
Below patch codes are based on the Ranjit’s tc cgroup code.
 
- Chei-yol Kim
 
--- ./linux-2.6.27/include/linux/cgroup_subsys.h 2008-10-10 07:13:53.000000000 
+0900
+++ ./linux-2.6.27-corset-net/include/linux/cgroup_subsys.h 2009-04-03 
11:27:50.000000000 +0900
@@ -48,3 +48,9 @@
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_TC
+SUBSYS(tc)
+#endif
+
+/* */
--- ./linux-2.6.27/include/linux/cgroup_tc.h 1970-01-01 09:00:00.000000000 
+0900
+++ ./linux-2.6.27-corset-net/include/linux/cgroup_tc.h 2009-04-23 
11:44:31.000000000 +0900
@@ -0,0 +1,22 @@
+#ifndef __LINUX_CGROUP_TC_H
+#define __LINUX_CGROUP_TC_H
+
+/* Interface to obtain tasks cgroup identifier. */
+
+#include <linux/cgroup.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+
+#ifdef CONFIG_CGROUP_TC
+
+void cgroup_tc_do_sock(struct sock *sk);
+void tc_list_del(struct sock *sk); 
+
+#else
+
+#define cgroup_tc_do_sock(sk)
+#define tc_list_del(sk) 
+
+#endif /* CONFIG_CGROUP_TC */
+
+#endif /* __LINUX_CGROUP_TC_H */
--- ./linux-2.6.27/include/linux/pkt_cls.h 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/include/linux/pkt_cls.h 2009-04-03 
11:27:50.000000000 +0900
@@ -380,6 +380,21 @@
 
 #define TCA_FLOW_MAX (__TCA_FLOW_MAX - 1)
 
+/* Cgroups filter */
+
+enum {
+ TCA_CGROUP_UNSPEC,
+ TCA_CGROUP_CLASSID,
+ TCA_CGROUP_MASK,
+ TCA_CGROUP_VALUE,
+ TCA_CGROUP_ACT,
+ TCA_CGROUP_POLICE,
+ TCA_CGROUP_EMATCHES,
+ __TCA_CGROUP_MAX
+};
+
+#define TCA_CGROUP_MAX (__TCA_CGROUP_MAX - 1)
+
 /* Basic filter */
 
 enum
--- ./linux-2.6.27/include/net/sock.h 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/include/net/sock.h 2009-04-23 10:35:49.000000000 
+0900
@@ -57,6 +57,7 @@
 #include <net/dst.h>
 #include <net/checksum.h>
 
+
 /*
  * This structure really needs to be cleaned up.
  * Most of it is for TCP, and not used by any of
@@ -271,6 +272,11 @@
  int   sk_write_pending;
  void   *sk_security;
  __u32   sk_mark;
+#ifdef CONFIG_CGROUP_TC
+ struct list_head sk_tc_list; // link to sk_list
+ int   sk_cid;  // creator pid
+ __u32   sk_cgroup_classid;
+#endif
  /* XXX 4 bytes hole on 64 bit */
  void   (*sk_state_change)(struct sock *sk);
  void   (*sk_data_ready)(struct sock *sk, int bytes);
--- ./linux-2.6.27/init/Kconfig 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/init/Kconfig 2009-04-03 11:27:41.000000000 +0900
@@ -290,6 +290,17 @@
 
    Say N if unsure
 
+config CGROUP_TC
+ bool "Traffic control cgroup subsystem"
+ depends on CGROUPS
+ default n
+ help
+   This option enables a simple cgroup subsystem that
+   allows network traffic to be classified based on the
+   cgroup of the task originating the traffic.
+
+   Say N if unsure
+
 config CGROUP_NS
         bool "Namespace cgroup subsystem"
         depends on CGROUPS
--- ./linux-2.6.27/kernel/Makefile 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/kernel/Makefile 2009-04-03 11:28:03.000000000 
+0900
@@ -57,6 +57,7 @@
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
+obj-$(CONFIG_CGROUP_TC) += tc_cgroup.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
--- ./linux-2.6.27/kernel/tc_cgroup.c 1970-01-01 09:00:00.000000000 +0900
+++ ./linux-2.6.27-corset-net/kernel/tc_cgroup.c 2009-04-23 11:42:33.000000000 
+0900
@@ -0,0 +1,183 @@
+/*
+ * tc_cgroup.c - traffic control cgroup subsystem
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/cgroup.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/cgroup_tc.h>
+
+#define ENTER_FN printk("%s:%i: ENTER \n", __FUNCTION__, __LINE__)
+#define OUT_FN  printk("%s:%i: OUT \n", __FUNCTION__, __LINE__)
+
+LIST_HEAD(sk_list);
+DEFINE_SPINLOCK(sk_list_lock);
+
+EXPORT_SYMBOL(sk_list);
+EXPORT_SYMBOL(sk_list_lock);
+
+
+struct tc_cgroup {
+ struct cgroup_subsys_state css;
+ unsigned int classid;
+};
+
+struct cgroup_subsys tc_subsys;
+
+static inline struct tc_cgroup *cgroup_to_tc(
+  struct cgroup *cgroup)
+{
+ return container_of(cgroup_subsys_state(cgroup, tc_subsys_id),
+       struct tc_cgroup, css);
+}
+
+static unsigned int cgroup_tc_classid(struct task_struct *tsk)
+{
+ unsigned int tc_classid;
+
+ rcu_read_lock();
+ tc_classid = container_of(task_subsys_state(tsk, tc_subsys_id),
+      struct tc_cgroup, css)->classid;
+ rcu_read_unlock();
+ return tc_classid;
+}
+
+void cgroup_tc_set_sock_classid(struct sock *sk)
+{
+ if (sk)
+  sk->sk_cgroup_classid = cgroup_tc_classid(current);
+}
+
+static void cgroup_tc_set_sock_pid_classid(struct sock *sk)
+{
+ struct task_struct *tsk = current;
+
+ if(sk) {
+  rcu_read_lock();
+  sk->sk_cgroup_classid = container_of(task_subsys_state(tsk, tc_subsys_id),
+      struct tc_cgroup, css)->classid;
+  sk->sk_cid = tsk->pid;  // socket creator id
+  rcu_read_unlock();
+ }
+}
+
+static void cgroup_tc_add_sk_list(struct sock *sk)
+{
+ spin_lock(&sk_list_lock);
+ lock_sock(sk);
+ list_add_tail(&sk->sk_tc_list, &sk_list);
+ release_sock(sk);
+ spin_unlock(&sk_list_lock);
+}
+
+void cgroup_tc_do_sock(struct sock *sk)
+{
+ if(sk) {
+  cgroup_tc_add_sk_list(sk);
+  cgroup_tc_set_sock_pid_classid(sk);
+ }
+}
+
+void tc_list_del(struct sock *sk) 
+{
+ spin_lock(&sk_list_lock);
+ list_del(&sk->sk_tc_list);
+ spin_unlock(&sk_list_lock);
+}
+
+
+static struct cgroup_subsys_state *tc_create(struct cgroup_subsys *ss,
+      struct cgroup *cgroup)
+{
+ struct tc_cgroup *tc_cgroup;
+
+ tc_cgroup = kzalloc(sizeof(*tc_cgroup), GFP_KERNEL);
+
+ if (!tc_cgroup)
+  return ERR_PTR(-ENOMEM);
+
+ /* Copy parent's class id if present */
+ if (cgroup->parent)
+  tc_cgroup->classid = cgroup_to_tc(cgroup->parent)->classid;
+
+ return &tc_cgroup->css;
+}
+
+static void tc_destroy(struct cgroup_subsys *ss,
+   struct cgroup *cgroup)
+{
+ kfree(cgroup_to_tc(cgroup));
+}
+
+static void tc_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+   struct cgroup *old_cgrp, struct task_struct *tsk)
+{
+ struct list_head *head;
+ struct sock *sk;
+ int pid;
+ unsigned int old_classid, new_classid;
+ int i=1;
+
+ pid = tsk->pid;
+ old_classid = cgroup_to_tc(old_cgrp)->classid;
+ new_classid = cgroup_to_tc(cgrp)->classid;
+ 
+
+ spin_lock(&sk_list_lock);
+ list_for_each(head, &sk_list) {
+  if(head == &sk_list)
+   break;
+  sk = container_of(head, struct sock, sk_tc_list);
+
+  if(sk->sk_cid == pid) {
+   if(sk->sk_cgroup_classid != old_classid)
+   sk->sk_cgroup_classid = new_classid; 
+  }
+  i++;
+ }
+ spin_unlock(&sk_list_lock);
+}
+
+static int tc_write_u64(struct cgroup *cgroup, struct cftype *cft, u64 val)
+{
+ struct tc_cgroup *tc = cgroup_to_tc(cgroup);
+
+ if (!cgroup_lock_live_group(cgroup))
+  return -ENODEV;
+
+ tc->classid = (unsigned int) (val & 0xffffffff);
+ cgroup_unlock();
+ return 0;
+}
+
+static u64 tc_read_u64(struct cgroup *cgroup, struct cftype *cft)
+{
+ struct tc_cgroup *tc = cgroup_to_tc(cgroup);
+ return tc->classid;
+}
+
+static struct cftype tc_files[] = {
+ {
+  .name = "classid",
+  .read_u64 = tc_read_u64,
+  .write_u64 = tc_write_u64,
+ }
+};
+
+static int tc_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
+{
+ int err;
+ err = cgroup_add_files(cgroup, ss, tc_files, ARRAY_SIZE(tc_files));
+ return err;
+}
+
+struct cgroup_subsys tc_subsys = {
+ .name = "tc",
+ .create = tc_create,
+ .destroy  = tc_destroy,
+ .attach = tc_attach, 
+ .populate = tc_populate,
+ .subsys_id = tc_subsys_id,
+};
--- ./linux-2.6.27/Makefile 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/Makefile 2009-04-03 11:30:05.000000000 +0900
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION =
+EXTRAVERSION = -corset-net
 NAME = Rotary Wombat
 
 # *DOCUMENTATION*
--- ./linux-2.6.27/net/sched/cls_cgroup.c 1970-01-01 09:00:00.000000000 +0900
+++ ./linux-2.6.27-corset-net/net/sched/cls_cgroup.c 2009-04-03 
11:27:55.000000000 +0900
@@ -0,0 +1,330 @@
+/*
+ * net/sched/cls_cgroup.c Simple packet classifier which can filter
+ *     packets based on the cgroups they belong to.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/skbuff.h>
+#include <net/pkt_cls.h>
+#include <net/netlink.h>
+#include <net/sock.h>
+
+struct cgroup_head {
+ struct list_head flist;  /* Head of filter list */
+};
+
+struct cgroup_filter {
+ u32   handle;  /* Unique filter handle */
+ struct tcf_exts  exts;
+ struct tcf_ematch_tree ematches;
+ struct tcf_result res;
+ struct list_head link;
+ u32   mask;
+ u32   value;
+};
+
+static const struct tcf_ext_map cgroup_ext_map = {
+ .action = TCA_CGROUP_ACT,
+ .police = TCA_CGROUP_POLICE,
+};
+
+/* This function is called from the qdisc to classify a particular packet
+ * contained in the skb to the appropriate sub-classes. It returns the
+ * classid of the target class. This filter will match if the cgroup_classid
+ * in the skb matches the value in the filter.
+ */
+static int cgroup_classify(struct sk_buff *skb, struct tcf_proto *tp,
+     struct tcf_result *res)
+{
+ struct cgroup_head *head = (struct cgroup_head *)tp->root;
+ struct cgroup_filter *f;
+ uint32_t cgroup_classid = 0;
+ int r;
+
+#ifdef CONFIG_CGROUP_TC
+ if (skb->sk)
+  cgroup_classid =  skb->sk->sk_cgroup_classid;
+#endif
+
+ list_for_each_entry(f, &head->flist, link) {
+
+  if (!tcf_em_tree_match(skb, &f->ematches, NULL))
+   continue;
+
+  if ((cgroup_classid & f->mask) == f->value) {
+   *res = f->res;
+   r = tcf_exts_exec(skb, &f->exts, res);
+   if (r < 0)
+    continue;
+   return r;
+  }
+ }
+ return -1;
+}
+
+/* Returns pointer to filter matching the handle passed into the function.*/
+static unsigned long cgroup_get(struct tcf_proto *tp, u32 handle)
+{
+ unsigned long l = 0UL;
+ struct cgroup_head *head = (struct cgroup_head *) tp->root;
+ struct cgroup_filter *f;
+
+ if (head == NULL)
+  return 0UL;
+
+ list_for_each_entry(f, &head->flist, link)
+  if (f->handle == handle)
+   l = (unsigned long) f;
+
+ return l;
+}
+
+/* Does not seem to be used for classifiers. */
+static void cgroup_put(struct tcf_proto *tp, unsigned long f)
+{
+}
+
+/* Initializer function called when tp is created. */
+static int cgroup_init(struct tcf_proto *tp)
+{
+ struct cgroup_head *head = kzalloc(sizeof(*head), GFP_KERNEL);
+ if (head == NULL)
+  return -ENOBUFS;
+
+ INIT_LIST_HEAD(&head->flist);
+ tp->root = head;
+ return 0;
+}
+
+/* Simple delete function called when filter is deleted */
+static inline void cgroup_delete_filter(struct tcf_proto *tp,
+           struct cgroup_filter *f)
+{
+ tcf_unbind_filter(tp, &f->res);
+ tcf_exts_destroy(tp, &f->exts);
+ tcf_em_tree_destroy(tp, &f->ematches);
+ kfree(f);
+}
+
+/* Destroy the entire tp structure.*/
+static void cgroup_destroy(struct tcf_proto *tp)
+{
+ struct cgroup_head *head = (struct cgroup_head *) xchg(&tp->root, NULL);
+ struct cgroup_filter *f, *n;
+
+ list_for_each_entry_safe(f, n, &head->flist, link) {
+  list_del(&f->link);
+  cgroup_delete_filter(tp, f);
+ }
+ kfree(head);
+}
+
+/* Delete one filter entry */
+static int cgroup_delete(struct tcf_proto *tp, unsigned long arg)
+{
+ struct cgroup_head *head = (struct cgroup_head *) tp->root;
+ struct cgroup_filter *t, *f = (struct cgroup_filter *) arg;
+
+ list_for_each_entry(t, &head->flist, link)
+  if (t == f) {
+   tcf_tree_lock(tp);
+   list_del(&t->link);
+   tcf_tree_unlock(tp);
+   cgroup_delete_filter(tp, t);
+   return 0;
+  }
+
+ return -ENOENT;
+}
+
+/* Set the mask and value parameters in the tp structure. */
+static inline int cgroup_set_parms(struct tcf_proto *tp,
+   unsigned long base,
+   struct cgroup_filter *f, struct nlattr **tb)
+{
+ int err = -EINVAL;
+
+ if (tb[TCA_CGROUP_MASK]) {
+  if (nla_len(tb[TCA_CGROUP_MASK]) < sizeof(u32))
+   return err;
+  f->mask =  nla_get_u32(tb[TCA_CGROUP_MASK]);
+ } else
+  f->mask = UINT_MAX;
+
+ if (tb[TCA_CGROUP_VALUE]) {
+  if (nla_len(tb[TCA_CGROUP_VALUE]) < sizeof(u32))
+   return err;
+  f->value = nla_get_u32(tb[TCA_CGROUP_VALUE]);
+ } else
+  return err;
+
+ if (tb[TCA_CGROUP_CLASSID]) {
+  if (nla_len(tb[TCA_CGROUP_CLASSID]) < sizeof(u32))
+   return err;
+  f->res.classid = nla_get_u32(tb[TCA_CGROUP_CLASSID]);
+  tcf_bind_filter(tp, &f->res, base);
+ } else
+  return err;
+
+ return 0;
+}
+
+/* Change the mask and value parameters in the current settings. */
+static int cgroup_change(struct tcf_proto *tp, unsigned long base, u32 handle,
+    struct nlattr **tca, unsigned long *arg)
+{
+ int err = -EINVAL;
+ struct cgroup_head *head = (struct cgroup_head *) tp->root;
+ struct nlattr *tb[TCA_CGROUP_MAX];
+ struct cgroup_filter *f = (struct cgroup_filter *) *arg;
+ struct tcf_exts e;
+ struct tcf_ematch_tree t;
+
+ if (tca[TCA_OPTIONS] == NULL)
+  return -EINVAL;
+
+ if (nla_parse_nested(tb, TCA_CGROUP_MAX, tca[TCA_OPTIONS], NULL) < 0)
+  return -EINVAL;
+
+ err = tcf_exts_validate(tp, tb, tca[TCA_RATE], &e, &cgroup_ext_map);
+ if (err < 0)
+  return err;
+
+ err = tcf_em_tree_validate(tp, tb[TCA_CGROUP_EMATCHES], &t);
+ if (err < 0)
+  goto error1;
+
+ if (f != NULL) {
+  if (handle && f->handle != handle)
+   goto error2;
+ } else {
+  if (!handle)
+   goto error2;
+  f = kzalloc(sizeof(*f), GFP_KERNEL);
+  if (f == NULL)
+   goto error2;
+  f->handle = handle;
+ }
+
+ err = cgroup_set_parms(tp, base, f, tb);
+ if (err < 0)
+  goto error3;
+
+ tcf_exts_change(tp, &f->exts, &e);
+ tcf_em_tree_change(tp, &f->ematches, &t);
+
+ if (*arg == 0) {
+  tcf_tree_lock(tp);
+  list_add(&f->link, &head->flist);
+  tcf_tree_unlock(tp);
+ }
+
+ *arg = (unsigned long)f;
+ return 0;
+
+error3:
+ if (*arg == 0)
+  kfree(f);
+error2:
+ tcf_em_tree_destroy(tp, &t);
+error1:
+ tcf_exts_destroy(tp, &e);
+
+ return err;
+}
+
+/* Walk the filter list for things like displaying contents.*/
+static void cgroup_walk(struct tcf_proto *tp, struct tcf_walker *arg)
+{
+ struct cgroup_head *head = (struct cgroup_head *) tp->root;
+ struct cgroup_filter *f;
+
+ list_for_each_entry(f, &head->flist, link) {
+  if (arg->count < arg->skip)
+   goto skip;
+
+  if (arg->fn(tp, (unsigned long) f, arg) < 0) {
+   arg->stop = 1;
+   break;
+  }
+skip:
+  arg->count++;
+ }
+}
+
+/* Retreive current settings in the filter */
+static int cgroup_dump(struct tcf_proto *tp, unsigned long fh,
+        struct sk_buff *skb, struct tcmsg *t)
+{
+ struct cgroup_filter *f = (struct cgroup_filter *) fh;
+ struct nlattr *nest;
+
+ if (f == NULL)
+  return skb->len;
+
+ t->tcm_handle = f->handle;
+
+ nest = nla_nest_start(skb, TCA_OPTIONS);
+ if (nest == NULL)
+  goto nla_put_failure;
+
+ NLA_PUT_U32(skb, TCA_CGROUP_CLASSID, f->res.classid);
+ NLA_PUT_U32(skb, TCA_CGROUP_MASK, f->mask);
+ NLA_PUT_U32(skb, TCA_CGROUP_VALUE, f->value);
+
+ if (tcf_exts_dump(skb, &f->exts, &cgroup_ext_map) < 0)
+  goto nla_put_failure;
+
+#ifdef CONFIG_NET_EMATCH
+ if (f->ematches.hdr.nmatches &&
+   tcf_em_tree_dump(skb, &f->ematches, TCA_CGROUP_EMATCHES) < 0)
+  goto nla_put_failure;
+#endif
+
+ if (tcf_exts_dump_stats(skb, &f->exts, &cgroup_ext_map) < 0)
+  goto nla_put_failure;
+
+ nla_nest_end(skb, nest);
+ return skb->len;
+
+nla_put_failure:
+ nla_nest_cancel(skb, nest);
+ return -1;
+}
+
+static struct tcf_proto_ops cls_cgroup_ops = {
+ .kind  = "cgroup",
+ .classify = cgroup_classify,
+ .init  = cgroup_init,
+ .destroy = cgroup_destroy,
+ .get  = cgroup_get,
+ .put  = cgroup_put,
+ .change  = cgroup_change,
+ .delete  = cgroup_delete,
+ .walk  = cgroup_walk,
+ .dump  = cgroup_dump,
+ .owner  = THIS_MODULE,
+};
+
+static int __init init_cgroup(void)
+{
+ return register_tcf_proto_ops(&cls_cgroup_ops);
+}
+
+static void __exit exit_cgroup(void)
+{
+ unregister_tcf_proto_ops(&cls_cgroup_ops);
+}
+
+module_init(init_cgroup)
+module_exit(exit_cgroup)
+MODULE_LICENSE("GPL");
+
--- ./linux-2.6.27/net/sched/Kconfig 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/net/sched/Kconfig 2009-04-03 11:27:55.000000000 
+0900
@@ -307,6 +307,16 @@
    To compile this code as a module, choose M here: the
    module will be called cls_flow.
 
+config NET_CLS_CGROUP
+ tristate "Cgroups tc classifier"
+ select NET_CLS
+ ---help---
+   If you say Y here, you will be able to classify packets based on
+   cgroup membership of the task originating the packet.
+
+   To compile this code as a module, choose M here: the
+   module will be called cls_cgroup.
+
 config NET_EMATCH
  bool "Extended Matches"
  select NET_CLS
--- ./linux-2.6.27/net/sched/Makefile 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/net/sched/Makefile 2009-04-03 11:27:55.000000000 
+0900
@@ -36,6 +36,7 @@
 obj-$(CONFIG_NET_CLS_RSVP6) += cls_rsvp6.o
 obj-$(CONFIG_NET_CLS_BASIC) += cls_basic.o
 obj-$(CONFIG_NET_CLS_FLOW) += cls_flow.o
+obj-$(CONFIG_NET_CLS_CGROUP) += cls_cgroup.o
 obj-$(CONFIG_NET_EMATCH) += ematch.o
 obj-$(CONFIG_NET_EMATCH_CMP) += em_cmp.o
 obj-$(CONFIG_NET_EMATCH_NBYTE) += em_nbyte.o
--- ./linux-2.6.27/net/socket.c 2008-10-10 07:13:53.000000000 +0900
+++ ./linux-2.6.27-corset-net/net/socket.c 2009-04-23 11:47:06.000000000 +0900
@@ -96,6 +96,7 @@
 
 #include <net/sock.h>
 #include <linux/netfilter.h>
+#include <linux/cgroup_tc.h>
 
 static int sock_no_open(struct inode *irrelevant, struct file *dontcare);
 static ssize_t sock_aio_read(struct kiocb *iocb, const struct iovec *iov,
@@ -526,6 +527,9 @@
 
 void sock_release(struct socket *sock)
 {
+ if(sock->sk)
+  tc_list_del(sock->sk);
+ 
  if (sock->ops) {
   struct module *owner = sock->ops->owner;
 
@@ -1173,6 +1177,8 @@
  if (err < 0)
   goto out_module_put;
 
+ cgroup_tc_do_sock(sock->sk);
+
  /*
   * Now to bump the refcnt of the [loadable] module that owns this
   * socket at sock_release time we decrement its refcnt.
@@ -1477,6 +1483,8 @@
  if (err < 0)
   goto out_fd;
 
+ cgroup_tc_do_sock(newsock->sk);
+
  if (upeer_sockaddr) {
   if (newsock->ops->getname(newsock, (struct sockaddr *)&address,
        &len, 2) < 0) {


