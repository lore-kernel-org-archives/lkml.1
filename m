Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbXBEOUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbXBEOUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbXBEOUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:20:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbXBEOUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:20:18 -0500
Subject: [DLM] Use workqueues for dlm lowcomms [23/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfield <pcaulfie@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:28:22 +0000
Message-Id: <1170685702.11001.317.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8b3c1aacbf337ec3c9a354c9ad9a86f4d31e72fc Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Mon, 15 Jan 2007 14:33:34 +0000
Subject: [PATCH] [DLM] Use workqueues for dlm lowcomms

This patch converts the DLM TCP lowcomms to use workqueues rather than using its
own daemon functions. Simultaneously removing a lot of code and making it more
scalable on multi-processor machines.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-sctp.c b/fs/dlm/lowcomms-sctp.c
index 5aeadad..dc83a9d 100644
--- a/fs/dlm/lowcomms-sctp.c
+++ b/fs/dlm/lowcomms-sctp.c
@@ -72,6 +72,8 @@ struct nodeinfo {
 	struct list_head	writequeue; /* outgoing writequeue_entries */
 	spinlock_t		writequeue_lock;
 	int			nodeid;
+	struct work_struct      swork; /* Send workqueue */
+	struct work_struct      lwork; /* Locking workqueue */
 };
 
 static DEFINE_IDR(nodeinfo_idr);
@@ -96,6 +98,7 @@ struct connection {
 	atomic_t		waiting_requests;
 	struct cbuf		cb;
 	int                     eagain_flag;
+	struct work_struct      work; /* Send workqueue */
 };
 
 /* An entry waiting to be sent */
@@ -137,19 +140,23 @@ static void cbuf_eat(struct cbuf *cb, int n)
 static LIST_HEAD(write_nodes);
 static DEFINE_SPINLOCK(write_nodes_lock);
 
+
 /* Maximum number of incoming messages to process before
  * doing a schedule()
  */
 #define MAX_RX_MSG_COUNT 25
 
-/* Manage daemons */
-static struct task_struct *recv_task;
-static struct task_struct *send_task;
-static DECLARE_WAIT_QUEUE_HEAD(lowcomms_recv_wait);
+/* Work queues */
+static struct workqueue_struct *recv_workqueue;
+static struct workqueue_struct *send_workqueue;
+static struct workqueue_struct *lock_workqueue;
 
 /* The SCTP connection */
 static struct connection sctp_con;
 
+static void process_send_sockets(struct work_struct *work);
+static void process_recv_sockets(struct work_struct *work);
+static void process_lock_request(struct work_struct *work);
 
 static int nodeid_to_addr(int nodeid, struct sockaddr *retaddr)
 {
@@ -222,6 +229,8 @@ static struct nodeinfo *nodeid2nodeinfo(int nodeid, gfp_t alloc)
 	spin_lock_init(&ni->lock);
 	INIT_LIST_HEAD(&ni->writequeue);
 	spin_lock_init(&ni->writequeue_lock);
+	INIT_WORK(&ni->lwork, process_lock_request);
+	INIT_WORK(&ni->swork, process_send_sockets);
 	ni->nodeid = nodeid;
 
 	if (nodeid > max_nodeid)
@@ -249,11 +258,8 @@ static struct nodeinfo *assoc2nodeinfo(sctp_assoc_t assoc)
 /* Data or notification available on socket */
 static void lowcomms_data_ready(struct sock *sk, int count_unused)
 {
-	atomic_inc(&sctp_con.waiting_requests);
 	if (test_and_set_bit(CF_READ_PENDING, &sctp_con.flags))
-		return;
-
-	wake_up_interruptible(&lowcomms_recv_wait);
+		queue_work(recv_workqueue, &sctp_con.work);
 }
 
 
@@ -361,10 +367,10 @@ static void init_failed(void)
 				spin_lock_bh(&write_nodes_lock);
 				list_add_tail(&ni->write_list, &write_nodes);
 				spin_unlock_bh(&write_nodes_lock);
+				queue_work(send_workqueue, &ni->swork);
 			}
 		}
 	}
