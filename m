Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYD2RWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYD2RWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbYD2RUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:24 -0400
Received: from mx1.suse.de ([195.135.220.2]:51849 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599AbYD2RUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:22 -0400
Date: Tue, 29 Apr 2008 10:18:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [07/37] RTNETLINK: Fix bogus ASSERT_RTNL warning
Message-ID: <20080429171808.GH14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtnetlink-fix-bogus-assert_rtnl-warning.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Patrick McHardy <kaber@trash.net>

[ Upstream commit: c9c1014b2bd014c7ec037bbb6f58818162fdb265 ]

ASSERT_RTNL uses mutex_trylock to test whether the rtnl_mutex is
held. This bogus warnings when running in atomic context, which
f.e. happens when adding secondary unicast addresses through
macvlan or vlan or when synchronizing multicast addresses from
wireless devices.

Mid-term we might want to consider moving all address updates
to process context since the locking seems overly complicated,
for now just fix the bogus warning by changing ASSERT_RTNL to
use mutex_is_locked().

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/rtnetlink.h |    4 ++--
 net/core/rtnetlink.c      |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -740,13 +740,13 @@ extern void rtmsg_ifinfo(int type, struc
 extern void rtnl_lock(void);
 extern void rtnl_unlock(void);
 extern int rtnl_trylock(void);
+extern int rtnl_is_locked(void);
 
 extern void rtnetlink_init(void);
 extern void __rtnl_unlock(void);
 
 #define ASSERT_RTNL() do { \
-	if (unlikely(rtnl_trylock())) { \
-		rtnl_unlock(); \
+	if (unlikely(!rtnl_is_locked())) { \
 		printk(KERN_ERR "RTNL: assertion failed at %s (%d)\n", \
 		       __FILE__,  __LINE__); \
 		dump_stack(); \
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -82,6 +82,11 @@ int rtnl_trylock(void)
 	return mutex_trylock(&rtnl_mutex);
 }
 
+int rtnl_is_locked(void)
+{
+	return mutex_is_locked(&rtnl_mutex);
+}
+
 static struct rtnl_link *rtnl_msg_handlers[NPROTO];
 
 static inline int rtm_msgindex(int msgtype)
@@ -1389,6 +1394,7 @@ EXPORT_SYMBOL(rtnetlink_put_metrics);
 EXPORT_SYMBOL(rtnl_lock);
 EXPORT_SYMBOL(rtnl_trylock);
 EXPORT_SYMBOL(rtnl_unlock);
+EXPORT_SYMBOL(rtnl_is_locked);
 EXPORT_SYMBOL(rtnl_unicast);
 EXPORT_SYMBOL(rtnl_notify);
 EXPORT_SYMBOL(rtnl_set_sk_err);

-- 
