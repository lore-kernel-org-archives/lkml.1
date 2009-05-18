Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZERVJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZERVJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 17:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZERVJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 17:09:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:18997 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZERVJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 17:09:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,211,1241420400"; 
   d="scan'208";a="413535601"
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A11B9E7.8010707@zytor.com>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	 <1242436626.27006.8623.camel@localhost.localdomain>
	 <4A0ED8D8.2010303@kernel.org>
	 <1242500964.27006.8636.camel@localhost.localdomain>
	 <4A0F672A.3000309@kernel.org>
	 <1242674444.27006.8691.camel@localhost.localdomain>
	 <4A11B9E7.8010707@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 18 May 2009 14:07:15 -0700
Message-Id: <1242680835.27006.8734.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 12:41 -0700, H. Peter Anvin wrote:
> Suresh Siddha wrote:
> > 
> > Can we don't use PERCPU_DYNAMIC_RESERVE in the first chunk and for
> > dynamic per_cpu_ptr's we can use some other offset such as
> > per_cpu_ptr_offset() or some such thing?
> > 
> > Then we can separate the static and dynamic chunks. And use large page
> > kernel-direct mappings for fast access for critical common things and
> > use small page accesses for dynamic and not so common accesses.
> > 
> > Just checking to see if we can reduce the complexity of setting up the
> > percpu areas (different versions for embed, non-embed etc) and handling
> > all these aliases with simple code, rather than making it complex.
> > 
> 
> I'm confused what you're suggesting here.  The whole point of the percpu
> unification work is that we can use %gs:absolute type references to hit
> a variable right away.  Although in theory we could use both %fs and %gs
> for pointers, setting up both would greatly increase the cost of
> entering the kernel, especially on 64 bits.
> 
> This means all percpu data has to have a constant (virtual) offset from
> the beginning of the static percpu area.

This %gs:absolute type accesses are for static percpu data.

But what I was referring to is the dynamic percpu data(accessed through
per_cpu_ptr()). Instead of combining some part of the dynamic percpu
data into  the static percpu data(first percpu chunk), we can use
different chunks for dynamic percpu data and governed by a different
per_cpu_dynamic_offset[NR_CPUS] array.

Then we can use large-page kernel direct mappings for static percpu data
(or %gs:offset) and small-page vmalloc mappings for dynamic percpu data.

thanks,
suresh

