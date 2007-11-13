Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbXKMW7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbXKMW7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbXKMW7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:59:14 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:56478 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759657AbXKMW7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:59:13 -0500
Date: Tue, 13 Nov 2007 14:58:48 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       William Cohen <wcohen@redhat.com>, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113225848.GK5747@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113222534.GC17145@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Tue, Nov 13, 2007 at 11:25:34PM +0100, Andi Kleen wrote:
> On Tue, Nov 13, 2007 at 02:22:34PM -0800, Stephane Eranian wrote:
> > Andi,
> > On Tue, Nov 13, 2007 at 10:50:56PM +0100, Andi Kleen wrote:
> > > > Yes, horribly more complicated because of locking issues within perfmon.
> > > > As soon as you expose a file descriptor, you need some locking to prevent
> > > > multiple user threads (malicious or not) to compete to access the PMU state.
> > > 
> > > Why do you need the file descriptor? 
> > > 
> > 
> > To identify your monitoring session be it system-wide (i.e., per-cpu) or per-thread.
> > file descriptor allows you to use close, read, select, poll and you leverage the
> 
> Surely that could be done with a flag for each call too? Keeping file descriptors
> to pass essentially a boolean seems overkill.
> 

I don't understand this.

Let's take the simplest possible example (self-monitoring per-thread)
counting one event in one data register.

int
main(int argc, char **argv)
{
	int ctx_fd;
	pfarg_pmd_t pd[1];
	pfarg_pmc_t pc[1];
	pfarg_ctx_t ctx;
	pfarg_load_t load_args;

	memset(&ctx, 0, sizeof(ctx));
	memset(pc, 0, sizeof(pc));
	memset(pd, 0, sizeof(pd));

	/* create session (context) and get file descriptor back (identifier) */
	ctx_fd = pfm_create_context(&ctx, NULL, NULL, 0);

	/* setup one config register (PMC0) */
	pc[0].reg_num   = 0
	pc[0].reg_value = 0x1234;

	/* setup one data register (PMD0) */
	pd[0].reg_num = 0;
	pd[0].reg_value = 0;

	/* program the registers */
	pfm_write_pmcs(ctx_fd, pc, 1);
	pfm_write_pmds(ctx_fd, pd, 1);

	/* attach the context to self */
	load_args.load_pid = getpid();
	pfm_load_context(ctx_fd, &load_args);

	/* activate monitoring */
	pfm_start(ctx_fd, NULL);

	/*
	 * run code to measure
	 */

	/* stop monitoring */
	pfm_stop(ctx_fd);

	/* read data register */
	pfm_read_pmds(ctx_fd, pd, 1);

	printf("PMD0 %llu\n", pd[0].reg_value);

	/* destroy session */
	close(ctx_fd);

	return 0;
}

-- 

-Stephane
