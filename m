Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYIMDPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYIMDPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 23:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbYIMDPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 23:15:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48205 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbYIMDPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 23:15:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu>
	<20080904132804.GA14709@us.ibm.com>
	<E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu>
	<E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
	<20080905153134.GA18367@us.ibm.com>
	<E1Kd3Mh-0001vk-F5@pomaz-ex.szeredi.hu>
	<m11vzrge86.fsf@frodo.ebiederm.org>
	<E1KdnOb-00068L-Eq@pomaz-ex.szeredi.hu>
	<20080911152033.GA29318@us.ibm.com>
	<m13ak6ecoi.fsf@frodo.ebiederm.org>
	<20080912220802.GA23230@us.ibm.com>
Date: Fri, 12 Sep 2008 20:12:18 -0700
In-Reply-To: <20080912220802.GA23230@us.ibm.com> (Serge E. Hallyn's message of
	"Fri, 12 Sep 2008 17:08:02 -0500")
Message-ID: <m1tzck68od.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2413]
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


> Ok, but this is all done as root.  Kind of a silly thing for root to
> do :)

There are less silly examples like setting up a chroot type
environment contained in a mount namespace and having a kernel oops
and then not being able to delete all of your files.

> So in order for me as an unprivileged user to pin a dentry by mounting
> over it, I have to have write permission to the dentry to begin with
> as well as the dentry being under a user=hallyn mount.

That second condition is interesting requiring write permission of the
dentry.  I thought we had obviated the need for that when we added
ownership to the mounts themselves.  In this case at least it shouldn't
it be write permission on the directory containing the dentry.

>> Now you can't create /etc/passwd.new and rename it to /etc/passwd.
>> Stopping adduser from working.
>> 
>> As Miklos said this can apply to any file or any directory, so it can
>> be a DOS against any other user on the system.
>
> Except I need to own the mount as well as the dentry.  So after
> root does
>
> 	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
> 	mmount --bind -o user=hallyn /home/serge /home/serge
>
> if user serge (uid 501) tries to
>
> 	mmount --bind /etc /home/hallyn/etc
> 	mmount --bind /etc /home/serge/etc
>
> permission for the first will be denied because serge does not
> have write perms to /home/hallyn/etc, and permission for the second
> will be denied because only hallyn may mount under /home/serge.
>
> If root properly did
>
> 	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
> 	mmount --bind -o user=serge /home/serge /home/serge
>
> and then hallyn does
>
> 	mmount --bind /etc /home/hallyn/etc
>
> and serge does
>
> 	mmount --bind /home/hallyn/etc /home/serge/etc
>
> then hallyn can still ummount /home/hallyn/etc.
>
> And we've decided that users cannot (for now) do shared mounts.
> So I'm still not sure where there is the potential for danger?

Ok.  Let's pick on something a little more interesting.

root does:
	mmount --bind -o user=hallyn /home/hallyn /home/hallyn
hallyn does:
	mount --bind /tmp /home/hallyn/tmp
        touch dummy
	mount --bind dummy /home/hallyn/tmp/some_shared_file_I_have_write_access_to.

Which allows me to transform write permissions into the ability to
deny someone else the ability to delete a file.

This seems to mess up things like revoke.

At a practical level it is a real annoyance, regardless of the security
implications.

As a point of comparison plan9 does not have that restriction.

Eric

