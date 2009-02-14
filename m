Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbZBNBNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbZBNBNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbZBNBBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:55 -0500
Received: from kroah.org ([198.145.64.141]:39791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761332AbZBNBBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:53 -0500
Date: Fri, 13 Feb 2009 16:59:06 -0800
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
       alan@lxorguk.ukuu.org.uk, Alex Williamson <alex.williamson@hp.com>,
       Mark McLoughlin <markmc@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 31/47] virtio_net: Fix MAX_PACKET_LEN to support 802.1Q
	VLANs
Message-ID: <20090214005906.GF11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="virtio_net-fix-max_packet_len-to-support-802.1q-vlans.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@hp.com>

[ Upstream commit e918085aaff34086e265f825dd469926b1aec4a4 ]

802.1Q expanded the maximum ethernet frame size by 4 bytes for the
VLAN tag.  We're not taking this into account in virtio_net, which
means the buffers we provide to the backend in the virtqueue RX ring
aren't big enough to hold a full MTU VLAN packet.  For QEMU/KVM,
this results in the backend exiting with a packet truncation error.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
Acked-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/virtio_net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -24,6 +24,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_net.h>
 #include <linux/scatterlist.h>
+#include <linux/if_vlan.h>
 
 static int napi_weight = 128;
 module_param(napi_weight, int, 0444);
@@ -33,7 +34,7 @@ module_param(csum, bool, 0444);
 module_param(gso, bool, 0444);
 
 /* FIXME: MTU in config. */
-#define MAX_PACKET_LEN (ETH_HLEN+ETH_DATA_LEN)
+#define MAX_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
 
 struct virtnet_info
 {

