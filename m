Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYAOKSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYAOKSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYAOKSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:18:46 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50709 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYAOKSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:18:45 -0500
Message-ID: <478C881B.5030503@bull.net>
Date: Tue, 15 Jan 2008 11:16:59 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com
Subject: Re: [RFC PATCH 4/4] [RESEND] Recomputing msgmni on memory add / remove
References: <20080115164440.6DBB.Y-GOTO@jp.fujitsu.com> <478C76D4.3010700@bull.net> <20080115182402.6DBD.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20080115182402.6DBD.Y-GOTO@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/01/2008 11:27:00,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/01/2008 11:27:02,
	Serialize complete at 15/01/2008 11:27:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
>>Yasunori Goto wrote:
>>
>>>Hello Nadia-san.
>>>
>>>
>>>
>>>>@@ -118,6 +122,10 @@ struct ipc_namespace {
>>>>	size_t		shm_ctlall;
>>>>	int		shm_ctlmni;
>>>>	int		shm_tot;
>>>>+
>>>>+#ifdef CONFIG_MEMORY_HOTPLUG
>>>>+	struct notifier_block ipc_memory_hotplug;
>>>>+#endif
>>>>};
>>>
>>>
>>>I'm sorry, but I don't see why each ipc namespace must have each callbacks
>>>of memory hotplug.
>>>I prefer only one callback for each subsystem, not for each namespace.
>>>In addition, the recompute_msgmni() calculation looks very similar for
>>>all ipc namespace.
>>>Or do you wish each ipc namespace have different callback for the future?
>>>
>>
>>Actually, this is what I wanted to do at the very beginning: have a 
>>single callback that would recompute the msgmni for each ipc namespace. 
>>But the issue here is that the namespaces are not linked to each other, 
>>so I had no simple way to go through all the namespaces.
>>I solved the issue by having a callback for any single ipc namespace and 
>>make it recompute the msgmni value for itslef.
> 
> 
> The recompute_msg() must be called when new ipc_namespace is created/removed
> as you mentioned. I think namespaces should be linked each other for it
> in the end....

Not if I do it the same way as for memory hotplug:
1) definee a "namespace event notifier"
2) insert another notifier block into the ipc namespace.
3) The callback routines in the notifier chain would be activated upon 
namespace creation / removal.

But I'm still thinking about it: Matt Helsley suggested that we might 
just copy the old namespace's value when creating a new namespace.

There's also the issue of an msgmni that has been changed via procfs: 
may be we should not unconditionally recompute it upon namespace 
creation / removal, so unregister the callback for the owning namespace 
as soon as msgmni has been changed from userspace.


Regards,
Nadia
