Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXDKUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXDKUzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030325AbXDKUzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:55:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:56664 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030316AbXDKUzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:55:48 -0400
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       Andi Kleen <ak@suse.de>
In-Reply-To: <20070411133122.badf1c4f.akpm@linux-foundation.org>
References: <20070411162904.232696302@mvista.com>
	 <20070411133122.badf1c4f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 13:54:41 -0700
Message-Id: <1176324881.20237.39.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-11 at 13:31 -0700, Andrew Morton wrote:
> On Wed, 11 Apr 2007 09:29:04 -0700
> Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The locking of the xtime_lock around the cpu notifier is unessesary now. At one
> > time the tsc was used after a frequency change for timekeeping, but the re-write
> > of timekeeping no longer uses the TSC unless the frequency is constant. 
> > 
> > The variables that are changed in this section of code had also once been used
> > for timekeeping, but not any longer ..
> > 
> > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > 
> > ---
> >  arch/i386/kernel/tsc.c |    8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > Index: linux-2.6.20/arch/i386/kernel/tsc.c
> > ===================================================================
> > --- linux-2.6.20.orig/arch/i386/kernel/tsc.c
> > +++ linux-2.6.20/arch/i386/kernel/tsc.c
> > @@ -200,13 +200,10 @@ time_cpufreq_notifier(struct notifier_bl
> >  {
> >  	struct cpufreq_freqs *freq = data;
> >  
> > -	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
> > -		write_seqlock_irq(&xtime_lock);
> > -
> >  	if (!ref_freq) {
> >  		if (!freq->old){
> >  			ref_freq = freq->new;
> > -			goto end;
> > +			return 0;
> >  		}
> >  		ref_freq = freq->old;
> >  		loops_per_jiffy_ref = cpu_data[freq->cpu].loops_per_jiffy;
> > @@ -237,9 +234,6 @@ time_cpufreq_notifier(struct notifier_bl
> >  			}
> >  		}
> >  	}
> > -end:
> > -	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
> > -		write_sequnlock_irq(&xtime_lock);
> >  
> >  	return 0;
> >  }
> 
> hm.
> 
> I've been permadropping Andi's
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current/patches/sched-clock-share
> because it causes a lockup when initscripts start ondemand on my
> single-CPU, CONFIG_SMP=n Vaio.
> 
> I don't know _why_ it locks up - I traced it down to the
> write_seqlock_irq() which you have just removed.  But write_seqlock()
> doesn't loop with CONFIG_SMP=n builds, so a hang there is quite mysterious.
> 
> Anyway, your patch might make that hang go away.  We'll see.


I don't know to what extent this is relevant, but it's something I've
noticed ..

>From the patch above ,

+ */
+unsigned long long sched_clock(void)
+{
+	int cpu = get_cpu();
+	struct sc_data *sc = &per_cpu(sc_data, cpu);
+	unsigned long long r;
+
+	if (sc->instable) {
+		/* TBD find a cheaper fallback timer than this */
+		r = ktime_to_ns(ktime_get());
+	} else {
+		get_scheduled_cycles(r);
+		r = ((u64)sc->ns_base) + cycles_2_ns(cpu, r - sc->last_tsc);
+	}
+	put_cpu();
+	return r;
+}

Your VAIO is the "instable" case above I think .. So your using a case
that needs to be implemented still , I guess .. ktime_get() has a
peculiarity of recursively looping on the read seqlock on xtime_lock ..

Here is the call ordering ,

ktime_get()
 ktime_get_ts() -> read_seqretry(&xtime_lock, seq)
  getnstimeofday()
   __get_realtime_clock_ts() -> read_seqretry(&xtime_lock, seq)


I wonder if there is a weird case which case this to loop forever .. But
as said , it's just something I noticed so I don't know if it's
related .

Daniel

