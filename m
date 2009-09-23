Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZIWUrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZIWUrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZIWUrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:47:07 -0400
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:27833 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751377AbZIWUrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:47:07 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: xJD19QcVM1mUawPFRVDe1SzNayt0XPOJG.WWZHi8BaG3qKKgG.FObUTxx5u1SDzxV0LRFwHpruqnO6HVnSSTOb1UFGEE2cDBdvVEXSRS6qqTsZ16xSsH8M25tXqbNP31cwhTWtBK0rVrZw9IgtUTvdZPorp.rP_camhS8dUMIRMiwCi5STVKeG414n3x7ag_B8BnUhyxTZ0YEaSozKSo94TynheCsP6FZxWLkhmNfr0T_3qjL6oyNLS0PXx1.yAvZGpPrgqbG..WHuSpx.VKUIGnVhSxdaPWcOZ.dd5NmkqdeQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4ABA892A.9090804@schaufler-ca.com>
Date: Wed, 23 Sep 2009 13:46:34 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: andy753421@gmail.com
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Privilege dropping security module
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
In-Reply-To: <20090923005644.GA28244@c.hsd1.tn.comcast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer wrote:
> I started work on a Linux Security Module called dpriv a few days ago
> and would like to get some feedback. It's by no means ready to be
> included in the kernel, but I'm sure there are many things that I could
> have done better so suggestions are welcome.
>   

Hi Andy. Git is a wonderful tool, but if you want people to review
your work you need to post patches.

> The code is available from gitweb and the dpriv branch of my tree:
>
>   git://lug.rose-hulman.edu/~spenceal/linux-dev dpriv
>
>   http://lug.rose-hulman.edu/git/?p=~spenceal/linux-dev;f=security/dpriv;hb=refs/heads/dpriv
>
>
> I'll start off with a quick FAQ
> -------------------------------
> Q: Why another LSM, don't we have enough already?
> A: As far as I know there are several rather unique things about dpriv
>    when compared to other LSMs. (it's also been a good way for me to
>    familiarize myself with the kernel)
>
> Q: So what's unique about dpriv?
> A: - Dpriv can be used by any user, not just by root
>    - The "policy" is created at runtime instead of fixed beforehand
>    - It does *not* implement Mandatory Access Control
>   

A good thing, or at least, a partial answer to #1.

>
> Now for how it works
> --------------------
> - Everything is controlled though a securityfs interface which consists
>   of three files: "stage", "policy", and "control".
>
> - Policies are created by writing lines to the stage file and then
>   writing the "commit" command to the control file. "Committing" the
>   policy merges the staged policy into the actual policy (the "policy"
>   file). Note that privileges can only be dropped during a commit, and
>   afterwards there is no way to get them back.
>
> - Policies are effective for the process which created them and are also
>   copied to all it's child processes.
>
> - For example, the following commands will set the root filesystem
>   read-only with the exception of allowing execute permission in /bin/
>   and write permission in /tmp/. (note that directory permission are
>   uppercase and file permissions are lowercase, both are recursive)
>
>   $ echo r--R-X /    > /sys/kernel/security/dpriv/stage
>   $ echo r-xR-X /bin > /sys/kernel/security/dpriv/stage
>   $ echo rw-RWX /tmp > /sys/kernel/security/dpriv/stage
>   $ echo commit      > /sys/kernel/security/dpriv/control
>
>   

And what do you propose as an interesting use case for dpriv?

> And some technical details
> --------------------------
> (subject to change)
>
> - Dpriv stores a list of active and staged permissions for each process
>   in current->cred->security. Each permissions line consists of a mode
>   mask and the inode that it is effective for.
>
> - When determining access rights for an inode: if the inode is in the
>   list of active permissions, use that mask, else recursively fetch (and
>   merge) the permissions from the inodes parents
>
>   (to do this, all the parents for hard links/mounts will need to be
>   known and stored in the inode somehow, possibly using extended
>   attributes, I haven't completely worked this out yet)
>
> - Permissions for things other than files could be implemented as well,
>   but I haven't started working on those either.
>
>
> Let me know what you think
>   

