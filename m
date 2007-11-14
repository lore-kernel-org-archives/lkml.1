Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbXKNOUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbXKNOUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXKNOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:20:33 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:63052 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbXKNOUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:20:32 -0500
Date: Wed, 14 Nov 2007 06:13:42 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114141342.GH6557@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <18234.41652.199520.31261@cargo.ozlabs.ibm.com> <20071114103805.GA16652@infradead.org> <18234.53558.883970.87414@cargo.ozlabs.ibm.com> <20071114110009.GA17833@infradead.org> <p734pfp6lyp.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p734pfp6lyp.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Nov 14, 2007 at 01:38:38PM +0100, Andi Kleen wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> >
> > I've done this a gazillion times before, so maybe instead of beeing a lazy
> > bastard you could look up mailinglist archive.  It's not like this is the
> > first discussion of perfmon.  But to get start look at the systems calls,
> > many of them are beasts like:
> >
> >   int pfm_read_pmds(int fd, pfarg_pmd_t *pmds, int n)
> >
> > This is basically a read(2) (or for other syscalls a write) on something
> 
> At least for x86 and I suspect some 1other architectures we don't
> initially need a syscall at all for this. There is an instruction
> RDPMC who can read a performance counter just fine. It is also much
> faster and generally preferable for the case where a process measures
> events about itself. In fact it is essential for one of the use cases
> I would like to see perfmon used (replacement of RDTSC for cycle
> counting) 
> 

This only works when counting (not sampling) and only for self-monitoring.

> Later a syscall might be needed with event multiplexing, but that seems
> more like a far away non essential feature.
> 
On a machine with only two generic counters such as MIPS or Intel Core 2 Duo,
multiplexing offers some advantages. If NMI watchdog is enabled, then you drop
to one generic counter on on Core 2.

> > else than the file descriptor provided to the system call.   The right thing
> 
> I don't like read/write for this too much. I think it's better to
> have individual syscalls.  After all that is CPU state and having
> syscalls for that does seem reasonable.

As I said earlier, we do use read(), not for reading counters but to extract overflow
notification messages when we are sampling. It makes more sense for this usage because
this is where you want to leverage some key mechanisms such as:

	 - asynchronous notification via SIGIO. this is how you can implement self-sampling
	   for instance.

	 - select/poll to allow monitoring tools to wait for notification coming from
	   multiple sessions in one call. This is useful when monitoring across fork or
	   pthread_create.

-- 
-Stephane
