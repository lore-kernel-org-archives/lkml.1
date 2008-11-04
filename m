Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYKDXnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYKDXnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbYKDXie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365AbYKDXid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:33 -0500
Date: Tue, 4 Nov 2008 15:31:33 -0800
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
       alan@lxorguk.ukuu.org.uk, Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/57] pkt_sched: sch_generic: Fix oops in sch_teql
Message-ID: <20081104233133.GR659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0004-pkt_sched-sch_generic-Fix-oops-in-sch_teql.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit 9f3ffae0dbce491a3e9871b686342fd5aa854f05 ]

After these commands:
# modprobe sch_teql
# tc qdisc add dev eth0 root teql0
# tc qdisc del dev eth0 root
we get an oops in teql_destroy() when spin_lock is taken from a null
qdisc_sleeping pointer. It's because at the moment teql0 dev haven't
been activated yet, and a qdisc_root_sleeping() is pointing to noop
qdisc's netdev_queue with qdisc_sleeping uninitialized. This patch
fixes this both for noop and noqueue netdev_queues to avoid similar
problems in the future.

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_generic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -319,6 +319,7 @@ struct Qdisc_ops noop_qdisc_ops __read_m
 
 static struct netdev_queue noop_netdev_queue = {
 	.qdisc		=	&noop_qdisc,
+	.qdisc_sleeping	=	&noop_qdisc,
 };
 
 struct Qdisc noop_qdisc = {
@@ -344,6 +345,7 @@ static struct Qdisc_ops noqueue_qdisc_op
 static struct Qdisc noqueue_qdisc;
 static struct netdev_queue noqueue_netdev_queue = {
 	.qdisc		=	&noqueue_qdisc,
+	.qdisc_sleeping	=	&noqueue_qdisc,
 };
 
 static struct Qdisc noqueue_qdisc = {

-- 
