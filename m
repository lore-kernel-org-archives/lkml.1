Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbXH1NAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbXH1NAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 09:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXH1NAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 09:00:38 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58292 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbXH1NAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 09:00:36 -0400
To: mrmacman_g4@mac.com
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 14/15] Conditional permission support.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <46CED214.6050505@gmail.com>
	<46CED5C6.8050501@gmail.com>
	<20070825110825.GB5850@ucw.cz>
	<200708261113.JHH03043.VQOtSOJLFFFHMO@I-love.SAKURA.ne.jp>
	<60BDD3AF-A5BD-4076-922E-40E629D7CBFA@mac.com>
In-Reply-To: <60BDD3AF-A5BD-4076-922E-40E629D7CBFA@mac.com>
Message-Id: <200708282200.HGG00985.VtOOOFFMJFSHQL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Tue, 28 Aug 2007 22:00:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kyle Moffett wrote:
> This is probably not acceptable; I doubt there's a chance in hell
> that TOMOYO will get merged as long as it has text-based-language
> parsing in the kernel.  You also have $NEW_RANDOM_ABUSE_OF_PROCFS and
> $PATH_BASED_LSM_ISSUES.  See the long flamewars on AppArmor for
> discussion on the latter.

Thank you for your comment.

Regarding /proc/tomoyo , this is not a big problem.
It will be possible to create a dedicated filesystem
after all other remaining problems are solved.

Regarding text-based-language parsing in the kernel,
it might be possible to use compiled policy.

So, let me explain pitfalls of path based access controls and
how TOMOYO Linux avoids these pitfalls.
Since problems of pathname based access control is scattered around,
I can't find all problems. But as far as I can see, it seems to me that
they are confusing userland-specific problems and kernel-specific problems
/ white-listing approach and black-listing approach.



Q1: Not all objects have pathnames!

A1: What TOMOYO Linux does is use pathnames
    that are accessible via filesystem's mount tree.
    TOMOYO Linux does not deny labeling on objects
    that are not accessible via filesystem's mount tree.
    Although it is not implemented yet; it's a future work.
    I need to reduce my burden of catching up with the latest kernels.

Q2: Pathname based access control is bypassed by creating hard links!

    Suppose an administrator wants to forbid access to /etc/shadow .
    Regarding pathname based access control, one can access to /etc/shadow
    by creating hardlinks to /tmp/shadow . Regarding label based access control,
    one can't access to /etc/shadow by creating hardlinks to /tmp/shadow
    because /tmp/shadow keeps the same label with /etc/shadow .

A2: Do you think you need to allow creating hardlinks of /etc/shadow
    to /tmp/shadow ? I don't think so.
    Such operation is not needed for systems to operate properly.

    Thus, TOMOYO Linux forbids creating hardlinks of /etc/shadow
    to /tmp/shadow from the beginning.
    TOMOYO Linux handles pathnames carefully.
    TOMOYO Linux checks for both link-source and link-target together.
    One can't do "ln /etc/shadow /tmp/shadow" unless the administrator
    explicitly give "allow_link /etc/shadow /tmp/shadow" permission.

    The essential combinations of link-source and link-target are not infinite
    and TOMOYO Linux allows only essential combinations to minimize the risk of
    bypassing pathname based access control.

    Please remember, TOMOYO Linux is white-listing and system-wide
    access control.
    It's black-listing's approach that denies access to /etc/shadow
    but allows access to /tmp/shadow .
    White-listing approach will not allow access to
    /tmp/shadow unless explicitly given.
    TOMOYO Linux can apply access control including login session.
    One can't do "ln /etc/shadow /tmp/shadow" unless the administrator
    explicitly give "allow_link /etc/shadow /tmp/shadow" permission.

Q3: Pathname based access control is bypassed by renaming files!

    Suppose an administrator wants to forbid access to /etc/shadow .
    Regarding pathname based access control, one can access to /etc/shadow
    by renaming to /tmp/shadow . Regarding label based access control,
    one can't access to /etc/shadow by renaming to /tmp/shadow
    because /tmp/shadow keeps the same label as /etc/shadow .

