Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbXE1U5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbXE1U5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXE1U5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:57:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:55373 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXE1U53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:57:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kWnrn45AvUTit/SrDj9QNdqaD5+QpuJ8pkzPoCB9ntQx41I7Eg1LeOovaqTPRMEeQryT8hsdopyw2YQ0a+3M9aqoRZ//JlAY8tSvA9StxSLdCq6Xh9lFiuyVGFo5hV+hNfSWtox2wl0kF6ypxzMlE6eOjCzFL7V0iFmRYE8aPoY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix potential memory leak in tipc_named_node_up()
Date: Mon, 28 May 2007 22:58:08 +0200
User-Agent: KMail/1.9.6
Cc: Per Linden <per.liden@ericsson.com>, Jon Maloy <jon.maloy@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>,
       tipc-discussion@lists.sourceforge.net,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705282258.08701.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a memory leak in net/tipc/name_distr.c::tipc_named_node_up()

The function, with comments, is this :

void tipc_named_node_up(unsigned long node)
{
        struct publication *publ;
        struct distr_item *item = NULL;
        struct sk_buff *buf = NULL;
        u32 left = 0;
        u32 rest;
        u32 max_item_buf;

        read_lock_bh(&tipc_nametbl_lock);
        max_item_buf = TIPC_MAX_USER_MSG_SIZE / ITEM_SIZE;
        max_item_buf *= ITEM_SIZE;
        rest = publ_cnt * ITEM_SIZE;

        list_for_each_entry(publ, &publ_root, local_list) {
-----> If we stop processing here after doing 1, 2 & 3 below we end up at (4) (below).
                if (!buf) {
                        left = (rest <= max_item_buf) ? rest : max_item_buf;
                        rest -= left;
                        buf = named_prepare_buf(PUBLICATION, left, node);
-----> (1) here we allocate memory and store a pointer to it in 'buf'.

                        if (!buf) {
-----> (2) This test needs to fail, meaning we did allocate some memory.
                                warn("Bulk publication distribution failure\n");
                                goto exit;
                        }
                        item = (struct distr_item *)msg_data(buf_msg(buf));
                }
                publ_to_item(item, publ);
                item++;
                left -= ITEM_SIZE;
                if (!left) {
-----> (3) If this test fails we loop and do nothing to 'buf'.
                        msg_set_link_selector(buf_msg(buf), node);
                        dbg("tipc_named_node_up: sending publish msg to "
                            "<%u.%u.%u>\n", tipc_zone(node),
                            tipc_cluster(node), tipc_node(node));
                        tipc_link_send(buf, node, node);
                        buf = NULL;
                }
        }
exit:
        read_unlock_bh(&tipc_nametbl_lock);
-----> (4) here we return without freeing 'buf' - memory leak.
}

Luckily this is easy to fix, since we can only leave the function with 'buf'
either set to NULL or (in the leak case) set to a valid address, and since 
kfree() handles being passed NULL gracefully we can simply kfree(buf) just 
before we leave the function.

The patch below frees 'buf' before leaving the function, thus avoiding the 
potential leak.



Fix a potential memory leak in tipc_named_node_up()

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 net/tipc/name_distr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/tipc/name_distr.c b/net/tipc/name_distr.c
index 39fd161..228ccfe 100644
--- a/net/tipc/name_distr.c
+++ b/net/tipc/name_distr.c
@@ -204,6 +204,7 @@ void tipc_named_node_up(unsigned long node)
 	}
 exit:
 	read_unlock_bh(&tipc_nametbl_lock);
+	kfree(buf);
 }
 
 /**



