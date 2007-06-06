Return-Path: <linux-kernel-owner+w=401wt.eu-S1761372AbXFFK77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372AbXFFK77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbXFFK7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:59:51 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:49155 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760207AbXFFK7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:59:50 -0400
Message-Id: <4666AFEF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 06 Jun 2007 13:00:31 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Keir Fraser" <keir@xensource.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <virtualization@lists.osdl.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@suse.de>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
References: <46669AD4.76E4.0078.0@novell.com>
 <C28C4362.1021C%keir@xensource.com>
In-Reply-To: <C28C4362.1021C%keir@xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Keir Fraser <keir@xensource.com> 06.06.07 11:56 >>>
>On 6/6/07 10:30, "Jan Beulich" <jbeulich@novell.com> wrote:
>
>>> If you have an ACPI PM timer in your system (and if you have SMM then your
>>> system is almost certainly modern enough to have one) then surely the
>>> problem is fixed for all practical purposes? The problem was overflow of a
>>> fixed-width platform counter. The PIT wraps every ~50ms, but the ACPI PM
>>> timer will wrap only every ~4s. It would be quite unreasonable for SMM to
>>> take the CPU away for multiple seconds, even as a one-time boot operation.
>> 
>> No, I don't think the problem's gone with the PM timer - it is just much less
>> likely. Since you depend on the TSC (which must generally be assumed be
>> unsyncronized across CPUs) and on the error correction factor (which shows
>> non-zero values every few seconds), getting the interpolated times on two
>> CPUs out of sync is still possible, and given the way the time keeping code
>> works even being off by just a single nanosecond may be fatal.
>
>If the error across CPUS is +/- just a few microseconds at worst then having
>the clocksource clamp to no less than the last timestamp returned seems a
>reasonable fix. Time won't 'stop' for longer than the cross-CPU error, and
>that should always be a tiny value.

Are you sure this is also true when e.g. a CPU gets throttled due to thermal
conditions? It is my understanding that both the duty cycle adjustment and
the frequency reduction would yield a reduced rate TSC, which would be
accounted for only the next time the local clock gets calibrated. Otherwise,
immediate calibration (and vcpu update) would need to be forced out of the
thermal interrupt.

Jan

