Return-Path: <linux-kernel-owner+w=401wt.eu-S1765409AbYAaJBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765409AbYAaJBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYAaJAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:00:53 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49933 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYAaJAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:00:52 -0500
Message-ID: <47A18E47.5050206@bull.net>
Date: Thu, 31 Jan 2008 10:00:55 +0100
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
 31/01/2008 10:09:32,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/01/2008 10:09:34,
	Serialize complete at 31/01/2008 10:09:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

	Thinking more about this, I think I must clarify why I choose this way.
In fact, the idea of these patches is to provide the missing user APIs (or
extend the existing ones) that allow to set or update _all_ properties of all
IPCs, as needed in the case of the checkpoint/restart of an application (the
current user API does not allow to specify an ID for a created IPC, for
example). And this, without changing the existing API of course.

	And msgget(), semget() and shmget() does not have any parameter we can use to
specify an ID.
	That's why I've decided to not change these routines and add a new control
command, IP_SETID, with which we can can change the ID of an IPC. (that looks to
me more straightforward and logical)

	Now, this patch is, in fact, only a preparation for the patch 10/15 which
really complete the user API by adding this IPC_SETID command.

(... continuing below ...)

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

And in fact, you do that from kernel space, you don't have the constraint to fit
the existing user API.
Again, this patch, even if it presents a new kernel API, is in fact a
preparation for the next patch which introduces a new user API.

Do you think that this could fit your need ?

-- 
Pierre
