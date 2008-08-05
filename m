Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYHEGDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYHEGDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbYHEFzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 01:55:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44876 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbYHEFzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 01:55:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=e5Bl3VziKU3W+sdTLx3l2Z99EDRbGFbJCjaoQNGMe5SJwhQsxU8T3rm7VCEFUqPGR
	aVADyA6wcmBbuwZMv/7wQ==
Message-ID: <6599ad830808042255y59215481l5463d4dca9fb2001@mail.gmail.com>
Date: Mon, 4 Aug 2008 22:55:31 -0700
From: "Paul Menage" <menage@google.com>
To: righi.andrea@gmail.com
Subject: Re: Too many I/O controller patches
Cc: "Dave Hansen" <dave@linux.vnet.ibm.com>, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org
In-Reply-To: <48976A2A.9060600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
	 <1217876521.20260.123.camel@nimitz> <48976A2A.9060600@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 1:44 PM, Andrea Righi <righi.andrea@gmail.com> wrote:
>
> A safer approach IMHO is to force the tasks to wait synchronously on
> each operation that directly or indirectly generates i/o.
>
> In particular the solution used by the io-throttle controller to limit
> the dirty-ratio in memory is to impose a sleep via
> schedule_timeout_killable() in balance_dirty_pages() when a generic
> process exceeds the limits defined for the belonging cgroup.
>
> Limiting read operations is a lot more easy, because they're always
> synchronized with i/o requests.

I think that you're conflating two issues:

- controlling how much dirty memory a cgroup can have at any given
time (since dirty memory is much harder/slower to reclaim than clean
memory)

- controlling how much effect a cgroup can have on a given I/O device.

By controlling the rate at which a task can generate dirty pages,
you're not really limiting either of these. I think you'd have to set
your I/O limits artificially low to prevent a case of a process
writing a large data file and then doing fsync() on it, which would
then hit the disk with the entire file at once, and blow away any QoS
guarantees for other groups.

As Dave suggested, I think it would make more sense to have your
page-dirtying throttle points hook into the memory controller instead,
and allow the memory controller to track/limit dirty pages for a
cgroup, and potentially do throttling as part of that.

Paul
