Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYHOFL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYHOFL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 01:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYHOFLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 01:11:18 -0400
Received: from jade.aracnet.com ([216.99.193.136]:37609 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYHOFLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 01:11:17 -0400
Message-ID: <48A50FBF.40500@BitWagon.com>
Date: Thu, 14 Aug 2008 22:10:23 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AT_EXECFN not useful
References: <48A46831.7030606@redhat.com>
In-Reply-To: <48A46831.7030606@redhat.com>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> I've just removed the support for AT_EXECFN again from glibc.  The
> information isn't useful because the path name isn't normalized.  I.e.,
> it's not the actual binary path if symlinks are followed during the
> resolution.  This makes it unusable for the $ORIGIN handling.

AT_EXECFN does provide one actual path, namely the one that was passed
to namei.  This path works for some uses and some cases, including some
uses and some cases of $ORIGIN.  The path which sometimes is revealed
by readlink("/proc/self/exe",) also works for some uses and some cases,
including some uses and some cases of $ORIGIN.  Neither /proc/self/exe
nor AT_EXECFN works for all uses and all cases.

> This is on top of the problem with relative paths.

Please provide a statement or citation which describes "the problem with
relative paths."

> Unless somebody has another use case where this is useful I suggest
> removing AT_EXECFN support again.  It's just superfluous work and memory
> use.

AT_EXECFN is useful when readlink("/proc/self/exe",) disappears
yet the actual pathname that was passed to execve() still is accessible.
Users of the UPX program compressor (http://upx.sourceforge.net) have
asked for such a feature several times.  The UPX runtime decompressor
creates an address space which is difficult to distinguish from
the address space which would result from an execve() of the original,
uncompressed file.  In particular, the UPX runtime decompressor unmaps
all pages of the compressed file, which triggers the removal of the /proc/self/exe
symlink.  As a palliative, UPX records readlink("/proc/self/exe",) in an environment
variable.  If the UPX decompressor is not the first to run after execve(),
then this palliative can fail in the same way.

One time-honored use of "the path that was specified to execve"
is to lookup the debug symbol table for the current main program
(for example in catching SIGSEGV and filing an automatic bug report with
traceback information) under some time-honored schemes for static binding.
Another use is to consult a default static database which has been appended
to the executable itself (usually with an index near the end of the file.)
Although such usage can be defeated, nevertheless in practice many installations,
applications, and users successfully avoid the problems.  In particular,
uses which do not depend on visiting other directories often work just fine.

AT_EXECFN is useful in documenting the kernel's actual behavior of
putting the pathname argument to execve() into the new address space.
Having a designated slot in the the aux vector also provides a convenient
place for a virtualizer to adjust and communicate this path in ways that
are appropriate to the virtualization.

> Of course I wouldn't object to a real implementation which always gives
> me the full, normalized path name of the executable...

Multiple hard links create multiple normalized path names, possibly including
paths that have the same endpoints but which differ in arc length.  Which
of these multiple paths is to be blessed as "the full, normalized path"?

The case of mounting another filesystem on top of an intermediate directory
in "the path to the executable" may cause there to be zero "full, normalized
path name"s to the current main executable.
Depending on the relationship of mount point, working directory, pathname to
execve, and the text which surrounds $ORIGIN, then a simplistic method of
textual select+concatenate may succeed despite the failure of a method
involving detailed normalization.

These cases illustrate that there can be problems in asking for too much
when dealing with $ORIGIN.  AT_EXECFN provides some actual historical data
that may be useful as a hint, especially when the kernel drops the
/proc/self/exe symbolic link.  This hint is enough for some current use cases.

-- 
John Reiser, jreiser@BitWagon.com
