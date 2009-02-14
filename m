Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbZBNBOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbZBNBOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761432AbZBNBB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:58 -0500
Received: from kroah.org ([198.145.64.141]:39835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753944AbZBNBB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:56 -0500
Date: Fri, 13 Feb 2009 16:59:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 34/47] packet: Avoid lock_sock in mmap handler
Message-ID: <20090214005911.GI11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="packet-avoid-lock_sock-in-mmap-handler.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 905db44087855e3c1709f538ecdc22fd149cadd8 ]

As the mmap handler gets called under mmap_sem, and we may grab
mmap_sem elsewhere under the socket lock to access user data, we
should avoid grabbing the socket lock in the mmap handler.

Since the only thing we care about in the mmap handler is for
pg_vec* to be invariant, i.e., to exclude packet_set_ring, we
can achieve this by simply using a new mutex.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/packet/af_packet.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -77,6 +77,7 @@
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/mutex.h>
 
 #ifdef CONFIG_INET
 #include <net/inet_common.h>
@@ -175,6 +176,7 @@ struct packet_sock {
 #endif
 	struct packet_type	prot_hook;
 	spinlock_t		bind_lock;
+	struct mutex		pg_vec_lock;
 	unsigned int		running:1,	/* prot_hook is attached*/
 				auxdata:1,
 				origdev:1;
@@ -1068,6 +1070,7 @@ static int packet_create(struct net *net
 	 */
 
 	spin_lock_init(&po->bind_lock);
+	mutex_init(&po->pg_vec_lock);
 	po->prot_hook.func = packet_rcv;
 
 	if (sock->type == SOCK_PACKET)
@@ -1863,6 +1866,7 @@ static int packet_set_ring(struct sock *
 	synchronize_net();
 
 	err = -EBUSY;
+	mutex_lock(&po->pg_vec_lock);
 	if (closing || atomic_read(&po->mapped) == 0) {
 		err = 0;
 #define XC(a, b) ({ __typeof__ ((a)) __t; __t = (a); (a) = (b); __t; })
@@ -1884,6 +1888,7 @@ static int packet_set_ring(struct sock *
 		if (atomic_read(&po->mapped))
 			printk(KERN_DEBUG "packet_mmap: vma is busy: %d\n", atomic_read(&po->mapped));
 	}
+	mutex_unlock(&po->pg_vec_lock);
 
 	spin_lock(&po->bind_lock);
 	if (was_running && !po->running) {
@@ -1916,7 +1921,7 @@ static int packet_mmap(struct file *file
 
 	size = vma->vm_end - vma->vm_start;
 
-	lock_sock(sk);
+	mutex_lock(&po->pg_vec_lock);
 	if (po->pg_vec == NULL)
 		goto out;
 	if (size != po->pg_vec_len*po->pg_vec_pages*PAGE_SIZE)
@@ -1939,7 +1944,7 @@ static int packet_mmap(struct file *file
 	err = 0;
 
 out:
-	release_sock(sk);
+	mutex_unlock(&po->pg_vec_lock);
 	return err;
 }
 #endif

