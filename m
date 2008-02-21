Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbYBUTie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbYBUTie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760684AbYBUThe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:37:34 -0500
Received: from www.tglx.de ([62.245.132.106]:49333 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761448AbYBUTha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:37:30 -0500
Date: Thu, 21 Feb 2008 20:37:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Quel Qun <kelk1@comcast.net>
cc: Dave Young <hidave.darkstar@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
In-Reply-To: <022120081649.19368.47BDAB89000C038700004BA82207300793CE05040A05@comcast.net>
Message-ID: <alpine.LFD.1.00.0802212024310.7583@apollo.tec.linutronix.de>
References: <022120081649.19368.47BDAB89000C038700004BA82207300793CE05040A05@comcast.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Quel Qun wrote:
> > >  > Not that I'm aware off, but this might as well be some old use after
> > >  > free bug which got exposed by some unrelated change. The good news is
> > >  > that it is reproducible. I'll hack up some nasty debug patch which
> > >  > lets us - hopefully - decode where the timer was armed.
> > >
> > >  Quel, before I do that, is there any chance that you retest with the
> > >  latest mainline git version ?
> > >
> > >  
> > http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.25-rc2-git4.bz2
> > 
> > And please test with this patch as well:
> > 
> > http://lkml.org/lkml/2008/2/20/121
> > 
> Same kind of result unfortunately with this last patch on top of git4:

At least it is fully reproducible. Please apply the patch below to
your git4 tree and do not change your .config. The output should show,
which code armed the timer.

Thanks,

	tglx

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -58,6 +58,40 @@ EXPORT_SYMBOL(jiffies_64);
 #define TVN_MASK (TVN_SIZE - 1)
 #define TVR_MASK (TVR_SIZE - 1)
 
+struct timer_trace {
+	struct timer_list *timer;
+	void *fn;
+	void *addr;
+};
+
+#define TTRACE_SIZE 4096
+static struct timer_trace ttrace[TTRACE_SIZE];
+static int ttrace_idx;
+static DEFINE_SPINLOCK(ttrace_lock);
+
+void ttrace_find_timer(struct timer_list *timer)
+{
+	char symname[KSYM_NAME_LEN];
+
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&ttrace_lock, flags);
+	for (i = 0; i < TTRACE_SIZE; i++) {
+		if (ttrace[i].timer == timer) {
+			printk(KERN_ERR "TTRACE timer %p fn %p addr %p\n",
+			       ttrace[i].timer, ttrace[i].fn, ttrace[i].addr);
+			if (lookup_symbol_name((unsigned long) ttrace[i].fn,
+					       symname) == 0)
+				printk(KERN_ERR "TTRACE fn %s\n", symname);
+			if (lookup_symbol_name((unsigned long) ttrace[i].addr,
+					       symname) == 0)
+				printk(KERN_ERR "TTRACE addr %s\n", symname);
+		}
+	}
+	spin_unlock_irqrestore(&ttrace_lock, flags);
+}
+
 struct tvec {
 	struct list_head vec[TVN_SIZE];
 };
@@ -395,6 +429,13 @@ int __mod_timer(struct timer_list *timer
 	unsigned long flags;
 	int ret = 0;
 
+	spin_lock_irqsave(&ttrace_lock, flags);
+	ttrace[ttrace_idx].timer = timer;
+	ttrace[ttrace_idx].fn = timer->function;
+	ttrace[ttrace_idx].addr = __builtin_return_address(0);
+	ttrace_idx = (ttrace_idx + 1) & (TTRACE_SIZE - 1);
+	spin_unlock_irqrestore(&ttrace_lock, flags);
+
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
 
@@ -687,6 +728,14 @@ static unsigned long __next_timer_interr
 	/* Look for timer events in tv1. */
 	index = slot = timer_jiffies & TVR_MASK;
 	do {
+		struct list_head *tmp;
+
+		__list_for_each(tmp, base->tv1.vec + slot) {
+			nte = (struct timer_list *) tmp;
+			if (nte->entry.next == (void *)0x6b6b6b6b)
+				ttrace_find_timer(nte);
+		}
+
 		list_for_each_entry(nte, base->tv1.vec + slot, entry) {
 			if (tbase_get_deferrable(nte->base))
 				continue;


