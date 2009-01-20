Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZATB3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZATB3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbZATB2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:28:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1609 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZATB2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:28:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=yx2Ok7a4ZQDGztS9jqxmy3iamwZljEXfGcYWLsW8ZQaJR9gLg+LikYSt6KFQM+0Vu
	xfheS55Mno68oQM8uCpKw==
MIME-Version: 1.0
In-Reply-To: <20090119014143.GA10271@elte.hu>
References: <496FEFCA.9050908@cn.fujitsu.com> <4970000E.7040902@cn.fujitsu.com>
	 <20090116125738.22c21bf2.akpm@linux-foundation.org>
	 <4972E2FD.1010902@cn.fujitsu.com> <20090118091038.GC27144@elte.hu>
	 <6599ad830901181737m1d04bb85t7bb0b48e925733a6@mail.gmail.com>
	 <20090119014143.GA10271@elte.hu>
Date: Mon, 19 Jan 2009 17:28:48 -0800
Message-ID: <6599ad830901191728k102f586ar1f252b8604226d95@mail.gmail.com>
Subject: Re: [PATCH 1/3] cgroup: convert open-coded mutex_lock(&cgroup_mutex) 
	calls into cgroup_lock() calls
From: Paul Menage <menage@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, miaox@cn.fujitsu.com,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.81
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 5:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Paul Menage <menage@google.com> wrote:
>
>> On Sun, Jan 18, 2009 at 1:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> > this just changes over a clean mutex call to a wrapped lock/unlock
>> > sequence that has higher overhead in the common case.
>> >
>> > We should do the exact opposite, we should change this opaque API:
>> >
>> >  void cgroup_lock(void)
>> >  {
>> >         mutex_lock(&cgroup_mutex);
>> >  }
>> >
>> > To something more explicit (and more maintainable) like:
>>
>> I disagree - cgroup_mutex is a very coarse lock that can be held for
>> pretty long periods of time by the cgroups framework, and should never
>> be part of any fastpath code. So the overhead of a function call should
>> be irrelevant.
>>
>> The change that you're proposing would send the message that
>> cgroup_mutex_lock(&cgroup_mutex) is appropriate to use in a
>> performance-sensitive function, when in fact we want to discourage such
>> code from taking this lock and instead use more appropriately
>> fine-grained locks.
>
> Uhm, how does that 'discourage' its use in fastpath code?

I agree, the existing code doesn't exactly discourage its use in
fastpath code, but we should be doing so. (The recent addition of
hierarchy_mutex is a step in that direction, although it still has
some issues to be cleaned up). But it seems to me that exposing the
lock is an invitation for people to use it even more than they do
currently. There's certainly no performance argument for exposing it,

>
> It just hides the real lock

Yes, I'd rather hide the real lock in this case.

Paul
