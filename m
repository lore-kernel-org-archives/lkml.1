Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZGNGtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZGNGtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 02:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZGNGtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 02:49:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZGNGtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 02:49:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gLXWr65klG8rLIq9IujFEvYLHdZVS4/8l3aJ3MzZwfmzM7ugZMbtiHivbKmVycyIw
	QEu6oatbR/U4IIZpoQHZQ==
MIME-Version: 1.0
In-Reply-To: <20090714055638.GI5051@balbir.in.ibm.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090705063850.GX11273@balbir.in.ibm.com>
	 <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com>
	 <20090713121138.GC5051@balbir.in.ibm.com>
	 <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com>
	 <20090714055638.GI5051@balbir.in.ibm.com>
Date: Mon, 13 Jul 2009 23:49:16 -0700
Message-ID: <6599ad830907132349u6cf52060t4fafb6637cbe4ed1@mail.gmail.com>
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com
Cc: lizf@cn.fujitzu.com, bblum@google.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 10:56 PM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
>>
>> Waiting for the next scheduling point might be too long, since a
>> thread can block for arbitrary amounts of time and keeping the marker
>> around for arbitrary time (unless we add a new task_struct field)
>> would be tricky. Marking the cgroup or tgid as being migrated which
>> then triggers the extra synchronization in the fork path (but which
>> isn't needed at other times) is probably where we'll end up.
>
>
> Hmm... but we would not need that information till we schedule the
> tasks, adding a field to task_struct is what I had in mind.

Waiting until schedule to move the threads would result in them still
showing up in the old "tasks" file until they next ran, which would be
confusing and misleading.

As a first cut, we were planning to add an rwsem that gets taken for
read in cgroup_fork(), released in cgroup_post_fork(), and taken for
write when moving an entire process to a new cgroup; not ideal
performance-wise, but safe.

If adding a field to task_struct is an option, then the rwsem could be
per thread-group leader, which would reduce contention.

Paul
