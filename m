Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXFOClS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXFOClS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXFOClH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:41:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:4346 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbXFOClG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:41:06 -0400
X-Greylist: delayed 3669 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 22:41:05 EDT
Message-Id: <200706150139.l5F1dgEd020323@www262.sakura.ne.jp>
Subject: Re: [RFC] TOMOYO Linux
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: James Morris <jmorris@namei.org>
Cc: Rik van Riel <riel@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Toshiharu Harada <haradats@nttdata.co.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Toshiharu Harada <haradats@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 15 Jun 2007 10:39:42 +0900
References: <466FA71C.1020309@nttdata.co.jp>  <1181743635.17547.350.camel@moss-spartans.epoch.ncsc.mil> <9d732d950706130722g12a22604p223381a8e281a4a1@mail.gmail.com> <46704D49.8010308@redhat.com>  <9d732d950706131435s636b852di98026aed1d9a6ac6@mail.gmail.com> <467064B9.1080005@redhat.com> <9d732d950706131525n667587e6t59e94c5cee951c6d@mail.gmail.com> <Line.LNX.4.64.0706131835040.13360@localhost.localdomain>
In-Reply-To: <Line.LNX.4.64.0706131835040.13360@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

James Morris wrote:
> Note that while SELinux does also have a similar capability with the 
> audit2allow tool, it should be considered an expert tool, the output of 
> which needs to be understood before use (as noted in its man page).
Yes, adding "allow" statement without understanding what the statement means
is dangerous.
But regarding TOMOYO Linux, "allow" statement that needs to be added
to grant requested access is quite easy for human to understand.
This helps administrator understand what will be allowed before allowing it.

For example, if "allow foo_t bin_t:execute" (sorry, I don't know proper
SELinux's policy syntax) statement is shown to an administrator,
he/she has to understand what programs belongs to bin_t before
adding this statement, for some files may be exposed (if /bin/cat is bin_t)
or some files may be deleted (if /bin/rm is bin_t).
But if "allow execute /bin/cat" statement is shown to an administrator,
he/she can easily understand what will happen because
only programs that are accessible via the pathname /bin/cat can be executed.

People assumes and expects that /bin/cat is a program that prints
the content of files, /usr/share/doc is a directory for shared documents,
/tmp is a directory for temporaly files and so on.
I know you worry about symlinks, chroots, bind mounts and private namespaces.
TOMOYO Linux solves all symlinks and traverses up to namespace's root
so that /bin/cat is exactly /bin/cat and nothing else
(e.g. /tmp/cat or /var/chroot/bin/cat, where /tmp/cat is a malicious program).
TOMOYO Linux restricts mount related operations to make sure
/bin is not a bind mount of /tmp and /bin/cat is not an alias of /tmp/cat .
TOMOYO Linux restricts modification of /bin/cat by not giving processes
write permission to /bin/cat unless needed.

TOMOYO Linux's way is respect pathnames and try to keep meaning of pathnames
unchanged as hard as possible so that the system can provide files
which poeple assumes and expects.

I know respecting pathnames will crash if the systems need complicated
namespace manipuration like shared subtree or overlay mounts.
For such systems, the only choice is label based access control.

But I think many systems don't need complicated namespace manipuration.
For such systems, both label based and pathname based access control
are possible choice.

> We have considered per-domain enforcing mode a couple of times in the 
> past, but figured that it could be implemented via policy alone (e.g. run 
> the task in a domain where all accesses are allowed and logged); and it 
> would also be of limited usefulness because of the aforementioned problems 
> with learning mode security policy.
If there were only "disabled" and "enforcing" modes,
per-domain enforcing mode would not be useful.
The development of TOMOYO Linux's policy starts from scratch
and builds up step by step for all domains.
If I use "enforcing mode but allows everything" approach,
it becomes impossible to develop policy using "learning" and "permissive" modes
where some of domains are already in enforcing mode but the rests are not yet.
At least, per-domain enforcing mode is useful for TOMOYO Linux.

Thanks.
