Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZFVHdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZFVHdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZFVHdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:33:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57461 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZFVHdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iyKjFbdd7j9KD2/LUv5W3lXXAD6mTTMzt6F1/Nrx784nl6n2SHUzv3zuM7vmuuHSOS
         qQA6gdrr6pW8bsUz8ggdv1L+Tsuqn9nBd0oQb+dg7GOeA6b7UHiWFxBRKhCV6KAWA1Gz
         pecB1spfxGtDi6ZmBtXAJXBJtUovJTEXw5hXw=
MIME-Version: 1.0
In-Reply-To: <20090621234324.06fda564@infradead.org>
References: <Pine.LNX.4.44L0.0906192141380.4003-100000@netrider.rowland.org>
	 <Pine.LNX.4.44L0.0906201010590.12994-100000@netrider.rowland.org>
	 <aec7e5c30906212320v3e3e991fyd028d005675f1e25@mail.gmail.com>
	 <20090621234324.06fda564@infradead.org>
Date: Mon, 22 Jun 2009 16:27:29 +0900
Message-ID: <aec7e5c30906220027v63c88e8aj32950a8d84558cce@mail.gmail.com>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework for 
	run-time PM of I/O devices
From: Magnus Damm <magnus.damm@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 3:43 PM, Arjan van de Ven<arjan@infradead.org> wrote:
> On Mon, 22 Jun 2009 15:20:43 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> On Sat, Jun 20, 2009 at 11:30 PM, Alan
>> Stern<stern@rowland.harvard.edu> wrote:
>> > Some more thoughts...
>> >
>> > Magnus, you might have some insights here.  It occurred to me that
>> > some devices can switch power levels very quickly, and the drivers
>> > might therefore want the runtime suspend and resume methods to be
>> > called as soon as possible, even in interrupt context.
>>
>> I'd like to call pm_request_suspend() from interrupt context. I don't
>
> there are some really strong reasons to at least be able to call the
> resume function from an interrupt handler.... shared interrupts are one
> of them.

I suppose you mean that you need to resume the hardware device before
you can check if it has a pending interrupt source? If so then you
also mean that suspended hardware devices may generate interrupts, no?

My plan for SuperH SoC is that runtime suspend always stops the clock,
but register save and power off may happen. Regardless, interrupts are
not generated from suspended hardware devices.

In the rare case of shared interrupts on SuperH we can just skip over
the platform devices that have been runtime suspended since they will
not have generated any interrupt.

But yes, if there is hardware than can generate interrupts from
suspended state then we need to resume from interrupt context. This
probably means that the entire bus hierarchy must resume from
interrupt context as well.

/ magnus
