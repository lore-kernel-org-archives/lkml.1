Return-Path: <linux-kernel-owner+w=401wt.eu-S968144AbXFHKM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968144AbXFHKM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937680AbXFHKML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:12:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43247 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937612AbXFHKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:12:09 -0400
Message-ID: <46692B7E.40000@bull.net>
Date: Fri, 08 Jun 2007 12:12:14 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, ak@suse.de
Subject: Re: [RFC][PATCH 1/6] Storing ipcs into radix trees
References: <20070607165302.917616000@bull.net> <20070607165555.155173000@bull.net> <200706072137.34563.ioe-lkml@rameria.de>
In-Reply-To: <200706072137.34563.ioe-lkml@rameria.de>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 08/06/2007 12:11:13,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 08/06/2007 12:15:46,
	Serialize complete at 08/06/2007 12:15:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Oeser wrote:
> Hi Nadia,
> 
> good to see someone is pounding this old beast again :-)
> 
> On Thursday 07 June 2007, Nadia.Derbey@bull.net wrote:
> 
>>Index: linux-2.6.21/ipc/util.h
>>===================================================================
>>--- linux-2.6.21.orig/ipc/util.h	2007-06-07 11:00:30.000000000 +0200
>>+++ linux-2.6.21/ipc/util.h	2007-06-07 11:07:22.000000000 +0200
>>@@ -13,6 +13,8 @@
>> #define USHRT_MAX 0xffff
>> #define SEQ_MULTIPLIER	(IPCMNI)
>> 
>>+#define IPCS_MAX_SCAN_ENTRIES 256
> 
> 
> That ...
> 
> 
>>Index: linux-2.6.21/ipc/util.c
>>===================================================================
>>--- linux-2.6.21.orig/ipc/util.c	2007-06-07 11:00:30.000000000 +0200
>>+++ linux-2.6.21/ipc/util.c	2007-06-07 11:29:43.000000000 +0200
>>@@ -252,72 +241,94 @@ void __init ipc_init_proc_interface(cons
>>  *	@key: The key to find
>>  *	
>>  *	Requires ipc_ids.mutex locked.
>>- *	Returns the identifier if found or -1 if not.
>>+ *	Returns the LOCKED pointer to the ipc structure if found or NULL
>>+ *	if not.
>>+ *      If key is found ipc contains its ipc structure
>>  */
>>  
>>-int ipc_findkey(struct ipc_ids* ids, key_t key)
>>+struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
>> {
>>-	int id;
>>-	struct kern_ipc_perm* p;
>>-	int max_id = ids->max_id;
>>+	struct kern_ipc_perm *ipc;
>>+	struct kern_ipc_perm *ipcs[IPCS_MAX_SCAN_ENTRIES];
> 
> 
> ... together with this means 4*256 -> 1k of precious stack space used.
> Please consider either lowering IPCS_MAX_SCAN_ENTRIES or kmalloc() that.
> 
> Same problem with your third patch called 
> "Changing the loops on a single ipcid into radix_tree_gang_lookup() calls"
> 
> If you cannot sleep, try to lower that constant (e.g. 16-32). 
> The current users use much smaller numbers.
> 
> If you can sleep and performance goes down after lowering that constant,
> try to kmalloc these arrays (since kmalloc() of that small amount 
> should succeed easily).
> 
> 
> 
> Regards
> 
> Ingo Oeser
> 

Ingo,

You're completely right, but trying to lower the extraction size, I'm 
afraid this will have an impact on performances.

Here are the results of a small test I did: I have run ctxbench on both 
the 256 and and 16 entries versions

1) 256 entries:

[root@akt ctxbench-1.9]# echo 1000 > /proc/sys/kernel/msgmni
[root@akt ctxbench-1.9]# ./ctx -m -t300


Context switching benchmark v1.17
   Using message queue for IPC control
    Max iterations:        0 (zero = no limit)
Max runtime (sec):      300 (zero = no limit)
42523679 itterations in 300.005423 seconds = 141743/sec

2) 16 entries:

[root@akt ctxbench-1.9]# echo 1000 > /proc/sys/kernel/msgmni
[root@akt ctxbench-1.9]# ./ctx -m -t300


Context switching benchmark v1.17
   Using message queue for IPC control
    Max iterations:        0 (zero = no limit)
Max runtime (sec):      300 (zero = no limit)
41774255 itterations in 300.005334 seconds = 139245/sec

Will try with a dynamic allocation.

Regards,
Nadia