-	wake_up_process(send_task);
 }
 
 /* Something happened to an association */
@@ -446,8 +452,8 @@ static void process_sctp_notification(struct msghdr *msg, char *buf)
 				spin_lock_bh(&write_nodes_lock);
 				list_add_tail(&ni->write_list, &write_nodes);
 				spin_unlock_bh(&write_nodes_lock);
+				queue_work(send_workqueue, &ni->swork);
 			}
-			wake_up_process(send_task);
 		}
 		break;
 
@@ -580,8 +586,8 @@ static int receive_from_sock(void)
 				spin_lock_bh(&write_nodes_lock);
 				list_add_tail(&ni->write_list, &write_nodes);
 				spin_unlock_bh(&write_nodes_lock);
+				queue_work(send_workqueue, &ni->swork);
 			}
-			wake_up_process(send_task);
 		}
 	}
 
@@ -590,6 +596,7 @@ static int receive_from_sock(void)
 		return 0;
 
 	cbuf_add(&sctp_con.cb, ret);
+	// PJC: TODO: Add to node's workqueue....can we ??
 	ret = dlm_process_incoming_buffer(cpu_to_le32(sinfo->sinfo_ppid),
 					  page_address(sctp_con.rx_page),
 					  sctp_con.cb.base, sctp_con.cb.len,
@@ -820,7 +827,8 @@ void dlm_lowcomms_commit_buffer(void *arg)
 		spin_lock_bh(&write_nodes_lock);
 		list_add_tail(&ni->write_list, &write_nodes);
 		spin_unlock_bh(&write_nodes_lock);
-		wake_up_process(send_task);
+
+		queue_work(send_workqueue, &ni->swork);
 	}
 	return;
 
@@ -1088,101 +1096,75 @@ int dlm_lowcomms_close(int nodeid)
 	return 0;
 }
 
-static int write_list_empty(void)
+// PJC: The work queue function for receiving.
+static void process_recv_sockets(struct work_struct *work)
 {
-	int status;
+	if (test_and_clear_bit(CF_READ_PENDING, &sctp_con.flags)) {
+		int ret;
+		int count = 0;
 
-	spin_lock_bh(&write_nodes_lock);
-	status = list_empty(&write_nodes);
-	spin_unlock_bh(&write_nodes_lock);
+		do {
+			ret = receive_from_sock();
 
-	return status;
+			/* Don't starve out everyone else */
+			if (++count >= MAX_RX_MSG_COUNT) {
+				cond_resched();
+				count = 0;
+			}
+		} while (!kthread_should_stop() && ret >=0);
+	}
+	cond_resched();
 }
 
-static int dlm_recvd(void *data)
+// PJC: the work queue function for sending
+static void process_send_sockets(struct work_struct *work)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	while (!kthread_should_stop()) {
-		int count = 0;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&lowcomms_recv_wait, &wait);
-		if (!test_bit(CF_READ_PENDING, &sctp_con.flags))
-			schedule();
-		remove_wait_queue(&lowcomms_recv_wait, &wait);
-		set_current_state(TASK_RUNNING);
-
-		if (test_and_clear_bit(CF_READ_PENDING, &sctp_con.flags)) {
-			int ret;
-
-			do {
-				ret = receive_from_sock();
-
-				/* Don't starve out everyone else */
-				if (++count >= MAX_RX_MSG_COUNT) {
-					cond_resched();
-					count = 0;
-				}
-			} while (!kthread_should_stop() && ret >=0);
-		}
-		cond_resched();
+	if (sctp_con.eagain_flag) {
+		sctp_con.eagain_flag = 0;
+		refill_write_queue();
 	}
-
-	return 0;
+	process_output_queue();
 }
 
