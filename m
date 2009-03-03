Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZCCOdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZCCOdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZCCOdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:33:24 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:58809 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCCOdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:33:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALvJrElMQW1W/2dsb2JhbACBTtZQhAYG
Date: Tue, 3 Mar 2009 09:28:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] Text Edit Lock - kprobes architecture independent
	support (v2)
Message-ID: <20090303142812.GA27043@Krystal>
References: <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu> <20090303000054.GC3906@Krystal> <20090303003237.GA30221@elte.hu> <20090303013124.GB7783@Krystal> <20090303092750.GG11484@elte.hu> <20090303120659.GA3480@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090303120659.GA3480@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:26:39 up 3 days, 10:52,  1 user,  load average: 0.50, 0.53,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> On Tue, Mar 03, 2009 at 10:27:50AM +0100, Ingo Molnar wrote:
> > 
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > @@ -709,7 +711,8 @@ int __kprobes register_kprobe(struct kpr
> 
> Hi Ingo,
> 
> > >  	if (kprobe_enabled)
> > >  		arch_arm_kprobe(p);
> > 
> > hm, it's cleaner now, but there's serious locking dependency 
> > problems visible in the patch:
> > 
> > > -
> > > +out_unlock_text:
> > > +	mutex_unlock(&text_mutex);
> > >  out:
> > >  	mutex_unlock(&kprobe_mutex);
> > 
> > this one creates a (text_mutex -> kprobe_mutex) dependency. 
> > (also you removed a newline spuriously - dont do that)
> 
> That is a mutex_unlock :-) ...
> 
> > > @@ -746,8 +749,11 @@ valid_p:
> > >  		 * enabled and not gone - otherwise, the breakpoint would
> > >  		 * already have been removed. We save on flushing icache.
> > >  		 */
> > > -		if (kprobe_enabled && !kprobe_gone(old_p))
> > > +		if (kprobe_enabled && !kprobe_gone(old_p)) {
> > > +			mutex_lock(&text_mutex);
> > >  			arch_disarm_kprobe(p);
> > > +			mutex_unlock(&text_mutex);
> > > +		}
> > >  		hlist_del_rcu(&old_p->hlist);
> > 
> > (kprobe_mutex -> text_mutex) dependency. AB-BA deadlock.
> 
> At this time the kprobe_mutex is already held.
> 
> ...
> 
> > > @@ -1280,12 +1285,14 @@ static void __kprobes enable_all_kprobes
> > >  	if (kprobe_enabled)
> > >  		goto already_enabled;
> > >  
> > > +	mutex_lock(&text_mutex);
> > >  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
> > >  		head = &kprobe_table[i];
> > >  		hlist_for_each_entry_rcu(p, node, head, hlist)
> > >  			if (!kprobe_gone(p))
> > >  				arch_arm_kprobe(p);
> > >  	}
> > > +	mutex_unlock(&text_mutex);
> > 
> > this one creates a (kprobe_mutex -> text_mutex) dependency 
> > again.
> 
> kprobe_mutex his held here too...
> 
> > > @@ -1310,6 +1317,7 @@ static void __kprobes disable_all_kprobe
> > >  
> > >  	kprobe_enabled = false;
> > >  	printk(KERN_INFO "Kprobes globally disabled\n");
> > > +	mutex_lock(&text_mutex);
> > >  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
> > >  		head = &kprobe_table[i];
> > >  		hlist_for_each_entry_rcu(p, node, head, hlist) {
> > > @@ -1317,7 +1325,7 @@ static void __kprobes disable_all_kprobe
> > >  				arch_disarm_kprobe(p);
> > >  		}
> > >  	}
> > > -
> > > +	mutex_unlock(&text_mutex);
> > >  	mutex_unlock(&kprobe_mutex);
> > 
> > And this one in the reverse direction again.
> 
> Unlock again :-)
> 
> > The dependencies are totally wrong. The text lock (a low level 
> > lock) should nest inside the kprobes mutex (which is the higher 
> > level lock).
> 
> From what I see, Mathieu has done just that and has gotten the order
> right in all cases. Or maybe I am missing something?
> 
> (I recall having tested this patch with LOCKDEP turned on and it
> din't throw any errors).
> 

Yes, I even moved all kprobe_mutexes out of arch_arm_kprobe/arch_arm_kprobe
a while ago in preparation for this patch. :) I can repost without the
white space modifications.

Mathieu

> Ananth

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
