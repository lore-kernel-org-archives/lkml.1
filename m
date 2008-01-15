Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYAOJFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYAOJFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYAOJFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:05:01 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46586 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYAOJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:04:58 -0500
Message-ID: <478C76D4.3010700@bull.net>
Date: Tue, 15 Jan 2008 10:03:16 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com
Subject: Re: [RFC PATCH 4/4] [RESEND] Recomputing msgmni on memory add / remove
References: <20080114155402.690906000@bull.net> <20080114155602.855698000@bull.net> <20080115164440.6DBB.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20080115164440.6DBB.Y-GOTO@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/01/2008 10:13:18,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/01/2008 10:13:19,
	Serialize complete at 15/01/2008 10:13:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
> Hello Nadia-san.
> 
> 
>>@@ -118,6 +122,10 @@ struct ipc_namespace {
>> 	size_t		shm_ctlall;
>> 	int		shm_ctlmni;
>> 	int		shm_tot;
>>+
>>+#ifdef CONFIG_MEMORY_HOTPLUG
>>+	struct notifier_block ipc_memory_hotplug;
>>+#endif
>> };
> 
> 
> I'm sorry, but I don't see why each ipc namespace must have each callbacks
> of memory hotplug.
> I prefer only one callback for each subsystem, not for each namespace.
> In addition, the recompute_msgmni() calculation looks very similar for
> all ipc namespace.
> Or do you wish each ipc namespace have different callback for the future?
> 

Actually, this is what I wanted to do at the very beginning: have a 
single callback that would recompute the msgmni for each ipc namespace. 
But the issue here is that the namespaces are not linked to each other, 
so I had no simple way to go through all the namespaces.
I solved the issue by having a callback for any single ipc namespace and 
make it recompute the msgmni value for itslef.

> 
> 
> BTW, have you ever tested this patch? If you don't have any test environment
> for memory hotplug code, then I'll check it. :-)

Well, I tested it but not in "real configuration": what I did is that I 
changed the status by hand under sysfs to offline. I also changed 
remove_memory() in mm/memory_hotplug.c in the following way (instead of 
returninf EINVAL):
1) decrease the total_ram pages
2) call memory_notify(MEM_OFFLINE, NULL)

and checked that the msgmni was recomputed.

But sure, if you are candidate to test it, that would be great!



Regards,
Nadia