-static int dlm_sendd(void *data)
+// PJC: Process lock requests from a particular node.
+// TODO: can we optimise this out on UP ??
+static void process_lock_request(struct work_struct *work)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(sctp_con.sock->sk->sk_sleep, &wait);
-
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (write_list_empty())
-			schedule();
-		set_current_state(TASK_RUNNING);
-
-		if (sctp_con.eagain_flag) {
-			sctp_con.eagain_flag = 0;
-			refill_write_queue();
-		}
-		process_output_queue();
-	}
-
-	remove_wait_queue(sctp_con.sock->sk->sk_sleep, &wait);
-
-	return 0;
 }
 
 static void daemons_stop(void)
 {
-	kthread_stop(recv_task);
-	kthread_stop(send_task);
+	destroy_workqueue(recv_workqueue);
+	destroy_workqueue(send_workqueue);
+	destroy_workqueue(lock_workqueue);
 }
 
 static int daemons_start(void)
 {
-	struct task_struct *p;
 	int error;
+	recv_workqueue = create_workqueue("dlm_recv");
+	error = IS_ERR(recv_workqueue);
+	if (error) {
+		log_print("can't start dlm_recv %d", error);
+		return error;
+	}
 
-	p = kthread_run(dlm_recvd, NULL, "dlm_recvd");
-	error = IS_ERR(p);
+	send_workqueue = create_singlethread_workqueue("dlm_send");
+	error = IS_ERR(send_workqueue);
 	if (error) {
-		log_print("can't start dlm_recvd %d", error);
+		log_print("can't start dlm_send %d", error);
+		destroy_workqueue(recv_workqueue);
 		return error;
 	}
-	recv_task = p;
 
-	p = kthread_run(dlm_sendd, NULL, "dlm_sendd");
-	error = IS_ERR(p);
+	lock_workqueue = create_workqueue("dlm_rlock");
+	error = IS_ERR(lock_workqueue);
 	if (error) {
-		log_print("can't start dlm_sendd %d", error);
-		kthread_stop(recv_task);
+		log_print("can't start dlm_rlock %d", error);
+		destroy_workqueue(send_workqueue);
+		destroy_workqueue(recv_workqueue);
 		return error;
 	}
-	send_task = p;
 
 	return 0;
 }
@@ -1194,6 +1176,8 @@ int dlm_lowcomms_start(void)
 {
 	int error;
 
+	INIT_WORK(&sctp_con.work, process_recv_sockets);
+
 	error = init_sock();
 	if (error)
 		goto fail_sock;
@@ -1224,4 +1208,3 @@ void dlm_lowcomms_stop(void)
 	for (i = 0; i < dlm_local_count; i++)
 		kfree(dlm_local_addr[i]);
 }
-
diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index b4fb578..86e5f81 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -115,6 +115,8 @@ struct connection {
 	atomic_t waiting_requests;
 #define MAX_CONNECT_RETRIES 3
 	struct connection *othercon;
+	struct work_struct rwork; /* Receive workqueue */
+	struct work_struct swork; /* Send workqueue */
 };
 #define sock2con(x) ((struct connection *)(x)->sk_user_data)
 
