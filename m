Return-Path: <linux-kernel-owner+w=401wt.eu-S1765091AbYEGVAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765091AbYEGVAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760863AbYEGVAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:00:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54117 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762148AbYEGVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:00:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <20080506173030.653828076@theryb.frec.bull.fr>
	<20080506173335.922289888@theryb.frec.bull.fr>
	<m13aoueyq8.fsf@frodo.ebiederm.org> <20080507190838.GA4467@suse.de>
Date: Wed, 07 May 2008 13:54:27 -0700
In-Reply-To: <20080507190838.GA4467@suse.de> (Greg KH's message of "Wed, 7 May
	2008 12:08:38 -0700")
Message-ID: <m1hcd9esxo.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0095]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 10/11] avoid kobject name conflict with different namespaces
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Wed, May 07, 2008 at 11:49:19AM -0700, Eric W. Biederman wrote:
>> Unless there is another path I think placing an additional pointer in
>> kobj_type so we can find it through ktype is the simplest solution.
>> Although using the kset is also sane.
>
> Ick, ick, ick :)

Well yes we are dealing with a pile of seemingly unnecessary layers,
that are attempting to add uniformity where no uniformity existed.
That is an easy recipe for ick.

>> The easiest and most trivially correct thing to do would be to simply
>> remove the unnecessary check from kobject_rename.  We perform the
>> check at the upper levels in the network anyway.  And kobject_rename
>> is only used by the network stack.
>
> Wireless uses it also for some things, and it requires that it fail if a
> duplicate is found.

Looks like it, that use is brand new, and at first glance I thought
it was another instance of the device_rename case that kobject uses.
Apparently not.

It looks like getting the wireless devices into the network namespace
is going to be interesting.  Since this phy name is user controllable
and shows up in rtnetlink messages it definitely appears to belong in
the network namespace. 

Virtual/logical devices are such a pain.

....

Given that kobject_rename is growing users we definitely need to
fix it so a noop rename does not return -EINVAL.

i.e. if (temp_kobj && (temp_kobj != kobj)) return -EINVAL.
instead of just if (temp_kobj) return -EINVAL;

> I thought that s390 also used it, but I don't see
> that usage in the tree anymore, perhaps they switched to something else.

That is the device_move -> kobject_move case.  Very similar (and nice
if we can figure out how to combine them).

> good luck,

Thanks.  It looks like we are just about there.

Hopefully we can get this merged soon so there won't be many more sets
of shifting requirements to chase.

Eric
