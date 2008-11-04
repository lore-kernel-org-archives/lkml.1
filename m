Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbYKDXqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbYKDXqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYKDXi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:58 -0500
Received: from mx1.suse.de ([195.135.220.2]:47414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbYKDXi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:57 -0500
Date: Tue, 4 Nov 2008 15:31:47 -0800
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
       alan@lxorguk.ukuu.org.uk, linux1394-devel@lists.sourceforge.net,
       Jay Fenlason <fenlason@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 23/57] firewire: fix struct fw_node memory leak
Message-ID: <20081104233147.GX659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fix-struct-fw_node-memory-leak.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jay Fenlason <fenlason@redhat.com>

commit 77e557191701afa55ae7320d42ad6458a2ad292e upstream

With the bus_resets patch applied, it is easy to see this memory leak
by repeatedly resetting the firewire bus while running slabtop in
another window.  Just watch kmalloc-32 grow and grow...

Signed-off-by: Jay Fenlason <fenlason@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

---
 drivers/firewire/fw-topology.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/firewire/fw-topology.c
+++ b/drivers/firewire/fw-topology.c
@@ -413,7 +413,7 @@ static void
 update_tree(struct fw_card *card, struct fw_node *root)
 {
 	struct list_head list0, list1;
-	struct fw_node *node0, *node1;
+	struct fw_node *node0, *node1, *next1;
 	int i, event;
 
 	INIT_LIST_HEAD(&list0);
@@ -485,7 +485,9 @@ update_tree(struct fw_card *card, struct
 		}
 
 		node0 = fw_node(node0->link.next);
-		node1 = fw_node(node1->link.next);
+		next1 = fw_node(node1->link.next);
+		fw_node_put(node1);
+		node1 = next1;
 	}
 }
 

-- 
