Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYELOrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYELOrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYELOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:47:30 -0400
Received: from sacred.ru ([62.205.161.221]:39493 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYELOr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:47:28 -0400
Message-ID: <482857AE.2030904@openvz.org>
Date: Mon, 12 May 2008 18:43:58 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>
CC: John Gregor <john.gregor@qlogic.com>, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][INFINIBAND]: Make ipath_portdata work with struct pid * not
 pid_t.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 12 May 2008 18:46:26 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The official reason is "with the presence of pid namespaces in the
kernel using pid_t-s inside one is no longer safe".

But the reason I fix exactly the infiniband right now is the following.

About a month ago (when the 2.6.25 was not yet released) there still
was a one last caller of a to-be-deprecated-soon function find_pid() -
the kill_proc() function, which in turn was only used by nfs callback
code.

During the last merge window, this last caller was finally eliminated 
by some NFS patch(es) and I was about to finally kill this kill_proc() 
and find_pid(), but found, that I was late and the kill_proc is now 
called from the infiniband driver (commit 58411d1c).

So here's the patch, that turns this code to use struct pid * and (!)
the kill_pid routine. If it is possible to have this one in 2.6.26, I
would appreciate this A LOT and be able to close one more hole in pid
namespaces.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index ce7b7c3..258e66c 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -2616,7 +2616,7 @@ int ipath_reset_device(int unit)
 				ipath_dbg("unit %u port %d is in use "
 					  "(PID %u cmd %s), can't reset\n",
 					  unit, i,
-					  dd->ipath_pd[i]->port_pid,
+					  pid_nr(dd->ipath_pd[i]->port_pid),
 					  dd->ipath_pd[i]->port_comm);
 				ret = -EBUSY;
 				goto bail;
@@ -2654,19 +2654,21 @@ bail:
 static int ipath_signal_procs(struct ipath_devdata *dd, int sig)
 {
 	int i, sub, any = 0;
-	pid_t pid;
+	struct pid *pid;
 
 	if (!dd->ipath_pd)
 		return 0;
 	for (i = 1; i < dd->ipath_cfgports; i++) {
-		if (!dd->ipath_pd[i] || !dd->ipath_pd[i]->port_cnt ||
-		    !dd->ipath_pd[i]->port_pid)
+		if (!dd->ipath_pd[i] || !dd->ipath_pd[i]->port_cnt)
 			continue;
 		pid = dd->ipath_pd[i]->port_pid;
+		if (!pid)
+			continue;
+
 		dev_info(&dd->pcidev->dev, "context %d in use "
 			  "(PID %u), sending signal %d\n",
-			  i, pid, sig);
-		kill_proc(pid, sig, 1);
+			  i, pid_nr(pid), sig);
+		kill_pid(pid, sig, 1);
 		any++;
 		for (sub = 0; sub < INFINIPATH_MAX_SUBPORT; sub++) {
 			pid = dd->ipath_pd[i]->port_subpid[sub];
@@ -2674,8 +2676,8 @@ static int ipath_signal_procs(struct ipath_devdata *dd, int sig)
 				continue;
 			dev_info(&dd->pcidev->dev, "sub-context "
 				"%d:%d in use (PID %u), sending "
-				"signal %d\n", i, sub, pid, sig);
-			kill_proc(pid, sig, 1);
+				"signal %d\n", i, sub, pid_nr(pid), sig);
+			kill_pid(pid, sig, 1);
 			any++;
 		}
 	}
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 3295177..b472b15 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -555,7 +555,7 @@ static int ipath_tid_free(struct ipath_portdata *pd, unsigned subport,
 			p = dd->ipath_pageshadow[porttid + tid];
 			dd->ipath_pageshadow[porttid + tid] = NULL;
 			ipath_cdbg(VERBOSE, "PID %u freeing TID %u\n",
-				   pd->port_pid, tid);
+				   pid_nr(pd->port_pid), tid);
 			dd->ipath_f_put_tid(dd, &tidbase[tid],
 					    RCVHQ_RCV_TYPE_EXPECTED,
 					    dd->ipath_tidinvalid);
