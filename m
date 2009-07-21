Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZGUU26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZGUU26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZGUU25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:28:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15888 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbZGUU24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:28:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=oXElgaWjY5sObQJfasOfLSFX9RlOieTB/5ctqkyo/JYOf/bATS1wBfvAmrhEc7yiv
	0epTmw3K/P2CWjnu6agJg==
MIME-Version: 1.0
In-Reply-To: <20090721160333.96AA4D3D@kernel>
References: <20090721160333.96AA4D3D@kernel>
Date: Tue, 21 Jul 2009 13:28:50 -0700
Message-ID: <6599ad830907211328w4ada3afboa8fcecfed980ffd0@mail.gmail.com>
Subject: Re: [RFC][PATCH] flexible array implementation
From: Paul Menage <menage@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 9:03 AM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
>
> Once a structure goes over PAGE_SIZE*2, we see occasional
> allocation failures.  Some people have chosen to switch
> over to things like vmalloc() that will let them keep
> array-like access to such a large structures.  But,
> vmalloc() has plenty of downsides.
>
> Here's an alternative.  I think it's what Andrew was
> suggesting  here:
>
>        http://lkml.org/lkml/2009/7/2/518

Looks like a useful library abstraction.

As far as using it for the cgroups tasks files, it would be possible,
although I was leaning towards an approach that I expressed in the
thread on Ben's patch to add the "procs" file:

- make css_set and its various linked lists RCU-safe
- make it possible for the cgroup iterator to pause/resume scanning by
leaving a cursor at the relevant point in the css_set lists.

Then we can avoid any memory allocations at all.

The downside is that we lose the current sorted output for the tasks
file; http://www.google.com/codesearch?q=cpuset+tasks suggests that
current users of the tasks file don't expect it to be sorted (and in
fact libcpuset explicitly sorts it after reading) so it's not clear if
this would be a problem. I don't think I can see a plausible scenario
where userspace would be relying on sorted output, but maybe others
can.

Paul
