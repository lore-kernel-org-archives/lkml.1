Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYKJWRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYKJWRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYKJWQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:16:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:31095 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKJWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:16:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=Zcz9nEyvUtSwq1XD/BAT8hshWYXkC4yT63WSZ0aFrKcW9Fp61FYkHy5BZjkPR6R5I
	Hx2WCqVeWI5ZB3mfYuHvQ==
Date: Mon, 10 Nov 2008 14:15:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Righi <righi.andrea@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, mrubin@google.com, menage@google.com,
       dave@linux.vnet.ibm.com, chlunde@ping.uio.no, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, agk@sourceware.org,
       m.innocenti@cineca.it, s-uchida@ap.jp.nec.com, ryov@valinux.co.jp,
       matt@bluehost.com, dradford@bluehost.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH -mm] mm: fine-grained dirty_ratio_pcm and dirty_background_ratio_pcm
 (v2)
In-Reply-To: <4918AFA1.4000102@gmail.com>
Message-ID: <alpine.DEB.2.00.0811101410170.2108@chino.kir.corp.google.com>
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com> <20080912131816.e0cfac7a.akpm@linux-foundation.org> <532480950809221641y3471267esff82a14be8056586@mail.gmail.com> <48EB4236.1060100@linux.vnet.ibm.com> <48EB851D.2030300@gmail.com>
 <20081008101642.fcfb9186.kamezawa.hiroyu@jp.fujitsu.com> <48ECB215.4040409@linux.vnet.ibm.com> <48EE236A.90007@gmail.com> <4918A074.1050003@gmail.com> <20081110131255.ce71ce60.akpm@linux-foundation.org> <4918AFA1.4000102@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Andrea Righi wrote:

> The KB limit is a static value, the other depends on the dirtyable
> memory. If we want to preserve the same behaviour we should do the
> following:
> 
> - when dirty_ratio changes to x:
>   dirty_amount_in_bytes = x * dirtyable_memory / 100.
> 
> - when dirty_amount_in_bytes changes to x:
>   dirty_ratio = x / dirtyable_memory * 100
> 

I think the idea is for a dynamic dirty_ratio based on a static value 
dirty_amount_in_bytes:

	dirtyable_memory = determine_dirtyable_memory() * PAGE_SIZE;
	dirty_ratio = dirty_amount_in_bytes / dirtyable_memory;

> But anytime the dirtyable memory changes (as well as the total memory in
> the system) we should update both values accordingly to preserve the
> coherency between them.
> 

Only dirty_ratio is actually updated if dirty_amount_in_bytes is static.

This allows you to control how many pages are NR_FILE_DIRTY or 
NR_UNSTABLE_NFS and gives you the granularity that you want with 
dirty_ratio_pcm, but on a byte scale instead of percent.

It's also a clean interface:

	echo 200M > /proc/sys/vm/dirty_ratio_bytes
