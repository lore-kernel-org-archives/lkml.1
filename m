Return-Path: <linux-kernel-owner+w=401wt.eu-S937928AbXHIApD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937928AbXHIApD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXHIAow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:44:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbXHIAov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:44:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qfjvkrFCiowGJslqvxHgHG1PkKA5T7dBKq6B/P1KabTnOMyyb6lEXNA7qaxAWQCOt
	JipHaUQ2bmG7jKk2lN5sA==
Message-ID: <8f95bb250708081744le5e5216k13087d05211a4056@mail.gmail.com>
Date: Wed, 8 Aug 2007 17:44:40 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: Avoid NMI Watchdog and/or long wait in setup_APIC_timer
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <200708090226.24002.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070808231719.GA7101@google.com> <200708090226.24002.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> On Thursday 09 August 2007 01:17:19 Aaron Durbin wrote:
> > In setup_APIC_timer with the HPET in use, a condition can arise while
> > waiting for the next irq slice to expire on the HPET which will either
> > cause an NMI watchdog to fire or a 3 minute busy loop if the NMI
> > watchdog is disabled.
> >
> > The HPET comparator and the counter keep incrementing during its normal
> > operation. When a comparison event fires the comparator will increment
> > by the designated period. If the HPET trigger occurs right after
> > the 'int trigger = hpet_readl(HPET_T0_CMP);' line, we will will spin
> > for up to 3 minutes (with a clock of 25MHz) waiting for the HPET
> > counter to wrap around. However, when the NMI watchdog is enabled the
> > NMI watchdog will detect a lockup and reboot the machine. This
> > scenario can be exasperated by the presence of an SMI which will
> > increase the window of opportunity for the condition to occur.
>
> Nasty.
>
> Iirc the clockevents code did away with the synchronization
> completely because Thomas determined it was useless because long term
> it'll drift anyways. So perhaps it could be just removed?
>

I was thinking along the same lines as well, but I really didn't know how
important all that code was for waiting for the next irq slice. I'm not time
expert, but I would imagine we would resynchronize correctly in the future after
this code path?
