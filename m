Return-Path: <linux-kernel-owner+w=401wt.eu-S1945913AbXCWOwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945913AbXCWOwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945915AbXCWOwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:52:07 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:55970 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945918AbXCWOwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:52:04 -0400
Message-ID: <4603E899.2050104@hitachi.com>
Date: Fri, 23 Mar 2007 23:47:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC][Patch 4/4] kprobes fast unregisteration documentation
References: <4603E7A4.50300@hitachi.com>
In-Reply-To: <4603E7A4.50300@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the description of the fast unregisteration interfaces.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---

 Documentation/kprobes.txt |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: linux-2.6.21-rc4-mm1/Documentation/kprobes.txt
===================================================================
--- linux-2.6.21-rc4-mm1.orig/Documentation/kprobes.txt
+++ linux-2.6.21-rc4-mm1/Documentation/kprobes.txt
@@ -36,6 +36,15 @@ registration function such as register_k
 the probe is to be inserted and what handler is to be called when
 the probe is hit.

+There are two kinds of unregistration functions. unregister_*probe()
+functions are useful to unregister a few probes. However, it will take
+several seconds to remove all probes when you unregister hundreds of
+probes. In contrast, unregister_*probe_fast() and commit_kprobes() are
+fast to remove hundreds of probes. unregister_*probe_fast() function
+removes probes, but doesn't cleanup it. So, don't forget to call
+commit_kprobes() for cleaning up when you finish to remove all probes
+by using unregister_*probe_fast().
+
 The next three subsections explain how the different types of
 probes work.  They explain certain things that you'll need to
 know in order to make the best use of Kprobes -- e.g., the
@@ -295,6 +304,27 @@ void unregister_kretprobe(struct kretpro
 Removes the specified probe.  The unregister function can be called
 at any time after the probe has been registered.

+4.5 unregister_*probe_fast
+
+#include <linux/kprobes.h>
+void unregister_kprobe_fast(struct kprobe *kp);
+void unregister_jprobe_fast(struct jprobe *jp);
+void unregister_kretprobe_fast(struct kretprobe *rp);
+
+Prepares to remove the specified probe, and add it to cleanup list.
+The unregister function can be called at any time after the probe has
+been registered.
+WARNING: you MUST call commit_kprobes() before freeing or reusing
+those probes.
+
+4.6 commit_kprobes
+
+#include <linux/kprobes.h>
+void commit_kprobes(void);
+
+Commits to removing all prepared probes. This function synchronizes
+scheduler for RCU safety, and unregisters all probes on the cleanup list.
+
 5. Kprobes Features and Limitations

 Kprobes allows multiple probes at the same address.  Currently,

