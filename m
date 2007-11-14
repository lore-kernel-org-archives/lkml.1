Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXKNNya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXKNNya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXKNNyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:54:22 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:61604 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbXKNNyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:54:21 -0500
Date: Wed, 14 Nov 2007 05:47:13 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114134713.GD6557@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <18234.41652.199520.31261@cargo.ozlabs.ibm.com> <20071114103805.GA16652@infradead.org> <18234.53558.883970.87414@cargo.ozlabs.ibm.com> <20071114110009.GA17833@infradead.org> <18234.56940.229831.735533@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18234.56940.229831.735533@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 14, 2007 at 10:39:24PM +1100, Paul Mackerras wrote:
> Christoph Hellwig writes:
> 
> >   int pfm_read_pmds(int fd, pfarg_pmd_t *pmds, int n)
> > 
> > This is basically a read(2) (or for other syscalls a write) on something
> > else than the file descriptor provided to the system call.
> 
> No it's not basically a read().  It's more like a request/reply
> interface, which a read()/write() interface doesn't handle very well.
> The request in this case is "tell me about this particular collection
> of PMDs" and the reply is the values.
> 

Exactly. This is not a brute force read()! On input you pass the list
of registers you want to read. Upon return, you get the list of values.

Now, I think the current call could be optimized even more by making
the structure smaller. Today, the structure passed read/write
PMD registers is the same. On write, we pass other information such as 
the reset values (sampling periods), randomization parameters and some
flags. They are not needed on read.

> It seems to me that an important part of this is to be able to collect
> values from several PMDs at a single point in time, or at least an
> approximation to a single point in time.  So that means that you don't
> want a file per PMD either.
> 

Yes, we want to be able to read one or many registers in one call.
The number of PMU counters is not going to shrink, so having a file
descriptor per register looks overkill to me.

> Basically we don't have a good abstraction for a request/reply (or
> command/response) type of interface, and this is a case where we need
> one.  Having a syscall that takes a struct containing the request and
> reply is as good a way as any, particularly for something that needs
> to be quick.
> 

-- 
-Stephane
