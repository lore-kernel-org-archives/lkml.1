Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZFJOUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZFJOUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbZFJOTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:19:47 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34286 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbZFJOTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:19:45 -0400
Date: Wed, 10 Jun 2009 16:19:35 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Eric Leblond <eric@inl.fr>, Patrick McHardy <kaber@trash.net>
Cc: Maran Pakkirisamy <maranpsamy@in.ibm.com>,
       Andreas Krebbel <krebbel1@de.ibm.com>, <linux-kernel@vger.kernel.org>,
       netfilter-devel@vger.kernel.org
Subject: netfilter: BUG: sleeping function called from invalid context
Message-ID: <20090610161935.0f8b1949@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maran reported the bug below (vanilla 2.6.30-rc8):

BUG: sleeping function called from invalid context at /mnt/s390test/linux-2.6-tip/arch/s390/include/asm/uaccess.h:234 
in_atomic(): 1, irqs_disabled(): 0, pid: 3245, name: sysctl 
CPU: 1 Not tainted 2.6.30-rc8-tipjun10-02053-g39ae214 #1 
Process sysctl (pid: 3245, task: 000000007f675da0, ksp: 000000007eb17cf0) 
0000000000000000 000000007eb17be8 0000000000000002 0000000000000000  
       000000007eb17c88 000000007eb17c00 000000007eb17c00 0000000000048156  
       00000000003e2de8 000000007f676118 000000007eb17f10 0000000000000000  
       0000000000000000 000000007eb17be8 000000000000000d 000000007eb17c58  
       00000000003e2050 000000000001635c 000000007eb17be8 000000007eb17c30  
Call Trace: 
(Ý<00000000000162e6>¨ show_trace+0x13a/0x148) 
 Ý<00000000000349ea>¨ __might_sleep+0x13a/0x164 
 Ý<0000000000050300>¨ proc_dostring+0x134/0x22c 
 Ý<0000000000312b70>¨ nf_log_proc_dostring+0xfc/0x188 
 Ý<0000000000136f5e>¨ proc_sys_call_handler+0xf6/0x118 
 Ý<0000000000136fda>¨ proc_sys_read+0x26/0x34 
 Ý<00000000000d6e9c>¨ vfs_read+0xac/0x158 
 Ý<00000000000d703e>¨ SyS_read+0x56/0x88 
 Ý<0000000000027f42>¨ sysc_noemu+0x10/0x16 

The code that introduces the bug came in with 17625274 "netfilter:
sysctl support of logger choice".

There we have this chunk:

+               rcu_read_lock();
+               logger = rcu_dereference(nf_loggers[tindex]);
+               if (!logger)
+                       table->data = "NONE";
+               else
+                       table->data = logger->name;
+               r = proc_dostring(table, write, filp, buffer, lenp, ppos);
+               rcu_read_unlock();

proc_dostring() will call copy_from_user() while preemption is disabled
because of rcu_read_lock().
Looks like somebody needs to fix this ;)
