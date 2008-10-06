Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYJFNa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYJFNa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 09:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYJFNaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 09:30:16 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:58059 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbYJFNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 09:30:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEAFOq6UhMQWq+/2dsb2JhbACBcbkpgWo
Date: Mon, 6 Oct 2008 09:30:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       David Smith <dsmith@redhat.com>, Roland McGrath <roland@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Marker depmod fix core kernel list
Message-ID: <20081006133012.GA1366@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:27:28 up 123 days, 18:07,  8 users,  load average: 0.48, 0.45,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Do you think this fix could be pulled in before 2.6.27 final ?

Thanks,

Mathieu

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


-   add_marker(mod, marker, fmt);
+   if (!mod->skip)
+     add_marker(mod, marker, fmt);
  }
  return;
 fail:

Here is a fix that should take care if this problem.

Thanks for the bug report!

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Tested-by: "Theodore Ts'o" <tytso@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>
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
--- linux-2.6-lttng.orig/scripts/mod/modpost.c	2008-10-03 17:19:59.000000000 -0400
+++ linux-2.6-lttng/scripts/mod/modpost.c	2008-10-03 17:22:48.000000000 -0400
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
