Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbXGQJGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbXGQJGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXGQJFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:05:53 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:14054 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXGQJFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:05:53 -0400
Message-ID: <469C86EB.8090501@sw.ru>
Date: Tue, 17 Jul 2007 13:07:55 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelianov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [Devel] Re: [PATCH] Fix user struct leakage with locked IPC shem
 segment
References: <469B636C.3060007@openvz.org> <20070716151738.2f4b5cf4.akpm@linux-foundation.org>
In-Reply-To: <20070716151738.2f4b5cf4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 16 Jul 2007 16:24:12 +0400
> Pavel Emelianov <xemul@openvz.org> wrote:
> 
> 
>>When user locks an ipc shmem segmant with SHM_LOCK ctl and the
>>segment is already locked the shmem_lock() function returns 0. 
>>After this the subsequent code leaks the existing user struct:
> 
> 
> I'm curious.  For the past few months, people@openvz.org have discovered
> (and fixed) an ongoing stream of obscure but serious and quite
> long-standing bugs.

thanks a lot :@)

> How are you discovering these bugs?

Not sure what to answer :) Just trying to do our best.

This bug was thought over by Pavel for about 3 month after a single
uid leak in container was detected by beancounters' kernel memory accounting...

>>== ipc/shm.c: sys_shmctl() ==
>>     ...
>>     err = shmem_lock(shp->shm_file, 1, user);
>>     if (!err) {
>>          shp->shm_perm.mode |= SHM_LOCKED;
>>          shp->mlock_user = user;
>>     }
>>     ...
>>==
>>
>>Other results of this are:
>>1. the new shp->mlock_user is not get-ed and will point to freed
>>   memory when the task dies.
> 
> 
> That sounds fairly serious - can this lead to memory corruption and crashes?

Yes it can. According to Pavel when the shmem segment is destroyed it
puts the mlock_user pointer, which can already be stalled.

Kirill
