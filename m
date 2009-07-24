Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZGXV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZGXV5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZGXV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:57:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZGXV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:57:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=JHvA/1RTeVm9imbtLu1dX/ZZJwWn5ewyvQjpDx0ULmiYraRgqopvSLPfNwNjK6xm9
	1uQi7i2ApadrN+rudGf3w==
MIME-Version: 1.0
In-Reply-To: <2f86c2480907241452m74c50975k522c5a43a62e8459@mail.gmail.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
	 <20090724100220.GF11101@hawkmoon.kerlabs.com>
	 <2f86c2480907241452m74c50975k522c5a43a62e8459@mail.gmail.com>
Date: Fri, 24 Jul 2009 14:57:36 -0700
Message-ID: <6599ad830907241457x3d1380b6ne613eb5921d6c5a0@mail.gmail.com>
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Benjamin Blum <bblum@google.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 2:52 PM, Benjamin Blum<bblum@google.com> wrote:
>> I don't see how css_sets are guaranteed while cgroup_fork_mutex is not held and
>> thus does not prevent new threads from being created right now. Could you
>> elaborate on that?
>
> Prefetching the css sets is independent of the fork lock/race issue.
> The idea is that we build a list, kept locally, that has references on
> all the css_sets we'll need to migrate each thread to the new cgroup.
> Since ordinarily we might need to malloc a new css_set for a thread
> before moving it, and it's possible that that could fail, we need to
> do allocations for all threads to be moved before committing any of
> them. As long as we have the list of prefetched css_sets, they'll stay
> there, and at the end, we drop the extra references we took on them to
> make that guarantee when tearing down the list.

And more specifically, since only the holder of cgroup_mutex can move
a thread to a new cgroup (and hence a potentially new unique css_set),
we know that once we've run through all the threads in the
thread_group and verified that we have the appropriate pre-fetched
css_set objects for all of them, it doesn't matter if any new threads
are created - they'll share one of the pre-fetched css_sets.

Paul
