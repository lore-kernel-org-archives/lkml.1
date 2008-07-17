Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYGQOw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYGQOw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYGQOwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:52:21 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:49482 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbYGQOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:52:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAFjzfkhMRKxB/2dsb2JhbACBWq57
Date: Thu, 17 Jul 2008 10:52:17 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wenji Huang <wenji.huang@oracle.com>, Roland McGrath <roland@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       ltt-dev@lists.casi.polymtl.ca, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markers duplicate modpost entry (update)
Message-ID: <20080717145217.GA24496@Krystal>
References: <20080715024754.GA26471@Krystal> <000001c8e7aa$b9548600$2bfd9200$@css.fujitsu.com> <20080717024550.GA22869@Krystal> <487ED503.2060503@oracle.com> <20080717070321.GB26035@Krystal> <20080717001613.8fe204df.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080717001613.8fe204df.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:41:52 up 42 days, 19:22,  6 users,  load average: 0.91, 1.60,
	1.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a kernel was rebuilt, the previous Module.markers was not cleared. It
caused markers with different format strings to appear as duplicates when a
markers was changed. This problem is present since scripts/mod/modpost.c started
to generate Module.markers,
commit b2e3e658b344c6bcfb8fb694100ab2f2b5b2edb0

It therefore applies to 2.6.25, 2.6.26 and linux-next.

I merely merged the patches from Roland, Wenji and Takashi here.

Credits to
Roland McGrath <roland@redhat.com>
Wenji Huang <wenji.huang@oracle.com> 
and
Takashi Nishiie <t-nishiie@np.css.fujitsu.com>

for providing the individual fixes.

- Changelog :
  - Integrated Takashi's Makefile modification to clear Module.markers upon
    make clean.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Roland McGrath <roland@redhat.com>
CC: Wenji Huang <wenji.huang@oracle.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: akpm@linux-foundation.org
---
 Makefile                 |    3 ++-
 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/scripts/Makefile.modpost
===================================================================
--- linux-2.6-lttng.orig/scripts/Makefile.modpost	2008-07-17 02:47:44.000000000 -0400
+++ linux-2.6-lttng/scripts/Makefile.modpost	2008-07-17 02:48:17.000000000 -0400
@@ -101,6 +101,7 @@ quiet_cmd_kernel-mod = MODPOST $@
       cmd_kernel-mod = $(modpost) $@
 
 vmlinux.o: FORCE
+	@rm -fr $(kernelmarkersfile)
 	$(call cmd,kernel-mod)
 
 # Declare generated files as targets for modpost
Index: linux-2.6-lttng/scripts/mod/modpost.c
===================================================================
--- linux-2.6-lttng.orig/scripts/mod/modpost.c	2008-07-17 02:49:33.000000000 -0400
+++ linux-2.6-lttng/scripts/mod/modpost.c	2008-07-17 02:50:10.000000000 -0400
@@ -1992,7 +1992,8 @@ static void read_markers(const char *fna
 			mod->skip = 1;
 		}
 
-		add_marker(mod, marker, fmt);
+		if (!mod->skip)
+			add_marker(mod, marker, fmt);
 	}
 	return;
 fail:
Index: linux-2.6-lttng/Makefile
===================================================================
--- linux-2.6-lttng.orig/Makefile	2008-07-17 10:37:44.000000000 -0400
+++ linux-2.6-lttng/Makefile	2008-07-17 10:38:34.000000000 -0400
@@ -1133,7 +1133,8 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' -o -name 'modules.order' \) \
+		-o -name '*.symtypes' -o -name 'modules.order' \
+		-o -name 'Module.markers' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
