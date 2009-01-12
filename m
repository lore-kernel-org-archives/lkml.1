Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZALDSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZALDSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 22:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZALDSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 22:18:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZALDSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 22:18:43 -0500
Date: Sun, 11 Jan 2009 22:18:41 -0500
From: Kyle McMartin <kyle@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au
Subject: [PATCH] [RFC] remove (more or less) unnecessary cacheline_aligned
	from module_ref
Message-ID: <20090112031841.GC21090@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64 systems with CONFIG_MAXSMP set, NR_CPUS is exploded to 4096
cpus. This cacheline_aligned attribute on the local_t in module_ref
results in struct module bloating to over 512KB in size on x86_64, which
tends to, er, add up. This results in insane disk usage on distro
kernel configs (1GB+ on Fedora.)

Killing cacheline_aligned reduces the size of struct module to somewhat
more sane levels.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
I'll followup with a patch to make mod->ref dynamically allocated, but
that needs a bit more thinking because module_unload_init currently
doesn't have a failure path.

Of course, reducing NR_CPUS to something sane was an easy way to patch
over the problem.

diff --git a/include/linux/module.h b/include/linux/module.h
index 4f7ea12..32b0bda 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -222,7 +222,7 @@ void *__symbol_get_gpl(const char *symbol);
 struct module_ref
 {
 	local_t count;
-} ____cacheline_aligned;
+};
 
 enum module_state
 {
