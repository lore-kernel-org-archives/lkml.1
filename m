Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYJGGh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYJGGh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 02:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYJGGhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 02:37:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51610 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbYJGGhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 02:37:48 -0400
Message-ID: <48EB032B.3070200@cn.fujitsu.com>
Date: Tue, 07 Oct 2008 14:35:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
CC: stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       systemtap@sourceware.org
Subject: [PATCH] markers: fix missing modpost entry in Module.markers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit d35cb360c29956510b2fe1a953bd4968536f7216 brought a bug.
marker points compiled in vmlinux are missing in Module.markers.

# cat Module.markers
subsystem_event samples/markers/marker-example  integer %d string %s
subsystem_eventb        samples/markers/marker-example

# stap -e 'probe kernel.mark("core_marker_format"){} '
semantic error: no match while resolving probe point kernel.mark("core_marker_format")
semantic error: no probes found
Pass 2: analysis failed.  Try again with more '-v' (verbose) options.

This patch revert a part of d35cb360c29956510b2fe1a953bd4968536f7216.
Other parts have fixed duplicate modpost entry bug.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 418cd7d..3509142 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1992,8 +1992,7 @@ static void read_markers(const char *fname)
 			mod->skip = 1;
 		}
 
-		if (!mod->skip)
-			add_marker(mod, marker, fmt);
+		add_marker(mod, marker, fmt);
 	}
 	return;
 fail:


