Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXCYM6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXCYM6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXCYM6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:58:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51924 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbXCYM6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:58:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<46065FED.8030206@m3y3r.de> <m11wjd4jiq.fsf@ebiederm.dsl.xmission.com>
	<200703251428.03382.rjw@sisk.pl>
Date: Sun, 25 Mar 2007 06:56:08 -0600
In-Reply-To: <200703251428.03382.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 25 Mar 2007 14:28:02 +0200")
Message-ID: <m1wt1532jb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Yes, in kernel/power/disk.c:power_down() .
>
> Please comment out the disable_nonboot_cpus() in there and retest (but please
> test the latest Linus' tree).

<rant>

Why do we even need a disable_nonboot_cpus in that path?  machine_shutdown
on i386 and x86_64 should take care of that.  Further the code that computes
the boot cpu is bogus (not all architectures require cpu == 0 to be
the boot cpu), and disabling non boot cpus appears to be a strong
x86ism, in the first place.

If the only reason for disable_nonboot_cpus there is to avoid the
WARN_ON in init_low_mappings() we should seriously consider killing
it.  If we can wait for 2.6.22 the relocatable x86_64 patchset that
Andi has queued, has changes that kill the init_low_mapping() hack.

I'm not very comfortable with calling cpu_down in a common code path
right now either.  I'm fairly certain we still don't have that
correct.  So if we confine the mess that is cpu_down to #if
defined(CPU_HOTPLUG) && defined(CONFIG_EXPERIMENTAL) I don't care.
If we start using it everywhere I'm very nervous.  I know the irq
migration when bringing a cpu down is strongly racy, and I don't think
we actually put cpus to sleep properly either.

</rant>


Eric
