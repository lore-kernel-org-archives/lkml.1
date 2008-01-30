Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYA3Jwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYA3Jwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYA3JwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:52:15 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46489 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbYA3JwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:52:13 -0500
Message-ID: <47A048CE.40106@bull.net>
Date: Wed, 30 Jan 2008 10:52:14 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 09/15] (RFC) IPC: new kernel API to change
 an ID
References: <20080129160229.612172683@bull.net> <20080129162000.454857358@bull.net> <20080129210656.GB1990@martell.zuzino.mipt.ru>
In-Reply-To: <20080129210656.GB1990@martell.zuzino.mipt.ru>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 30/01/2008 11:00:51,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 30/01/2008 11:00:53,
	Serialize complete at 30/01/2008 11:00:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexey Dobriyan wrote:
> On Tue, Jan 29, 2008 at 05:02:38PM +0100, pierre.peiffer@bull.net wrote:
>> This patch provides three new API to change the ID of an existing
>> System V IPCs.
>>
>> These APIs are:
>> 	long msg_chid(struct ipc_namespace *ns, int id, int newid);
>> 	long sem_chid(struct ipc_namespace *ns, int id, int newid);
>> 	long shm_chid(struct ipc_namespace *ns, int id, int newid);
>>
>> They return 0 or an error code in case of failure.
>>
>> They may be useful for setting a specific ID for an IPC when preparing
>> a restart operation.
>>
>> To be successful, the following rules must be respected:
>> - the IPC exists (of course...)
>> - the new ID must satisfy the ID computation rule.
>> - the entry in the idr corresponding to the new ID must be free.
> 
>>  ipc/util.c          |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  ipc/util.h          |    1 +
>>  8 files changed, 197 insertions(+)
> 
> For the record, OpenVZ uses "create with predefined ID" method which
> leads to less code. For example, change at the end is all we want from
> ipc/util.c .
> 

Yes, indeed, I saw that. The idea here is, at the end, to propose a more
"userspace oriented" solution.
As we can't use msgget(), etc, API to specify an ID, I think we can at least
change it afterwards

> Also, if ids were A and B at the moment of checkpoint, and during
> restart they became B and A you'll get collision in both ways which you
> techically can avoid by classic "tmp = A, A = B, B = tmp"

In the general case, yes, you're right.
In the case of the checkpoint/restart, this is not necessarily a problem, as we
will probably restart an application in an empty "container"/"namespace"; Thus
we can create all needed IPCs in an empty IPC namespace like this:
1. create first IPC
2. change its ID
3. create the second IPC
4. change its ID
5. etc..

But yes, I agree that if we can directly create an IPC with the right ID, it
would be better; may be with an IPC_CREATE command or something like that if the
direction is to do that from userspace.

-- 
Pierre Peiffer
