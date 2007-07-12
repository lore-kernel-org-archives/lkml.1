Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXGLSRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXGLSRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXGLSRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:17:13 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:26640 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755499AbXGLSRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:17:12 -0400
X-YMail-OSG: 172gTlwVM1kOHfE8H60YHvnoLZUYYAgZIgc5vPZOw5RHNeBgOj1L.twAWeYiOivaNNB6yvcaJ43PHTvtqpIt08FUU8IBTirta.m749HLTfsdwnf5Av4-
Date: Thu, 12 Jul 2007 13:17:08 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Zeus =?iso-8859-1?Q?G=F3mez?= Marmolejo <zeus@aluzina.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New LSM security operation
Message-ID: <20070712181708.GA28760@vino.hallyn.com>
References: <4695A225.6050807@aluzina.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4695A225.6050807@aluzina.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Zeus Gómez Marmolejo (zeus@aluzina.org):
> Hi people,
> 
> I've looked around on how to hide inodes in a Linux filesystem but 
> surprisingly the kernel lacks this functionality. It would be desirable 
> for me to add an ACL to a file in order not to be seen in the directory 
> contents but only for some users.
> 
> Some Selinux experts point out that the correct way to do this is via 
> poly-instantiated directories such as /tmp or /var/tmp, so each user 
> "view" his own version of this directory. But that's not what I want, 
> for example in /etc, I would want to hide some directories or files for 
> some users. I don't want a whole /etc instantiation for each user logged in.
> 
> Also, there is a patch called LIDS that does the thing, but patching the 
> whole kernel and adding much extra functionality such as intrussion 
> detection system as it is. Some rootkits -like adore- also can hide 
> inodes, but changing the owner to an uid that the kernel module hides 
> from the system call. I don't thing this is a good approach...
> 
> For me, the correct way to achieve this is to add an extra op in the 
> "security_operations" struct, as an inode operation. With this, a 
> Mandatory Access Control system that uses LSM such as SELinux can add 
> some policies on the "list" file access vector.

That's how it is often done elsewhere, but (at least until now) the
correct way to achieve this in Linux is to make use of either
per-process namespaces or chroots.  For example, either create custom fs
trees for each user under /share/ and chroot user hallyn under /share/hallyn
upon login, or, upon login, create a new mounts namespace and massage
the fs tree there.

For persistant filesystems, you can of course keep custom versions of
the filesystems in hidden directories.  I.e. under /tmp/ you could
keep /tmp/.priv/hallyn, and, when hallyn logs in, do
	mount --bind /tmp/.priv/hallyn /tmp
or if you're going the /share route, just do
	mount --bind /share/hallyn/tmp/.priv/hallyn /share/hallyn/tmp
while setting up your trees after boot.

For procfs and sysfs, the containers (specifically process id namespaces
and network namespaces) are starting some of the work to support
showing only authorized data to containers.

-serge

> So, I'd call this hook in the vfs_readdir() syscall just after the "file 
> <http://lxr.linux.no/ident?i=file>->f_op->readdir()" -the particular 
> filesystem readdir()- and walk through the list to ask for each inode if 
> it has permission to be "listed" in that directory. Then, the MAC system 
> can handle the grant or deny permission per inode, and then return the 
> "modified" list to userspace.
> 
> I'm not sure if this is the correct way, or maybe it adds to much 
> overhead to the "ls" command, but I'd like to hear some opinions, I can 
> try to code it and summit a patch...
> 
> Thanks for your answer,
> 
> Zeus Gómez.
> PS. Please, include me in the CC if you reply this message.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
