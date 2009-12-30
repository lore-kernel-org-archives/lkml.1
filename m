Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZL3Veu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZL3Veu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZL3Ves
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:34:48 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41969 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZL3Veq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:34:46 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected (was: Re: Linux 2.6.33-rc2 - Merry Christmas ...)
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 30 Dec 2009 13:34:38 -0800
In-Reply-To: <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain> (Linus Torvalds's message of "Wed\, 30 Dec 2009 13\:10\:51 -0800 \(PST\)")
Message-ID: <m11victac1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> We've seen it several times (yes, mostly with drm, but it's been seen with 
> others too), and it's very annoying. It can be fixed by having very 
> careful readdir implementations, but I really would blame sysfs in 
> particular for having a very annoying lock reversal issue when used 
> reasonably.

Maybe.  The mnmap_sem has some interesting issues all of it's own.
What reasonable thing is the drm doing that is causing problems?

> So the optimal situation would be for sysfs to not have that annoying lock 
> dependency, and it would really have to be sysfs_readdir() that drops the 
> sysfs_mutex around the filldir call (and that obviously implies having to 
> re-validate and be really careful).
>
> Added Eric and Greg to the cc, in case the sysfs people want to solve it.

There are scalability reasons for dropping the sysfs_mutex in sysfs_readdir
and I have some tenative patches for that.  I will take a look after I
come back from the holidays, in a couple of days.  I don't understand
the issue as described.

> And yes, one option would be to just fix drm - by avoiding calling any 
> sysfs functions while holding the mmap_lock (either in the mmap callback 
> or the page fault paths). However, as mentioned, I really do think that 
> the blame can be laid on sysfs for trying to be a nice generic interface, 
> but having a damn inconvenient locking model.

Could be.  I have simplified the sysfs locking quite a bit this last
round.  I don't know if there is much more than corner cases left to
improve.

Eric

