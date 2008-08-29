Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYH2NyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYH2NyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbYH2NyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:54:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYH2NyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:54:13 -0400
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
From: Kay Sievers <kay.sievers@vrfy.org>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Zeuthen <david@fubar.dk>
In-Reply-To: <48B7FAEC.80206@kernel.org>
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org>
	 <20080828164924.GB17475@kroah.com> <48B6D9B7.2050406@kernel.org>
	 <3ae72650808290048v1a5d7e51pc68270b2a8d6faa@mail.gmail.com>
	 <48B7AD11.2070906@kernel.org> <1220016439.24737.18.camel@lgn.site>
	 <48B7FAEC.80206@kernel.org>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 15:54:17 +0200
Message-Id: <1220018057.24737.36.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+j1ZYvRRMO+FhFzfoLUdHS2saZINtl75UrRg3
 ACh2CrDjVouJr5CZleI6OZDbSa7sS8nLIZ1bnMtBpahicLBv0D
 J/X7vC743N4r+dT2yJ+jGVByOi6oeH4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 15:34 +0200, Tejun Heo wrote:
> Kay Sievers wrote:
> >> For OSS emulation, it didn't really matter.  For cases where it matters,
> >> I think easier path to take would be let the userland emulation set up a
> >> directory containing pseudo files and just override DEVPATH to it.
> >> Would that work?
> > 
> > No, I don't think so, it's a too bad hack. the SUBSYSTEM key, the entry
> > in the class/bus directory, and the target of the symlink in the device
> > directory _must_ match. Everything else asks for serious trouble, by the
> > inconsistency it creates.
> 
> I'm afraid trying to do that from kernel side would require more scary
> hack as CUSE will need to push in random device under unsuspecting
> parent / class.  Maybe we can add a variable to indicate an emulated
> device or to tell

Sure, SUSBYSTEM=cuse will be exactly that value. :) I see no problem, if
cuse adds SUBSYSTEM_FAKE, or whatever it would be.

> udev/hal whatever to use alt root for sys hierarchy or
> just consider sysfs is not available?  I think this problem can be
> settled between userland programs.

Exactly, we can do anything needed in userspace to support that. I see
no problem doing that.

I just say, that we can _not_ allow to fake the SUBSYSTEM value for
"cuse" or any other device. If the kernel wants to let "cuse" devices
look like members of a specific subsystem, they have to appear in the
class/bus list of that subsystem, and have to have the proper
"susbsystem" link, not only a (wrong) environment key.

Userland enumerates devices by looking at class/bus directories for
things like: "give me all soundcards", it expects a set of certain sysfs
attributes to be present for a specific device, it reads the "subsystem"
link, and so on. All that would break and make things "special"  and
needlessly inconsistent.

So please drop that plan, of faking only a tiny part of
driver-core/sysfs device parameters. Either we do it properly, or we
don't do it, and leave it up to userspace to pick up a (consistent)
"cuse" device, but use it as a device of whatever class.

Thanks,
Kay

