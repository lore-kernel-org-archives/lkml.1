Return-Path: <linux-kernel-owner+w=401wt.eu-S1758900AbZCCAJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbZCCAJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZCCAIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:08:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:47675 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZCCAIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:08:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903021533130.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903012324.39327.rjw@sisk.pl>
	 <d6200be20903021501x4ad710fbr834b11b8a6647d2c@mail.gmail.com>
	 <200903030013.02805.rjw@sisk.pl>
	 <d6200be20903021518r48fe6fb2vd07e9dedc4f5ff44@mail.gmail.com>
	 <alpine.LFD.2.00.0903021530200.3111@localhost.localdomain>
	 <alpine.LFD.2.00.0903021533130.3111@localhost.localdomain>
Date: Mon, 2 Mar 2009 16:08:52 -0800
Message-ID: <d6200be20903021608x3ccd8d47u613b35f2ebc609be@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/4] PM: Rework handling of interrupts during 
	suspend-resume (rev. 4)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 3:35 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 2 Mar 2009, Linus Torvalds wrote:
>>
>> If IRQ_SUSPENDED _is_ set, then that means that we're after the
>> suspend_late() sequence and before the resume_early() sequence
>
> Sorry, after the suspend, and before the resume.
>
> We could be _in_ the suspend_late/resume_early sequence, but a driver that
> were to try to play with interrupts at that stage would be broken. It
> can't very well do a enable_irq(), because that would be a MAJOR BUG - it
> would make the whole irq suspend thing pointless, since now interrupts
> would start to happen exactly where they must not happen!

It may be pointless for a driver to call disable_irq and enable_irq
from suspend_late or resume_early (instead of suspend and resume), but
I would not call it a bug. Since disable_irq and enable_irq are
reference counted all this is doing is indicating that this driver can
or cannot accept interrupts. If you want to make an additional
restriction that drivers are not allowed to call disable_irq or
enable_irq from suspend_late and resume_early, then yes you can tell
that enable_irq was called from resume_device_irqs.

I don't know of any drivers that do this, I was just pointing out the
danger of releasing a reference without knowing if you acquired that
reference.

-- 
Arve Hjønnevåg
