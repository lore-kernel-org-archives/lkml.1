Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYIKTFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYIKTFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYIKTFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:05:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58140 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYIKTFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:05:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu>
	<20080903224334.GA726@us.ibm.com>
	<E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu>
	<20080904132804.GA14709@us.ibm.com>
	<E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
	<E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
	<20080905153134.GA18367@us.ibm.com>
	<E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu>
	<m11vzrge86.fsf@frodo.ebiederm.org>
	<E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu>
	<20080911152033.GA29318@us.ibm.com>
Date: Thu, 11 Sep 2008 11:54:05 -0700
In-Reply-To: <20080911152033.GA29318@us.ibm.com> (Serge E. Hallyn's message of
	"Thu, 11 Sep 2008 10:20:33 -0500")
Message-ID: <m13ak6ecoi.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: unprivileged mounts git tree
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Miklos Szeredi (miklos@szeredi.hu):
>> On Thu, 11 Sep 2008, ebiederm@xmission.com (Eric W. Biederman)
>> > There is a weird corner case I'm trying to wrap my head around.
>> > unlink and rmdir do not work on dentries that are mount points
>> > in another mount namespace.
>> > 
>> > Which is at least needed for the moment so we don't leak mounts.
>> > 
>> > Once we have unprivileged mounts does that introduce a DOS attack?
>> 
>> Hmm, yes.  That's a tough one...
>> 
>> I think if the dentry has only user mounts, unlink should go ahead and
>> on success dissolve any mounts on the dentry.  Does that sound
>> workable?
>> 
>> Thanks,
>> Miklos
>
> Is it really a problem?  The admin can always go ahead and kill the
> user, which already takes care of any mounts in private namespaces,
> which I think is Eric's primary concern.  IT also takes care of that
> user's processes pinning files under the mounts.  So now the admin can
> umount all the user's mounts in the init namespace (using a script
> parsing /proc/self/mountinfo if need be), and delete the files.
>
> Doesn't really seem like a problem.
>
> Or am I missing Eric's real concern?

Assume /user is the base unprivileged mount point.

echo dummy > /tmp/1234
mount --bind /etc /user/etc
mount --bind /tmp/1234 /user/etc/passwd

Now you can't create /etc/passwd.new and rename it to /etc/passwd.
Stopping adduser from working.

As Miklos said this can apply to any file or any directory, so it can
be a DOS against any other user on the system.

It is also contrary to classic unix and linux semantics as open files
don't otherwise prevent unlink, rename or, rmdir from happening. So
applications are not going to be ready for it.

At a practical level I recently replace chroot with mount namespaces
to simplify handling of mounts and ouch!  When a process goes crazy
and doesn't exit when you expect and then you try and delete the
directory it is a pain.

Eric

