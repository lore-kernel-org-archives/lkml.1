Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbYCEVJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbYCEVJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYCEVJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:09:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:20990 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYCEVJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:09:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=s9fpU9hZ68ce0QCiv5IQUSnEXxKK56J5YP1icSEASVgdwA/jUkFndWyNxz5QW1k6l
	zMmPcvmsZGTEG/Hq+0SYA==
Message-ID: <6599ad830803051309g22d5b746ta30c4f28a394572c@mail.gmail.com>
Date: Wed, 5 Mar 2008 13:09:13 -0800
From: "Paul Menage" <menage@google.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [BUG?] 2.6.25-rc[23]-mm1 cgroup list corruption under load with VM Scalability patches
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <1204745828.6244.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204745828.6244.31.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 11:37 AM, Lee Schermerhorn
<Lee.Schermerhorn@hp.com> wrote:
> list_del corruption in cgroup_exit() on 16 cpu, 32GB ia64 NUMA platform.
>
>  I've been seeing this for a while now, but we've had known problems
>  [page leaks, ...] with the VM scalability series.  Now the system
>  appears to be running very well with these patches under stress loads
>  that would hang it or cause OOM kill of tests with plenty of swap space
>  left.  Eventually, [after 40-45 minutes], I hit a list corruption in
>  cgroup_exit().
>
>  I can't say for sure that our patches aren't causing this, but I've been
>  unable to keep the system up long enough under the stress load w/o the
>  splitlru+noreclaim patches to hit the problem.
>
>  I looked in the mailing lists and found one other thread related to
>  cgroup list corruption:
>
>         http://marc.info/?l=linux-kernel&m=119263666823236&w=4
>
>  Paul looked into this and couldn't see anywhere that the lists are
>  manipulate w/o holding the css set lock.  I concur.  I did find one
>  possible race in enabling the task cg_lists [see patch below], but this
>  did not solve the problem.  And I did not hit the printk in the patch.

No, that's not a (malign) race - cgroup_enable_task_cg_lists() is
idempotent. In the case that you see, every thread seen in the
do_each_thread() loop will already have a non-empty cg_list field, so
it will be a no-op. So adding the additional check isn't wrong but
it's not needed.

I'll look again at the code to try to figure out where the problem is.

Paul
