Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbYAJTLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbYAJTLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760718AbYAJTK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:10:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58783 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760708AbYAJTK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:10:58 -0500
Subject: Re: [RFC][PATCH 3/4] change mnt_writers[] spinlock to mutex
From: Dave Hansen <haveblue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, serue@us.ibm.com
In-Reply-To: <20080110190701.FF57BF50@kernel>
References: <20080110190657.92A8B61F@kernel>
	 <20080110190701.FF57BF50@kernel>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 11:10:49 -0800
Message-Id: <1199992249.25690.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed the description on that one.  Here it is:

We're shortly going to need to be able to block new
mnt_writers for long periods of time during a
superblock remount operation.  Since this operation
can sleep, we can not use a spinlock.  We opt for
a mutex instead.

This are very, very rarely contented, mostly because
they are per-cpu.  So, this should be very close to
as fast as the spinlocks just with the added benefit
that we can sleep while holding them.

We also need to change the get_cpu_var() to use
__get_cpu_var() so that we don't disable preemption.
Otherwise, we'll be in_atomic() when we try to lock
the (sleepable) mutex.  We only use the per-cpu data
for cache benefits and its per-cpuness is not part
of locking logic, so this is OK.
_
-- Dave

