Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZGPEd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZGPEd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZGPEd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:33:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbZGPEd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:33:57 -0400
Date: Wed, 15 Jul 2009 21:33:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       mike.miller@hp.com, jens.axboe@oracle.com
Subject: Re: [PATCH 2/3] cciss: use only one scan thread
Message-Id: <20090715213348.0805073f.akpm@linux-foundation.org>
In-Reply-To: <1247717759.25954.75.camel@grinch>
References: <20090714220239.22282.44414.stgit@bob.kio>
	<20090714220250.22282.69385.stgit@bob.kio>
	<20090715150637.6f171759.akpm@linux-foundation.org>
	<1247717759.25954.75.camel@grinch>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 04:15:59 +0000 Andrew Patterson <andrew.patterson@hp.com> wrote:

> > > +}
> > 
> > We already did init_completion(h->scan_wait) at startup time?  Doing
> > the INIT_COMPLETION() here looks unusual and is hopefully unnecessary.
> > 
> 
> I am following the text in the "Linux Device Drivers 3rd Edition section
> 5.4:
> 
> "A completion is normally a one-shot device; it is used once then
> discarded. It is possible, however, to reuse completion structures if
> proper care is taken. If complete_all is not used, a completion
> structure can be reused without any problems as long as there is no
> ambiguity about what event is being signalled. If you use complete_all,
> however, you must reinitialize the completion structure before reusing
> it. The macro:
> 
> INIT_COMPLETION(struct completion c);
> 
> can be used to quickly perform this reinitialization."
> 
> It there are better way to do this? INIT_COMPLETION() currently just
> sets done = 0.

OK, I'd assumed that a full wait_for_completion()/complete() operation
would leave the completion in ready-to-use-again state.

But wait_for_completion_interruptible() can indeed leave
completion.done in a non-zero state if it was interrupted by a signal.
hm.  Perhaps so the caller can run wait_for_completion*() again.
