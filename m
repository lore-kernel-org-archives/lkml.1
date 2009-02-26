Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZBZCN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZBZCN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 21:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBZCNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 21:13:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:43314 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZBZCNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 21:13:48 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl>
	 <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl>
	 <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	 <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
Date: Wed, 25 Feb 2009 18:13:45 -0800
Message-ID: <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 5:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
>>
>> Do you plan to fix edge triggered wakeup interrupts? It still looks
>> like edge triggered wakeup interrupts that occur between
>> suspend_device_irqs and local_irq_disable will not cause a wakeup.
>
> IF we ever see this as a real issue, we can either see it in the
> IRQ_PENDING flag, or we can mark such interrupts specially. So it would be
> solvable. That said, I haven't actually heard any real usage cases. Normal
> wakeup events are _not_ interrupts in the regular "device interrupt
> controller" sense.
>
> So can you actually point to an explicit example of something where this
> is a real issue?

On the msm platform the keyboard driver currently leave the interrupts
enabled when suspended. If the interrupt handler is called, we use a
wakelock to abort suspend (without wakelocks you would need to set a
flag and abort in suspend_late instead). If the interrupt occurs after
local_irq_disable, it will still be pending when we get to the suspend
enter hook and suspend will be aborted there.

As far as I can tell, this change breaks this. If you press a key at
the right time, it will be ignored.

-- 
Arve Hjønnevåg
