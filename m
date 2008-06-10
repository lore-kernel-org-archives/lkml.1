Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYFJR5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYFJR5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYFJR5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:57:40 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:22991 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYFJR5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:57:39 -0400
Date: Tue, 10 Jun 2008 10:57:24 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Zach Brown <zach.brown@oracle.com>
CC: Mark Fasheh <mark.fasheh@oracle.com>, Kurt Hackel <kurt.hackel@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: static kset (and kobject)...
Message-ID: <20080610175723.GT26334@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zack,  FYI:  I just learned that static ksets and kobjects
are bad (see Documentation/kobject.txt for details).  The
following commit:

commit 52fd3d6fea441835fe3a35b7280e5e128bdeca9b
Author: Zach Brown <zach.brown@oracle.com>
Date:   Thu Dec 15 14:31:23 2005 -0800

    [PATCH] OCFS2: The Second Oracle Cluster Filesystem
    
    Very simple printk wrapper which adds the ability to enable various
    sets of debug messages at run-time.
    
    Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
    Signed-off-by: Kurt Hackel <kurt.hackel@oracle.com>

Introduces:

+static struct kset mlog_kset = {
+       .kobj   = {.name = "logmask", .ktype = &mlog_ktype},
+};
+
+int mlog_sys_init(struct subsystem *o2cb_subsys)
+{
+       int i = 0;
+
+       while (mlog_attrs[i].attr.mode) {
+               mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
+               i++;
+       }
+       mlog_attr_ptrs[i] = NULL;
+
+       mlog_kset.subsys = o2cb_subsys;
+       return kset_register(&mlog_kset);
+}
+
+void mlog_sys_shutdown(void)
+{
+       kset_unregister(&mlog_kset);
+}

which I've learned the hard way probably won't
work as expected.  I'm surprised that you don't
see some sort of issue w/ this on module reload...

Arthur
