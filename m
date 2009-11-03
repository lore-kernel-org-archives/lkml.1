Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbZKCHZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbZKCHZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZKCHZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:25:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZKCHZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:25:16 -0500
Date: Tue, 3 Nov 2009 08:24:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes
Message-ID: <20091103072439.GA19928@elte.hu>
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <20091029191801.CADC3538@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029191801.CADC3538@magilla.sf.frob.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Roland McGrath <roland@redhat.com> wrote:

> > Thirdly, i think we should expose the build-id of the kernel and the 
> > path to the vmlinux (and modules) via /proc/build-id or so. That way 
> > tooling can find the vmlinux file and can validate that it matches 
> > the kernel's signature. (maybe include a file date as well - that's 
> > a faster check than a full build-id checksum, especially for large 
> > kernels)
> 
> You seem to be confused about what build IDs are.  There is no 
> "checksum validation".  Once the bits are stored there is no 
> calculation ever done again, only exact comparison with an expected 
> build ID bitstring.  The size of an object file is immaterial.
> 
> As Frank mentioned, the kernel's and modules' allocated ELF notes (and 
> thus build IDs) are already exposed in /sys.  Tools like "eu-unstrip 
> -nk" use this information today.

Ah, i didnt realize we link with --build-id already, unconditonally, 
since v2.6.23 (if ld supports it):

 |
 | From 18991197b4b588255ccabf472ebc84db7b66a19c Mon Sep 17 00:00:00 2001
 | From: Roland McGrath <roland@redhat.com>
 | Date: Thu, 19 Jul 2007 01:48:40 -0700
 | Subject: [PATCH] Use --build-id ld option
 |
 | This change passes the --build-id when linking the kernel and when 
 | linking modules, if ld supports it.  This is a new GNU ld option that 
 | synthesizes an ELF note section inside the read-only data.  The note in 
 | this section contains unique identifying bits called the "build ID", 
 | which are generated so as to be different for any two linked ELF files 
 | that aren't identical.
 |

So we have an SHA1 build-id already on the vmlinux and on modules, and 
it's exposed in /sys/*/*/notes. Just have to make use of it in 
tools/perf too.

The other useful addition i mentioned isnt implemented yet: to emit an 
ELF note of the absolute path of the output directory the kernel was 
built in as well. This information is not available right now, and it 
would be a place to look in to search for the vmlinux and the modules.

What do you think? Also, if we do this, is there a standard way to name 
it , or should i just pick a suitably new, Linux-specific name for that?

Thanks,

	Ingo
