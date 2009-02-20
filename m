Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbZBTRUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbZBTRUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZBTRUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:20:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:61104 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZBTRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JfbiGWeriXhTYwB+Dv9j+ZeUnVsshT5stD6AWpek/k0fzoRoHCvEAZ62kSQHhTgSp+
         DqCs0QNwrOsSnDQ1kbJI3zAzvpTw2SKHfNQ31q1IfiUNroH9I8rzmVR3ctId8/Ld+lsv
         7AmPbBQtHCdDVIzaL//QY950Zg67sDbWVFCkc=
Date: Fri, 20 Feb 2009 18:20:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090220172026.GG5732@nowhere>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499EE162.4050008@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 08:59:14AM -0800, Randy Dunlap wrote:
> Frederic Weisbecker wrote:
> > Sometimes it happens that KConfig dependencies are not handled
> > like in the following scenario:
> > 
> > - config A
> >    bool
> > 
> > - config B
> >    bool
> >    depends on A
> > 
> > -config C
> >    bool
> >    select B
> > 
> > If one selects C, then it will select B without checking its dependency to A, if A
> > hasn't been selected elsewhere, it will result in a build crash.
> 
> as documented in Documentation/kbuild/kconfig-language.txt (and yes, it is
> considered to be a shortcoming/problem by most people AFAIK):
> 
>   Note:
> 	select should be used with care. select will force
> 	a symbol to a value without visiting the dependencies.
> 	By abusing select you are able to select a symbol FOO even
> 	if FOO depends on BAR that is not set.
> 	In general use select only for non-visible symbols
> 	(no prompts anywhere) and for symbols with no dependencies.
> 	That will limit the usefulness but on the other hand avoid
> 	the illegal configurations all over.
> 	kconfig should one day warn about such things.


Ah thanks!


 
> > This is what happens on the following build error:
> > 
> > kernel/built-in.o: In function `marker_update_probe_range':
> > (.text+0x52f64): undefined reference to `tracepoint_probe_register_noupdate'
> > kernel/built-in.o: In function `marker_update_probe_range':
> > (.text+0x52f74): undefined reference to `tracepoint_probe_unregister_noupdate'
> > kernel/built-in.o: In function `marker_update_probe_range':
> > (.text+0x52fb9): undefined reference to `tracepoint_probe_unregister_noupdate'
> > kernel/built-in.o: In function `marker_update_probes':
> > marker.c:(.text+0x530ba): undefined reference to `tracepoint_probe_update_all'
> > 
> > CONFIG_KVM_TRACE will select CONFIG_MARKER, but the latter depends on CONFIG_TRACEPOINTS
> > which will not be selected.
> > 
> > A temporary fix is to make CONFIG_MARKER select CONFIG_TRACEPOINTS, though it doesn't
> > fix the source KConfig dependency handling problem.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Cc: Roman Zippel <zippel@linux-m68k.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  init/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/init/Kconfig b/init/Kconfig
> > index b6400a5..a93f957 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -975,7 +975,7 @@ config TRACEPOINTS
> >  
> >  config MARKERS
> >  	bool "Activate markers"
> > -	depends on TRACEPOINTS
> > +	select TRACEPOINTS
> >  	help
> >  	  Place an empty function call at each marker site. Can be
> >  	  dynamically changed for a probe function.
> 
> but using "select" instead of "depends on" just causes the kind of problem
> that you described, whereas using "depends on" does follow dependency
> chains.


Ok, but here we are in the case described in the above KConfig documentation
which tells that select is mostly useful for config that are not prompted.

This is the case for TRACEPOINTS. So I think this fix is right.

MARKERS/TRACEPOINTS could be likely described as library which can be used
by debugging facilities anywhere in the kernel.

Using only a chain of dependency would hide a lot of those debugging options.
So IMHO, I think such "library" things should be selected directly from other
options and not be enabled by hand, hence only show the debugging options anywhere
in the kernel if those two are selected.

 
> -- 
> ~Randy

