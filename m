Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbYJRTMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbYJRTMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYJRTEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:04:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:47530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbYJRTEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:04:30 -0400
Date: Sat, 18 Oct 2008 11:47:42 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 08/26] modules: fix module "notes" kobject leak
Message-ID: <20081018184742.GI301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="modules-fix-module-notes-kobject-leak.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Alexey Dobriyan <adobriyan@gmail.com>

commit e94320939f44e0cbaccc3f259a5778abced4949c upstream

Fix "notes" kobject leak

It happens every rmmod if KALLSYMS=y and SYSFS=y.

	# modprobe foo

kobject: 'foo' (ffffffffa00743d0): kobject_add_internal: parent: 'module', set: 'module'
kobject: 'holders' (ffff88017e7c5770): kobject_add_internal: parent: 'foo', set: '<NULL>'
kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
kobject: 'notes' (ffff88017fa9b668): kobject_add_internal: parent: 'foo', set: '<NULL>'
	  ^^^^^

	# rmmod foo

kobject: 'holders' (ffff88017e7c5770): kobject_cleanup
kobject: 'holders' (ffff88017e7c5770): auto cleanup kobject_del
kobject: 'holders' (ffff88017e7c5770): calling ktype release
kobject: (ffff88017e7c5770): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'foo' (ffffffffa00743d0): kobject_cleanup
kobject: 'foo' (ffffffffa00743d0): does not have a release() function, it is broken and must be fixed.
kobject: 'foo' (ffffffffa00743d0): auto cleanup 'remove' event
kobject: 'foo' (ffffffffa00743d0): kobject_uevent_env
kobject: 'foo' (ffffffffa00743d0): fill_kobj_path: path = '/module/foo'
kobject: 'foo' (ffffffffa00743d0): auto cleanup kobject_del
kobject: 'foo': free name

	[whooops]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1143,7 +1143,7 @@ static void free_notes_attrs(struct modu
 		while (i-- > 0)
 			sysfs_remove_bin_file(notes_attrs->dir,
 					      &notes_attrs->attrs[i]);
-		kobject_del(notes_attrs->dir);
+		kobject_put(notes_attrs->dir);
 	}
 	kfree(notes_attrs);
 }

-- 
