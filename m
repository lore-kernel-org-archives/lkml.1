Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYJCTyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYJCTyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYJCTyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:54:40 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:35900 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYJCTyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:54:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqAEADsR5khMQWq+/2dsb2JhbACBcbsGgWiDIA
Date: Fri, 3 Oct 2008 15:54:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Smith <dsmith@redhat.com>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: [PATCH] Marker depmod fix core kernel list
Message-ID: <20081003195436.GA13506@Krystal>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <E1Klq8Z-0003Vd-L6@closure.thunk.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:28:01 up 121 days, 8 min,  5 users,  load average: 0.24, 0.40,
	0.34
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Ts'o (tytso@mit.edu) wrote:
> 
> I've been playing with adding some markers into ext4 to see if they
> could be useful in solving some problems along with Systemtap.  It
> appears, though, that as of 2.6.27-rc8, markers defined in code which is
> compiled directly into the kernel (i.e., not as modules) don't show up
> in Module.markers:
> 
> kvm_trace_entryexit arch/x86/kvm/kvm-intel  %u %p %u %u %u %u %u %u
> kvm_trace_handler arch/x86/kvm/kvm-intel  %u %p %u %u %u %u %u %u
> kvm_trace_entryexit arch/x86/kvm/kvm-amd  %u %p %u %u %u %u %u %u
> kvm_trace_handler arch/x86/kvm/kvm-amd  %u %p %u %u %u %u %u %u
> 
> (Note the lack of any of the kernel_sched_* markers, and the markers I
> added for ext4_* and jbd2_* are missing as wel.)
> 
> Systemtap apparently depends on in-kernel trace_mark being recorded in
> Module.markers, and apparently it's been claimed that it used to be
> there.  Is this a bug in systemtap, or in how Module.markers is getting
> built?   And is there a file that contains the equivalent information
> for markers located in non-modules code?
> 
> Thanks, regards,
> 


I think the problem comes from this patch :
commit d35cb360c29956510b2fe1a953bd4968536f7216
"markers: fix duplicate modpost entry"

Especially :

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a07f91a..8f038e6 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1992,7 +1992,8 @@ static void read_markers(const char *fname)
      mod->skip = 1;
    }

-   add_marker(mod, marker, fmt);
+   if (!mod->skip)
+     add_marker(mod, marker, fmt);
  }
  return;
 fail:

Here is a fix that should take care if this problem. Given I am not the
modpost expert, let's see if I can get an ACK from Sam.

Thanks for the bug report!

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Theodore Ts'o <tytso@mit.edu>
CC: David Smith <dsmith@redhat.com>
CC: Roland McGrath <roland@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: Wenji Huang <wenji.huang@oracle.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
---
 scripts/mod/modpost.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/scripts/mod/modpost.c
===================================================================
--- linux-2.6-lttng.orig/scripts/mod/modpost.c	2008-10-03 15:42:00.000000000 -0400
+++ linux-2.6-lttng/scripts/mod/modpost.c	2008-10-03 15:42:59.000000000 -0400
@@ -1986,11 +1986,13 @@ static void read_markers(const char *fna
 
 		mod = find_module(modname);
 		if (!mod) {
-			if (is_vmlinux(modname))
-				have_vmlinux = 1;
 			mod = new_module(NOFAIL(strdup(modname)));
 			mod->skip = 1;
 		}
+		if (is_vmlinux(modname)) {
+			have_vmlinux = 1;
+			mod->skip = 0;
+		}
 
 		if (!mod->skip)
 			add_marker(mod, marker, fmt);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
