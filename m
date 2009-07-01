Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZGAPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZGAPpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZGAPox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:44:53 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50459 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZGAPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PcKzQceQhc9Vy2buymjphz19vOOR6nrnZad/IXoZxXdZEzyMchAWs3se3pMV5zduQ4
         iXZekGswXQv/avhUQSb47K4vXGCglg4Ul0z2zKWST3EzQERRI+9B6nJJ4lDerSLZz/vM
         UIriCODwdLQ/o2CS1NkxPHjZDyr4fh3rgIEDs=
Date: Wed, 1 Jul 2009 17:44:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, acme@redhat.com, a.p.zijlstra@chello.nl,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
	how many spinlocks to schedstat
Message-ID: <20090701154450.GC5097@nowhere>
References: <20090701090749.GA13535@elte.hu> <20090701.184232.131509470674490734.mitake@dcl.info.waseda.ac.jp> <20090701110620.GB15958@elte.hu> <20090701.215304.864843820974206197.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090701.215304.864843820974206197.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:53:04PM +0900, Hitoshi Mitake wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> Date: Wed, 1 Jul 2009 13:06:20 +0200
> 
> > 
> > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > 
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > > Date: Wed, 1 Jul 2009 11:07:49 +0200
> > > 
> > > > 
> > > > * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> > > > 
> > > > > From: Andi Kleen <andi@firstfloor.org>
> > > > > Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
> > > > > Date: Wed, 01 Jul 2009 09:38:04 +0200
> > > > > 
> > > > > > Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> writes:
> > > > > > 
> > > > > > > Hi,
> > > > > > >
> > > > > > > I wrote a test patch which add information of counts processes acquired how many spinlocks to schedstat.
> > > > > > > After applied this patch, /proc/<PID>/sched will change like this,
> > > > > > 
> > > > > > The problem is that spinlocks are very common and schedstats is 
> > > > > > enabled commonly in production kernels. You would need to 
> > > > > > demonstrate that such a change doesn't have significant 
> > > > > > performance impact. For me it looks like it has.
> > > > > 
> > > > > I agree with your opinion about performance impact.
> > > > > I thought this will make no problem,
> > > > > because schedstat is categorized as "Kernel hacking" section.
> > > > > But according to you, many production kernels enable it
> > > > > so my patch will make widespread performance degradation.
> > > > > I didn't know that, sorry.
> > > > 
> > > > His arguments are bogus: both lockstat and perfcounters are optional 
> > > > (and default off), and the sw counter can be made near zero cost 
> > > > even if both perfcounters and lockstat is enabled. Also, sw counters 
> > > > are generally per CPU, etc. so not a performance issue.
> > > > 
> > > > The only (small) overhead will be when the lock-acquire sw counter 
> > > > is actively enabled because you run 'perf stat -e lock-acquire' - 
> > > > but that is expected and inherent in pretty much any kind of 
> > > > instrumentation.
> > > > 
> > > > The feature you are working on has the chance to be a very useful 
> > > > and popular piece of instrumentation. Being able to tell the lock 
> > > > acquire stats on a per task, per workload, per CPU or system-wide 
> > > > basis is a unique capability no other tool can offer right now.
> > > > 
> > > > Andi is often trolling perfcounters related (and other) threads, 
> > > > please dont let yourself be deterred by that and feel free to ignore 
> > > > him.
> > > OK, at least it is truth that
> > > counter in perfcounters makes only valid overhead.
> > > 
> > > And I have a question,
> > > I tried to build perf, but I got a build error,
> > > 
> > > util/symbol.c: In function ‘dso__load_sym’:
> > > util/symbol.c:466: error: ‘ELF_C_READ_MMAP’ undeclared (first use in this function)
> > > util/symbol.c:466: error: (Each undeclared identifier is reported only once
> > > util/symbol.c:466: error: for each function it appears in.)
> > > 
> > > I used this libelf,
> > > http://www.mr511.de/software/english.html
> > > but constant ELF_C_READ_MMAP is not provided...
> > > 
> > > which "libelf" should I use?
> > > It seems that there are some libelf implementations.
> > 
> > I use the elfutils-libelf* packages:
> > 
> >  elfutils-libelf-devel-static-0.141-1.fc10.i386
> >  elfutils-0.141-1.fc10.i386
> >  elfutils-libelf-0.141-1.fc10.i386
> >  elfutils-libs-0.141-1.fc10.i386
> >  elfutils-libelf-devel-0.141-1.fc10.i386
> > 
> > do they work fine or you?
> 
> I'm a Debian user, so I build this library from source
> 
> https://fedorahosted.org/releases/e/l/elfutils/elfutils-0.141.tar.bz2
> 
> And I succeed to build perf, thanks!


You could also just

apt-get install libelf-dev

