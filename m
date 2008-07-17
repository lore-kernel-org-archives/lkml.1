Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYGQHDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYGQHDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYGQHD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:03:26 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:34972 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbYGQHD0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:03:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAOCJfkhMRKxB/2dsb2JhbACBWq5b
Date: Thu, 17 Jul 2008 03:03:21 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: akpm@linux-foundation.org, Wenji Huang <wenji.huang@oracle.com>
Cc: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       ltt-dev@lists.casi.polymtl.ca, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Fix markers duplicate modpost entry
Message-ID: <20080717070321.GB26035@Krystal>
References: <20080715024754.GA26471@Krystal> <000001c8e7aa$b9548600$2bfd9200$@css.fujitsu.com> <20080717024550.GA22869@Krystal> <487ED503.2060503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <487ED503.2060503@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 02:53:11 up 42 days, 11:34,  4 users,  load average: 0.74, 0.84,
	1.07
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a kernel was rebuilt, the previous Module.markers was not cleared. It
caused markers with different format strings to appear as duplicates when a
markers was changed.

I merely merged the patches from Roland and Wenji here. It applies to
mainline (and is not intrusive, so will also apply to linux-next).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
From: Roland McGrath <roland@redhat dot com>
From: Wenji Huang <wenji.huang@oracle.com>
CC: akpm@linux-foundation.org
---
 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

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

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
