Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbXE1Wac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbXE1Wac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762148AbXE1WaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:30:07 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33691 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbXE1WaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:30:04 -0400
Message-ID: <465B57D7.2040101@novell.com>
Date: Mon, 28 May 2007 15:29:43 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Cliffe <cliffe@iinet.net.au>
CC: casey@schaufler-ca.com, Kyle Moffett <mrmacman_g4@mac.com>,
       linux-security-module <linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <465AE46B.4090109@iinet.net.au>
In-Reply-To: <465AE46B.4090109@iinet.net.au>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cliffe wrote:
> The following would be used in conjunction with a pathname based
> confinement to try to provide some assurances about what a path refers
> to.
>
> "/etc/shadow" is a name to a sensitive resource. There is no guarantee
> that there are not other ways to access this resource. For example a
> link "/etc/shadowlink" or a rename to "/etc/shadownewname"
>
> Pathname based security has various advantages (such as the ability to
> have more readable and centralised policies by describing resources in
> terms of their pathnames) but the above is clearly a problem (if
> confidentiality or integrity of a specific resource is important).
>
> Could we find a way to make paths a more reliable mechanism by
> labeling the file data with a simple description of names it is
> allowed to be accessed with?
>
> If we want "/etc/shadow" to be the only way to access the shadow file
> we could label the data with "/etc/shadow". Any attempts to access
> this data using a renamed file or link would be denied (attempts to
> link or rename could also be denied).
Eloquently put.

AppArmor actually does something similar to this, by mediating all of
the ways that you can make an alias to a file. These are:

    * Symbolic links: these actually don't work for making aliases with
      respect to LSM-based security systems such as AppArmor, SELinux,
      and TOMOYO Linux, because the symbolic link is resolved before the
      access request is presented to the LSM hooks. So if you create the
      symbolic link /tmp/harmless -> /etc/shadow and then the confined
      victim tries to access /tmp/harmless, what the LSM sees is an
      attempt to access /etc/shadow.
    * Hard links: AppArmor explicitly mediates permission to make a hard
      link to a file. To be able to make a hard link /tmp/harmless ->
      /etc/shadow you have to have explicit permission to do so, or the
      attempt to make the link is blocked. This mediation is kept
      relatively simple by the fact that you can only hard link to
      files, and not to directories.
    * Multiple mounts: Linux lets you mount the same file system
      multiple times at multiple mount points, so the same file could
      appear at two different places. AppArmor has very coarse mediation
      here, and simply prohibits all calls to mount() without special
      permission. So only highly privileged processes can create such an
      alias.
    * Name spaces: Linux name spaces present a similar issue, and
      AppArmor's coarse blocking of mount() serves the same function;
      only highly privileged processes are permitted to create name spaces.


> We could label a document with "/home/me/documents/*". Then the
> document could be linked or renamed within that specified directory.
We are thinking about something kind of like this for finer-grained
mediation of mount(). Currently it is all-or-nothing; we either totally
block the ability to create aliases with multiple mount points or name
spaces, or we totally trust the process with permission to do what it
likes with multiple mount point and name space aliases.

What we want is a more nuanced mediation of mount point and name space
manipulation, so that you can write a spec that says "/tmp/* can be
aliased any way you like, but /etc/shadow cannot be aliased at all" or
something like that.

However, not much work has been done on this, because at the moment the
AppArmor team is concentrating on making the code for current
functionality acceptable for upstreaming.

> Obvious problems with this solution:
> * it seems hard to determine what the label should be set to (setting
> it to "*" would be tempting and completely negate the whole thing,
> while setting it to the current filename would often be too restrictive).
This is equivalent to the question of what kind of access to grant to
the data. I don't see it as really difficult. What is harder is that the
specification has to specify what you can alias, and where it can
appear, and dealing with the two factors tends to make one's head hurt.

I am reminded of the pithy quote "Noalias must go. This is not
negotiable" -- Dennis Ritchie, referring to a proposed 'noalias' type
qualifier in ANSI C http://www.lysator.liu.se/c/dmr-on-noalias.html

Mediating permission to make aliases is complicated :(

> * when files are created these labels need to be created, and they may
> need to be changed.
.. if you use the approach of labeling the files :) In fact this
problem is general: label-based security has a hard time dealing with
new files in general, not just with respect to permission to create
aliases. The security policy for a newly created file is determined by
the label on the file, and so labeling new files is critical. SELinux
uses a variety of smart heuristics to decide the label of a new file:

    * the label of the parent directory
    * the label of the creating process
    * the domain for the creating process can do conditional things
      based on the label of the parent directory and the creating process
    * applications that link to libselinux can overtly set the label
      according to application logic

AppArmor, not using labels, doesn't have this problem. You can write an
AA profile with respect to files and directories that don't exist at all.

> * if this type of solution requires significant additional management
> (as it seems to) it is probably not a suitable addition to a pathname
> based confinement mechanism.
As I explained above, a lot of it is already in place with our mediation
of hard links. Our mediation of multiple mount points and name spaces is
lame, but the extent to which this needs to be improved will largely be
determined by how application developers choose to use these features.
Because AppArmor is intended primarily to confine applications, an
administrative approach of just using unconfined (completely trusted)
shells to manipulate name spaces and multiple mount points suffices, and
application manipulation of name spaces and multiple mount points is the
only concern.

> * A program creating a new file and copying the contents of the file
> is outside of the scope of this solution.
That is the information flow problem. While important, it is fairly
separate from the alias problem. The information flow problem is general
to all access control systems, while the alias problem is special to
name-based access control systems.

This is one of the name/label trade-offs. Aliasing is problematic in
name based systems, while new file creation is problematic in label
based systems. This follows directly from the semantics each system is
using:

    * Names are references. Name based systems are really mediating
      access to references. Thus creating new references and who can
      access these new references is problematic.
    * Labels are equivalence classes of objects. Label based systems are
      really mediating access to objects, regardless of the reference.
      Thus creating new objects and who can access these new objects is
      problematic.


> * Stoping a path from pointing to arbitrary data is also outside the
> scope of this solution (for example "/etc/shadow" could be replaced
> with another file).
This depends on where you place the "may alias" access control. You can
put it on the source (/tmp/harmless -> somewhere) on the target
(somewhere -> /etc/shadow) or somewhere else (what AppArmor does,
associating the policy with confined processes).

> Could a name based policy include the pathname as well as an inode
> number or some (more secure) identifying attribute (which could be
> calculated based on the supplied pathname)? A one-way-hash would
> identify but could not be used for each file a program accesses as
> they can change...
It could be done, but that has implications. That would mean that you
get the "belt and suspenders" effect of all of the security benefits of
(say) AppArmor and SELinux. But the non-overlapping security benefits
are relatively small (SELinux advocates may dispute this, but whatever,
it is some magnitude). On the other hand, you would get the management
problems of both AppArmor and SELinux; you would have to solve both the
new file problem, and the file alias problem. Think about what you would
have to do to accommodate (say) a text editor's file save procedure of
"write new file.tmp, rename oldfile to oldfile.old, rename newfile.tmp
to oldfile, delete oldfile.old".

So it could be done, but AFAICT, with small benefit and large cost. More
security may be more secure, but it isn't necessarily better.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
		   Security: It's not linear

