Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbXBSQIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbXBSQIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbXBSQIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:08:07 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:37479 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385AbXBSQIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:08:04 -0500
Message-ID: <45D9CB43.6000909@linux.vnet.ibm.com>
Date: Mon, 19 Feb 2007 21:37:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: balbir@in.ibm.com
CC: Paul Menage <menage@google.com>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org
Subject: Re: [ckrm-tech] [RFC][PATCH][2/4] Add RSS accounting and control
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219065034.3626.2658.sendpatchset@balbir-laptop> <20070219005828.3b774d8f.akpm@linux-foundation.org> <45D97DF8.5080000@in.ibm.com> <20070219030141.42c65bc0.akpm@linux-foundation.org> <45D9856D.1070902@in.ibm.com> <20070219032352.2856af36.akpm@linux-foundation.org> <45D9906F.2090605@in.ibm.com> <6599ad830702190409x4f64e56ex4044a12d949e44af@mail.gmail.com> <45D9AFBE.5020107@in.ibm.com>
In-Reply-To: <45D9AFBE.5020107@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Balbir Singh wrote:
> Paul Menage wrote:
>> On 2/19/07, Balbir Singh <balbir@in.ibm.com> wrote:
>>>> More worrisome is the potential for use-after-free.  What prevents the
>>>> pointer at mm->container from referring to freed memory after we're dropped
>>>> the lock?
>>>>
>>> The container cannot be freed unless all tasks holding references to it are
>>> gone,
>> ... or have been moved to other containers. If you're not holding
>> task->alloc_lock or one of the container mutexes, there's nothing to
>> stop the task being moved to another container, and the container
>> being deleted.
>>
>> If you're in an RCU section then you can guarantee that the container
>> (that you originally read from the task) and its subsystems at least
>> won't be deleted while you're accessing them, but for accounting like
>> this I suspect that's not enough, since you need to be adding to the
>> accounting stats on the correct container. I think you'll need to hold
>> mm->container_lock for the duration of memctl_update_rss()
>>
>> Paul
>>
> 
> Yes, that sounds like the correct thing to do.
> 

Accounting accuracy will anyway be affected when a process is migrated
while it is still allocating pages.  Having a lock here does not
necessarily improve the accounting accuracy.  Charges from the old
container would have to be moved to the new container before deletion
which implies all tasks have already left the container and no
mm_struct is holding a pointer to it.

The only condition that will break our code will be if the container
pointer becomes invalid while we are updating stats.  This can be
prevented by RCU section as mentioned by Paul.  I believe explicit
lock and unlock may not provide additional benefit here.

--Vaidy

