Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0CEMDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:03:35 -0500
Received: from smtp-out.google.com ([216.239.33.17]:4079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0CEMDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:03:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=aXN+m5MI6vNbJUosjOfNFmkuoEm34luGh/T9PE/8hX7eOQxhDZAixIHexL0AUDldo
	yAkfAHw9g0BZgQim45Avg==
MIME-Version: 1.0
In-Reply-To: <4B8E3F77.6070201@cn.fujitsu.com>
References: <4B8E3F77.6070201@cn.fujitsu.com>
Date: Fri, 5 Mar 2010 04:03:26 -0800
Message-ID: <6599ad831003050403v2e988723k1b6bf38d48707ab1@mail.gmail.com>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy and 
	mems_allowed
From: Paul Menage <menage@google.com>
To: miaox@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 2:52 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> if MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed or mems_allowed in
> task->mempolicy are not atomic operations, and the kernel page allocator gets an empty
> mems_allowed when updating task->mems_allowed or mems_allowed in task->mempolicy. So we
> use a rwlock to protect them to fix this probelm.

Rather than adding locks, if the intention is just to avoid the
allocator seeing an empty nodemask couldn't we instead do the
equivalent of:

current->mems_allowed |= new_mask;
current->mems_allowed = new_mask;

i.e. effectively set all new bits in the nodemask first, and then
clear all old bits that are no longer in the new mask. The only
downside of this is that a page allocation that races with the update
could potentially allocate from any node in the union of the old and
new nodemasks - but that's the case anyway for an allocation that
races with an update, so I don't see that it's any worse.

Paul
