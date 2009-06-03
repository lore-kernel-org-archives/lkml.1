Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZFCJft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZFCJft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbZFCJeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:34:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:21206 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbZFCJe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ihWGFAEZShf0mCofx3zgQo/0FVYK6Z1UCZhk1XEdCELntjZJlyu02HB4Yr/6QdBHm+
         +CYZZlpzPtW89KZ5EMrh+4cEh/1a6JAB4Dx323F2ykbxpS5+pa5JjJoitZvzkgS8lPRQ
         FY6y0DTraTuZMJzFkyzR+R+huyq301smIvxvQ=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       davem@davemloft.net, Stephen Rothwell <sfr@canb.auug.org.au>,
       Sergey Lapin <slapin@ossfans.org>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH 5/6] ieee802154: add documentation about our stack
Date: Wed,  3 Jun 2009 13:33:48 +0400
Message-Id: <1244021629-18409-6-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244021629-18409-5-git-send-email-dbaryshkov@gmail.com>
References: <1244021629-18409-1-git-send-email-dbaryshkov@gmail.com>
 <1244021629-18409-2-git-send-email-dbaryshkov@gmail.com>
 <1244021629-18409-3-git-send-email-dbaryshkov@gmail.com>
 <1244021629-18409-4-git-send-email-dbaryshkov@gmail.com>
 <1244021629-18409-5-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MAINTAINERS entry and a small text describing our stack interfaces,
how to hook the drivers, etc.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Sergey Lapin <slapin@ossfans.org>
---
 Documentation/networking/ieee802154.txt |   76 +++++++++++++++++++++++++++++++
 MAINTAINERS                             |   12 +++++
 2 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/networking/ieee802154.txt

diff --git a/Documentation/networking/ieee802154.txt b/Documentation/networking/ieee802154.txt
new file mode 100644
index 0000000..a0280ad
--- /dev/null
+++ b/Documentation/networking/ieee802154.txt
@@ -0,0 +1,76 @@
+
+		Linux IEEE 802.15.4 implementation
+
+
+Introduction
+============
+
+The Linux-ZigBee project goal is to provide complete implementation
+of IEEE 802.15.4 / ZigBee / 6LoWPAN protocols. IEEE 802.15.4 is a stack
+of protocols for organizing Low-Rate Wireless Personal Area Networks.
+
+Currently only IEEE 802.15.4 layer is implemented. We have choosen
+to use plain Berkeley socket API, the generic Linux networking stack
+to transfer IEEE 802.15.4 messages and a special protocol over genetlink
+for configuration/management
+
+
+Socket API
+==========
+
+int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
+.....
+
+The address family, socket addresses etc. are defined in the
+include/net/ieee802154/af_ieee802154.h header or in the special header
+in our userspace package (see either linux-zigbee sourceforge download page
+or git tree at git://linux-zigbee.git.sourceforge.net/gitroot/linux-zigbee).
+
+One can use SOCK_RAW for passing raw data towards device xmit function. YMMV.
+
+
+MLME - MAC Level Management
+============================
+
+Most of IEEE 802.15.4 MLME interfaces are directly mapped on netlink commands.
+See the include/net/ieee802154/nl802154.h header. Our userspace tools package
+(see above) provides CLI configuration utility for radio interfaces and simple
+coordinator for IEEE 802.15.4 networks as an example users of MLME protocol.
+
+
+Kernel side
+=============
+
+Like with WiFi, there are several types of devices implementing IEEE 802.15.4.
+1) 'HardMAC'. The MAC layer is implemented in the device itself, the device
+   exports MLME and data API.
+2) 'SoftMAC' or just radio. These types of devices are just radio transceivers
+   possibly with some kinds of acceleration like automatic CRC computation and
+   comparation, automagic ACK handling, address matching, etc.
+
+Those types of devices require different approach to be hooked into Linux kernel.
+
+
+HardMAC
+=======
+
+See the header include/net/ieee802154/netdevice.h. You have to implement Linux
+net_device, with .type = ARPHRD_IEEE802154. Data is exchanged with socket family
+code via plain sk_buffs. The control block of sk_buffs will contain additional
+info as described in the struct ieee802154_mac_cb.
+
+To hook the MLME interface you have to populate the ml_priv field of your
+net_device with a pointer to struct ieee802154_mlme_ops instance. All fields are
+required.
+
+We provide an example of simple HardMAC driver at drivers/ieee802154/fakehard.c
+
+
+SoftMAC
+=======
+
+We are going to provide intermediate layer impelementing IEEE 802.15.4 MAC
+in software. This is currently WIP.
+
+See header include/net/ieee802154/mac802154.h and several drivers in
+drivers/ieee802154/
diff --git a/MAINTAINERS b/MAINTAINERS
index 77cbfb1..d7214c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2807,6 +2807,18 @@ L:	linux1394-devel@lists.sourceforge.net
 S:	Maintained
 F:	drivers/ieee1394/raw1394*
 
+IEEE 802.15.4 SUBSYSTEM
+P:	Dmitry Eremin-Solenikov
+M:	dbaryshkov@gmail.com
+P:	Sergey Lapin
+M:	slapin@ossfans.org
+L:	linux-zigbee-devel@lists.sourceforge.net
+W:	http://apps.sourceforge.net/trac/linux-zigbee
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git
+S:	Maintained
+F:	net/ieee802154/
+F:	drivers/ieee801254/
+
 INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
 P:	Mimi Zohar
 M:	zohar@us.ibm.com
-- 
1.6.3.1

