Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZESVon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZESVon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZESVog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:44:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZESVof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:44:35 -0400
Subject: [PATCH] SELinux: BUG in SELinux compat_net code
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
       selinux@vger.kernel.org
Cc: jmorris@namei.org, sds@tycho.nsa.gov, paul.moore@hp.com,
       manoj.iyer@canonical.com
Content-Type: text/plain
Date: Tue, 19 May 2009 17:41:58 -0400
Message-Id: <1242769318.2763.22.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not applicable to Linus's tree as the code in question has
been removed for 2.6.30.  I'm sending in case any of the stable
maintainers would like to push to their branches (which I think anything
pre 2.6.30 would like to do).

Ubuntu users were experiencing a kernel panic when they enabled SELinux
due to an old bug in our handling of the compatibility mode network
controls, introduced Jan 1 2008 effad8df44261031a882e1a895415f7186a5098e
Most distros have not used the compat_net code since the new code was
introduced and so noone has hit this problem before.  Ubuntu is the only
distro I know that enabled that legacy cruft by default.  But, I was ask
to look at it and found that the above patch changed a call to
avc_has_perm from if(send_perm) to if(!send_perm) in
selinux_ip_postroute_iptables_compat().  The result is that users who
turn on SELinux and have compat_net set can (and oftern will) BUG() in
avc_has_perm_noaudit since they are requesting 0 permissions.

This patch corrects that accidental bug introduction.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -up linux-source-2.6.28/security/selinux/hooks.c.pre.send linux-source-2.6.28/security/selinux/hooks.c
--- linux-source-2.6.28/security/selinux/hooks.c.pre.send	2009-05-18 13:23:16.043632602 -0400
+++ linux-source-2.6.28/security/selinux/hooks.c	2009-05-18 13:23:27.899632772 -0400
@@ -4561,7 +4561,7 @@ static int selinux_ip_postroute_iptables
 	if (err)
 		return err;
 
-	if (send_perm != 0)
+	if (!send_perm)
 		return 0;
 
 	err = sel_netport_sid(sk->sk_protocol,


