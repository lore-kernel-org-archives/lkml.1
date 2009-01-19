Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZASBhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZASBhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbZASBh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:37:29 -0500
Received: from smtp-out.google.com ([216.239.33.17]:33080 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbZASBh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:37:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=cDRUyzKKs9ma2Ux6jPzq2qaqeWXB5mhMpUZRvI4VHDEXETGx9MVE5WDQvOnFXAcgJ
	4YUmlPJnv99//Y00bBP/g==
MIME-Version: 1.0
In-Reply-To: <20090118091038.GC27144@elte.hu>
References: <496FEFCA.9050908@cn.fujitsu.com> <4970000E.7040902@cn.fujitsu.com>
	 <20090116125738.22c21bf2.akpm@linux-foundation.org>
	 <4972E2FD.1010902@cn.fujitsu.com> <20090118091038.GC27144@elte.hu>
Date: Sun, 18 Jan 2009 17:37:21 -0800
Message-ID: <6599ad830901181737m1d04bb85t7bb0b48e925733a6@mail.gmail.com>
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
X-GMailtapped-By: 172.24.198.65
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 1:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
> this just changes over a clean mutex call to a wrapped lock/unlock
> sequence that has higher overhead in the common case.
>
> We should do the exact opposite, we should change this opaque API:
>
>  void cgroup_lock(void)
>  {
>         mutex_lock(&cgroup_mutex);
>  }
>
> To something more explicit (and more maintainable) like:

I disagree - cgroup_mutex is a very coarse lock that can be held for
pretty long periods of time by the cgroups framework, and should never
be part of any fastpath code. So the overhead of a function call
should be irrelevant.

The change that you're proposing would send the message that
cgroup_mutex_lock(&cgroup_mutex) is appropriate to use in a
performance-sensitive function, when in fact we want to discourage
such code from taking this lock and instead use more appropriately
fine-grained locks.

Paul
