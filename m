Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYCNUnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYCNUnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758819AbYCNUm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:42:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805AbYCNUm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:42:58 -0400
Message-ID: <47DAE2F5.4050900@redhat.com>
Date: Fri, 14 Mar 2008 16:41:25 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Shaohua Li <shaohua.li@intel.com>, David Miller <davem@davemloft.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH -mm 5/5] kprobes: update document about batch registration
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the description of batch registration interfaces to
Documentation/kprobes.txt.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 Documentation/kprobes.txt |   51 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 47 insertions(+), 4 deletions(-)

Index: 2.6.25-rc5-mm1/Documentation/kprobes.txt
===================================================================
--- 2.6.25-rc5-mm1.orig/Documentation/kprobes.txt
+++ 2.6.25-rc5-mm1/Documentation/kprobes.txt
@@ -37,6 +37,11 @@ registration function such as register_k
 the probe is to be inserted and what handler is to be called when
 the probe is hit.

+There are also register_/unregister_*probes() functions for batch
+registration/unregistration of a group of *probes. These functions
+can speed up unregistration process when you have to unregister
+a lot of probes at once.
+
 The next three subsections explain how the different types of
 probes work.  They explain certain things that you'll need to
 know in order to make the best use of Kprobes -- e.g., the
@@ -190,10 +195,11 @@ code mapping.
 4. API Reference

 The Kprobes API includes a "register" function and an "unregister"
-function for each type of probe.  Here are terse, mini-man-page
-specifications for these functions and the associated probe handlers
-that you'll write.  See the files in the samples/kprobes/ sub-directory
-for examples.
+function for each type of probe. The API also includes "register_*probes"
+and "unregister_*probes" functions for (un)registering arrays of probes.
+Here are terse, mini-man-page specifications for these functions and
+the associated probe handlers that you'll write. See the files in the
+samples/kprobes/ sub-directory for examples.

 4.1 register_kprobe

@@ -319,6 +325,43 @@ void unregister_kretprobe(struct kretpro
 Removes the specified probe.  The unregister function can be called
 at any time after the probe has been registered.

+NOTE:
+If the functions find an incorrect probe (ex. an unregistered probe),
+they clear the addr field of the probe.
+
+4.5 register_*probes
+
+#include <linux/kprobes.h>
+int register_kprobes(struct kprobe **kps, int num);
+int register_kretprobes(struct kretprobe **rps, int num);
+int register_jprobes(struct jprobe **jps, int num);
+
+Registers each of the num probes in the specified array.  If any
+error occurs during registration, all probes in the array, up to
+the bad probe, are safely unregistered before the register_*probes
+function returns.
+- kps/rps/jps: an array of pointers to *probe data structures
+- num: the number of the array entries.
+
+NOTE:
+You have to allocate(or define) an array of pointers and set all
+of the array entries before using these functions.
+
+4.6 unregister_*probes
+
+#include <linux/kprobes.h>
+void unregister_kprobes(struct kprobe **kps, int num);
+void unregister_kretprobes(struct kretprobe **rps, int num);
+void unregister_jprobes(struct jprobe **jps, int num);
+
+Removes each of the num probes in the specified array at once.
+
+NOTE:
+If the functions find some incorrect probes (ex. unregistered
+probes) in the specified array, they clear the addr field of those
+incorrect probes. However, other probes in the array are
+unregistered correctly.
+
 5. Kprobes Features and Limitations

 Kprobes allows multiple probes at the same address.  Currently,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com



