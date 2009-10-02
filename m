Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZJBMEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZJBMEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZJBMEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:04:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:45185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbZJBMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:04:14 -0400
Message-ID: <4AC5EBFF.70404@kernel.org>
Date: Fri, 02 Oct 2009 21:03:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
References: <1254384558-1018-20-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org> <10231.1254402926@redhat.com>
In-Reply-To: <10231.1254402926@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 12:03:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
>> gcwq always keeps at least single idle worker around.  When a new
>> worker is necessary and the worker is the last idle one, the worker
>> assumes the role of "manager" and manages the worker pool -
>> ie. creates another worker.  Forward-progress is guaranteed by having
>> dedicated rescue workers for workqueues which may be necessary while
>> creating a new worker.  When the manager is having problem creating a
>> new worker, mayday timer activates and rescue workers are summoned to
>> the cpu and execute works which may be necessary to create new
>> workers.
> 
> I take it that means that the rescue-workers are donated to the pool
> to become worker threads (perhaps on a temporary basis) in the event
> that forking fails due to ENOMEM, such that resources can be freed
> up for fork() to use.

Yes, when kthread_create() doesn't return fast enough
(MAYDAY_INITIAL_TIMEOUT, currently 10ms), rescue workers are summoned
to the cpu.  They scan the pending works and process only the works
which are for the workqueue the rescuer is bound to which should solve
the possible allocation deadlock.  Currently, all workqueues are
created with a rescuer by default but that will be changed as most of
them don't need it.

Thanks.

-- 
tejun
