Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYJXMGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYJXMGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYJXMGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:06:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYJXMGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:06:09 -0400
Date: Fri, 24 Oct 2008 14:05:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator
	driver
Message-ID: <20081024120544.GA9812@elte.hu>
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024120103.GD1680@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> On Fri 2008-10-24 04:19:04, Mike Travis wrote:
> > [Ingo - could you let me know what's holding up this driver?
> > Thanks!, Mike]
> 
> I thought that...
> 
>  > +static __init void uv_scir_register_cpu_notifier(void)
> > +{
> > +	hotcpu_notifier(uv_scir_cpu_notify, 0);
> > +	idle_notifier_register(&uv_idle_notifier);
> > +}
> 
> ...Ingo said that idle_notifier_register is deprecated and going away?

yes, but i suspect Mike noticed that i acked Len's use of idle notifiers 
in the ACPI tree, and now he wants to refresh this discussion?

i cannot really believe why anyone would want to slow down the from-idle 
hotpath in such a lame way:

+       } else if (action == IDLE_END) {
+
+               uv_hub_info->scir.state |= SCIR_CPU_ACTIVITY;
+               uv_hub_info->scir.idle_off += elapsed;
+               uv_hub_info->scir.last = jiffies;
+       }

with such a lame and low-res timestamp:

+       unsigned long elapsed = jiffies - uv_hub_info->scir.last;

it's an absolutely pointless act of adding overhead. Just use a regular 
timer mechanism to update uv_hub_info->scir.idle_off.

	Ingo
