Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbZFIK1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbZFIK1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760744AbZFIKT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:19:59 -0400
Received: from kroah.org ([198.145.64.141]:54978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760719AbZFIKT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:19:58 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:02 2009
Message-Id: <20090609094102.610840271@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:33 -0700
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
       alan@lxorguk.ukuu.org.uk, Eric Paris <eparis@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 45/87] SELinux: BUG in SELinux compat_net code
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=selinux-bug-in-selinux-compat_net-code.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4648,7 +4648,7 @@ static int selinux_ip_postroute_iptables
 	if (err)
 		return err;
 
-	if (send_perm != 0)
+	if (!send_perm)
 		return 0;
 
 	err = sel_netport_sid(sk->sk_protocol,


