Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbXEUU5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbXEUU5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbXEUU47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:56:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58761 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbXEUU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:56:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=grmuTzDLLI1/4abnm3e7aLyMr9CY9lJ4hJOgW34iQJiqjs8fVDHOBrG7b4beMZdX+
	ojLBoN0D4OHQsgxKZPccA==
Message-ID: <6599ad830705211356l9f2d24jc3a7834e7db34458@mail.gmail.com>
Date: Mon, 21 May 2007 13:56:31 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] Per container statistics
Cc: vatsa@in.ibm.com, linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       akpm@linux-foundation.org, devel@openvz.org
In-Reply-To: <20070514174454.15338.67171.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514174454.15338.67171.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

On 5/14/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> This patch implements per container statistics infrastructure and re-uses
> code from the taskstats interface. A new set of container operations are
> registered with commands and attributes. It should be very easy to
> extend per container statistics, by adding members to the containerstats
> structure.

Sorry for the delay in looking at this. (I've been travelling a bit).

The basic idea of being able to get stats on a per-container basis
seems good, but I've got some suggestions on the API/implementation:

- saving a mount pointer in the containerfsroot structure won't work
because a hierarchy (superblock) can be mounted in more than one
place, or even in zero places (if you unmount a hierarchy with active
containers, the superblock and the containers stay active). Also it
might be possible to move a mounted container hierarchy via mount
--move, although I've not actually tried that.

- a cleaner way to pass in a container id would be to pass a file
descriptor on a container directory. The dentry associated with this
fd would unambiguously identify the hierarchy and the container, so
then even if we didn't maintain a per-container task likst, the
for_each_thread() loop would involve just a single comparison per task
to see if the task was in the desired container.

- if we're trying to integrate this with taskstats, then it would be
nice to support retrieving all the other taskstats values (where they
make sense) on a per-container basis (in the same way that we can
currently request them on a per-thread or a per-process basis). i.e.
don't create a new container_taskstats structure, but instead augment
the current taskstats structure, and allow the user to retrieve the
aggregate of that for the entire container. Similarly, being able to
get taskstats notifications based on the container memberships of a
task might be nice.

Paul