@@ -1609,7 +1609,7 @@ static int try_alloc_port(struct ipath_devdata *dd, int port,
 			   port);
 		pd->port_cnt = 1;
 		port_fp(fp) = pd;
-		pd->port_pid = current->pid;
+		pd->port_pid = get_pid(task_pid(current));
 		strncpy(pd->port_comm, current->comm, sizeof(pd->port_comm));
 		ipath_stats.sps_ports++;
 		ret = 0;
@@ -1793,14 +1793,15 @@ static int find_shared_port(struct file *fp,
 			}
 			port_fp(fp) = pd;
 			subport_fp(fp) = pd->port_cnt++;
-			pd->port_subpid[subport_fp(fp)] = current->pid;
+			pd->port_subpid[subport_fp(fp)] =
+				get_pid(task_pid(current));
 			tidcursor_fp(fp) = 0;
 			pd->active_slaves |= 1 << subport_fp(fp);
 			ipath_cdbg(PROC,
 				   "%s[%u] %u sharing %s[%u] unit:port %u:%u\n",
 				   current->comm, current->pid,
 				   subport_fp(fp),
-				   pd->port_comm, pd->port_pid,
+				   pd->port_comm, pid_nr(pd->port_pid),
 				   dd->ipath_unit, pd->port_port);
 			ret = 1;
 			goto done;
@@ -2066,7 +2067,8 @@ static int ipath_close(struct inode *in, struct file *fp)
 		 * the slave(s) don't wait for receive data forever.
 		 */
 		pd->active_slaves &= ~(1 << fd->subport);
-		pd->port_subpid[fd->subport] = 0;
+		put_pid(pd->port_subpid[fd->subport]);
+		pd->port_subpid[fd->subport] = NULL;
 		mutex_unlock(&ipath_mutex);
 		goto bail;
 	}
@@ -2074,7 +2076,7 @@ static int ipath_close(struct inode *in, struct file *fp)
 
 	if (pd->port_hdrqfull) {
 		ipath_cdbg(PROC, "%s[%u] had %u rcvhdrqfull errors "
-			   "during run\n", pd->port_comm, pd->port_pid,
+			   "during run\n", pd->port_comm, pid_nr(pd->port_pid),
 			   pd->port_hdrqfull);
 		pd->port_hdrqfull = 0;
 	}
@@ -2134,11 +2136,12 @@ static int ipath_close(struct inode *in, struct file *fp)
 			unlock_expected_tids(pd);
 		ipath_stats.sps_ports--;
 		ipath_cdbg(PROC, "%s[%u] closed port %u:%u\n",
-			   pd->port_comm, pd->port_pid,
+			   pd->port_comm, pid_nr(pd->port_pid),
 			   dd->ipath_unit, port);
 	}
 
-	pd->port_pid = 0;
+	put_pid(pd->port_pid);
+	pd->port_pid = NULL;
 	dd->ipath_pd[pd->port_port] = NULL; /* before releasing mutex */
 	mutex_unlock(&ipath_mutex);
 	ipath_free_pddata(dd, pd); /* after releasing the mutex */
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 02b24a3..2097587 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -159,8 +159,8 @@ struct ipath_portdata {
 	/* saved total number of polled urgent packets for poll edge trigger */
 	u32 port_urgent_poll;
 	/* pid of process using this port */
-	pid_t port_pid;
-	pid_t port_subpid[INFINIPATH_MAX_SUBPORT];
+	struct pid *port_pid;
+	struct pid *port_subpid[INFINIPATH_MAX_SUBPORT];
 	/* same size as task_struct .comm[] */
 	char port_comm[16];
 	/* pkeys set by this use of this port */
