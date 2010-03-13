Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018Ab0CMAVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:21:13 -0500
Received: from kroah.org ([198.145.64.141]:60747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934942Ab0CMAUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:24 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.120690033@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Fietkau <nbd@openwrt.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 068/123] skbuff: align sk_buff::cb to 64 bit and close some potential holes
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Felix Fietkau <nbd@openwrt.org>

commit da3f5cf1f8ebb0fab5c5fd09adb189166594ad6c upstream.

The alignment requirement for 64-bit load/store instructions on ARM is
implementation defined. Some CPUs (such as Marvell Feroceon) do not
generate an exception, if such an instruction is executed with an
address that is not 64 bit aligned. In such a case, the Feroceon
corrupts adjacent memory, which showed up in my tests as a crash in the
rx path of ath9k that only occured with CONFIG_XFRM set.

This crash happened, because the first field of the mac80211 rx status
info in the cb is an u64, and changing it corrupted the skb->sp field.

This patch also closes some potential pre-existing holes in the sk_buff
struct surrounding the cb[] area.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/skbuff.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -315,22 +315,23 @@ struct sk_buff {
 	struct sk_buff		*next;
 	struct sk_buff		*prev;
 
-	struct sock		*sk;
 	ktime_t			tstamp;
+
+	struct sock		*sk;
 	struct net_device	*dev;
 
-	unsigned long		_skb_dst;
-#ifdef CONFIG_XFRM
-	struct	sec_path	*sp;
-#endif
 	/*
 	 * This is the control buffer. It is free to use for every
 	 * layer. Please put your private variables there. If you
 	 * want to keep them across layers you have to do a skb_clone()
 	 * first. This is owned by whoever has the skb queued ATM.
 	 */
-	char			cb[48];
+	char			cb[48] __aligned(8);
 
+	unsigned long		_skb_dst;
+#ifdef CONFIG_XFRM
+	struct	sec_path	*sp;
+#endif
 	unsigned int		len,
 				data_len;
 	__u16			mac_len,


