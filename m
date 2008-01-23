Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYAWEth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYAWEth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 23:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYAWEt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 23:49:27 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52369 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752204AbYAWEt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 23:49:27 -0500
Message-Id: <20080123044924.508382000@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 22 Jan 2008 20:49:24 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, jeremy@goop.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] percpu: Optimize percpu accesses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset provides the following:

  * Generic: Percpu infrastructure to rebase the per cpu area to zero

    This provides for the capability of accessing the percpu variables
    using a local register instead of having to go through a table
    on node 0 to find the cpu-specific offsets.  It also would allow
    atomic operations on percpu variables to reduce required locking.

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

Based on 2.6.24-rc8-mm1

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---

-- 
