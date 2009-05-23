Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZEWUKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZEWUKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZEWUKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:10:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39365 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZEWUKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:10:03 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>
	<4A14F356.3030501@kernel.org> <m1k54a7w2x.fsf@fess.ebiederm.org>
	<4A15046A.10106@kernel.org> <m1octm287f.fsf@fess.ebiederm.org>
	<4A1512E2.2040505@kernel.org> <m1vdnuyftb.fsf@fess.ebiederm.org>
	<4A151ECE.50800@kernel.org> <m17i08jpk8.fsf@fess.ebiederm.org>
	<ac3eb2510905230435n20dc376cw95e10eb2cb0cfecb@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 23 May 2009 13:09:54 -0700
In-Reply-To: <ac3eb2510905230435n20dc376cw95e10eb2cb0cfecb@mail.gmail.com> (Kay Sievers's message of "Sat\, 23 May 2009 13\:35\:48 +0200")
Message-ID: <m1prdzh97x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, tj@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of  directories with subdirectories
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Sat, May 23, 2009 at 08:33, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> My plan going forward is to fix the ordering problems with deleting
>> /sys/dev/char and /sys/dev/block.  Add a WARN_ON if we delete a
>> non-empty directory.  Ensure we don't add something to an already
>> deleted directory.
>
> What's the problem in /sys/dev/? There are just a bunch of symlinks,
> one for every device with a dev_t, and all in flat directories, and no
> directory to remove.

device_shutdown called during reboot removes /sys/dev/block and /sys/dev/char.
The current sysfs_remove_dir (because it empties directories)
removes all of those symlinks.

The problem is that it is the device objects for each individual
device that owns those symlinks, and normally removes those symlinks.

Which means that in theory we could have double deletion going on.

In practice today it doesn't matter because this is at reboot.

And as far as that goes it is wrong to remove anything from sysfs during
device_shutdown so the fix is just to not call kobject_put there.

Eric
