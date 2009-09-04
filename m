Return-Path: <linux-kernel-owner+w=401wt.eu-S934158AbZIDUPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158AbZIDUPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933992AbZIDUPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:15:06 -0400
Received: from kroah.org ([198.145.64.141]:36337 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123AbZIDUOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:57 2009
Message-Id: <20090904200857.466721861@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:08:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steve Dickson <SteveD@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 48/48] SUNRPC: Fix tcp reconnection
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=sunrpc-fix-tcp-reconnection.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>

This fixes a problem that was reported as Red Hat Bugzilla entry number
485339, in which rpciod starts looping on the TCP connection code,
rendering the NFS client unusable for 1/2 minute or so.

It is basically a backport of commit
f75e6745aa3084124ae1434fd7629853bdaf6798 (SUNRPC: Fix the problem of
EADDRNOTAVAIL syslog floods on reconnect)

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/linux/sunrpc/xprt.h |    1 +
 net/sunrpc/xprt.c           |    6 ++----
 net/sunrpc/xprtsock.c       |   37 ++++++++++++++++++++++++++++++++++---
 3 files changed, 37 insertions(+), 7 deletions(-)

--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -260,6 +260,7 @@ void			xprt_conditional_disconnect(struc
 #define XPRT_BOUND		(4)
 #define XPRT_BINDING		(5)
 #define XPRT_CLOSING		(6)
+#define XPRT_CONNECTION_CLOSE	(8)
 
 static inline void xprt_set_connected(struct rpc_xprt *xprt)
 {
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -645,10 +645,8 @@ xprt_init_autodisconnect(unsigned long d
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state))
 		goto out_abort;
 	spin_unlock(&xprt->transport_lock);
-	if (xprt_connecting(xprt))
-		xprt_release_write(xprt, NULL);
-	else
-		queue_work(rpciod_workqueue, &xprt->task_cleanup);
+	set_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
+	queue_work(rpciod_workqueue, &xprt->task_cleanup);
 	return;
 out_abort:
 	spin_unlock(&xprt->transport_lock);
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -748,6 +748,9 @@ out_release:
  *
  * This is used when all requests are complete; ie, no DRC state remains
  * on the server we want to save.
+ *
+ * The caller _must_ be holding XPRT_LOCKED in order to avoid issues with
+ * xs_reset_transport() zeroing the socket from underneath a writer.
  */
 static void xs_close(struct rpc_xprt *xprt)
 {
@@ -781,6 +784,14 @@ clear_close_wait:
 	xprt_disconnect_done(xprt);
 }
 
+static void xs_tcp_close(struct rpc_xprt *xprt)
+{
+	if (test_and_clear_bit(XPRT_CONNECTION_CLOSE, &xprt->state))
+		xs_close(xprt);
+	else
+		xs_tcp_shutdown(xprt);
+}
+
 /**
  * xs_destroy - prepare to shutdown a transport
  * @xprt: doomed transport
@@ -1676,11 +1687,21 @@ static void xs_tcp_connect_worker4(struc
 				goto out_clear;
 			case -ECONNREFUSED:
 			case -ECONNRESET:
+			case -ENETUNREACH:
 				/* retry with existing socket, after a delay */
-				break;
+				goto out_clear;
 			default:
 				/* get rid of existing socket, and retry */
 				xs_tcp_shutdown(xprt);
+				printk("%s: connect returned unhandled error %d\n",
+						__func__, status);
+			case -EADDRNOTAVAIL:
+				/* We're probably in TIME_WAIT. Get rid of existing socket,
+				 * and retry
+				 */
+				set_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
+				xprt_force_disconnect(xprt);
+				status = -EAGAIN;
 		}
 	}
 out:
@@ -1735,11 +1756,21 @@ static void xs_tcp_connect_worker6(struc
 				goto out_clear;
 			case -ECONNREFUSED:
 			case -ECONNRESET:
+			case -ENETUNREACH:
 				/* retry with existing socket, after a delay */
-				break;
+				goto out_clear;
 			default:
 				/* get rid of existing socket, and retry */
 				xs_tcp_shutdown(xprt);
+				printk("%s: connect returned unhandled error %d\n",
+						__func__, status);
+			case -EADDRNOTAVAIL:
+				/* We're probably in TIME_WAIT. Get rid of existing socket,
+				 * and retry
+				 */
+				set_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
+				xprt_force_disconnect(xprt);
+				status = -EAGAIN;
 		}
 	}
 out:
@@ -1871,7 +1902,7 @@ static struct rpc_xprt_ops xs_tcp_ops = 
 	.buf_free		= rpc_free,
 	.send_request		= xs_tcp_send_request,
 	.set_retrans_timeout	= xprt_set_retrans_timeout_def,
-	.close			= xs_tcp_shutdown,
+	.close			= xs_tcp_close,
 	.destroy		= xs_destroy,
 	.print_stats		= xs_tcp_print_stats,
 };


