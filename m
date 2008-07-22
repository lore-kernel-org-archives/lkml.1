Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbYGVXbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbYGVXbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbYGVXXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469AbYGVXXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:13 -0400
Date: Tue, 22 Jul 2008 16:17:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Jenkins <darrenrjenkins@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 40/47] drivers/char/pcmcia/ipwireless/hardware.c fix
	resource leak
Message-ID: <20080722231723.GO8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-char-pcmcia-ipwireless-hardware.c-fix-resource-leak.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Darren Jenkins <darrenrjenkins@gmail.com>

commit 43f77e91eadbc290eb76a08110a039c809dde6c9 upstream

Coverity CID: 2172 RESOURCE_LEAK

When pool_allocate() tries to enlarge a packet, if it can not allocate enough
memory, it returns NULL without first freeing the old packet.

This patch just frees the packet first.

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/pcmcia/ipwireless/hardware.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -616,8 +616,10 @@ static struct ipw_rx_packet *pool_alloca
 		packet = kmalloc(sizeof(struct ipw_rx_packet) +
 				old_packet->length + minimum_free_space,
 				GFP_ATOMIC);
-		if (!packet)
+		if (!packet) {
+			kfree(old_packet);
 			return NULL;
+		}
 		memcpy(packet, old_packet,
 				sizeof(struct ipw_rx_packet)
 					+ old_packet->length);

-- 
