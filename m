Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbXEBGHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbXEBGHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXEBGHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:07:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:53701 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbXEBGHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:07:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=WfMBg4V1RjaRWJdCm2eXvJb1UndlIk14UI8Q6fl3nB1fGcFkNVj/Q8+vij/4Ep3TJ
	Dq0sknngVtX0XIVzt6DNw==
Date: Tue, 1 May 2007 23:06:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <1178084403.28659.222.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <1178084403.28659.222.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Rusty Russell wrote:

> Adding this macro doesn't give us anything that simply saying
> "__attribute__((unused))" doesn't give.  But it does add a layer of
> kernel-specific indirection.
> 

That's obviously true since we're defining __attribute_unused__ to be 
__attribute__((unused)).

We were trying to clean up the misconception that the current 
__attribute_used__ was created to suppress warnings when, in fact, that 
was not its purpose.  It was created to emit the code for a function that 
appeared to be unreferenced and only suppressed warnings as a side-effect 
in gcc <3.4.

> If we're going to get kernel-specific, I'd prefer to see:
> 
> __needed: suppress warning and don't discard,

That would be the current definition of __attribute_used__ (i.e. we're 
saying that we use the function in inline assembly even though it appears 
we don't use it at all).

> __unneeded: suppress warning and might discard.
> 

That would be the patched definition of __attribute_unused__.

So let's go back to the problem this was initially supposed to fix from 
arch/i386/pci/init.c:

static __init int pci_access_init(void)
{
	int type = 0;

#ifdef CONFIG_PCI_DIRECT
	type = pci_direct_probe();
#endif
#ifdef CONFIG_PCI_MMCONFIG
	pci_mmcfg_init(type);
#endif
	...

and type is unreferenced for the remainder of the function.  Obviously we 
could add #if defined(CONFIG_PCI_DIRECT) || defined(CONFIG_PCI_MMCONFIG) 
before the declaration of 'type', but that becomes sloppy pretty quickly.

The patched version makes this:

	int type __attribute_unused__ = 0;

which definitely tells you that you're using a compiler attribute that 
will be attached to that automatic.  In your case:

	int type __unneeded = 0;

doesn't say anything in this case.  It doesn't resemble any attribute that 
a programmer might be familiar with and begs the question of why we've 
declared it if it's truly "unneeded"?

By the way, there are tons of these instances where __attribute__((used)) 
needs to be added in driver code to suppress unreferenced warnings.

		David
