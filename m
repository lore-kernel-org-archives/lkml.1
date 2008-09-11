Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYIKTz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYIKTz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYIKTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:55:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24183 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYIKTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:55:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Bir/onpQjUx5lGLGCV6r0XLVUq2eZa5P1d6HoJHD5fwYFWLya/CBEFgTw7a+TTuW9
	SCGyjpT7vPLzwDkkvr91A==
Message-ID: <6599ad830809111254h62e1945egd72b30f2c8585104@mail.gmail.com>
Date: Thu, 11 Sep 2008 12:54:53 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH -mm] cgroup,cpuset: use alternative malloc to allocate large memory buf for tasks
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <6599ad830809110945pb85ec68o16328b31cbb0dc52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C8F32E.2020004@cn.fujitsu.com>
	 <6599ad830809110945pb85ec68o16328b31cbb0dc52@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 9:45 AM, Paul Menage <menage@google.com> wrote:
> On Thu, Sep 11, 2008 at 3:30 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> This new alternative allocation implementation can allocate memory
>> up to 64M in 32bits system or 512M in 64bits system.
>
> Isn't a lot of this patch just reimplementing vmalloc()?

To extend on this, I think there are two ways of fixing the large
allocation problem:

1) just use vmalloc() rather than kmalloc() when the pid array is over
a certain threshold (probably 1 page?)

2) allocate pages/chunks in a similar way to your CL, but don't bother
mapping them. Instead we'd use the fact that each record (pid) is the
same size, and hence we can very easily use the high bits of an index
to select the chunk and the low bits to select the pid within the
chunk - no need to suffer the overhead of setting up and tearing down
ptes in order for the MMU do the same operation for us in hardware.

Obviously option 1 is a lot simpler, but option 2 avoids a
vmap()/vunmap() on every open/close of a tasks file. I'm not familiar
enough with the performance of vmap/vunmap on typical
hardware/workloads to know how high this overhead is  - maybe a VM
guru can comment?

Paul
