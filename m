Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYH1Hq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYH1Hq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYH1HqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:46:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYH1HqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:46:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Diggs <kevdig@hypersurf.com>
Subject: Re: [PATCH 2/4] Add cpufreq driver for the IBM PowerPC 750GX
Date: Thu, 28 Aug 2008 09:46:09 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <48B28F23.1000906@hypersurf.com> <200808271334.16712.arnd@arndb.de> <48B5C0AD.9040006@hypersurf.com>
In-Reply-To: <48B5C0AD.9040006@hypersurf.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808280946.10077.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX198EH0qoK+08oY+EyDvhA+jjiccRckD9O2jM6O
 u1pFMpaa+AOlI5Qdjw4YCdeJr/vxgm61r249mK/gg0f3HHYyCk
 b91Kb0ghcP0Hk65d4tkAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 August 2008, Kevin Diggs wrote:
> Arnd Bergmann wrote:
> > 
> > Module parameter names should be short, so just "minmax" would
> > be a good name, but better put the module_param() line right
> > after that. If it's a bool type, I would just leave out the
> > initialization.
> > 
> Ok. But leaving out the initialization will make me itch. Should I
> also replace "override_min_core" with "mincore" (or "min_core")? And
> "override_max_core" with "maxcore" (or "max_core")?
> 
> Leaving out the initializations makes me ... uneasy. It's ok to leave
> them out if they are 0?

Yes, that's how global and static variables are defined in C.
Only automatic variables have undefined content.

> > I think the module_exit() function should leave the frequency in a
> > well-defined state, so the easiest way to get there is probably
> > to delete the timer, and then manually set the frequency.
> > 
> I really don't follow you here? If I let the timer fire then the cpu
> (and the cpufreq sub-system) will be left in a well-defined state. I
> don't understand why you want me to delete the timer and then
> basically do manually what it was going to do anyway. There are two
> calls to cpufreq_notify_transition(). One just before the modify_PLL()
> call, with CPUFREQ_PRECHANGE as an argument, and one in the
> pll_switch_cb() routine, with CPUFREQ_POSTCHANGE as an argument. I
> would need to make sure that these are matched up.
> 
> Even without the HRTimer stuff being used the timer fires in less than
> 4 ms (@ 250 HZ). So I can't see the user actually trying to interrupt
> a frequency change. With HRTimers it is 100 us.
> 
> Can we please, please leave this part as is?

I'm still not convinced that it's actually correct if you call complete()
from the other places as well. You have three locations in your code where
you call complete() but only one for INIT_COMPLETION. The part that I don't
understand (and therefore don't expect other readers to understand) is how
the driver guarantees that only one complete() will be called on the
completion variable after it has been initialized.

What I meant with the well-defined state is that after unloading the module,
the CPU frequency should be the same as before loading the module, typically
the maximum frequency, but not the one that was set last.

	Arnd <><
