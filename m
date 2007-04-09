Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbXDIEMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbXDIEMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXDIEMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:12:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40154 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbXDIEMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:12:40 -0400
Date: Mon, 9 Apr 2007 09:46:08 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Christoph Hellwig <hch@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, srinivasa@in.ibm.com,
       akpm@linux-foundation.org,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, richardj_moore@uk.ibm.com
Subject: Re: [RFC][PATCH] Kprobes: The ON/OFF knob thru debugfs
Message-ID: <20070409041608.GA17066@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070404121349.GA26313@in.ibm.com> <20070408102231.GA2297@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408102231.GA2297@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 11:22:31AM +0100, Christoph Hellwig wrote:
> On Wed, Apr 04, 2007 at 05:43:49PM +0530, Ananth N Mavinakayanahalli wrote:
> > This patch provides a debugfs knob to turn kprobes on/off
> > 
> > o A new file /debug/kprobes/enabled indicates if kprobes is enabled or
> >   not (default enabled)
> > o Echoing 0 to this file will disarm all installed probes
> > o Any new probe registration when disabled will register the probe but
> >   not arm it. A message will be printed out in such a case.
> > o When a value 1 is echoed to the file, all probes (including ones
> >   registered in the intervening period) will be enabled
> > o Unregistration will happen irrespective of whether probes are globally
> >   enabled or not.
> > o Update Documentation/kprobes.txt to reflect these changes. While there
> >   also update the doc to make it current.
> 
> Looks good.
> 
> When I suggested a user interface to enable/disable probes was nice to
> have I was more thinking about a interface to enable/disable individual
> probes.  Any chance you could try to implement that aswell as see if
> any code can be shared with this feature?

Thats on the TODO list - any preferences on what the debugfs control
should look like? One file per kprobe seems simplest, but it'd be
unwieldly if there are hundreds of active probes.

> > -	arch_arm_kprobe(p);
> > +		arch_arm_kprobe(p);
> > +	} else
> > +		printk("Kprobes are globally disabled. This kprobe [@ %p] "
> > +			"will be enabled with all other probes\n", p->addr);
> 
> This printk seems far too verbose.  Just remove it and make sure
> the debugfs interface has an indicator of whether probes are en- or
> disabled.

Agreed... and "enabled" file is the indicator.

Andrew, please include this incremental patch against 2.6.21-rc6-mm1
that removes the verbose printk.

o Remove verbose printk during registration with kprobes globally
  disabled
o Print out a message when kprobes are enabled/disabled globally

Signed-off-by: Ananth N Mavinakyanahalli <ananth@in.ibm.com>

---
 kernel/kprobes.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc6/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/kprobes.c
+++ linux-2.6.21-rc6/kernel/kprobes.c
@@ -574,10 +574,7 @@ static int __kprobes __register_kprobe(s
 			register_page_fault_notifier(&kprobe_page_fault_nb);
 
 		arch_arm_kprobe(p);
-	} else
-		printk("Kprobes are globally disabled. This kprobe [@ %p] "
-			"will be enabled with all other probes\n", p->addr);
-
+	}
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -928,6 +925,7 @@ static void __kprobes enable_all_kprobes
 	}
 
 	kprobe_enabled = true;
+	printk("Kprobes globally enabled\n");
 
 already_enabled:
 	mutex_unlock(&kprobe_mutex);
@@ -948,6 +946,7 @@ static void __kprobes disable_all_kprobe
 		goto already_disabled;
 
 	kprobe_enabled = false;
+	printk("Kprobes globally disabled\n");
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
