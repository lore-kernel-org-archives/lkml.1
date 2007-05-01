Return-Path: <linux-kernel-owner+w=401wt.eu-S1945966AbXEAWII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945966AbXEAWII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946030AbXEAWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:08:08 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:41983 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945966AbXEAWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:08:06 -0400
Date: Tue, 1 May 2007 18:08:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070501220803.GA27698@Krystal>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p733b2gzqkg.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 17:41:28 up 88 days, 11:48,  3 users,  load average: 1.55, 1.30, 1.48
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

* Andi Kleen (andi@firstfloor.org) wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> 
> > Static markers.  Will merge.
> There don't seem to be any users of this. How do you know it hasn't
> already bitrotted?
> 

See the detailed explanation at :
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/linux-kernel-markers-kconfig-menus.patch

Major points :

It is currently used as an instrumentation infrastructure for the LTTng
tracer at IBM, Google, Autodesk, Sony, MontaVista and deployed in
WindRiver products.  The SystemTAP project also plan to use this type of
infrastructure to trace sites hard to instrument. The Linux Kernel
Markers has the support of Frank C. Eigler, author of their current
marker alternative (which he wishes to drop in order to adopt the
markers infrastructure as soon as it hits mainline).

Quoting Jim Keniston <jkenisto@us.ibm.com> :

"kprobes remains a vital foundation for SystemTap.  But markers are
attactive as an alternate source of trace/debug info.  Here's why:
[...]"

> It seems quite overcomplicated to me. Has the complexity been justified?
> 

To summarize the document pointed at the URL above, where the full
the key goals of the markers, showing the rationale being the most
important design choices :
- Almost non perceivable impact on production machines when compiled in
  but markers are "disabled".
  - Use a separate section to keep the data to minimize d-cache
    trashing.
  - Put the code (stack setup and function call) in unlikely branches of the
    if() condition to minimize i-cache impact.
  - Since it is required to allow instrumentation of variables within
    the body of a function, accept the impact on compiler's
    optimizations and let it keep the variables "live" sometimes longer
    than required. It is up to the person who puts the marker in the
    code to choose the location that will have a small impact in this
    aspect.
  - Allow per-architecture optimized versions which removes the need for
    a d-cache based branch (patch a "load immediate" instruction
    instead). It minimized the d-cache impact of the disabled markers.
  - Accept the cost of an unlikely branch at the marker site because the
    gcc compiler does not give the ability to put "nops" instead of a
    branch generated from C code. Keep this in mind for future
    per-architecture optimizations.
- Instrumentation of challenging kernel sites
  - Instrumentation such as the one provided in the already existing
    Lock dependency checker (lockdep) and instrumentation of trap
    handlers implies being reentrant for such context. Therefore, the
    implementation must be lock-free and update the state in an atomic
    fashion (rcu-style). It must also let the programmer who describes
    a marker site the ability to specify what is forbidden in the probe
    that will be connected to the marker : can it generate a trap ? Can
    it call lockdep (irq disable, take any type of lock), can it call
    printk ? This is why flags can be passed to the _MARK() marker,
    while the MARK() marker has the default flags.

Please tell me if I forgot to explain the rationale behind some
implementation detail and I will be happy to explain in more depth.

Regards,

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
