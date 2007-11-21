Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXKUQa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXKUQa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 11:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbXKUQas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 11:30:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40551 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752224AbXKUQar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 11:30:47 -0500
Message-ID: <47445D2D.8090703@sgi.com>
Date: Wed, 21 Nov 2007 08:30:37 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, mingo@elte.hu, apw@shadowen.org,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: Reduce pressure on stack from cpumask usage
 -v2
References: <20071121100201.156191000@sgi.com> <200711211118.45137.ak@suse.de>
In-Reply-To: <200711211118.45137.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 21 November 2007 11:02:01 travis@sgi.com wrote:
>> v2:
>>     - fix some compile errors when NR_CPUS > default for ia386 (128 & 4096)
>>     - remove unnecessary includes
>>
>> Convert cpumask_of_cpu to use a static percpu data array and
>> set_cpus_allowed to pass the cpumask_t arg as a pointer.
> 
> I'm not sure that is too useful alone because you didn't solve the
> set_cpus_allowed(oldmask) problem.

Passing by reference does reduce the amount of data pushed onto the stack
for all cases.

I've been looking at a couple of options to fix up the rest of the cpumask_t
users.  The least disruptive would be to make cpumask_t a "const *cpumask"
type and then fix up instances where a cpumask var is needed.  It does get
messy attempting to keep cpumask_t a simple integer in the NR_CPUS <=
BITS_PER_LONG case, in a transparent manner.

The other is to continue to modify subroutines that expect cpumask_t
arguments and work back up the call chain passing by reference instead.
In this case I could use the idea of allocating a "scratch" cpumask_t
array in the task struct (or somewhere else?) to accommodate trivial
changes, to lessen local frame storage.  Again though, the code gets
messy in the same manner as above.

The set_cpus_allowed is about 30% of the "cpumask_t pass by value" code
though much lower in call usage.  The highest call count goes to the
send_IPI_mask, irq and smp_call functions.

Btw, is there a good source code call trace analyzer tool around someplace?

Thanks,
Mike

