Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZKJEmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZKJEmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZKJEmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:42:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51311 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZKJEmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:42:52 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <m1pr7siqjz.fsf@fess.ebiederm.org>
	<200911091628.47003.arnd@arndb.de>
	<20091109154621.GG26740@basil.fritz.box>
	<200911091723.23785.arnd@arndb.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 09 Nov 2009 20:42:47 -0800
In-Reply-To: <200911091723.23785.arnd@arndb.de> (Arnd Bergmann's message of "Mon\, 9 Nov 2009 17\:23\:23 +0100")
Message-ID: <m1ocnbrnw8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Monday 09 November 2009, Andi Kleen wrote:
>> > 
>> > So? Most users of old glibc are also using old kernels, and they
>> 
>> How do you know? At least here it's quite common to use new kernels
>> with old user land.
>
> If by 'here' you mean kernel developers, sure. Other people I'd
> assume typically run whatever comes with the distro, and that
> usually includes both a libc and a kernel.

The question with respect to my patchset. Is the increase in time
a measurable performace regression or is the cost lost in the noise?

Andi do you know of a way to measure this?

Doing a special case for /proc/sys/kernel/version if someone can
measure the overhead seem sane.  But the double maintenance isn't
my idea of fun.

The code involved would need to look something like:

	if (len > sizeof(current->nsporxy->uts_ns.name.version)
		len = sizeof(current->nsporxy->uts_ns.name.version);
	down_read(&uts_sem);
	ret = copy_to_user(buf, current->nsproxy->uts_ns.name.version, len);
	up_read(&uts_sem);

That isn't a particular pretty expression, and it has a much higher chance
of bitrotting than what I have now.

>> > can still use the  config option for the compatibility code.
>> > There wouldn't even be a performance penalty over new glibc with
>> > new kernels which already use procfs.
>> 
>> When he drops the sysctl(2) API completely the old userland will
>> be unhappy.
>
> I did not get the impression that this was the plan. Maybe I missed
> something, but the work that Eric did seemed to be strategic for
> leaving the code around for a really long time without causing any
> maintainance pain that the current code does.
>
> It will be years before we can really remove that code, but distros
> can start disabling it (or making it modular) earlier than that
> when they feel the time has come to stop support for static binaries
> using sysctl (there should really be few of those).

There is always the question if we can get away with it.  I intend to
submit a patch that changes the default to off.  Beyond that I don't
don't know.  I expect folks doing enterprise distro would want to turn
of sys_sysctl because it is a typically buggy.  Why chance bitrot leading
to a security hole?

Eric
