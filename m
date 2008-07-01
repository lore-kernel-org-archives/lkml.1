Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYGAMRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYGAMRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYGAMQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:16:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42966 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753244AbYGAMQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:16:35 -0400
Message-Id: <20080701121634.865966000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Jul 2008 05:16:34 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [RFC 0/5] percpu: Optimize percpu accesses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset provides the following:

  * Cleanup: Fix early references to cpumask_of_cpu(0)

    Provides an early cpumask_of_cpu(0) usable before the cpumask_of_cpu_map
    is allocated and initialized.

  * Generic: Percpu infrastructure to rebase the per cpu area to zero

    This provides for the capability of accessing the percpu variables
    using a local register instead of having to go through a table
    on node 0 to find the cpu-specific offsets.  It also would allow
    atomic operations on percpu variables to reduce required locking.
    Uses a new config var HAVE_ZERO_BASED_PER_CPU to indicate to the
    generic code that the arch has this new basing.

    (Note: split into two patches, one to rebase percpu variables at 0,
    and the second to actually use %gs as the base for percpu variables.)

  * x86_64: Fold pda into per cpu area

    Declare the pda as a per cpu variable. This will move the pda
    area to an address accessible by the x86_64 per cpu macros.
    Subtraction of __per_cpu_start will make the offset based from
    the beginning of the per cpu area.  Since %gs is pointing to the
    pda, it will then also point to the per cpu variables and can be
    accessed thusly:

	%gs:[&per_cpu_xxxx - __per_cpu_start]

  * x86_64: Rebase per cpu variables to zero

    Take advantage of the zero-based per cpu area provided above.
    Then we can directly use the x86_32 percpu operations. x86_32
    offsets %fs by __per_cpu_start. x86_64 has %gs pointing directly
    to the pda and the per cpu area thereby allowing access to the
    pda with the x86_64 pda operations and access to the per cpu
    variables using x86_32 percpu operations.


Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---

-- 