@@ -131,14 +133,9 @@ struct writequeue_entry {
 
 static struct sockaddr_storage dlm_local_addr;
 
-/* Manage daemons */
-static struct task_struct *recv_task;
-static struct task_struct *send_task;
-
-static wait_queue_t lowcomms_send_waitq_head;
-static DECLARE_WAIT_QUEUE_HEAD(lowcomms_send_waitq);
-static wait_queue_t lowcomms_recv_waitq_head;
-static DECLARE_WAIT_QUEUE_HEAD(lowcomms_recv_waitq);
+/* Work queues */
+static struct workqueue_struct *recv_workqueue;
+static struct workqueue_struct *send_workqueue;
 
 /* An array of pointers to connections, indexed by NODEID */
 static struct connection **connections;
@@ -146,17 +143,8 @@ static DECLARE_MUTEX(connections_lock);
 static struct kmem_cache *con_cache;
 static int conn_array_size;
 
-/* List of sockets that have reads pending */
-static LIST_HEAD(read_sockets);
-static DEFINE_SPINLOCK(read_sockets_lock);
-
-/* List of sockets which have writes pending */
-static LIST_HEAD(write_sockets);
-static DEFINE_SPINLOCK(write_sockets_lock);
-
-/* List of sockets which have connects pending */
-static LIST_HEAD(state_sockets);
-static DEFINE_SPINLOCK(state_sockets_lock);
+static void process_recv_sockets(struct work_struct *work);
+static void process_send_sockets(struct work_struct *work);
 
 static struct connection *nodeid2con(int nodeid, gfp_t allocation)
 {
@@ -189,6 +177,8 @@ static struct connection *nodeid2con(int nodeid, gfp_t allocation)
 		init_rwsem(&con->sock_sem);
 		INIT_LIST_HEAD(&con->writequeue);
 		spin_lock_init(&con->writequeue_lock);
+		INIT_WORK(&con->swork, process_send_sockets);
+		INIT_WORK(&con->rwork, process_recv_sockets);
 
 		connections[nodeid] = con;
 	}
@@ -203,41 +193,22 @@ static void lowcomms_data_ready(struct sock *sk, int count_unused)
 {
 	struct connection *con = sock2con(sk);
 
-	atomic_inc(&con->waiting_requests);
-	if (test_and_set_bit(CF_READ_PENDING, &con->flags))
-		return;
-
-	spin_lock_bh(&read_sockets_lock);
-	list_add_tail(&con->read_list, &read_sockets);
-	spin_unlock_bh(&read_sockets_lock);
-
-	wake_up_interruptible(&lowcomms_recv_waitq);
+	if (!test_and_set_bit(CF_READ_PENDING, &con->flags))
+		queue_work(recv_workqueue, &con->rwork);
 }
 
 static void lowcomms_write_space(struct sock *sk)
 {
 	struct connection *con = sock2con(sk);
 
-	if (test_and_set_bit(CF_WRITE_PENDING, &con->flags))
-		return;
-
-	spin_lock_bh(&write_sockets_lock);
-	list_add_tail(&con->write_list, &write_sockets);
-	spin_unlock_bh(&write_sockets_lock);
-
-	wake_up_interruptible(&lowcomms_send_waitq);
+	if (!test_and_set_bit(CF_WRITE_PENDING, &con->flags))
+		queue_work(send_workqueue, &con->swork);
 }
 
 static inline void lowcomms_connect_sock(struct connection *con)
 {
-	if (test_and_set_bit(CF_CONNECT_PENDING, &con->flags))
-		return;
-
-	spin_lock_bh(&state_sockets_lock);
-	list_add_tail(&con->state_list, &state_sockets);
-	spin_unlock_bh(&state_sockets_lock);
-
-	wake_up_interruptible(&lowcomms_send_waitq);
+	if (!test_and_set_bit(CF_CONNECT_PENDING, &con->flags))
+		queue_work(send_workqueue, &con->swork);
 }
 
 static void lowcomms_state_change(struct sock *sk)
@@ -388,7 +359,8 @@ out:
 	return 0;
 
 out_resched:
-	lowcomms_data_ready(con->sock->sk, 0);
+	if (!test_and_set_bit(CF_READ_PENDING, &con->flags))
+		queue_work(recv_workqueue, &con->rwork);
 	up_read(&con->sock_sem);
 	cond_resched();
 	return 0;
@@ -477,6 +449,8 @@ static int accept_from_sock(struct connection *con)
 			othercon->nodeid = nodeid;
 			othercon->rx_action = receive_from_sock;
 			init_rwsem(&othercon->sock_sem);
+			INIT_WORK(&othercon->swork, process_send_sockets);
+			INIT_WORK(&othercon->rwork, process_recv_sockets);
 			set_bit(CF_IS_OTHERCON, &othercon->flags);
 			newcon->othercon = othercon;
 		}
@@ -498,7 +472,8 @@ static int accept_from_sock(struct connection *con)
 	 * beween processing the accept adding the socket
 	 * to the read_sockets list
 	 */
