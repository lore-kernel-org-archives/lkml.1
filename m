Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZKEMB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZKEMB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 07:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZKEMB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 07:01:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:45978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZKEMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:01:58 -0500
Date: Thu, 5 Nov 2009 10:01:18 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/1] perf symbols: Use the buildids if present
Message-ID: <20091105120118.GB3494@ghostprotocols.net>
References: <1257367843-26224-1-git-send-email-acme@infradead.org> <4AF24681.1060504@redhat.com> <20091105082733.GA18011@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105082733.GA18011@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 05, 2009 at 09:27:33AM +0100, Ingo Molnar escreveu:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Arnaldo Carvalho de Melo wrote:
> >> From: Arnaldo Carvalho de Melo<acme@redhat.com>
> >>
> >> Now 'perf record' will intercept PERF_RECORD_MMAP calls, creating a
> >> linked list of DSOs, then when the session finishes, it will traverse
> >> this list and read the buildids, stashing them at the end of the file
> >> and will set up a new feature bit in the header bitmask.
> >>
> >> 'perf report' will then notice this feature and populate the 'dsos' list
> >> and set the build ids.
> >>
> >> When reading the symtabs it will refuse to load from a file that doesn't
> >> have the same build id.
> >>
> >> Example:
> >>
> >>   [root@doppio ~]# perf report | head
> >>   /home/acme/bin/perf with build id b1ea544ac3746e7538972548a09aadecc5753868 not found, continuing without symbols
> >>    # Samples: 2621434559
> >>    #
> >>    # Overhead          Command                  Shared Object  Symbol
> >>    # ........  ...............  .............................  ......
> >>    #
> >>         7.91%             init  [kernel]        [k] read_hpet
> >>         7.64%             init  [kernel]        [k] mwait_idle_with_hints
> >>         7.60%          swapper  [kernel]        [k] read_hpet
> >>         7.60%          swapper  [kernel]        [k] mwait_idle_with_hints
> >>         3.65%             init  [kernel]        [k] 0xffffffffa02339d9
> >> [root@doppio ~]#
> >>
> >> In this case the 'perf' binary was an older one, vanished, so it the symbols
> >> probably wouldn't match.
> >>
> >> Next patches will support the kernel as well, reading the build id notes for it
> >> and the modules from /sys.
> >
> > Great! then I can use it on 'perf probe' to check the dwarf binary is
> > same as running kernel.

Yes, at perf record I'll always get the build id from /sys/kernel/notes
and insert it in the buildid table, then at 'perf report' it will match
it against the file from where it is getting the symbols, be it
/proc/kallsyms or the vmlinux file, be it one specified in the command
line, found on some standard location (/sys/kernel/`uname
-r`/build/vmlinux) or from some new /sys file, as Ingo suggests.

The resulting infrastructure can then be used in perf probe to match
running kernel buildid against the vmlinux used.

> >> Another patch should also introduce a new plumbing command:
> >>
> >> 'perf list-buildids'
> >>
> >> that will then be used in porcelain that is distro specific to
> >> fetch -debuginfo packages where such buildids are present. This will in turn
> >> allow for one to run 'perf record' in one machine and 'perf report' in another.
> >
> > Hmm, so, will this command list up all debuginfo files with buildids?
> > If so, can it also find a kernel binary built locally?
> 
> Arnaldo, how about adding the kernel binary's build path to 
> /sys/kernel/notes, during the kernel build? (With perhaps a .config 
> override as well, for package builds.)
> 
> That object might or might not exist, and if it does not exist, or if 
> there is a buildid mismatch, we can fall back to 'well known' places for 
> kernel/module binaries.

Yeah, I'll do that. I haven't touched much of the kernel because I'm
trying to use what is already there to the fullest extent.

But there are things to do in the kernel (and wiki), yeah:

1. atomically generate mmap events, keeping the synthesize mmap/comm
events that traverses /proc/ pidspace just for older kernels

2. insert the buildid in the PERF_RECORD_MMAP events

3. kernel binary build path

4. write such entries in the perf wiki TODO page

:-)

- Arnaldo
