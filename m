Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbZFIKUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbZFIKUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760488AbZFIKST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:19 -0400
Received: from kroah.org ([198.145.64.141]:54515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760483AbZFIKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:18 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:56 2009
Message-Id: <20090609094056.699126694@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:08 -0700
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
       alan@lxorguk.ukuu.org.uk, Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 20/87] wimax: fix oops if netlink fails to add attribute
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=wimax-fix-oops-if-netlink-fails-to-add-attribute.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Inaky Perez-Gonzalez <inaky@linux.intel.com>

commit d1a2627a29667fe7c4a9d06e1579a2d65bd39bba upstream.

When sending a message to user space using wimax_msg(), if nla_put()
fails, correctly interpret the return code from wimax_msg_alloc() as
an err ptr and return the error code instead of crashing (as it is
assuming than non-NULL means the pointer is ok).

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wimax/op-msg.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/wimax/op-msg.c
+++ b/net/wimax/op-msg.c
@@ -149,7 +149,8 @@ struct sk_buff *wimax_msg_alloc(struct w
 	}
 	result = nla_put(skb, WIMAX_GNL_MSG_DATA, size, msg);
 	if (result < 0) {
-		dev_err(dev, "no memory to add payload in attribute\n");
+		dev_err(dev, "no memory to add payload (msg %p size %zu) in "
+			"attribute: %d\n", msg, size, result);
 		goto error_nla_put;
 	}
 	genlmsg_end(skb, genl_msg);
@@ -302,10 +303,10 @@ int wimax_msg(struct wimax_dev *wimax_de
 	struct sk_buff *skb;
 
 	skb = wimax_msg_alloc(wimax_dev, pipe_name, buf, size, gfp_flags);
-	if (skb == NULL)
-		goto error_msg_new;
-	result = wimax_msg_send(wimax_dev, skb);
-error_msg_new:
+	if (IS_ERR(skb))
+		result = PTR_ERR(skb);
+	else
+		result = wimax_msg_send(wimax_dev, skb);
 	return result;
 }
 EXPORT_SYMBOL_GPL(wimax_msg);


