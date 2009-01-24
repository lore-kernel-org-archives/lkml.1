Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbZAXBzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbZAXBzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 20:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZAXBz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 20:55:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:4870 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbZAXBzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 20:55:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=EbLcjeBjdZkueqcdxKl4xMUKOM1IAnyN1dK2E9o4Psjw5/gfq4hjpAKNFDbNfJONY
	VBcrMkJmFBXITNjxfoi/g==
Date: Fri, 23 Jan 2009 17:55:14 -0800
From: Mandeep Singh Baines <msb@google.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v3] softlockup: remove hung_task_check_count
Message-ID: <20090124015513.GA31189@google.com>
References: <20090122083457.GC7438@elte.hu> <20090122195513.GA22146@google.com> <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com> <20090123092306.GB29820@elte.hu> <c62985530901230204i3880c3f8xbebdb6844f35addf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901230204i3880c3f8xbebdb6844f35addf@mail.gmail.com>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.85
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> 2009/1/23 Ingo Molnar <mingo@elte.hu>:
> >
> > not sure i like the whole idea of removing the max iterations check. In
> > theory if there's a _ton_ of tasks, we could spend a lot of time looping
> > there. So it always looked prudent to limit it somewhat.
> >
> 
> Which means we can loose several of them. Would it hurt to iterate as
> much as possible along the task list,
> keeping some care about writers starvation and latency?
> BTW I thought about the slow work framework, but I can't retrieve
> it....  But this thread has already a slow priority.
> 
> Would it be interesting to provide a way for rwlocks to know if there
> is writer waiting for the lock?

Would be cool if that API existed. You could release the CPU and/or lock as
soon as either was contended for. You'd have the benefits of fine-grained
locking without the overhead of locking and unlocking multiple time.

Currently, there is no bit that can tell you there is a writer waiting. You'd
probably need to change the write_lock() implementation at a minimum. Maybe
if the first writer left the RW_LOCK_BIAS bit clear and then waited for the
readers to leave instead of re-trying? That would actually make write_lock()
more efficient for the 1-writer case since you'd only need to spin doing
a read in the failure case instead of an atomic_dec and atomic_inc.

