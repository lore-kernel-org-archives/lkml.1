Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbZATMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbZATMvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZATMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:51:09 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:54286 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372AbZATMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:51:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAIhTdUlMQWt2/2dsb2JhbACBbMl4hXM
Date: Tue, 20 Jan 2009 07:51:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: Michel Dagenais <michel.dagenais@polymtl.ca>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ltt-dev@lists.casi.polymtl.ca
Subject: LTTng userspace tracing : chained signal handlers with new SA_CHAIN
Message-ID: <20090120125103.GB22421@Krystal>
References: <20090116164926.GA31282@Krystal> <1232141978.18539.34.camel@localhost> <20090117021942.GB13419@Krystal> <1232380137.6093.33.camel@localhost> <20090119182345.GB30683@Krystal> <497585D2.1090001@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <497585D2.1090001@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:24:51 up 19 days, 11:23,  1 user,  load average: 0.21, 0.38,
	0.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pierre-Marc Fournier (pierre-marc.fournier@polymtl.ca) wrote:
> Mathieu Desnoyers wrote:

[ some context : we are trying to connect a signal handler in a
new userspace shared library without the application knowing and without
recompiling the application. See below for sigaction() new sa_flags
proposal. Comments are welcome. ]

> >>> Yes, it's totally possible to to this in user-space. There is an issue
> >>> with SIGIO though.
> >>>
> >>> The problem is that we are an object linked to the application _without
> >>> it knowing_ (possibly linked to glibc for instance). We don't want to
> >>> override the application's SIGIO handler behind their back.
> >> Ideally applications would "chain" their use of handlers for modularity.
> >> I am not sure if many applications do, however.
> >>
> > 
> > I'm pretty much convinced they don't. Reusing the existing signals from
> > a library will be a real pain.
> > 
> 
> Unfortunately, signal handlers cannot easily be chained the way IRQ
> handlers were in the good old times.
> 
> One possible way to go would be to use SIGIO (or another signal) and use
> a special value for the si_code field of the siginfo_t structure to
> indicate that this is a tracing related SIGIO. (See the sigaction(2) man
> page.) Applications that don't use aysnc io would work out of the box
> after just being relinked. Applications that do use async IO would
> accidentally overwrite the handler setup by the tracing library. Their
> code could therefore be patched to look at the si_code flag and, if the
> SIGIO was a tracing-related one, redirect the call to the tracing
> library via a function call.
> 
> void sigio_handler_of_aio_app(int sig, siginfo_t *si, void *)
> {
> 	if(sig == SIGIO && si->si_code == SI_TRACE)
> 		libusertrace_signal_received();
> 	else {
> 		/* process async io */
> 	}
> }
> 
> It can be argued that if an application needs to be relinked in order to
> support userspace tracing, the occasional need for small changes to the
> way a particular signal is handled might be acceptable.
> 

The problem comes when we want to instrument a library, not the
executable itself. In this case, we would only have to relink the
library, not the application. In some cases, with a proprietary
application, it would be impossible to recompile the application per se.

So I don't see this as a clean solution. I just looked at SIGWINCH,
which is used in libraries (at least by ncurses), which looked rather
promising, but even there, ncurses detects if it is set to the default
handler and if not, it will refuse to connect to it. :(

Maybe we could create a new sigaction sa_flag which would give us the
ability to add a signal handler prior to the standard signal chain ?

e.g. :

SA_CHAIN
        Adds a signal handler to this signal's signal handler chain.
        The signal handler is called at the beginning of the chain.
        If sigaction() is called again with the same sa_sigaction with
        the SA_CHAIN flag set, it will return the next handler in the
        chain in "oldact". Standard sigaction() and signal() users
        should not notice any difference with the standard behavior.
        Using sa_sigaction (rather than sa_handler) is mandatory.
        SA_CHAIN implies SA_SIGINFO.

SA_UNCHAIN
        Removes a signal handler from this signal's signal handler
        chain.


Example use :

#include <signal.h>
#include <stdio.h>

void sigio_tracing_handler(int signum, siginfo_t *siginfo, void *ucontext)
{
  struct sigaction thissig, nextsig;

  thissig.sa_flags = SA_CHAIN;
  thissig.sa_sigaction = sigio_tracing_handler;
  if (!sigaction(signum, &thissig, &nextsig)) {
    if (nextsig.sa_handler != SIG_IGN && nextsig.sa_handler != SIG_DFL)
      if (nextsig.sa_flags & SA_SIGINFO)
        nextsig.sa_sigaction(signum, siginfo, ucontext);
      else
        nextsig.sa_handler(signum);  /*
                                      * Next in chain is standard (not
                                      * SA_CHAIN not SA_SIGINFO) signal
                                      * handler.
                                      */
  }
}

int main(void)
{
  struct sigaction act, oldact;
  int ret;
 
  /* signal handler installation */
  act.sa_flags = SA_CHAIN;
  act.sa_sigaction = sigio_tracing_handler;
  ret = sigaction(SIGIO, &act, &oldact);
  if (ret) {
    printf("Problem installing sigio_tracing_handler SIGIO handler\n");
    exit(1);
  }

  /* cleanup */
  act.sa_flags = SA_UNCHAIN;
  act.sa_sigaction = sigio_tracing_handler;
  ret = sigaction(SIGIO, &act, &oldact);
  if (ret) {
    printf("Problem removing sigio_tracing_handler SIGIO handler\n");
    exit(1);
  }
  return 0;
}


Mathieu


> pmf

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
