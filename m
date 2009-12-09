Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZLIIoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZLIIoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZLIIoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:44:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbZLIIoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:44:14 -0500
Date: Wed, 9 Dec 2009 09:43:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/8] perf-probe updates
Message-ID: <20091209084341.GA21333@elte.hu>
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com>
 <20091209072220.GA4328@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209072220.GA4328@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> One hickup is that -d/--del does not appear to be working yet:
> 
>   # perf probe -l
>   probe:schedule                           (on schedule)
> 
>   # perf probe -d probe:schedule
>   Fatal: Failed to write event: Invalid argument

Ah, that was with an older kernel - a freshly booted kernel with 
delete-probe syntax worked fine.

There's another small hickup i had - when i typoed 'perf probe -', it 
gave me:

 # perf probe -
 No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.
 An error occurred in debuginfo analysis. Try to use symbols.
   Fatal: Failed to write event: Invalid argument

Similar thing happens if i try to probe a non-existent symbol:

 # perf probe test
 No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO.
 An error occurred in debuginfo analysis. Try to use symbols.
   Fatal: Failed to write event: Invalid argument

I think we should print something more helpful, such as:

 # perf probe test
 Fatal: Kernel symbol 'test' not found - probe not added.

the debuginfo printout is not helpful in this case - we should fall back 
to symbols silently, unless the nature of the error indicates that we 
fail _because_ there's no debuginfo.

Here the failure was because the symbol does not exist.

There's similar problems in most other failure cases. Trying to remove a 
non-existent probe gives:

 # perf probe -d test
 Warning: event "probe:test" is not found.

It should say something like:

 # perf probe -d test
 Info: event "probe:test" does not exist, could not remove it.

Also, it's possible to add multiple probes to the same function, using 
'perf probe schedule' + 'perf probe schedule', etc. While in general it 
makes sense to allow it, by default we should refuse the second, 
identical probe on the symbol - and add a -f/--force option to force 
duplicate probes. I.e. the second probe should print:

 # perf probe schedule
 Info: event "probe:schedule" already exists. (Use -f to force a duplicate.)

etc. Please try out various sensible and also less sensible options of 
this tool and try to make it break - and see whether the behavior is 
intuitive and obvious to users - whether the messages are consistent, 
etc. etc.

	Ingo
