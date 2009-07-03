Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZGCAoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZGCAoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZGCAnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:43:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZGCAnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:43:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ZZVzEiANzWITtefpuTwLuSrUAMyE3db7ikVu0eFyfEIy27u/iaK7AqylTRBWhDoQI
	kEplmxbuASfB6XsbWOe2Q==
MIME-Version: 1.0
In-Reply-To: <20090702165413.f4a21471.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232625.3969.54444.stgit@menage.mtv.corp.google.com>
	 <20090702165413.f4a21471.akpm@linux-foundation.org>
Date: Thu, 2 Jul 2009 17:43:52 -0700
Message-ID: <2f86c2480907021743k5c1aeafeq234da81bb5c9676d@mail.gmail.com>
Subject: Re: [PATCH 2/2] Ensures correct concurrent opening/reading of 
	pidlists across pid namespaces
From: Benjamin Blum <bblum@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 4:54 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> +static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
>> +                                               enum cgroup_filetype type)
>> +{
>> +     struct cgroup_pidlist *l;
>> +     /* don't need task_nsproxy() if we're looking at ourself */
>> +     struct pid_namespace *ns = get_pid_ns(current->nsproxy->pid_ns);
>> +     mutex_lock(&cgrp->pidlist_mutex);
>> +     list_for_each_entry(l, &cgrp->pidlists, links) {
>> +             if (l->key.type == type && l->key.ns == ns) {
>> +                     /* found a matching list - drop the extra refcount */
>> +                     put_pid_ns(ns);
>> +                     /* make sure l doesn't vanish out from under us */
>
> This looks fishy.
>
>> +                     down_write(&l->mutex);
>> +                     mutex_unlock(&cgrp->pidlist_mutex);
>> +                     l->use_count++;
>> +                     return l;
>
> The caller of cgroup_pidlist_find() must ensure that l->use_count > 0,
> otherwise cgroup_pidlist_find() cannot safely use `l' - it could be
> freed at any time.  But if l->use_count > 0, there is no risk of `l'
> "vanishing out from under us".
>
> I'm probably wrong there, but that's the usual pattern and this code
> looks like it's doing something different.  Please check?
>

That comment is vague, and should be rewritten. Individual pidlist
locks depend on the cgroup->pidlist_mutex; the main idea here is that
we can't drop the pidlist_mutex before picking up l->lock in case
somebody's trying to remove it from the list at the same time (compare
with cgroup_release_pid_array, the destroyer). The pid_namespace
refcount is also safe, because having found the existing list means
whoever put it there has a reference on the namespace in l->key, which
hasn't gone away yet and also is protected by the
cgroup->pidlist_mutex.

The only ordering that's important here is that incrementing
l->use_count and dropping cgroup->pidlist_mutex both have to come
after taking l->mutex.
