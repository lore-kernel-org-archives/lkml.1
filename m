Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbYHRPGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbYHRPGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYHRPGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:06:03 -0400
Received: from jade.aracnet.com ([216.99.193.136]:35785 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYHRPGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:06:01 -0400
Message-ID: <48A98F62.6050707@BitWagon.com>
Date: Mon, 18 Aug 2008 08:04:02 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: AT_EXECFN not useful
References: <48A46831.7030606@redhat.com> <48A50FBF.40500@BitWagon.com> <48A61878.2060000@redhat.com>
In-Reply-To: <48A61878.2060000@redhat.com>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> John Reiser wrote:
> 
>>>AT_EXECFN does provide one actual path, namely the one that was passed
>>>to namei.  This path works for some uses and some cases, including some
>>>uses and some cases of $ORIGIN.
> 
> 
> It is not possible to use the raw path provided.  One _always_ would
> have to canonicalize the path (call realpath etc).  That's terribly
> expensive and it requires that nothing in the path hasn't changed.

It certainly is possible to use the path provided.  If an application
is installed with the main program in  ./app_dir/bin/my_app , and DT_NEEDED
shared library libmy_lib.so in  ./app_dir/lib/libmy_lib.so.1.0 , and link
libmy_lib.so -> libmy_lib.so.1.0 , and if DT_RUNPATH contains  $ORIGIN/../lib ,
and if the main program is invoked via execve("./app_dir/bin/my_app",,);
then the shared library may be accessed using AT_EXECFN via:
   open("./app_dir/bin/../lib/libmy_lib.so.1.0",)
which does not require any canonicalizing of the path [use of realpath, etc.]
It also does not require the success of readlink("/proc/self/exe",).

>>>The path which sometimes is revealed
>>>by readlink("/proc/self/exe",) also works for some uses and some cases,
>>>including some uses and some cases of $ORIGIN.
> 
> 
> The information is always correct when it is provided.

readlink("/proc/self/exe",) succeeds yet the provided path fails,
if a mount is performed on top of an intermediate directory in that path.
Also, readlink("/proc/self/exe",) returns only one of the paths
which may apply to an executable that has multiple hard links.  The paths
may not all be equivalent for the purpose of resolving $ORIGIN, particularly
because they may involve differing numbers of directory components.
This can affect the result if $ORIGIN involves evaluating any ancestor
directory of the executable file.

>  If the file goes
> away then the AT_EXECFN use case also fails since realpath fails, or
> worse, provides wrong data since it's using newer files.

As shown above, using AT_EXECFN need not require calling realpath.
Also, some administrators can provide an external guarantee that the files
may not be overwritten [read-only file system, restrictive permissions,
etc.], some programs have their own internal consistency checks,
the usage may be constrained by convention (shell script wrapper, etc.),
and some users are willing to live with any remaining uncertainties.

>>>Neither /proc/self/exe
>>>nor AT_EXECFN works for all uses and all cases.
> 
> 
> The only case where AT_EXECFN has an advantage is when /proc isn't
> mounted.  

As shown above, AT_EXECFN also may have an advantage when the kernel
drops /proc/self/exe, even when /proc is mounted.

> That's not supported anyway because this is the only way for
> many things how the kernel exposes data (sysctl is deprecated) and we
> need this information in many places.

>>>Please provide a statement or citation which describes "the problem with
>>>relative paths."
> 
> 
> If the program is started via a relative path AT_EXECFN has this string.

A single fact by itself never can be a problem.  A problem requires a
contradiction that involves two or more facts, or a discrepancy between facts
and expectations.  What expectations regarding $ORIGIN does a relative path
not fulfill, and where and why do these expectations arise?

>>>AT_EXECFN is useful when readlink("/proc/self/exe",) disappears
> 
> 
> As said above, in that case it isn't useful either because one cannot
> verify the value.

Perhaps glibc cannot verify the value, so that may be a reason to avoid
the value in the case of suid/sgid execution.  In other cases an administrator
or user may provide verification external to glibc, or the application
itself performs internal verification, or an administrator provides appropriate
guarantees, or users accept the risks directly, or usage which requires
that parent directory name "../" work when backing up into a symbolic link
is just an error on the part of the usage or design of the installation
of the application software.

> I've removed all support for AT_EXECFN and won't put it back since there
> is no use case where it has any advantage.  realpath() is terribly slow.

AT_EXECFN provides an advantage for users of UPX executable compression,
where the kernel drops the link /proc/self/exe because the runtime decompressor
unmaps all pages of the original executable, yet the rest of the environment
is unchanged.  AT_EXECFN provides the first documentation for long-standing
kernel behavior.  More generally, AT_EXECFN provides a supported mechanism
for cooperation between a virtualizer and its subject programs.  These are
sufficient reasons for adding AT_EXECFN, regardless of whether glibc
chooses to use AT_EXECFN.  As shown above there are cases where users would
benefit if glibc did use AT_EXECFN, if nothing other than as a second chance
when readlink("/proc/self/exe",) fails.

-- 
John Reiser, jreiser@BitWagon.com
