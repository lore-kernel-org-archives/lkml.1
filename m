Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXF0DDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXF0DDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 23:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXF0DDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 23:03:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbXF0DDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 23:03:38 -0400
Message-ID: <4681D37E.2020706@redhat.com>
Date: Tue, 26 Jun 2007 23:03:26 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] MAP_NOZERO - implement a new VM_NOZERO/MAP_NOZERO
 page retirement policy
References: <send-serie.davidel@xmailserver.org.29496.1182912259.1>
In-Reply-To: <send-serie.davidel@xmailserver.org.29496.1182912259.1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> This is the core implementation of the new VM_NOZERO page retirement
> policy (and the associated MAP_NOZERO).
> A new field  owner_uid  is added the the  mm_struct, and it is kept set to
> the effective UID of the task that own the  mm_struct.
> A new field  owner_uid  is also added to the page struct.

You will also need to take the task's SELinux security
context into account.

SUID programs should not be able to use this feature,
either.

> When pages exit (unmapped from) a  vma, they are marked with the effective
> UID of the  mm_struct  that owns it.


> --- linux-2.6.mod.orig/include/linux/mm_types.h	2007-06-21 14:02:06.000000000 -0700
> +++ linux-2.6.mod/include/linux/mm_types.h	2007-06-25 19:11:22.000000000 -0700
> @@ -64,6 +64,7 @@
>  	struct list_head lru;		/* Pageout list, eg. active_list
>  					 * protected by zone->lru_lock !
>  					 */
> +	int owner_uid;			/* Last owner of the page */
>  	/*
>  	 * On machines where all RAM is mapped into kernel address space,
>  	 * we can simply calculate the virtual address. On machines with

Since this is only set when the page is freed, could
the owner_uid and security context be put inside a
union with some fields that are not otherwise used
for free pages?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
