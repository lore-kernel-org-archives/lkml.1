Return-Path: <linux-kernel-owner+w=401wt.eu-S932449AbZAOUQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbZAOUQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765991AbZAOUAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:52 -0500
Received: from kroah.org ([198.145.64.141]:48984 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762658AbZAOUAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:40 -0500
Date: Thu, 15 Jan 2009 11:58:09 -0800
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
       alan@lxorguk.ukuu.org.uk, "Serge E. Hallyn" <serue@us.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pavel Emelyanov <xemul@openvz.org>,
       Paul Menage <menage@google.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 25/94] devices cgroup: allow mkfifo
Message-ID: <20090115195809.GY14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="devices-cgroup-allow-mkfifo.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Serge E. Hallyn <serue@us.ibm.com>

commit 0b82ac37b889ec881b645860da3775118effb3ca upstream.

The devcgroup_inode_permission() hook in the devices whitelist cgroup has
always bypassed access checks on fifos.  But the mknod hook did not.  The
devices whitelist is only about block and char devices, and fifos can't
even be added to the whitelist, so fifos can't be created at all except by
tasks which have 'a' in their whitelist (meaning they have access to all
devices).

Fix the behavior by bypassing access checks to mkfifo.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: James Morris <jmorris@namei.org>
Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/device_cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -513,6 +513,9 @@ int devcgroup_inode_mknod(int mode, dev_
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
+	if (!S_ISBLK(mode) && !S_ISCHR(mode))
+		return 0;
+
 	rcu_read_lock();
 
 	dev_cgroup = task_devcgroup(current);