A3: Do you think you need to allow renaming /etc/shadow to /tmp/shadow ?
    I don't think so.
    Such operation is not needed for systems to operate properly.

    Thus, TOMOYO Linux forbids renaming /etc/shadow to /tmp/shadow
    from the beginning.
    TOMOYO Linux checks for both old-name and new-name together.
    One can't do "mv /etc/shadow /tmp/shadow" unless the administrator
    explicitly give "allow_rename /etc/shadow /tmp/shadow" permission.

    The essential combinations of old-name and new-name are not infinite
    and TOMOYO Linux allows only essential combinations to minimize the risk of
    bypassing pathname based access control.

    You might worry that /etc/shadow can be renamed to /tmp/shadow between
    the moment the kernel got "dentry" and "vfsmount" from /etc/shadow and
    the moment TOMOYO Linux obtains a pathname from "dentry" and "vfsmount".
    Yes, the possibility is not zero.
    But TOMOYO Linux is white-listing and system-wide access control.
    TOMOYO Linux allows only essential combinations of renaming requests.
    Thus, renaming /etc/shadow to /tmp/shadow will not happen
    unless the administrator explicitly give
    "allow_rename /etc/shadow /tmp/shadow" permission.

Q4: Pathname based access control is bypassed by creating symbolic links!

    Suppose an administrator wants to forbid access to /etc/shadow .
    Regarding pathname based access control, one can access to /etc/shadow
    by creating symbolic links from /tmp/shadow to /etc/shadow .

A4: This is because you are using pathnames before resolving symbolic links
    for access control, and this is a problem of performing access control
    at userland level.
    What TOMOYO Linux deals is performing access control at kernel level.

    In the kernel, a pathname is converted into "dentry" and "vfsmount".
    And one can get a pathname without symbolic links, ".", "..", "//"
    by traversing "dentry" and "vfsmount" upward.
    Thus, even if one requests access to /tmp/shadow , TOMOYO Linux will think
    that /etc/shadow is requested.
    Therefore, TOMOYO Linux will not allow access to /etc/shadow
    using a symbolic link /tmp/shadow .

Q5: Pathname based access control is poor at handling random names.

    Suppose an administrator wants to perform access control for temporary files
    created in /tmp/ directory. Since temporary files has random names,
    the administrator has to grant very wide access permission like /tmp/* .

A5: Do you think the administrator has to give such a wide permission?
    I don't think so.

    Most temporary files has some prefix.
    Thus, the administrator seldom need to grant whole permission like /tmp/* .
    If there is no prefix, it is easy to modify the source code to use prefix.
    Also, you will be able to switch the location of temporary files
    using environment variables like TMP/TEMP and/or config files of application
    to e.g. ~/tmp/ directory.

Q6: Pathname based access control is bypassed by namespace manipulation!

    a) One can change the location of a file using mount() operation.
    b) One can change the location of a file using pivot_root() operation.
    c) Each process can have different namespace.
    d) Process can access files outside chroot jail
       if chroot() operation failed.

A6: Not so regarding TOMOYO Linux.

    a) TOMOYO Linux checks combination of mount_device, mount_point, filesystems
       for mount operation. This is what [TOMOYO 11/15] is doing.
       Thus, one can't do "mount --bind /etc/ /tmp/" unless the administrator
       explicitly give "allow_mount /etc/ /tmp/ --bind 0" permission.

    b) TOMOYO Linux checks combination of old_root and new_root
       for pivot_root() operation (although pivot_root() is seldom used
       after /sbin/init starts).
       Thus, one can't do "pivot_root / /tmp/" unless the administrator
       explicitly give "allow_pivot_root / /tmp/" permission.

    c) Even if each process can have different namespace,
       it is restricted by mount()/pivot_root() checking.
       Thus, one can't freely create his/her own namespace.

    d) TOMOYO Linux uses absolute pathname that is not affected by chroot()
       (this is what [TOMOYO 04/15] is doing).
       Pathnames derived by traversing upward up to the root of process's
       namespace are used in TOMOYO Linux. It is not a process's root directory.
       Thus, permissions are given using pathnames starting from outside
       the chroot jail.

Q7: Pathnames don't contain owner's information.

A7: Yes, it is true. But there is no rule that pathname-based access control
    must not use anything but pathname.
    In fact, TOMOYO Linux allows the administrator use inode's uid/gid/ino
    information in addition to pathnames (this is what [TOMOYO 14/15] is doing).

Q8: LSM hook functions are not receiving vfsmount parameter!

A8: Exactly. It is a painful thing for TOMOYO Linux too.
    [TOMOYO 13/15] scans namespace list for matching vfsmount for given dentry.

    Since vfsmount is not added to LSM hook functions yet, the development of
    TOMOYO Linux 1.5.x (non-LSM version of TOMOYO Linux which can coexist with
    SELinux and AppArmor) has been continued.
    http://tomoyo.sourceforge.jp/en/1.5.x/



I'll be offline for days because of summer vacation.
Therefore, I can't respond soon. Please be patient.

Regards.
