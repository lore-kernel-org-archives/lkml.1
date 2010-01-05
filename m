Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326Ab0AECPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0AECPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190Ab0AECPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:15:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43054 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab0AECP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:15:29 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20100105315.789846878@firstfloor.org>
To: ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/9] SYSCTL: Use RCU to avoid races with string sysctls v2
Date: Tue,  5 Jan 2010 03:15:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2 version that addresses all the earlier review comments
minus patches that were already merged.

I think this one is ready for merge now. Andrew, could you please
take it?

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---

With BKL-less sysctls most of the writable string sysctls are racy. There
is no locking on the reader side, so a reader could see an inconsistent
string or worse miss the terminating null and walk of beyond it.

This patch kit adds a new "rcu string" variant to avoid these 
problems and convers the racy users. One the writer side the strings are 
always copied to new memory and the readers use rcu_read_lock()
to get a stable view. For readers who access the string over
sleeps the reader copies the string. 

This is all hidden in a new generic "rcu_string" ADT which can be also 
used for other purposes.

This finally implements all the letters in RCU, most other users
leave out the 'C'.

I left some obscure users in architectures (sparc, mips) alone and audited
all of the others. The sparc reboot_cmd one has references to asm files
which I didn't want to touch and the mips variant seemd just too obscure.

All the others are not racy.

-Andi
