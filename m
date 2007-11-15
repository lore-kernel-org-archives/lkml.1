Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbXKOI3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbXKOI3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:29:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbXKOI32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:29:28 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:62438 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbXKOI31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:29:27 -0500
Date: Thu, 15 Nov 2007 00:29:03 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Paul Mackerras <paulus@samba.org>
Cc: mucci@cs.utk.edu, wcohen@redhat.com, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071115082903.GA8603@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <18235.28062.309910.416774@cargo.ozlabs.ibm.com> <20071114.150303.13732085.davem@davemloft.net> <18235.32982.439970.359975@cargo.ozlabs.ibm.com> <20071114.152134.266510129.davem@davemloft.net> <18235.40110.831730.847548@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18235.40110.831730.847548@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 15, 2007 at 12:11:10PM +1100, Paul Mackerras wrote:
> David Miller writes:
> 
> > From: Paul Mackerras <paulus@samba.org>
> > Date: Thu, 15 Nov 2007 10:12:22 +1100
> > 
> > > *I* never had a problem with a few extra system calls.  I don't
> > >  understand why you (apparently) do.
> > 
> > We're stuck with them forever, they are hard to version and extend
> > cleanly.
> > 
> > Those are my main objections.
> 
> The first is valid (for suitable values of "forever") but applies to
> any user/kernel interface, not just system calls.
> 
Agreed.

> As for the second (hard to version) I don't see why it applies to
> syscalls specifically more than to other interfaces.  It's just a
> matter of designing it correctly in the first place.  For example, the
> sys_swapcontext system call we have on powerpc takes an argument which
> is the size of the ucontext_t that userland is using, which allows us
> to extend it in future if necessary.  (Note that I'm not saying that
> the current perfmon2 interfaces are well-designed in this respect.)
> 
> The third (hard to extend cleanly) is a good point, and is a valid
> criticism of the current set of perfmon2 system calls, I think.
> However, the goal of being able to extend the interface tends to be in
> opposition to the goal of having strong typing of the interface.
> Things like a multiplexed syscall or an ioctl are much easier to
> extend but that is at the expense of losing strong typing.  Something
> like my transaction() (or your weird kind of read() :) also provides
> extensibility but loses type safety to some degree.
> 
In the initial design there was only one perfmon syscall perfmonctl()
and it was a multiplexing call. People objected to it and thus I split it
up into multiple system calls. I like the strong typing but I agree that
it is harder to extend without creating new syscalls. In the current
state, all perfmon syscalls take a pointer to structs which have reserved
fields for future extensions. If you specify that reserved fields must be
zeroed, then it leaves you *some* flexibility for extending the structs.

Another alternative, similar to your ucontext, would be to pass the size
of the structure. If we assume we drop the vector arguments, we could do:

	pfm_write_pmcs(fd, &pmc, sizeof(pmc));
instead of
	pfm_write_pmcs(fd, &pmc);

Should the sizeof(pmc) need to change we could demultiplex inside the
kernel. Another, probably cleaner, possibility is to version structures
that are passed:
	union pfarg_pmc {
		int version;
		struct {
			int version;
			int reg_num;
			u64 reg_value;
		}
	}

But that seems overkill. I think versioning could be passed when the session
is created instead of at every call:

	fd = pfm_create_session(version, &ctx, ....);


> Also, as Andi says, this is core CPU state that we are dealing with,
> not some I/O device, so treating the whole of perfmon2 (or any
> performance monitoring infrastructure) as a driver doesn't fit very
> well, and in fact system calls are appropriate.  Just like we don't
> try to make access to debugging facilities fit into a driver, we
> shouldn't make performance monitoring fit into a driver either.
> 

Agreed 100%. This is especially true because we support per-thread
monitoring.

-- 
-Stephane
