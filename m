Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZLUBUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZLUBUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZLUBUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:20:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37699 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbZLUBU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:28 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20091221220.243954235@firstfloor.org>
To: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com
Subject: [PATCH] [0/11] SYSCTL: Use RCU to avoid races with string sysctls
Date: Mon, 21 Dec 2009 02:20:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

I also fixed the zone order list sysctl to use a mutex to avoid
racing with itself. 

I left some obscure users in architectures (sparc, mips) alone and audited
all of the others. The sparc reboot_cmd one has references to asm files
which I didn't want to touch and the mips variant seemd just too obscure.

All the others are not racy.

-Andi
