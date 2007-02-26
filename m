Return-Path: <linux-kernel-owner+w=401wt.eu-S1161279AbXBZWO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161279AbXBZWO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161286AbXBZWO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:14:27 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:36236 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161279AbXBZWO0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:14:26 -0500
Date: Mon, 26 Feb 2007 17:14:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Daniel Walker <dwalker@mvista.com>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070226221423.GA2286@Krystal>
References: <20061124215904.GI25048@Krystal> <1164475747.5196.5.camel@localhost.localdomain> <20061126170542.GA30771@Krystal> <1164561427.16871.14.camel@localhost.localdomain> <20061126231833.GA22241@Krystal> <1164585589.16871.52.camel@localhost.localdomain> <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com> <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1172525261.5517.69.camel@imap.mvista.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 17:06:30 up 24 days, 12:14,  3 users,  load average: 2.35, 2.00, 1.83
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker (dwalker@mvista.com) wrote:
> On Mon, 2007-02-26 at 15:53 -0500, Mathieu Desnoyers wrote:
> 
> > > > /* On frequency change event */
> > > > /* In irq context */
> > > > void freq_change_cb(unsigned int new_freq)
> > > > {
> > > 
> > > It's possible for the TSC to change frequencies without notification. It
> > > can also completely stop when the system goes idle.
> > > 
> > 
> > Hrm, I see. I though those freq change without notification would happen
> > rarely and could be dealt by resynchronizing the CPUs. I guess I was
> > wrong.
> 
> The system could be UP .. I don't think tracking this kind of thing is
> trival, and given the TSC track record you have to assume there are will
> be other issue in the future.
> 

The other solution, good for UP, would be to sychronize the TSC with
another clock source (HPET or timer), but it starts to look pretty much
like what is done right now.

> > > > /* Userspace */
> > > > /* Export all this data to user space through the vsyscall page. Use a function
> > > >  * like read_time to read the walltime. This function can be implemented as-is
> > > >  * because it doesn't need to disable preemption. */
> > > 
> > > What would be the benefit of using this over the vsyscall gettimeofday()
> > > from userspace ? 
> > > 
> > 
> > So we can get a monotonic, non NTP corrected timestamp quickly from user
> > space without going through a system call. Are there other alternatives ?
> 
> The NTP daemon needs to be active AFAIK before you would start observing
> weird time jumps. There are adjustments made without NTP but they are
> only seen over short periods.. So I still think gettimeofday() would be
> an alternative ..
> 
> Have you considered adding something to glibc? You could access only the
> TSC from userspace.. I don't think the addition of a vsyscall/syscall
> for this would go over too well considering that there are other ways to
> get timestamps. It might help if you tell us what you think this would
> be used for in userspace ?
> 

For kernel and user space tracing, those small jumps are very annoying :
it can show, in a trace, that a fork() appears on a CPU after the first
schedule() of the thread on the other CPU : scheduling causality relationship
can become very hard to follow. This is only a sample case. Inaccuracy and
periodical modification of the clock time (non monotonic) can cause important
inaccuracy in performance tests, even on UP systems. A monotonic clock,
accessible from anywhere in kernel space (including NMI handler) and
from user space is very useful for performance analysis and, more
generally, for timestamping data in per cpu buffers so it can be later
reordered correctly.

Mathieu

> Daniel
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
