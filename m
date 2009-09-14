Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZINKFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZINKFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZINKFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:05:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46601 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZINKFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:05:02 -0400
Date: Mon, 14 Sep 2009 15:34:59 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [BUGFIX] kprobes: prevent re-registration of the same kprobe -
	take2
Message-ID: <20090914100459.GA4446@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <20090913100713.GB14251@in.ibm.com> <4AADA0BB.4030307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AADA0BB.4030307@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 13, 2009 at 09:47:39PM -0400, Masami Hiramatsu wrote:
> Ananth N Mavinakayanahalli wrote:
> > On Fri, Sep 11, 2009 at 05:12:54AM +0200, Frederic Weisbecker wrote:
> >> On Thu, Sep 10, 2009 at 07:53:30PM -0400, Masami Hiramatsu wrote:
 
...

> Hmm, if we catch the second registration here, it's too late. At
> register_kprobe(), we initialized some field of kprobe before calling
> register_aggr_kprobe(). Especially kprobe.list is cleared.
> 
> And this can't check the case that 'p' is already registered on
> an aggr kprobe.

Agreed. I thought of this case after sending out the earlier patch...

> Thus, I think some initialization paths should be changed (kp.flag
> field is initialized too early, yearh, that's my mistake),
> and also, you will need to use get_valid_kprobe() to check the kprobe
> has not been registered.

__get_valid_kprobe() makes the task easy. We should just prevent
re-registration whether or not the earlier probe is disabled.

How does this patch look?

---
Prevent re-registration of the same kprobe. This situation, though
unlikely, needs to be flagged since it can lead to a system crash if its
not handled.

The core change itself is small, but the helper routine needed to be
moved around a bit; hence the diffstat.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/kprobes.c |   58 ++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 20 deletions(-)

Index: linux-2.6.31/kernel/kprobes.c
===================================================================
--- linux-2.6.31.orig/kernel/kprobes.c
+++ linux-2.6.31/kernel/kprobes.c
@@ -681,6 +681,40 @@ static kprobe_opcode_t __kprobes *kprobe
 	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
 }
 
+/* Check passed kprobe is valid and return kprobe in kprobe_table. */
+static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
+{
+	struct kprobe *old_p, *list_p;
+
+	old_p = get_kprobe(p->addr);
+	if (unlikely(!old_p))
+		return NULL;
+
+	if (p != old_p) {
+		list_for_each_entry_rcu(list_p, &old_p->list, list)
+			if (list_p == p)
+			/* kprobe p is a valid probe */
+				goto valid;
+		return NULL;
+	}
+valid:
+	return old_p;
+}
+
+/* Return error if the kprobe is being re-registered */
+static inline int check_kprobe_rereg(struct kprobe *p)
+{
+	int ret = 0;
+	struct kprobe *old_p;
+
+	mutex_lock(&kprobe_mutex);
+	old_p = __get_valid_kprobe(p);
+	if (old_p == p)
+		ret = -EINVAL;
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+
 int __kprobes register_kprobe(struct kprobe *p)
 {
 	int ret = 0;
@@ -693,6 +727,10 @@ int __kprobes register_kprobe(struct kpr
 		return -EINVAL;
 	p->addr = addr;
 
+	ret = check_kprobe_rereg(p);
+	if (ret)
+		return ret;
+
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr)) {
@@ -762,26 +800,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
-/* Check passed kprobe is valid and return kprobe in kprobe_table. */
-static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
-{
-	struct kprobe *old_p, *list_p;
-
-	old_p = get_kprobe(p->addr);
-	if (unlikely(!old_p))
-		return NULL;
-
-	if (p != old_p) {
-		list_for_each_entry_rcu(list_p, &old_p->list, list)
-			if (list_p == p)
-			/* kprobe p is a valid probe */
-				goto valid;
-		return NULL;
-	}
-valid:
-	return old_p;
-}
-
 /*
  * Unregister a kprobe without a scheduler synchronization.
  */
