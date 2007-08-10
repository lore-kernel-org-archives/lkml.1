Return-Path: <linux-kernel-owner+w=401wt.eu-S933475AbXHJScO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbXHJScO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbXHJSb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:31:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37344 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbXHJSb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:31:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@sw.ru>, axboe@kernel.dk
Subject: Re: [PATCH 08/10] sysctl: Remove broken cdrom binary sysctls
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
	<m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vebo8avf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6mc8at5.fsf_-_@ebiederm.dsl.xmission.com>
	<m1myx08arh.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ir7o8ap1.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810143342.173d2637@the-village.bc.nu>
	<m17io3z8o2.fsf@ebiederm.dsl.xmission.com>
	<20070810181632.3a491575@the-village.bc.nu>
Date: Fri, 10 Aug 2007 12:30:07 -0600
In-Reply-To: <20070810181632.3a491575@the-village.bc.nu> (Alan Cox's message
	of "Fri, 10 Aug 2007 18:16:32 +0100")
Message-ID: <m1y7gjw8cw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> I just wanted something stupid and simple, so the -mm tree would not
>> be full of broken sysctls.
>
> Well I'd like you to not replace one pile of hard to clean up but easy to
> locate crap by smearing other hard to fix in one go crap over the kernel.

I'm not certain I see the difference. I just replaced the comparison
of one label with another.  There may have been more beauty in one or
the other but it really should not have made a difference maintenance
wise.  Perhaps I'm just short some cdrom context here to understand
your problem.

Regardless.  Looking at the code I think we can do something straightforward
and even more stupid without needing any comparisons.

Alan does this look a little better?

static int cdrom_sysctl_handler(struct ctl_table *ctl, int write, struct file * filp,
				void __user *buffer, size_t *lenp, loff_t *ppos)
{
	int *valp = ctl->data;
	int val = *valp;
	int ret;
	
	ret = proc_dointvec(ctl, write, filp, buffer, lenp, ppos);

	if (write) {
	
		/* we only care for 1 or 0. */
		autoclose        = !!cdrom_sysctl_settings.autoclose;
		autoeject        = !!cdrom_sysctl_settings.autoeject;
		debug	         = !!cdrom_sysctl_settings.debug;
		lockdoor         = !!cdrom_sysctl_settings.lock;
		check_media_type = !!cdrom_sysctl_settings.check;

		/* update the option flags according to the changes. we
		   don't have per device options through sysctl yet,
		   but we will have and then this will disappear. */
		cdrom_update_settings();
	}

        return ret;
}

Eric
