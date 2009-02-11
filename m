Return-Path: <linux-kernel-owner+w=401wt.eu-S1757675AbZBKABe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbZBKABe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZBKABL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:01:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:5205 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbZBKABK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:01:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=MN4cEsdlaXOFA/8wWz5UjlxNoBkIhpvTyFEuX61LUPtUvDiaxGyPAH09nGq5rY+Ob
	7ZCIsuxqawnfMUjq/sh0A==
MIME-Version: 1.0
In-Reply-To: <20090210124527.GA28946@ZenIV.linux.org.uk>
References: <4991497B.4030200@cn.fujitsu.com>
	 <6599ad830902100215o185edd31k8731e033717dbb49@mail.gmail.com>
	 <20090210124527.GA28946@ZenIV.linux.org.uk>
Date: Tue, 10 Feb 2009 16:01:07 -0800
Message-ID: <6599ad830902101601i294ffaa5xd01611c5121a5685@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix possible use after free
From: Paul Menage <menage@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 4:45 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Feb 10, 2009 at 02:15:36AM -0800, Paul Menage wrote:
>> On Tue, Feb 10, 2009 at 1:31 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> > In cgroup_kill_sb(), root is freed before sb is detached from the list,
>> > so another sget() may find this sb and call cgroup_test_super(),
>> > which will access the root that has been freed.
>>
>> I think that I'd assumed that by the time we get to cgroup_kill_sb()
>> there's no chance of the sb being resurrected by sget().
>
> There is none.  grab_super() will fail to get it, so sget() will go
> through retry logics.  Which doesn't mean that test won't be called
> on it in the meanwhile.

OK, so Zefan's patch looks like the safest way to fix this particular
issue. I think I see some other potential races with
cgroup_test_super() though - we probably need to synchronize against
the changing of a root's subsys_bits in rebind_subsystems(). Taking
cgroup_mutex around the call to sget() would certainly provide that,
but I'd have to check whether it causes locking cycles.

Paul
