Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYFXXar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYFXXar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYFXXak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:30:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYFXXaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:30:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HIQWlMeaQY1R4tXcATI2kRnI0RD3CA0x2gXihUqsBSWkMQJkIK/bPrGNhZIJzETd2
	HmDM+ytE9F3rOqzhD/Huw==
Message-ID: <6599ad830806241630k33516715x7440e14ed6026fed@mail.gmail.com>
Date: Tue, 24 Jun 2008 16:30:35 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/8] CGroup Files: Move the release_agent file to use typed handlers
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <20080624162325.005c87e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620234358.182933000@menage.corp.google.com>
	 <20080621000730.255258000@menage.corp.google.com>
	 <20080624162325.005c87e0.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 4:23 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> +/**
>> + * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
>> + * @cgrp: the cgroup to be checked for liveness
>> + *
>> + * Returns true (with lock held) on success, or false (with no lock
>> + * held) on failure.
>> + */
>> +int cgroup_lock_live_group(struct cgroup *cgrp)
>> +{
>> +     mutex_lock(&cgroup_mutex);
>> +     if (cgroup_is_removed(cgrp)) {
>> +             mutex_unlock(&cgroup_mutex);
>> +             return false;
>> +     }
>> +     return true;
>> +}
>
> I think that if we're going to do this it would be nice to add a
> symmetrical cgroup_unlock_live_group()?

There's already a cgroup_unlock() function exported in cgroup.h -
that's the counterpart to both cgroup_lock() and
cgroup_lock_live_group(). I can add a comment about this in the docs
for cgroup_lock_live_cgroup().


>
> Because code like this:
>
>> +     if (!cgroup_lock_live_group(cgrp))
>> +             return -ENODEV;
>> +     strcpy(cgrp->root->release_agent_path, buffer);
>> +     mutex_unlock(&cgroup_mutex);
>
> is a bit WTFish, no?  it forces each caller of cgroup_lock_live_group()
> to know about cgroup_lock_live_group() internals.

cgroup_mutex isn't directly exported outside of cgroup.c, so real
callers would have no choice but to use cgroup_unlock() in this
instance. I guess it could make sense to be consistent and use
cgroup_unlock() within cgroup.c as well.

Paul
