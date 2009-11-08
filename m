Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZKHXb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZKHXb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 18:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZKHXbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 18:31:25 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36852 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZKHXbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 18:31:25 -0500
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Leo Chen <leochen@broadcom.com>
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org>
	<20091108225652.GB31433@flint.arm.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 15:31:23 -0800
In-Reply-To: <20091108225652.GB31433@flint.arm.linux.org.uk> (Russell King's message of "Sun\, 8 Nov 2009 22\:56\:52 +0000")
Message-ID: <m1ocnch9v8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk+lkml@arm.linux.org.uk> writes:

> On Sun, Nov 08, 2009 at 02:45:36PM -0800, Eric W. Biederman wrote:
>> Russell King <rmk+lkml@arm.linux.org.uk> writes:
>> 
>> >
>> > NAK.  Glibc uses these numeric sysctls to support ioperm emulation on ARM.
>> > Therefore, removal of these numeric sysctls breaks that user interface:
>> >
>> >   static int iobase_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_BASE };
>> >   static int ioshift_name[] = { CTL_BUS, BUS_ISA, BUS_ISA_PORT_SHIFT };
>> >   if (! sysctl (iobase_name, 3, &io.io_base, &len, NULL, 0)
>> >       && ! sysctl (ioshift_name, 3, &io.shift, &len, NULL, 0))
>> >     {
>> >       io.initdone = 1;
>> >       return 0;
>> >     }
>> 
>> Those still exist in sysctl_binary.c are provided by reading
>> /proc/sys/bus/isa/membase, /proc/sys/bus/isa/portbase, and
>> /proc/sys/bus/isa/portshift.
>> 
>> The practical difference is that /proc support now must be compiled
>> in to support sys_sysctl.
>
> Have you checked whether glibc supports reading these from procfs rather
> than sysfs using the code as it stands above?
>
> If not, continued NAK due to user visible ABI change which will cause
> breakage.

There is not a user visible ABI change.  Just a massive implementation change.
The only user visible change is that CONFIG_SYS_SYSCALL now depends on
CONFIG_PROC_SYSCTL.

The implementation of sys_sysctl in binary_sysctl.c will now read
/proc/sys/bus/isa/portbase and using vfs_read convert the text string
to a binary integer and return it to glibc in the form sys_sysctl has
always used.

And yes, as of glibc-ports-10.1 the arm implementation of ioperm still
depends on the binary sys_sysctl implementation to get this information.

Eric
