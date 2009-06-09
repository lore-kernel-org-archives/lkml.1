Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZFIGvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZFIGvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbZFIGvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:51:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966AbZFIGvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:51:41 -0400
Date: Tue, 9 Jun 2009 08:51:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
Message-ID: <20090609065117.GA16707@elte.hu>
References: <1244481941.13761.9119.camel@twins> <4A2D6041.4050309@linux.vnet.ibm.com> <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com> <20090608215002.GB22049@elte.hu> <4A2DB1C6.6090209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2DB1C6.6090209@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> If I understand you correctly, you would simply make 
> perf_counter_attr larger every time you want to add a new 
> attribute.  Users using the new attributes would call 
> sys_perf_counter_open with a larger attr_size value.

Yes, exactly. Basically ABIs in Linux only get extended (never 
shrunk and never changed) so it's not like we ever want to (or can) 
shrink the size of the structure or change its semantics.

Each future extension gives the structure a new, unique size - which 
also acts as an 'ABI version' identifier, in a pretty robust way. We 
check this 'ABI version' (the structure size) in the kernel code so 
it's not just a passive 'version field' thing.

Here are the various compatibility variations:

 - same-version kernel and user-space: they both use the same 
   attr_size value and support the full set of features.

 - old user-space running on new kernel: works fine, as the kernel 
   will do a short copy and zero out the remaining attributes.

 - new user-space running on old kernel: the kernel returns -ENOTSUP 
   and user-space has a choice to refuse to run cleanly - or, if an 
   old ABI version is widespread, might chose to utilize the old,
   smaller attribute structure size field (at the cost of not using
   new attribute features, obviously).

( Additional detail: in the size mismatch failure case the kernel 
  should write back the supported size into attr_size, so that 
  user-space knows which precise ABI variant it deals with on the 
  kernel side. )

This kind of ABI maintenance method has a number of substantial 
advantages:

 - It is very compatible (see above)

 - It is extensible easily and in an unlimited way - we just extend 
   the structure size.

 - It is very clean on the kernel side and the user side as well,
   because we just have a single attribute structure.

 - It makes the ABI 'version' field an _active_ component of 
   functionality - so there is no way for subtle breakages to slip 
   in.

 - New attributes are prime-time members of the attribute structure, 
   not second-class citizens that first have to be read in via an
   elaborate chaining mechanism at extra cost.

[ If only all our syscall ABIs used this technique :-) It would be 
  so much easier to extend syscalls cleanly - without having to go 
  through the expensive and time-consuming process to add new
  syscalls. ]

> What about arch-dependent attributes?  Would you want to place 
> them all in the perf_counter_attr struct?  I suppose this could be 
> done by #include'ing an arch-specific .h file.

What arch-dependent attributes are you thinking about? In the 
perfcounters subsystem we want to support PMU and other performance 
analysis features in a way that makes it possible for all 
architectures to make use of them.

So 'arch dependent attributes' per se are bad and against the 
perfcounters design. "Generic perfcounter feature only supported by 
a single architecture initially" is better.

	Ingo
