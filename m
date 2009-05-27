Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZE0WG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZE0WG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZE0WGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:06:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49137 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZE0WGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:06:14 -0400
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <Pine.LNX.4.44L0.0905271736460.2669-100000@iolanthe.rowland.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 27 May 2009 15:06:09 -0700
In-Reply-To: <Pine.LNX.4.44L0.0905271736460.2669-100000@iolanthe.rowland.org> (Alan Stern's message of "Wed\, 27 May 2009 17\:38\:50 -0400 \(EDT\)")
Message-ID: <m1ljoi6w1a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: stern@rowland.harvard.edu, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, kay.sievers@vrfy.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0592]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 27 May 2009, Eric W. Biederman wrote:
>
>> Alan Stern <stern@rowland.harvard.edu> writes:
>> 
>> >
>> > As fas as I know, they can't.  Instead, they can cause the SCSI layer 
>> > to unregister a sysfs directory containing a child directory.  :-)
>> >
>> > Basically, a user program can delay removal of the child (i.e., the
>> > target) directory indefinitely, because currently the target isn't
>> > unregistered when all its children are removed -- it's unregistered
>> > when all its children are _released_.
>> 
>> Ok.  Is this opens of /dev/sda1 and the like that are being held open by
>> userspace that are potentially causing problems?
>
> Yes, plus any other mechanism for preventing a struct device's refcount 
> from going to 0.

Thanks.  The discussion makes sense now.

>> I think I have the fix to that...
>
> The fix is to delete the target when its children are deleted, and not
> wait until the children are released.

I think I can do both.

I am currently working on a patchset which at the VFS layer disconnects a
fd from an underlying device.  It does the necessary use count tracking
and when the disconnect is done it returns.  As part of the disconnect it
calls the release method.

We already do this in at least sysfs, proc, sysctl, and sound.  So I
figure it is time to move this into some generic code so we don't need
to duplicate the bugs and the insanities.

Once merged it would take just a few lines of code to use this functionality.

Eric
