Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbYBSIIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbYBSIIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYBSIIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:08:35 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53769 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYBSIIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:08:34 -0500
Date: Tue, 19 Feb 2008 17:04:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1
 softlockup  while bootup on powerpc
Message-Id: <20080219170432.9c04376f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080217192913.GO23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	<47B67E5E.4010001@linux.vnet.ibm.com>
	<20080217192913.GO23197@kernel.dk>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 20:29:13 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> It's odd stuff. Could you perhaps try and add some printks to
> block/cfq-iosched.c:call_for_each_cic(), like dumping the 'nr' return
> from radix_tree_gang_lookup() and the pointer value of cics[i] in the
> for() loop after the lookup?
> 
I met the same issue on ia64/NUMA box.
seems cisc[]->key is NULL and index for radix_tree_gang_lookup() was always '1'.

Attached patch works well for me, 
but I don't know much about cfq. please confirm. 

Regards,
-Kame

==
cics[]->key can be NULL.
In that case, cics[]->dead_key has key value.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.25-rc2/block/cfq-iosched.c
===================================================================
--- linux-2.6.25-rc2.orig/block/cfq-iosched.c
+++ linux-2.6.25-rc2/block/cfq-iosched.c
@@ -1171,7 +1171,11 @@ call_for_each_cic(struct io_context *ioc
 			break;
 
 		called += nr;
-		index = 1 + (unsigned long) cics[nr - 1]->key;
+
+		if (!cics[nr - 1]->key)
+			index = 1 + (unsigned long) cics[nr - 1]->dead_key;
+		else
+			index = 1 + (unsigned long) cics[nr - 1]->key;
 
 		for (i = 0; i < nr; i++)
 			func(ioc, cics[i]);