-	lowcomms_data_ready(newsock->sk, 0);
+	if (!test_and_set_bit(CF_READ_PENDING, &newcon->flags))
+		queue_work(recv_workqueue, &newcon->rwork);
 	up_read(&con->sock_sem);
 
 	return 0;
@@ -757,12 +732,8 @@ void dlm_lowcomms_commit_buffer(void *mh)
 	kunmap(e->page);
 	spin_unlock(&con->writequeue_lock);
 
-	if (test_and_set_bit(CF_WRITE_PENDING, &con->flags) == 0) {
-		spin_lock_bh(&write_sockets_lock);
-		list_add_tail(&con->write_list, &write_sockets);
-		spin_unlock_bh(&write_sockets_lock);
-
-		wake_up_interruptible(&lowcomms_send_waitq);
+	if (!test_and_set_bit(CF_WRITE_PENDING, &con->flags)) {
+		queue_work(send_workqueue, &con->swork);
 	}
 	return;
 
@@ -803,6 +774,7 @@ static void send_to_sock(struct connection *con)
 		offset = e->offset;
 		BUG_ON(len == 0 && e->users == 0);
 		spin_unlock(&con->writequeue_lock);
+		kmap(e->page);
 
 		ret = 0;
 		if (len) {
@@ -884,85 +856,29 @@ out:
 }
 
 /* Look for activity on active sockets */
-static void process_sockets(void)
+static void process_recv_sockets(struct work_struct *work)
 {
-	struct list_head *list;
-	struct list_head *temp;
-	int count = 0;
-
-	spin_lock_bh(&read_sockets_lock);
-	list_for_each_safe(list, temp, &read_sockets) {
-
-		struct connection *con =
-			list_entry(list, struct connection, read_list);
-		list_del(&con->read_list);
-		clear_bit(CF_READ_PENDING, &con->flags);
-
-		spin_unlock_bh(&read_sockets_lock);
+	struct connection *con = container_of(work, struct connection, rwork);
+	int err;
 
-		/* This can reach zero if we are processing requests
-		 * as they come in.
-		 */
-		if (atomic_read(&con->waiting_requests) == 0) {
-			spin_lock_bh(&read_sockets_lock);
-			continue;
-		}
-
-		do {
-			con->rx_action(con);
-
-			/* Don't starve out everyone else */
-			if (++count >= MAX_RX_MSG_COUNT) {
-				cond_resched();
-				count = 0;
-			}
-
-		} while (!atomic_dec_and_test(&con->waiting_requests) &&
-			 !kthread_should_stop());
-
-		spin_lock_bh(&read_sockets_lock);
-	}
-	spin_unlock_bh(&read_sockets_lock);
+	clear_bit(CF_READ_PENDING, &con->flags);
+	do {
+		err = con->rx_action(con);
+	} while (!err);
 }
 
-/* Try to send any messages that are pending
- */
-static void process_output_queue(void)
-{
-	struct list_head *list;
-	struct list_head *temp;
-
-	spin_lock_bh(&write_sockets_lock);
-	list_for_each_safe(list, temp, &write_sockets) {
-		struct connection *con =
-			list_entry(list, struct connection, write_list);
-		clear_bit(CF_WRITE_PENDING, &con->flags);
-		list_del(&con->write_list);
-
-		spin_unlock_bh(&write_sockets_lock);
-		send_to_sock(con);
-		spin_lock_bh(&write_sockets_lock);
-	}
-	spin_unlock_bh(&write_sockets_lock);
-}
 
-static void process_state_queue(void)
+static void process_send_sockets(struct work_struct *work)
 {
-	struct list_head *list;
-	struct list_head *temp;
-
-	spin_lock_bh(&state_sockets_lock);
-	list_for_each_safe(list, temp, &state_sockets) {
-		struct connection *con =
-			list_entry(list, struct connection, state_list);
-		list_del(&con->state_list);
-		clear_bit(CF_CONNECT_PENDING, &con->flags);
-		spin_unlock_bh(&state_sockets_lock);
+	struct connection *con = container_of(work, struct connection, swork);
 
+	if (test_and_clear_bit(CF_CONNECT_PENDING, &con->flags)) {
 		connect_to_sock(con);
-		spin_lock_bh(&state_sockets_lock);
 	}
-	spin_unlock_bh(&state_sockets_lock);
+
+	if (test_and_clear_bit(CF_WRITE_PENDING, &con->flags)) {
+		send_to_sock(con);
+	}
 }
 
 
@@ -979,97 +895,29 @@ static void clean_writequeues(void)
 	}
 }
 
