Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540Ab0ADP5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0ADP5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354Ab0ADP5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:57:08 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:49105 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0ADP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:57:07 -0500
Date: Mon, 4 Jan 2010 16:57:02 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: kprobes: get rid of distinct type warning
Message-ID: <20100104155702.GB5671@osiris.boeblingen.de.ibm.com>
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
 <20091221111759.GA12670@in.ibm.com>
 <20091221120224.GA4471@osiris.boeblingen.de.ibm.com>
 <20091230132945.f32f49fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230132945.f32f49fd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 01:29:45PM -0800, Andrew Morton wrote:
> On Mon, 21 Dec 2009 13:02:24 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > Of course the patch wouldn't help for CONFIG_PREEMPT and !CONFIG_SMP since
> > we would have a comparison of a signed and and unsigned value again *sigh*.
> 
> We should fix that, shouldn't we?  Rather than working around it at one
> caller site.
> 
> : #if NR_CPUS > 1
> : #define num_online_cpus()	cpumask_weight(cpu_online_mask)
> : #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
> : #define num_present_cpus()	cpumask_weight(cpu_present_mask)
> : #define num_active_cpus()	cpumask_weight(cpu_active_mask)
> : #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
> : #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
> : #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
> : #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
> : #else
> : #define num_online_cpus()	1
> : #define num_possible_cpus()	1
> : #define num_present_cpus()	1
> : #define num_active_cpus()	1
> : #define cpu_online(cpu)		((cpu) == 0)
> : #define cpu_possible(cpu)	((cpu) == 0)
> : #define cpu_present(cpu)	((cpu) == 0)
> : #define cpu_active(cpu)		((cpu) == 0)
> : #endif
> 
> The num_*() "functions" return unsigned on SMP and int on UP.  This is
> wrong.
> 
> The cpu_*() "functions" got lucky and return int in both cases.
> 
> Personally I think it's neatest if a quantity which can never be
> negative is held in an unsigned type.  Than includes anything starting
> with "num".  But for expediency's sake we could live with making these
> things consistently return "int".
> 
> Alas, changing those four num_*() "functions" to return int on SMP is a
> pretty wide-reaching change and will probably expose warts.

Looks like there are quite a lot of num_* function usages in the kernel.
Some seem to assume they return an int some assume an unsigned int.
Don't know if it's worth changing anything here.
Maybe Rusty has an opinion.
