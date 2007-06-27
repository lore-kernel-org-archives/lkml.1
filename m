Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbXF0ETQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbXF0ETQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 00:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbXF0ETE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 00:19:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbXF0ETD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 00:19:03 -0400
Message-ID: <4681E52A.8030300@redhat.com>
Date: Wed, 27 Jun 2007 00:18:50 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO
 page retirement policy
References: <send-serie.davidel@xmailserver.org.29496.1182912259.1> <4681D37E.2020706@redhat.com> <Pine.LNX.4.64.0706262016080.26540@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706262016080.26540@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Tue, 26 Jun 2007, Rik van Riel wrote:
> 
>> SUID programs should not be able to use this feature,
>> either.
> 
> Why? A SUID programs runs under the UID of the owner, and should be no 
> problems in it seeing the owners data.

Because an SUID program can change its UID back.

At least, one that was SUID root.  OTOH, any
program running as root can change UID, so we
should probably not allow root to get nonzeroed
pages.

> But the patch post was more a quest for possible scenarios where the use 
> of MAP_NOZERO can result in lower security WRT the same program (under the 
> same security restrictions) not using such feature.
> If you have something specific in mind, please go ahead and shoot.

Besides the non-enforcing of SELinux security
labels (and maybe namespaces?), I cannot think
of anything.

>>> When pages exit (unmapped from) a  vma, they are marked with the effective
>>> UID of the  mm_struct  that owns it.
>>
>>> --- linux-2.6.mod.orig/include/linux/mm_types.h	2007-06-21
>>> 14:02:06.000000000 -0700
>>> +++ linux-2.6.mod/include/linux/mm_types.h	2007-06-25 19:11:22.000000000
>>> -0700
>>> @@ -64,6 +64,7 @@
>>>  	struct list_head lru;		/* Pageout list, eg. active_list
>>>  					 * protected by zone->lru_lock !
>>>  					 */
>>> +	int owner_uid;			/* Last owner of the page */
>>>  	/*
>>>  	 * On machines where all RAM is mapped into kernel address space,
>>>  	 * we can simply calculate the virtual address. On machines with
>> Since this is only set when the page is freed, could
>> the owner_uid and security context be put inside a
>> union with some fields that are not otherwise used
>> for free pages?
> 
> I tried to look, and the attempt to reuse _mapcount failed miserably :)
> The last time we have the owner info (vma->mm) available, is before 
> processing of the other fields ends. OTOH I'm not VM guru either, so I may 
> be wrong. It can share ->virtual (when enabled).

I think the process that actually calls the page freeing
functions is always the process that owned the page, so
going for current->mm should work.

Getting the UID wrong for file pages caught in a truncate
is fine, since the process obviously already had access
to the data in that page.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
