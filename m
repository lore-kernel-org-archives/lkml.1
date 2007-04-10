Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXDJW3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXDJW3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXDJW3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:29:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49871 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030506AbXDJW3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:29:48 -0400
Date: Tue, 10 Apr 2007 15:28:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>, Thomas Gleixner <tglx@linutronix.de>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/10] Vmi timer update.patch
Message-ID: <20070410222844.GN19575@sequoia.sous-sol.org>
References: <200704100006.l3A06RUR020644@zach-dev.vmware.com> <20070410023702.GJ10574@sequoia.sous-sol.org> <461BC373.10306@vmware.com> <20070410172429.GN10574@sequoia.sous-sol.org> <461C084C.9020009@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461C084C.9020009@vmware.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Zachary Amsden (zach@vmware.com) wrote:
> Yes, but unfortunately that is a nop:
> 
>         /*
>          * Avoid unnecessary state transitions, as it confuses
>          * Geode / Cyrix based boxen.
>          */
>         case CLOCK_EVT_MODE_SHUTDOWN:
>                 if (evt->mode == CLOCK_EVT_MODE_UNUSED)
>                         break;
>         case CLOCK_EVT_MODE_UNUSED:
>                 if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
>                         break;

This one should be fallthrough case during exchange (mode == PERIODIC)

>         case CLOCK_EVT_MODE_ONESHOT:
>                 /* One shot setup */
>                 outb_p(0x38, PIT_MODE);
> 
> So switching from PIT to VMI does not disable PIT timer interrupts.  
> Thus I have to keep this part of the patch.

Oh, I was looking at this (x86_64 work I have here):

	case CLOCK_EVT_MODE_SHUTDOWN:
	case CLOCK_EVT_MODE_UNUSED:
		outb_p(0x30, PIT_MODE);
		outb_p(0, PIT_CH0);	/* LSB */
		outb_p(0, PIT_CH0);	/* MSB */
		break;

That's mode 0, not mode 5, but I think the end result is the same.
