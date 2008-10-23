Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYJWStY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYJWStY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYJWStO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 14:49:14 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:47287 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYJWStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 14:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lOOObeKEtlT4UPjPaSTLiSxF6mO5kp9ikV6eLiX7l9LQmWdNTAAsIsxMw6Cl/qywgF
         AxstLpqJ6ZFlfJHow9XNM10elS1pW5W6hyxrLgtqpGTTbP2q3Wvgm846mxMHwVt7LcgP
         XpdBibr1kY/EunO2WYpxNFGPNEEnCfPOfREhs=
Date: Thu, 23 Oct 2008 22:49:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, travis@sgi.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: do_boot_cpu can deadlock?
Message-ID: <20081023184906.GA2612@localhost>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <20081023163517.GB21008@redhat.com> <20081023170212.GA22599@redhat.com> <20081023182119.GA1480@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023182119.GA1480@in.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Gautham R Shenoy - Thu, Oct 23, 2008 at 11:51:19PM +0530]
| On Thu, Oct 23, 2008 at 07:02:12PM +0200, Oleg Nesterov wrote:
| > Hmm. arch/x86/kernel/smpboot.c:do_boot_cpu() can deadlock ?
| > 
| > It is called from _cpu_up() under cpu_hotplug_begin(), and it
| > waits for c_idle.work. Again, if we have the pending work which
| > needs get_online_cpus() we seem to have problems.
| 
| Good point. Though this code gets triggered mostly during boot time when
| the CPUs are being brought online for the first time. If we have some
| work-item pending at that time, which needs get_online_cpus(), we could
| possibly see this deadlock.
| 
| > 
| > Oleg.
| 
| -- 
| Thanks and Regards
| gautham
| 

May I ask? If I understand right we do use this part of do_boot_cpu

	if (!keventd_up() || current_is_keventd())
		c_idle.work.func(&c_idle.work);
	else {
		schedule_work(&c_idle.work);
		wait_for_completion(&c_idle.done);
	}

if only we've been called the first time after power on. And all
subsequent call of this do_boot_cpu would lead to

	if (c_idle.idle) {
		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
		init_idle(c_idle.idle, cpu);
		goto do_rest;
	}

ie go to do_rest and no wait_for_completion/schedule_work at all.
Did I miss something? *Sorry* in advance if the question is quite
not related. This work-pending situation is in 'possible' scenario
only (ie we don't have such a callers for now... yet)?

		- Cyrill -
