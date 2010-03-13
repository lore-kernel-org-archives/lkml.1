Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935553Ab0CMAcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:31 -0500
Received: from kroah.org ([198.145.64.141]:46808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935391Ab0CMAbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.647865700@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [039/145] net: Fix sysctl restarts...
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 88af182e389097997c5e2a0b42285b3522796759 ]

Yuck.  It turns out that when we restart sysctls we were restarting
with the values already changed.  Which unfortunately meant that
the second time through we thought there was no change and skipped
all kinds of work, despite the fact that there was indeed a change.

I have fixed this the simplest way possible by restoring the changed
values when we restart the sysctl write.

One of my coworkers spotted this bug when after disabling forwarding
on an interface pings were still forwarded.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/devinet.c  |    7 ++++++-
 net/ipv6/addrconf.c |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1351,14 +1351,19 @@ static int devinet_sysctl_forward(ctl_ta
 {
 	int *valp = ctl->data;
 	int val = *valp;
+	loff_t pos = *ppos;
 	int ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 
 	if (write && *valp != val) {
 		struct net *net = ctl->extra2;
 
 		if (valp != &IPV4_DEVCONF_DFLT(net, FORWARDING)) {
-			if (!rtnl_trylock())
+			if (!rtnl_trylock()) {
+				/* Restore the original values before restarting */
+				*valp = val;
+				*ppos = pos;
 				return restart_syscall();
+			}
 			if (valp == &IPV4_DEVCONF_ALL(net, FORWARDING)) {
 				inet_forward_change(net);
 			} else if (*valp) {
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -504,8 +504,11 @@ static int addrconf_fixup_forwarding(str
 	if (p == &net->ipv6.devconf_dflt->forwarding)
 		return 0;
 
-	if (!rtnl_trylock())
+	if (!rtnl_trylock()) {
+		/* Restore the original values before restarting */
+		*p = old;
 		return restart_syscall();
+	}
 
 	if (p == &net->ipv6.devconf_all->forwarding) {
 		__s32 newf = net->ipv6.devconf_all->forwarding;
@@ -3991,12 +3994,15 @@ int addrconf_sysctl_forward(ctl_table *c
 {
 	int *valp = ctl->data;
 	int val = *valp;
+	loff_t pos = *ppos;
 	int ret;
 
 	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 
 	if (write)
 		ret = addrconf_fixup_forwarding(ctl, valp, val);
+	if (ret)
+		*ppos = pos;
 	return ret;
 }
 
@@ -4075,8 +4081,11 @@ static int addrconf_disable_ipv6(struct
 	if (p == &net->ipv6.devconf_dflt->disable_ipv6)
 		return 0;
 
-	if (!rtnl_trylock())
+	if (!rtnl_trylock()) {
+		/* Restore the original values before restarting */
+		*p = old;
 		return restart_syscall();
+	}
 
 	if (p == &net->ipv6.devconf_all->disable_ipv6) {
 		__s32 newf = net->ipv6.devconf_all->disable_ipv6;
@@ -4095,12 +4104,15 @@ int addrconf_sysctl_disable(ctl_table *c
 {
 	int *valp = ctl->data;
 	int val = *valp;
+	loff_t pos = *ppos;
 	int ret;
 
 	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 
 	if (write)
 		ret = addrconf_disable_ipv6(ctl, valp, val);
+	if (ret)
+		*ppos = pos;
 	return ret;
 }
 


