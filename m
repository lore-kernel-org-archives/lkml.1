Return-Path: <linux-kernel-owner+w=401wt.eu-S1762042AbYB1WGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbYB1WGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758996AbYB1WGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:06:46 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbYB1WGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:06:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DBIhs+SWJvCq5exY8FCDPfHxM4aTDNEYI/Qde0kev7YyEcBEp9F3JIGeDLaK6ssfl
	r2IlXPVT8CiqzRD6DmvfQ==
Message-ID: <6599ad830802281406t38e486d8g267df1873bc754c2@mail.gmail.com>
Date: Thu, 28 Feb 2008 14:06:30 -0800
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, xemul@openvz.org,
       pj@sgi.com
In-Reply-To: <20080228134027.05b2aa87.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	 <20080228132142.4d4b1eef.akpm@linux-foundation.org>
	 <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
	 <20080228134027.05b2aa87.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 1:40 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  Maybe cgroups shouldn't be putting kernel-generated files in places where
>  user-specified files appear?
>

Well, that API (mixing control files and group directories in the same
directory namespace) was inherited directly from cpusets.

It wouldn't be hard to throw that away and move all the user-created
group directories into their own subdirectory, i.e. change the
existing directory layout from something like:

/mnt/cgroup/
    tasks
    cpu.shares
    memory.limit_in_bytes
    memory.usage_in_bytes
    user_created_groupname1/
        tasks
        cpu.shares
        memory.limit_in_bytes
        memory.usage_in_bytes
    user_created_groupname2/
        tasks
        cpu.shares
        memory.limit_in_bytes
        memory.usage_in_bytes

to something like:

/mnt/cgroup/
    tasks
    cpu.shares
    memory.limit_in_bytes
    memory.usage_in_bytes
    groups/
        user_created_groupname1/
            tasks
            cpu.shares
            memory.limit_in_bytes
            memory.usage_in_bytes
            groups/
        user_created_groupname2/
            tasks
            cpu.shares
            memory.limit_in_bytes
            memory.usage_in_bytes
            groups/

That would completely solve the namespace problem, at the cost of a
little extra verbosity/inelegance for human users (I suspect
programmatic users would prefer it), and lack of compatibility with
2.6.24. I'd also need to make the existing model a mount option so
that we could keep compatibility with the cpusets filesystem API.

>  (Am still thrashing around a bit here without an overview of the overall
>  layout and naming).

Pretty much the same as cpusets, other than the additional
kernel-generated files in each directory, as provided by the resource
subsystems. So the same potential problem faced cpusets, but the fact
that new cpuset features weren't being developed quickly meant the
problem was less likely to actually bite people.

Paul