-static int read_list_empty(void)
-{
-	int status;
-
-	spin_lock_bh(&read_sockets_lock);
-	status = list_empty(&read_sockets);
-	spin_unlock_bh(&read_sockets_lock);
-
-	return status;
-}
-
-/* DLM Transport comms receive daemon */
-static int dlm_recvd(void *data)
+static void work_stop(void)
 {
-	init_waitqueue_entry(&lowcomms_recv_waitq_head, current);
-	add_wait_queue(&lowcomms_recv_waitq, &lowcomms_recv_waitq_head);
-
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (read_list_empty())
-			schedule();
-		set_current_state(TASK_RUNNING);
-
-		process_sockets();
-	}
-
-	return 0;
+	destroy_workqueue(recv_workqueue);
+	destroy_workqueue(send_workqueue);
 }
 
-static int write_and_state_lists_empty(void)
+static int work_start(void)
 {
-	int status;
-
-	spin_lock_bh(&write_sockets_lock);
-	status = list_empty(&write_sockets);
-	spin_unlock_bh(&write_sockets_lock);
-
-	spin_lock_bh(&state_sockets_lock);
-	if (list_empty(&state_sockets) == 0)
-		status = 0;
-	spin_unlock_bh(&state_sockets_lock);
-
-	return status;
-}
-
-/* DLM Transport send daemon */
-static int dlm_sendd(void *data)
-{
-	init_waitqueue_entry(&lowcomms_send_waitq_head, current);
-	add_wait_queue(&lowcomms_send_waitq, &lowcomms_send_waitq_head);
-
-	while (!kthread_should_stop()) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (write_and_state_lists_empty())
-			schedule();
-		set_current_state(TASK_RUNNING);
-
-		process_state_queue();
-		process_output_queue();
-	}
-
-	return 0;
-}
-
-static void daemons_stop(void)
-{
-	kthread_stop(recv_task);
-	kthread_stop(send_task);
-}
-
-static int daemons_start(void)
-{
-	struct task_struct *p;
 	int error;
-
-	p = kthread_run(dlm_recvd, NULL, "dlm_recvd");
-	error = IS_ERR(p);
+	recv_workqueue = create_workqueue("dlm_recv");
+	error = IS_ERR(recv_workqueue);
 	if (error) {
-		log_print("can't start dlm_recvd %d", error);
+		log_print("can't start dlm_recv %d", error);
 		return error;
 	}
-	recv_task = p;
 
-	p = kthread_run(dlm_sendd, NULL, "dlm_sendd");
-	error = IS_ERR(p);
+	send_workqueue = create_singlethread_workqueue("dlm_send");
+	error = IS_ERR(send_workqueue);
 	if (error) {
-		log_print("can't start dlm_sendd %d", error);
-		kthread_stop(recv_task);
+		log_print("can't start dlm_send %d", error);
+		destroy_workqueue(recv_workqueue);
 		return error;
 	}
-	send_task = p;
 
 	return 0;
 }
@@ -1086,7 +934,7 @@ void dlm_lowcomms_stop(void)
 			connections[i]->flags |= 0xFF;
 	}
 
-	daemons_stop();
+	work_stop();
 	clean_writequeues();
 
 	for (i = 0; i < conn_array_size; i++) {
@@ -1138,7 +986,7 @@ int dlm_lowcomms_start(void)
 	if (error)
 		goto fail_unlisten;
 
-	error = daemons_start();
+	error = work_start();
 	if (error)
 		goto fail_unlisten;
 
-- 
1.4.4.2



