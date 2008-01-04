Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbYADOT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbYADOT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYADOTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:19:21 -0500
Received: from www.tglx.de ([62.245.132.106]:50088 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYADOTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:19:21 -0500
Date: Fri, 4 Jan 2008 15:19:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less
 frequently
In-Reply-To: <200801041317.30404.ak@suse.de>
Message-ID: <alpine.LFD.0.99999.0801041449460.4042@localhost.localdomain>
References: <20080103442.621670000@suse.de> <20080103154226.67D6414DDB@wotan.suse.de> <alpine.LFD.0.99999.0801041032430.4042@localhost.localdomain> <200801041317.30404.ak@suse.de>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, Andi Kleen wrote:
> On Friday 04 January 2008 10:42:17 Thomas Gleixner wrote:
> > On Thu, 3 Jan 2008, Andi Kleen wrote:
> > > This makes a significant difference in boot up performance on AMD SimNow!
> > > Also I expect it to be a little faster on native systems too because a smp 
> > > switch does a lot of text_poke()s which each synchronize the pipeline.
> > 
> > Please run your patches through checkpatch.pl.
> > 
> > ERROR: use tabs not spaces
> > #48: FILE: arch/x86/kernel/alternative.c:360:
> 
> 
> I saw a lot of these warnings, but disregarded them as obviously silly. I don't
> have plans to redo all the patches for that.

Andi, this behaviour is obviously silly. 

I know that you do not care about white space and consistent coding
style, but others do.

The kernel process request that _all_ contributors run their patches
through checkpath.pl and fix the problems. The review process is the
same for _all_ contributors and I'm not going to add an extra Andi
attitude mode to it.

> > > +
> > > +		/* Only switch to UP mode if we don't immediately boot others */
> > > +		if (num_possible_cpus() == 1 || max_cpus == 0)
> > 
> > Shouldn't this be max_cpus <= 1 ?
> 
> Don't think so, smp_init() seems to use it one off.

It's not a question of what you think. It's a question of what the
code does and what the meaning of the command line parameter is:

/*
 * Setup routine for controlling SMP activation
 *
 * Command-line option of "nosmp" or "maxcpus=0" will disable SMP
 * activation entirely (the MPS table probe still happens, though).
 *
 * Command-line option of "maxcpus=<NUM>", where <NUM> is an integer
 * greater than 0, limits the maximum number of CPUs activated in
 * SMP mode to <NUM>.
 */

There is no "one off" use in smp_init():

	for_each_present_cpu(cpu) {
		if (num_online_cpus() >= max_cpus)
			break;

so the above check needs to be "max_cpus <= 1".

> > > +extern unsigned int max_cpus;
> > 
> > I'm a bit wary about making max_cpus global. max_cpus is used all over
> > the place as a local variable name. Can we please rename it to
> > setup_max_cpus or something like that?
> 
> Hmm, I didn't see any warnings from this so surely it's not a big issue?

It's not about warnings. It's about name spaces and it makes the
purpose of the global variable clear to the reader.

     tglx
