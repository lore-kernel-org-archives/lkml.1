Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYC0SpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYC0SpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYC0SpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:45:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52718 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbYC0SpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:45:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Kdl4x9Xvd/NIDJeJ0kZAy9+UxQqsDCERktrDm4J4VNkXgHIdpKWTtSjgdCEfZiqdN
	PIv2eMYCFJ30PjrVEg9/Q==
Message-ID: <6599ad830803271144k635da1d8y106710152bb9c3be@mail.gmail.com>
Date: Thu, 27 Mar 2008 11:44:52 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][0/3] Virtual address space control for cgroups (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EBDE7B.4090002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>
	 <6599ad830803261522p45a9daddi8100a0635c21cf7d@mail.gmail.com>
	 <47EB5528.8070800@linux.vnet.ibm.com>
	 <6599ad830803270728y354b567s7bfe8cb7472aa065@mail.gmail.com>
	 <47EBDE7B.4090002@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:50 AM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
>  >
>  > I was thinking more about that, and I think I found a possibly fatal flaw:
>  >
>
>  What is the critical flaw?
>

Oops, after I'd written that I decided while describing it that maybe
it wasn't that fatal after all, just fiddly, and so deleted the
description but forgot to delete the preceding sentence. :-)

There were a couple of issues. The first was that if the new owner is
in a different cgroup, we might have to fix up the address space
charges when we pass off the ownership, which would be a bit of a
layer violation but maybe manageable.

The other was to do with ensuring that mm->owner remains valid until
after exit_mmap() has been called (so the va limit controller can
deduct from the va usage).
>
>  Yes, I've seen some patches there as well. As far as sparse virtual addresses
>  are concerned, I find it hard to understand why applications would use sparse
>  physical memory and large virtual addresses. Please see my comment on overcommit
>  below.

Java (or at least, Sun's JRE) is an example of a common application
that does this. It creates a huge heap mapping at startup, and faults
it in as necessary.

>  > But the problem that I have with this is that mmap() is only very
>  > loosely connected with physical memory. If we're trying to help
>  > applications avoid swapping, and giving them advance warning that
>  > they're running out of physical memory, then we should do exactly
>  > that, not try to treat address space as a proxy for physical memory.
>
>  Consider why we have the overcommit feature in the Linux kernel. Virtual memory
>  limits (decided by the administrator) help us prevent from excessively over
>  committing the system.

Well if I don't believe in per-container virtual address space limits,
I'm unlikely to be a big fan of system-wide virtual address space
limits either. So running with vm.overcommit_memory=2 is right out ...

I'm certainly not disputing that it's possible to avoid excessive
overcommit by using virtual address space limits.

It's just for that both of the real-world large-scale production
systems I've worked with (a virtual server system for ISPs, and
Google's production datacenters) there were enough cases of apps/jobs
that used far more virtual address space than actual physical memory
that picking a virtual address space ratio/limit that would be useful
for preventing dangerous overcommit while not breaking lots of apps
would be pretty much impossible to do automatically. And specifying
them manually requires either unusually clueful users (most of whom
have enough trouble figuring out how much physical memory they'll
need, and would just set very high virtual address space limits) or
sysadmins with way too much time on their hands ...

As I said, I think focussing on ways to tell apps that they're running
low on physical memory would be much more productive.

Paul
