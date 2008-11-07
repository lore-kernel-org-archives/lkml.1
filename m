Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYKGCF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYKGCF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYKGCFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:05:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34365 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYKGCFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:05:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172521.91061dcf.akpm@linux-foundation.org>
Date: Thu, 06 Nov 2008 18:02:24 -0800
In-Reply-To: <20081106172521.91061dcf.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 6 Nov 2008 17:25:21 -0800")
Message-ID: <m1fxm4xphr.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task directories
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 06 Nov 2008 02:48:35 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> This is a genearl mechanism that is capable of removing
>> any unused mounts on /proc in any directory.  As we flush
>> the mounts when a processes dies this mechanism is tailored
>> for flushing mounts in the per task and per task group
>> directories.
>
> What I'm missing here is any sense of what these patches are for,
> where they're headed, what the big picture is, etc?

Sorry.

> My vague guess is that perhaps it has something to do with mounting
> procfs multiple times in separate containers.  How did I do?

The big picture is that right now /proc/<pid>/net/stat
is a directory that is hard linked in different locations.

Which means you can deadlock rename at the vfs level
(despite the fact that proc doesn't support rename).

So this patchset splits /proc/net out into it's own filesystem
so we don't have multiple hard links.

It uses the vfs level automounts  to preserve backwards compatibility
so user space does not need to explicitly mount /proc/<pid>/net.

When Al noticed the problem there was some security drama, and
people were privately cc'd etc.  And however it works I am incompetent
at getting patches merged in that kind of environment.  So these
patches have languished since the middle of September.

On one level these patches constitute a bug fix for the bug
of having multiple hard links in /proc/net.  At another level
these patches are a clean up and a nice to have feature.  Allowing
a network namespace to be monitored in the weird interval between when
the last processes goes away and when the network namespace is destroyed.
Because you can mount /proc/net independently.

Eric

