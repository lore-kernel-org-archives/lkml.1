Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZIMKHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZIMKHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 06:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZIMKHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 06:07:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44292 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZIMKHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 06:07:24 -0400
Date: Sun, 13 Sep 2009 15:37:13 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: [BUGFIX] kprobes: prevent re-registration of the same kprobe
Message-ID: <20090913100713.GB14251@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911031253.GD16396@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 05:12:54AM +0200, Frederic Weisbecker wrote:
> On Thu, Sep 10, 2009 at 07:53:30PM -0400, Masami Hiramatsu wrote:

...

> Is it possible to have two kprobes having the exact same
> properties? (pointing to the same address, having the same
> probe handlers, etc...)

Yes, this is possible with two *different* kprobes. However, we have a bug
with the current code where there is insufficient scaffolding to prevent
re-registration of the same kprobe. Here is a patch...

---
Prevent re-registration of the same kprobe. Current code allows this,
albeit with disastrous consequences. Its not a common case, but should
be flagged nonetheless.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

Index: ptrace-10sep/kernel/kprobes.c
===================================================================
--- ptrace-10sep.orig/kernel/kprobes.c
+++ ptrace-10sep/kernel/kprobes.c
@@ -589,6 +589,9 @@ static int __kprobes register_aggr_kprob
 	int ret = 0;
 	struct kprobe *ap = old_p;
 
+	if (old_p == p)
+		/* Attempt to re-register the same kprobe.. fail */
+		return -EINVAL;
 	if (old_p->pre_handler != aggr_pre_handler) {
 		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
 		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
