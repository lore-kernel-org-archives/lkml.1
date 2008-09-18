Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbYIRLXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbYIRLXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYIRLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:22:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48122 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYIRLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:22:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
	<m1r67i61rh.fsf@frodo.ebiederm.org>
	<20080918090705.6985cced@gondolin.boeblingen.de.ibm.com>
Date: Thu, 18 Sep 2008 03:00:31 -0700
In-Reply-To: <20080918090705.6985cced@gondolin.boeblingen.de.ibm.com>
	(Cornelia Huck's message of "Thu, 18 Sep 2008 09:07:05 +0200")
Message-ID: <m17i99wz7k.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cornelia Huck <cornelia.huck@de.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4082]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH]sysfs: Don't emit a warning when sysfs_rename_link() fails.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> On Wed, 17 Sep 2008 11:55:14 -0700,
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>> Cornelia Huck <cornelia.huck@de.ibm.com> writes:


>> Or we are actually using a conflicting name.  In which case it is a
>> real and valid problem. 
>
> Which may be in userspace as well. In the past the networking folks
> were unhappy about the sysfs warning, claiming that failures should
> rather be handled in their layer.

Because the failures have always been handled in the networking
stack.

The only case that was ever warned about by sysfs were noop
renames.

So no we will not catch any userspace bugs with this code.

>> The netdev layer especially since the
>> networking layer already has validated that the rename is valid
>> before calling device_rename.
>
> Does it? Or do I just don't get it because of lack of coffee?

In the dev_change_name we either do dev_alloc_name
which generates a unique device name or __dev_get_by_name
which looks to see if we are already using that name.

The code in cfg80211_dev_rename is a trivial probe so I
don't think that is subtle.

>> > The following patch switches sysfs_rename_link() to non-warning symlink
>> > creation again. It is on top of the current driver core series.
>> 
>> We don't need this.  Using the non-warning symlink creation is unnecessary.
>> Using non-warning symlink creation hides real errors.
>
> For most cases, yes.

In these cases especially.

>> In practice any errors that show up will be errors in sysfs, because
>> the network subsystem validates everything before calling us.
>
> I was under the impression that no checks are done if the rename is
> triggered via ioctl. And it makes more sense to have the caller of the
> ioctl get an error than to spit a sysfs warning.

Currently there are exactly 2 callers of device_rename.
net/core/dev.c:dev_change_name 
net/wireless/core.c:cfg80211_dev_rename

Both of which verify that the rename is valid before
they call device_rename.  In fact that they have to because
the kobject layer does not have enough information to verify
that the rename is valid, and sysfs is not necessarily compiled in.

Eric
