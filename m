Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbZAWScY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbZAWScY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZAWScQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:32:16 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbZAWScP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:32:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=cqmrc0akOpBo5B/kUl6XsCTNMrpixdkJoeB41z/XK2UIqoOGyVCoyzr7+0FQ/+W8d
	6mMKXDYuUttpageAAaFsg==
MIME-Version: 1.0
In-Reply-To: <20090123181056.GA31142@elte.hu>
References: <20090123004703.25103.29754.stgit@menage.corp.google.com>
	 <20090123181056.GA31142@elte.hu>
Date: Fri, 23 Jan 2009 10:32:09 -0800
Message-ID: <6599ad830901231032h76a301ceica371145eca30388@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Fix root_count when mount fails due to busy 
	subsystem
From: Paul Menage <menage@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.147
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 10:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paul Menage <menage@google.com> wrote:
>
>> cgroup: Fix root_count when mount fails due to busy subsystem
>>
>> root_count was being incremented in cgroup_get_sb() after all error
>> checking was complete, but decremented in cgroup_kill_sb(), which can be
>> called on a superblock that we gave up on due to an error.  This patch
>> changes cgroup_kill_sb() to only decrement root_count if the root was
>> previously linked into the list of roots.
>
> i'm wondering, what happens in the buggy case: does cgroup_kill_sb() get
> called twice (if yes, why?),

No.

> or do we call cgroup_kill_sb() on a not yet
> added sb and hence root_count has not been elevated yet?

Right.

> (if yes, which
> codepath does this?)

It's via the call to deactivate_super().

The code could be restructured such that:

- we don't set sb->s_fs_info until we've linked the new root into the root_list
- do any necessary cleanup for a failed root in cgroup_get_sb()
- have cgroup_kill_sb() handle either no root or a fully-initialized root

But then you're replacing "only decrement root_count if root was
linked in to list" with "only do root cleanup if root was atached to
sb" in cgroup_kill_sb(). I don't see that one is much cleaner than the
other.

For 2.6.29, we should fix this by reverting the broken part of the
patch that made it into 2.6.29-rcX

Paul
