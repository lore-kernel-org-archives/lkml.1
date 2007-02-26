Return-Path: <linux-kernel-owner+w=401wt.eu-S1161028AbXBZU6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028AbXBZU6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 15:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161035AbXBZU6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 15:58:21 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:36456 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161028AbXBZU6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 15:58:21 -0500
Date: Mon, 26 Feb 2007 15:53:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Daniel Walker <dwalker@mvista.com>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070226205304.GA30800@Krystal>
References: <20061124215904.GI25048@Krystal> <1164475747.5196.5.camel@localhost.localdomain> <20061126170542.GA30771@Krystal> <1164561427.16871.14.camel@localhost.localdomain> <20061126231833.GA22241@Krystal> <1164585589.16871.52.camel@localhost.localdomain> <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1172340369.24216.31.camel@imap.mvista.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 15:49:16 up 24 days, 10:57,  3 users,  load average: 3.81, 3.33, 2.73
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker (dwalker@mvista.com) wrote:
> On Sat, 2007-02-24 at 11:19 -0500, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > I am trying to improve the Linux kernel time source so it can be read
> > without seqlock from NMI handlers. I have also seen some interest for
> > such an accurate monotonic clock readable from user space. It mainly
> > implies an atomic update of the time value. I am also trying to figure a
> > way to support architectures with multiple CPUs with non-synchronized
> > TSCs.
> > 
> > I would like to have your comments on the following idea.
> > 
> > Thanks in advance,
> > 
> > Mathieu
> > 
> > 
> > Monotonic accurate time
> > 
> > The goal of this design is to provide a monotonic time :
> > 
> > Readable from userspace without a system call
> > Readable from NMI handler
> > Readable without disabling interrupts
> > Readable without disabling preemption
> > Only one clock source (most precise available : tsc)
> > Support architectures with variable TSC frequency.
> 
> I don't think you could use only the tsc. From reviewing John, and
> Thomas work it's pretty clear the TSC isn't going to work correctly all
> the time.
> 

Ok, if there are other high precision timers we can use, I guess it may
be better to fall back on them.

> > /* On frequency change event */
> > /* In irq context */
> > void freq_change_cb(unsigned int new_freq)
> > {
> 
> It's possible for the TSC to change frequencies without notification. It
> can also completely stop when the system goes idle.
> 

Hrm, I see. I though those freq change without notification would happen
rarely and could be dealt by resynchronizing the CPUs. I guess I was
wrong.

> > /* Userspace */
> > /* Export all this data to user space through the vsyscall page. Use a function
> >  * like read_time to read the walltime. This function can be implemented as-is
> >  * because it doesn't need to disable preemption. */
> 
> What would be the benefit of using this over the vsyscall gettimeofday()
> from userspace ? 
> 

So we can get a monotonic, non NTP corrected timestamp quickly from user
space without going through a system call. Are there other alternatives ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
