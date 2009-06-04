Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZFDAlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZFDAlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 20:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZFDAl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 20:41:28 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50363 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZFDAl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 20:41:27 -0400
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/26] sysfs: sysfs_remove_dir stop checking for bogus cases.
References: <m1r5y73bok.fsf_-_@fess.ebiederm.org>
	<1243628376-22905-4-git-send-email-ebiederm@xmission.com>
	<20090603235322.GA19375@kroah.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 17:41:21 -0700
In-Reply-To: <20090603235322.GA19375@kroah.com> (Greg KH's message of "Wed\, 3 Jun 2009 16\:53\:22 -0700")
Message-ID: <m163fcg79q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: greg@kroah.com, ebiederm@aristanetworks.com, kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Fri, May 29, 2009 at 01:19:14PM -0700, Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> kobj->sd can not be NULL in sysfs_remove_dir.
>> 
>> sysfs_remove_dir is only called from kobject_add (to clean up after failure)
>> and from kobject_del at the end of a kobject's life.  In both cases kobject_add
>> has already called sysfs_create_dir successfully.  The only writers of
>> kobj->sd are sysfs_create_dir on sucess and sysfs_remove_dir when it clears
>> the kobj just before deleting the directory.
>> 
>> Which means at the time sysfs_remove_dir is called kobj->sd will be
>> valid.
>
> Yeah, we would hope so.
>
> But as we have been forced to add many checks like this into the driver
> core to handle those "no one could ever call this" type problems that
> have been springing up over time, I am hesitant to remove this check.
>
> Why do you want to remove it, what is the problem here you are trying to
> solve?

I'm cleaning up and simplifying the code.

In this particular instance the check is actually wrong.  There is no
valid code path that depends on that behavior.   Which means the test
is both useless and actively obscures the code.

Making it a BUG_ON would be valid.

The other side of it is I realized I had been running for months without
that check.  I had deleted it as an oversight.  Then when the code churn
was small enough and Tejun asked me about it.  I split this hunk out
into it's own separate patch.  As I figured  it deserved it's own patch
so the change could stand out and be reviewed.  Since my review of the code
path showed no valid use case I kept it.

Eric
