Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbYCFLDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbYCFLDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764267AbYCFK5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:57:06 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3552 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763426AbYCFK5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:57:05 -0500
Date: Thu, 6 Mar 2008 10:56:03 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David J. Wilder" <dwilder@us.ibm.com>, linux-kernel@vger.kernel.org,
       systemtap@sourceware.org
Subject: Re: [patch 1/3]  Relay Reset Consumed
Message-ID: <20080306105603.GC25123@shadowen.org>
References: <1204588311.32186.7.camel@lc4eb748232119.ibm.com> <20080305141229.d79d846b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305141229.d79d846b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 02:12:29PM -0800, Andrew Morton wrote:
> On Mon, 03 Mar 2008 15:51:50 -0800
> "David J. Wilder" <dwilder@us.ibm.com> wrote:
> 
> > This patch allows relay channels to be reset i.e. unconsumed.
> > Basically allows a 'rewind' function for flight-recorder tracing.
> > 
> > +void relay_reset_consumed(struct rchan *chan)
> > +{
> > +	unsigned int i;
> > +	struct rchan_buf *prev = NULL;
> > +
> > +	if (!chan)
> > +		return;
> > +
> > +	for (i = 0; i < NR_CPUS; i++) {
> 
> Use of NR_CPUS is usually wrong.  In this case it seems you should be using
> for_each_possible_cpu().
> 
> Also the existing usage of NR_CPUS in relay_subbufs_consumed() should be
> switched to using cpu_possible().
> 
> 
> New usage of NR_CPUS might be checkpatch-worthy, actually:
> 
> akpm:/usr/src/25> grep -l '^+.*NR_CPUS' patches/*.patch 
> patches/ext4-mm-mballoc-core.patch
> patches/git-kvm.patch
> patches/git-perfmon.patch
> patches/relay-reset-consumed.patch
> patches/x86-andi-git-x86.patch
> patches/x86-andi-smp-switch-optimize.patch
> 
> that's a sample of 1852 patches.
> 
> An appropriate warning would be "Usage of NR_CPUS is often wrong - should
> you be using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(),
> etc?".

That seems reasonable.  If we special case the definitions of NR_CPUS
and the use of them to define arrays of things both of which appear
reasonable,

	#define NR_CPUS 10
	int semid[NR_CPUS];

then it seems sensible to report this one:

	WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc
	#1: FILE: Z101.c:1:
	+       for (i = 0; i < NR_CPUS; i++)

This will be in the next push to -mm.

-apw
