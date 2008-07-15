Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYGOHua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYGOHua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYGOHuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:50:19 -0400
Received: from ozlabs.org ([203.10.76.45]:36819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbYGOHuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:50:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
Date: Tue, 15 Jul 2008 17:50:11 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <487B05CE.1050508@jp.fujitsu.com> <200807142043.56968.rusty@rustcorp.com.au> <487BF946.1050006@jp.fujitsu.com>
In-Reply-To: <487BF946.1050006@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151750.12131.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2008 11:11:34 Hidetoshi Seto wrote:
> Hi Rusty,

Hi Hidetoshi,

> However we need to be careful that the stuck CPU can restart unexpectedly.

OK, if you are worried about that race, I think we can still fix it...

> > +	for_each_online_cpu(i) {
> > +		if (!cpu_isset(i, prepared_cpus) && i != smp_processor_id()) {
> > +			bool ignore;
> > +
>
> Note that here is a window that a not-prepared frozen cpu can be thawed and
> become be prepared.
>
> > +			/* If we wanted to run on a particular CPU, and that's
> > +			 * the one which is stuck, it's a real failure. */
> > +			ignore = !cpus || !cpu_isset(i, *cpus);
> > +			printk(KERN_CRIT "stopmachine: cpu#%d seems to be "
> > +			       "stuck, %s.\n",
> > +			       i, ignore ? "ignoring" : "FAILING");
> > +			/* Unbind thread: it will exit when it sees
> > +			 * that prepared_cpus bit set. */
> > +			set_cpus_allowed(threads[i], cpu_online_map);
>
> Unbinded threads still can wake up on a cpu where they originally targeted.

What if we use:
	if (i != smp_processor_id() && !cpu_test_and_set(i, prepared_cpus)) {

instead of cpu_isset?  That means that if a CPU restarts during that window, 
either the thread will exit (because we set the bit here), or this will 
detect it.

Hmm, there's still the vague possibility that the thread doesn't schedule 
until we start a new stop_machine (and clear prepared_cpus).  We could simply 
loop in the main thread if any threads are alive, before freeing them (inside 
the lock).  A counter and notifier is the other way, but it seems like 
overkill for a very unlikely event.

Thanks for the analysis!
Rusty.
