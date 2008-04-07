Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYDGNZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYDGNZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYDGNZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:25:10 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:39709 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYDGNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:25:09 -0400
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <200804060201.52726.balajirrao@gmail.com>
References: <200804052339.46632.balajirrao@gmail.com>
	 <20080405194041.GB21279@linux.vnet.ibm.com>
	 <200804060201.52726.balajirrao@gmail.com>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 15:24:53 +0200
Message-Id: <1207574693.15579.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-06 at 02:01 +0530, Balaji Rao wrote:

> > > +static s64 cpu_cgroup_read_stat(struct cpu_cgroup_stat *stat,
> > > +		enum cpu_cgroup_stat_index idx)
> > > +{
> > > +	int cpu;
> > > +	s64 ret = 0;
> > > +	unsigned long flags;
> > 
> > > +
> > > +	local_irq_save(flags);
> > 
> > I am just wondering. Is local_irq_save() enough?
> > 
> Hmmm.. You are right.This does not prevent concurrent updates on other CPUs 
> from crossing a 32bit boundary. Am not sure how to do this in a safe way. I 
> can only think of using atomic64_t now..
> 
> > > +	for_each_possible_cpu(cpu)
> > > +		ret += stat->cpustat[cpu].count[idx];
> > > +	local_irq_restore(flags);
> > > +
> > > +	return ret;
> > > +}
> > > +

So many stats to steal code from,.. but you didn't :-(

Look at mm/vmstat.c, that is a rather complete example.

The trick to solving the above is to use per cpu deltas instead, the
deltas can be machine word size and are thus always read in an atomic
manner (provided they are also naturally aligned).

