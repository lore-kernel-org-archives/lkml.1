Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXLMOko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXLMOko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbXLMOkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:40:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbXLMOka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:40:30 -0500
Date: Thu, 13 Dec 2007 09:40:09 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NLM: Add lockd reference counting and clean up lockd
 startup and shutdown
Message-ID: <20071213094009.7a7e1923@tleilax.poochiereds.net>
In-Reply-To: <20071208140747.GA11675@infradead.org>
References: <1197118932-4512-1-git-send-email-jlayton@redhat.com>
	<20071208140747.GA11675@infradead.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 14:07:47 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> > +	mutex_lock(&nlmsvc_mutex);
> > +	while (atomic_read(&nlmsvc_ref) != 0) {
> 
> might be better to do the refcounting outside the thread and use the
> kthread api, which is something we still need to do for lockd anyway.
> 

I took a swipe at doing this, and have a set of patches that make lockd
use kthreads. It works well, but there's a problem once I add in the
reference counting.

In the situation that prompted this whole thing, the last nlmsvc_ref
gets put by lockd itself. A kthread can't call kthread_stop on itself
since it will deadlock.

Is there a way to gracefully allow a kthread to shut itself down?
Alternately, I suppose I could schedule_work() the kthread_stop, though
that seems sort of ugly...

-- 
Jeff Layton <jlayton@redhat.com>
