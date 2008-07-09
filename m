Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYGIR1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYGIR1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 13:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYGIR1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 13:27:32 -0400
Received: from gw.goop.org ([64.81.55.164]:38750 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbYGIR1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:27:31 -0400
Message-ID: <4874F4F2.9010603@goop.org>
Date: Wed, 09 Jul 2008 10:27:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080709165129.292635000@polaris-admin.engr.sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> This patchset provides the following:
>
>   * Cleanup: Fix early references to cpumask_of_cpu(0)
>
>     Provides an early cpumask_of_cpu(0) usable before the cpumask_of_cpu_map
>     is allocated and initialized.
>
>   * Generic: Percpu infrastructure to rebase the per cpu area to zero
>
>     This provides for the capability of accessing the percpu variables
>     using a local register instead of having to go through a table
>     on node 0 to find the cpu-specific offsets.  It also would allow
>     atomic operations on percpu variables to reduce required locking.
>     Uses a new config var HAVE_ZERO_BASED_PER_CPU to indicate to the
>     generic code that the arch has this new basing.
>
>     (Note: split into two patches, one to rebase percpu variables at 0,
>     and the second to actually use %gs as the base for percpu variables.)
>
>   * x86_64: Fold pda into per cpu area
>
>     Declare the pda as a per cpu variable. This will move the pda
>     area to an address accessible by the x86_64 per cpu macros.
>     Subtraction of __per_cpu_start will make the offset based from
>     the beginning of the per cpu area.  Since %gs is pointing to the
>     pda, it will then also point to the per cpu variables and can be
>     accessed thusly:
>
> 	%gs:[&per_cpu_xxxx - __per_cpu_start]
>
>   * x86_64: Rebase per cpu variables to zero
>
>     Take advantage of the zero-based per cpu area provided above.
>     Then we can directly use the x86_32 percpu operations. x86_32
>     offsets %fs by __per_cpu_start. x86_64 has %gs pointing directly
>     to the pda and the per cpu area thereby allowing access to the
>     pda with the x86_64 pda operations and access to the per cpu
>     variables using x86_32 percpu operations.

The bulk of this series is pda_X to x86_X_percpu conversion.  This seems 
like pointless churn to me; there's nothing inherently wrong with the 
pda_X interfaces, and doing this transformation doesn't get us any 
closer to unifying 32 and 64 bit.

I think we should start devolving things out of the pda in the other 
direction: make a series where each patch takes a member of struct 
x8664_pda, converts it to a per-cpu variable (where possible, the same 
one that 32-bit uses), and updates all the references accordingly.  When 
the pda is as empty as it can be, we can look at removing the 
pda-specific interfaces.

    J
