Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYLKApI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYLKApI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYLKAo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:44:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:37045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYLKAoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:44:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=ueiSMwyCy8fNhHUqo1YxijwbO9WgA5DLt9imZY9pu9OIY+MTOQgK3jRHPMbxUiDdL
	/xtjoRhqZUrwoyXVeWdIg==
MIME-Version: 1.0
In-Reply-To: <20081211093733.c24deb6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081210233654.563182000@menage.corp.google.com>
	 <20081210234432.065445000@menage.corp.google.com>
	 <20081211093733.c24deb6e.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 10 Dec 2008 16:44:51 -0800
Message-ID: <6599ad830812101644l639daab5yab35e299d3badad9@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] CGroups: Add a per-subsystem hierarchy_mutex
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 4:37 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> +static void cgroup_unlock_hierarchy(struct cgroupfs_root *root)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>> +             struct cgroup_subsys *ss = subsys[i];
>> +             if (ss->root == root)
>> +                     mutex_unlock(&ss->hierarchy_mutex);
>> +     }
>> +}
>> +
> Maybe no problem..but I don't like releasing lock in the order of acquiring lock.
>
>        for (i = CGROUP_SUBSYS_COUNT - 1; i >=0; i--)  ?

The order that you release the locks is irrelevant for correctness. In
this case, since the only callers of cgroup_lock_hierarchy() also hold
cgroup_mutex and hence can't race with one another, the order of
locking is irrelevant for correctness too - right now the locking
order is just designed to keep lockdep happy.

I think that the reverse-ordered loop is less readable for no gain.

Paul
