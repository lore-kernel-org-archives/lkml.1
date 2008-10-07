Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbYJGBkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbYJGBkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYJGBkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:40:03 -0400
Received: from ozlabs.org ([203.10.76.45]:46245 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbYJGBkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:40:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to stop_machine infrastructrue.
Date: Tue, 7 Oct 2008 11:39:58 +1000
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
References: <20081003105632.357231142@de.ibm.com> <200810061542.41224.rusty@rustcorp.com.au> <20081006201650.GA4708@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081006201650.GA4708@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810071239.58732.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2008 07:16:50 Heiko Carstens wrote:
> > > Patch 2 introduces the new proposed interface
> >
> > Could we just encapsulate the threads etc. into a "struct stopmachine"
> > which is returned from stop_machine_prepare(), then implement everything
> > in terms of that?
>
> You mean that we put the pointers to the threads, the cpu mask, etc. in
> this structure, instead of wasting bss size?
> That would be just a kmalloc call in __stop_machine_get_threads().
> Or do you think of something different?

That's exactly my idea.  We kmalloc already because NR_CPUS might be too big 
for the stack.  This version would just kmalloc a struct containing 
everything we need.

I prefer _prepare() / _run() / _destroy() as nomenclature BTW.  prepare comes 
from wait.h's prepare_to_wait; I don't like alloc() since it does more than 
allocate memory, yet _get_threads unnecessarily reveals too much about the 
implementation.

Then we have the simple case:

static inline int stop_machine(int (*fn)(void *), void *data,
			       const struct cpumask *cpus)
{
	struct stop_machine *sm = stop_machine_prepare();
	int err;

	if (!sm)
		return -ENOMEM;

	err = stop_machine_run(sm, fn, data, cpus);
	stop_machine_destroy(sm);
	return err;
}

I think you want to be able to call stop_machine_run() with the same "sm" 
multiple times, but that should be pretty easy to ensure.

Cheers!
Rusty.
