Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYJOLww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYJOLww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYJOLwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:52:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:46856 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYJOLwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:52:42 -0400
Date: Wed, 15 Oct 2008 07:52:46 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
 mechanism
Message-ID: <20081015075246.2e1610f3@infradead.org>
In-Reply-To: <20081015014117.faff3a61.akpm@linux-foundation.org>
References: <20081012194427.2e21c22e@infradead.org>
	<20081015014117.faff3a61.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 01:41:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:
> > +static int async_active = 0;
> 
> ?
ok will add comment

> 
> Please talk to Evgeniy about his new thread_pool stuff which I've
> suggested become a generic library.
> 
> (looks at changelog, doesn't really understand the need for the
> thread pool thing, doesn't understand the comment about device
> numbers)

it's very simple. Take the case of doing each sata port probe as an
asynchronous item. In order to keep a stable device naming/ordering,
all the sata probes need to be done in sequence, but, say, the USB
probing can be done in parallel. This means that we need to assign the
various async tasks to specific pools (based on which device number
space they will put devices in) and can't just arbitrarily spawn them
to arbitrary threads.

> 
> > +
> > +void call_async(int pool_number, int argc, ...)
> 
> This looks like schedule_work().  Why cannot that be used (perhaps
> after suitable modification)?

as I said in the comments... the object lifetimes don't work.
We need to be able to schedule one per sata port (as per Linus'
suggest) which means we need a new work struct per function call. And
then we need something that garbage collects these, now dynamically
allocated, work structs. Which work queues just don't do. If you make
them do that... you end up with the code I wrote.

> 
> 
> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
