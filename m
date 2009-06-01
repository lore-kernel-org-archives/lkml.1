Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZFAVoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZFAVoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZFAVnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:43:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34991 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbZFAVnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:43:52 -0400
Date: Mon, 1 Jun 2009 14:43:46 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Trivial Patches <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linuxtronix.de>
Subject: [PATCH] Documentation: Fix inconsistent description of futex
	list_op_pending
Message-ID: <20090601214346.GN9285@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Documentation: Fix inconsistent description of futex list_op_pending

    Strictly speaking list_op_pending points to the 'lock entry', not the
    'lock word' (which is actually at 'offset' from 'lock entry'). We can
    infer this based on reading the code in kernel/futex.c:

	    struct robust_list __user *entry, *next_entry, *pending;
		...
            if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
                    return;
            ...
            if (pending)
                    handle_futex_death((void __user *)pending + futex_offset,
                                       curr, pip);

    Which is also consistent with the rest of the docs on robust futex
    lists.

    Signed-off-by: Matt Helsley <matthltc@us.ibm.com>

diff --git a/Documentation/robust-futex-ABI.txt b/Documentation/robust-futex-ABI.txt
index 535f69f..fd1cd8a 100644
--- a/Documentation/robust-futex-ABI.txt
+++ b/Documentation/robust-futex-ABI.txt
@@ -135,7 +135,7 @@ manipulating this list), the user code must observe the following
 protocol on 'lock entry' insertion and removal:
 
 On insertion:
- 1) set the 'list_op_pending' word to the address of the 'lock word'
+ 1) set the 'list_op_pending' word to the address of the 'lock entry'
     to be inserted,
  2) acquire the futex lock,
  3) add the lock entry, with its thread id (TID) in the bottom 29 bits
@@ -143,7 +143,7 @@ On insertion:
  4) clear the 'list_op_pending' word.
 
 On removal:
- 1) set the 'list_op_pending' word to the address of the 'lock word'
+ 1) set the 'list_op_pending' word to the address of the 'lock entry'
     to be removed,
  2) remove the lock entry for this lock from the 'head' list,
  2) release the futex lock, and
