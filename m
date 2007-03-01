Return-Path: <linux-kernel-owner+w=401wt.eu-S965263AbXCAPWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbXCAPWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXCAPWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:22:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56503 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965263AbXCAPWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:22:32 -0500
Date: Thu, 1 Mar 2007 07:22:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in on_each_cpu?
Message-Id: <20070301072225.9f00c36c.akpm@linux-foundation.org>
In-Reply-To: <45E6BD5B.4030305@vmware.com>
References: <45E6AC1A.8050608@vmware.com>
	<20070301024524.c7c8ea1a.akpm@linux-foundation.org>
	<45E6BA3A.2040306@vmware.com>
	<1172749278.10271.43.camel@localhost.localdomain>
	<45E6BD5B.4030305@vmware.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 03:47:39 -0800 Zachary Amsden <zach@vmware.com> wrote:

> Rusty Russell wrote:
> > On Thu, 2007-03-01 at 03:34 -0800, Zachary Amsden wrote:
> >   
> >> What would be really, really nice would be to statically check all 
> >> callsites that issue irq disables actually keep irqs disabled.  
> >> Presumably, there was a reason they disabled irqs, and re-enabling them 
> >> underneath their noses, even if it is to avoid a race, breaks the logic 
> >> behind that reason.
> >>     
> >
> > For the moment, how about a BUG_ON() in on_each_cpu()?
> >   
> 
> Sounds quite decent.  But why does on_each_cpu need to disable 
> interrupts at all?  It just calls func(), then re-enables interrupts.  
> So whatever was going to happen during func() that might not be 
> interrupt safe could just be done in the callee, avoiding the rather 
> expensive mess of disabling and re-enabling interrupts for those cases 
> where it doesn't matter.

The handler for smp_call_function() is called with local interrupts
disabled (from the IPI handler).

So to provide a consistent call environment for that handler, on_each_cpu()
will also disable local interrupts when making the direct call on this CPU.

Similarly the !CONFIG_SMP version of on_each_cpu() disables local
interrupts when running the caller's function.

