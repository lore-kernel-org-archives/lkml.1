Return-Path: <linux-kernel-owner+w=401wt.eu-S1758457AbZBZVUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457AbZBZVUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 16:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZBZVUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 16:20:25 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:46742 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZBZVUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 16:20:25 -0500
MIME-Version: 1.0
In-Reply-To: <1235681849.7388.22.camel@pasglop>
References: <200902221837.49396.rjw@sisk.pl> <200902250029.16107.rjw@sisk.pl>
	 <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	 <200902261050.50531.rjw@sisk.pl>
	 <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com>
	 <1235681849.7388.22.camel@pasglop>
Date: Thu, 26 Feb 2009 13:20:21 -0800
Message-ID: <d6200be20902261320q58a347e5s1af790e56b186c81@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 12:57 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2009-02-26 at 12:34 -0800, Arve Hjønnevåg wrote:
>> That is enough for drivers that use wakelocks to abort suspend (if I
>> fix the wakelock code to not use a platform device as its last abort
>> point). It is not enough if you don't have wakelocks, since the
>> interrupt can occur after suspend_late has been called and the driver
>> has no way to abort suspend.
>>
> I still don't quite see how you deal with the race anyway. Ie. Even
> without Rafael patch, what if the interrupt occurs after your sysdev
> suspend ?

After local_irq_disable has been called, the interrupt will no longer
be cleared by Linux when it occurs. This means that is still pending
when you get to the low level suspend code which will prevent suspend.

> In general, unless they are level sensitive, wakeup interrupts tend to
> always be somewhat racy.

They don't have to be. If you have a separate hardware component that
tracks wakeup interrupts, you need to start this before you stop the
main interrupt controller. If any interrupts are pending at this time
you abort suspend. After a wakeup you do the reverse.

-- 
Arve Hjønnevåg
