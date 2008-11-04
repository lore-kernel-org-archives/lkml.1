Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbYKDX60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbYKDX60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbYKDXlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:41:23 -0500
Received: from ns2.suse.de ([195.135.220.15]:52370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbYKDXlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:41:22 -0500
Date: Tue, 4 Nov 2008 15:33:36 -0800
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
       alan@lxorguk.ukuu.org.uk, Andy Gospodarek <andy@greyhouse.net>,
       Jay Vosburgh <fubar@us.ibm.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 56/57] bonding: fix panic when taking bond interface down
	before removing module
Message-ID: <20081104233336.GE659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bonding-fix-panic-when-taking-bond-interface-down-before-removing-module.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andy Gospodarek <andy@greyhouse.net>

commit ce39a800ea87c655de49af021c8b20ee323cb40d upstream.

A panic was discovered with bonding when using mode 5 or 6 and trying to
remove the slaves from the bond after the interface was taken down.
When calling 'ifconfig bond0 down' the following happens:

    bond_close()
        bond_alb_deinitialize()
            tlb_deinitialize()
		kfree(bond_info->tx_hashtbl)
                bond_info->tx_hashtbl = NULL

Unfortunately if there are still slaves in the bond, when removing the
module the following happens:

    bonding_exit()
        bond_free_all()
            bond_release_all()
                bond_alb_deinit_slave()
                    tlb_clear_slave()
                        tx_hash_table = BOND_ALB_INFO(bond).tx_hashtbl
			u32 next_index = tx_hash_table[index].next

As you might guess we panic when trying to access a few entries into the
table that no longer exists.

I experimented with several options (like moving the calls to
tlb_deinitialize somewhere else), but it really makes the most sense to
be part of the bond_close routine.  It also didn't seem logical move
tlb_clear_slave around too much, so the simplest option seems to add a
check in tlb_clear_slave to make sure we haven't already wiped the
tx_hashtbl away before searching for all the non-existent hash-table
entries that used to point to the slave as the output interface.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_alb.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -167,11 +167,14 @@ static void tlb_clear_slave(struct bondi
 	/* clear slave from tx_hashtbl */
 	tx_hash_table = BOND_ALB_INFO(bond).tx_hashtbl;
 
-	index = SLAVE_TLB_INFO(slave).head;
-	while (index != TLB_NULL_INDEX) {
-		u32 next_index = tx_hash_table[index].next;
-		tlb_init_table_entry(&tx_hash_table[index], save_load);
-		index = next_index;
+	/* skip this if we've already freed the tx hash table */
+	if (tx_hash_table) {
+		index = SLAVE_TLB_INFO(slave).head;
+		while (index != TLB_NULL_INDEX) {
+			u32 next_index = tx_hash_table[index].next;
+			tlb_init_table_entry(&tx_hash_table[index], save_load);
+			index = next_index;
+		}
 	}
 
 	tlb_init_slave(slave);

-- 
