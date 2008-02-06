Return-Path: <linux-kernel-owner+w=401wt.eu-S1765032AbYBGADz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765032AbYBGADz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764350AbYBFXzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:55:10 -0500
Received: from mail.suse.de ([195.135.220.2]:45410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760421AbYBFXzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:55:07 -0500
Date: Wed, 6 Feb 2008 15:51:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Mark McLoughlin <markmc@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/73] INET: Fix netdev renaming and inet address labels
Message-ID: <20080206235157.GU13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="inet-fix-netdev-renaming-and-inet-address-labels.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Mark McLoughlin <markmc@redhat.com>

[INET]: Fix netdev renaming and inet address labels

[ Upstream commit: 44344b2a85f03326c7047a8c861b0c625c674839 ]

When re-naming an interface, the previous secondary address
labels get lost e.g.

  $> brctl addbr foo
  $> ip addr add 192.168.0.1 dev foo
  $> ip addr add 192.168.0.2 dev foo label foo:00
  $> ip addr show dev foo | grep inet
    inet 192.168.0.1/32 scope global foo
    inet 192.168.0.2/32 scope global foo:00
  $> ip link set foo name bar
  $> ip addr show dev bar | grep inet
    inet 192.168.0.1/32 scope global bar
    inet 192.168.0.2/32 scope global bar:2

Turns out to be a simple thinko in inetdev_changename() - clearly we
want to look at the address label, rather than the device name, for
a suffix to retain.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/devinet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1030,7 +1030,7 @@ static void inetdev_changename(struct ne
 		memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
 		if (named++ == 0)
 			continue;
-		dot = strchr(ifa->ifa_label, ':');
+		dot = strchr(old, ':');
 		if (dot == NULL) {
 			sprintf(old, ":%d", named);
 			dot = old;

-- 
