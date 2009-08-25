Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZHYJ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZHYJ4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZHYJ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:56:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:47211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZHYJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:56:32 -0400
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
 cpumask on multi-node processors
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090825093101.GJ20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins>
	 <20090825093101.GJ20811@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 11:55:43 +0200
Message-Id: <1251194143.7538.1128.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:31 +0200, Andreas Herrmann wrote:
> On Mon, Aug 24, 2009 at 05:36:16PM +0200, Peter Zijlstra wrote:
> > On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > > The correct mask that describes core-siblings of an processor
> > > is topology_core_cpumask. See topology adapation patches, especially
> > > http://marc.info/?l=linux-kernel&m=124964999608179
> > 
> > 
> > argh, violence, murder kill.. this is the worst possible hack and you're
> > extending it :/
> 
> So this is the third code area
> (besides sched_*_power_savings sysfs interface, and the __cpu_power fiddling)
> that is crap, mess, a hack.
> 
> Didn't know that I'd enter such a minefield when touching this code. ;-(

Yeah, you're lucky that way ;-) Its been creaking for a while, and I've
been making noises to the IBM people (who so far have been the main
source of power saving patches) to clean this up, but now you trod onto
all of it at once..

> What would be your perferred solution for the
> core_cpumask/llc_shared_map stuff?  Another domain level to get rid of
> this function?

Right, I'd like to see everything exposed as domain levels.


numa-cluster
numa
socket
in-socket-numa
multi-core
shared-cache
core
threads

We currently have a fixed order of these things, but I think we should
simply provide helpers for building the sd tree and let the arch code do
that instead of exporting all these masks in a fixed order.

Once we get the arch domain tree, we do degenerate stuff to cull all the
trivial domains and fold SD flags.
