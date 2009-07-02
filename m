Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZGBHmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZGBHmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZGBHmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:42:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45298 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZGBHmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:42:25 -0400
Date: Thu, 2 Jul 2009 09:42:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
	kernel modules
Message-ID: <20090702074214.GA19187@elte.hu>
References: <1246514639.13293.40.camel@marge.simson.net> <20090702064712.GA26690@elte.hu> <1246519076.6384.22.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246519076.6384.22.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Thu, 2009-07-02 at 08:47 +0200, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > Per $subject, this patch set only supports for the LIVE kernel.  
> > > It adds support infrastructure for path discovery, load address 
> > > lookup, and symbol generation of live kernel modules.
> > > 
> > > TODO includes resurrection of live annotation in perf top, and 
> > > support for annotation and report generation of other than live 
> > > modules.  As the patch set sits, Perf top can generate symbols 
> > > from live binaries, but there's no live annotation capability yet.
> > > 
> > > patch1: perf_counter tools: Make symbol loading consistently return number of loaded symbols.
> > > patch2: perf_counter tools: Add infrastructure to support loading of kernel module symbols
> > > patch3: perf_counter tools: connect module support infrastructure to symbol loading infrastructure
> > > patch4: perf_counter tools: Enable kernel module symbol loading in tools
> > > 
> > > Comments and suggestions most welcome.
> > 
> > Looks very nice! I've applied it with a few minor stylistic fixlets 
> > and a tad more verbose changelogs.
> 
> Thanks!
> 
> (sorry about changelogs, I did stare at them, nothing spiffy 
> happened)

[ We want to be verbose in changelogs generally - i.e. it's not a 
  problem at all to tell a boring story about what happens in the 
  patch. To _you_ it certainly looks boring - to others it's a 
  useful summary that sets their mind-set before looking at the 
  patch. ]

> > I'm wondering about the next step: couldnt we somehow guess at 
> > the position of the vmlinux too, validate somehow that it 
> > corresponds to the kernel we are running - and then use it 
> > automatically and by default?
> 
> I don't know of a way to discover where the image lives.  Been 
> pondering that very thing, along with idiot-proofing.

There's two main usecases:

 - distro kernels. Here the vmlinux and module path varies but 
   should be discoverable with a finite list of try-and-err paths.

 - 'make install modules_install' builds of kernel developers. Here 
   the vmlinux and the source tree might be anywhere. A small trick 
   might help: we could expose the build position of the kernel
   source tree via a new /proc/kernel-buildpath special file, which
   contains the vmlinux filename plus an MD5 sum (or CRC32) for good 
   measure.

Note that /proc/kernel-buildpath might also help the distro case: a 
distro could set it thusly to have the correct position for a 
debuginfo rpm/deb install.

I.e. /proc/kernel-buildpath and the MD5 could solve both usecases. 
Other tools could make use of it too.

A second, more complex possibility would be to expose the kernel 
image itself plus the module images as well. This has limitations 
though: debuginfo wont be embedded, and symbols are in 
/proc/kallsyms (which we do parse).

The advantage is that it's all readily available in memory (just not 
exposed), plus it would show the _real_ instructions - the 
post-paravirt-fixup post-ftrace-fixup and other dynamic patching 
results.

To expose that we'd have to create some sort of special "kernel 
image directory" within debugfs that has files like:

  /debug/kimage/vmlinux
  /debug/kimage/modules/
  /debug/kimage/modules/snd_hda_intel.ko
  /debug/kimage/modules/firewire_core.ko

Debugfs is quite easy to use and if we dont make it too fancy (no 
separate module directories for example) it would be doable without 
too much fuss.

It would be assembly-only annotations, without debuginfo.

> > Plus, offline analysis would be nice as well i suspect - being 
> > able to look at profiles on a different box?
> 
> Yes, that's high on my TODO.  I've been pondering a perf archive 
> tool that would package everything that's needed to do analysis on 
> a different box.  One big problem though, is that while you can 
> easily package vmlinux and modules, what about all the userland 
> binaries?  A large perf.data and/or debug info binaries can easily 
> make transport impractical enough.

I wouldnt worry about size too much, at least initially.

[ If it ever becomes a big issue then we could do a separate 'perf 
  compress' pass which could do a 'specific'/sparse snapshot of 
  affected binaries: i.e. pre-parse the data file, pick out all the 
  RIPs that matter and check which binaries relate to them, and then 
  read and pack those bits only. ]

Plus we could use Git's zlib smarts to compress the data file on the 
fly as well, during data capture. It's very easy to generate a gig 
or two of data currently.

> After I resurrect (well, try) live annotation in top, I'll fiddle 
> with offline kernel analysis.

Ok :-)

Btw, another thing: we are thinking about making -F 1000 (1 KHz 
auto-freq sampling) the default for perf top and perf record. This 
way we'd always gather enough data (and never too much or too little 
data), regardless of the intensity of the workload. Have you played 
with -F before, what's your general experience about it? It's 
particularly useful for 'rare' and highly fluctuating events like 
cache-misses.

Maybe 1KHz is a bit too low - Oprofile defaults to 100000 cycles 
interval by default which is about 10 KHz on a 1GHz box and 30 KHz 
on a 3GHz box. Perhaps 10 KHz is a better default?

	Ingo
