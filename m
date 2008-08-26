Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbYHZUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbYHZUDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYHZUD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:03:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:16526 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYHZUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:03:25 -0400
Subject: Re: [PATCH 4/4] acpi: semaphore removal
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Len Brown <len.brown@intel.com>, Robert Moore <robert.moore@intel.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080826195051.GF23698@parisc-linux.org>
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
	 <1219777186-4787-2-git-send-email-dwalker@mvista.com>
	 <1219777186-4787-3-git-send-email-dwalker@mvista.com>
	 <1219777186-4787-4-git-send-email-dwalker@mvista.com>
	 <20080826191335.GE23698@parisc-linux.org>
	 <1219779046.3797.12.camel@dhcp32.mvista.com>
	 <20080826195051.GF23698@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 13:03:21 -0700
Message-Id: <1219781001.3797.31.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 13:50 -0600, Matthew Wilcox wrote:
> On Tue, Aug 26, 2008 at 12:30:46PM -0700, Daniel Walker wrote:
> > On Tue, 2008-08-26 at 13:13 -0600, Matthew Wilcox wrote:
> > > On Tue, Aug 26, 2008 at 11:59:49AM -0700, Daniel Walker wrote:
> > > > The semaphore usage in ACPI is more like completions. The ASL
> > > 
> > > Huh?  They are semaphores.  They're not 'more like completions' at all.
> > 
> > You can clearly make a completion out of a semaphore, but we have a
> > completion API .. ACPI is using locked semaphores, and essentially
> > re-making completions with the semaphore API..
> 
> What makes you think that?
> 
> executer/excreate.c:    status = acpi_os_create_semaphore(ACPI_NO_UNIT_LIMIT, 0,
> executer/exsystem.c:        acpi_os_create_semaphore(ACPI_NO_UNIT_LIMIT, 0, &temp_semaphore);
> namespace/nsaccess.c:                                       acpi_os_create_semaphore(1, 0,
> osl.c:acpi_os_create_semaphore(u32 max_units, u32 initial_units, acpi_handle * handle)
> 
> All users set 'initial_units' to 0.
> 

We have from ACPI,

acpi_status
acpi_os_create_semaphore(u32 max_units, u32 initial_units, acpi_handle * handle)
{
        struct semaphore *sem = NULL;
...
        sema_init(sem, initial_units);



Then from semaphore.h,

#define init_MUTEX(sem)         sema_init(sem, 1)
#define init_MUTEX_LOCKED(sem)  sema_init(sem, 0)

So initial units of 0 means make it locked initially .. Initialize to 1
would be a regular unlocked mutex ..

Daniel

