Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYE0JRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYE0JRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYE0JQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:16:58 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:21632 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbYE0JQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:16:57 -0400
Message-ID: <483BD183.9010103@de.ibm.com>
Date: Tue, 27 May 2008 11:16:51 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
References: <48313E08.8070904@de.ibm.com> <20080522201724.cf4bd471.akpm@linux-foundation.org> <20080523171840.GD28257@cs181133002.pp.htv.fi> <20080523111707.89df9f67.akpm@linux-foundation.org> <20080523190950.GA32541@uranus.ravnborg.org>
In-Reply-To: <20080523190950.GA32541@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, May 23, 2008 at 11:17:07AM -0700, Andrew Morton wrote:
>> On Fri, 23 May 2008 20:18:40 +0300
>> Adrian Bunk <bunk@kernel.org> wrote:
>> 
>> > On Thu, May 22, 2008 at 08:17:24PM -0700, Andrew Morton wrote:
>> > > On Mon, 19 May 2008 10:44:56 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
>> > > 
>> > > > From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> > > > 
>> > > > Change all source and include paths to absolute form when
>> > > > CONFIG_GCOV_PROFILE is enabled.
>> > > > 
>> > > > Example:
>> > > > 
>> > > >   gcc -Idir1 -c a.c -o a.o
>> > > > 
>> > > > will become
>> > > > 
>> > > >   gcc -I/path/to/dir1 -c /path/to/a.c -o a.o
>> > > > 
>> > > > Required by the gcov profiling infrastructure: when compiling with
>> > > > option -fprofile-arcs, gcc stores file names inside object files.
>> > > > Relative paths prevent the gcov tool from finding corresponding source
>> > > > files.
>> > > 
>> > > I don't like this.  It converts the compiler error messages from
>> > > relative paths to absolute paths which is rather obnoxious when
>> > > all kernel developent is (or should be) base-directory-agnostic.
>> > 
>> > The compiler error messages are already absolute paths when using O=
>> > (see e.g. all error messages sent by me in recent years).
>> > 
>> 
>> Well I guess that's understandable with O=.
>> 
>> But I find it rather nasty.  (I guess it'd be less nasty if I were to
>> get off my butt and work out how to teach rxvt that "/" is a word
>> separator).
>> 
>> What do others think?
> 
> That the gcov tool has a bug if it insist on using absolute paths.
> And thus we should fix gcov and not workaround it in the kernel.

I've given this some more thought and came up with a possible
alternative solution that doesn't require paths to be absolute:

For a given source file x.c, gcov requires x.c (main source),
x.gcno (static coverage meta data) and x.gcda (dynamically created
coverage data) to work. x.gcno may refer to further source files. To
find these files the corresponding paths need to be either absolute or
gcov must be called from gcc's current working directory during
compilation (which always should be $(objtree)).

Currently these files are placed like this:

  sysfs:
    x.gcda
    x.gcno -> symbolic link to $(objtree)/rel/path/x.gcno
    x.c -> symbolic link to $(srctree)/rel/path/x.c

  objtree:
    x.gcno

  srctree:
    x.c

Instead, kbuild could be modified to create links to x.gcda in
$(objtree) like this:

  sysfs:
    x.gcda
 
  objtree:
    x.gcno
    x.gcda -> symbolic link to /sys/kernel/debug/gcov/rel/path/x.gcda

  srctree:
    x.c

gcov could then be called like this:

  cd $(objtree)
  gcov -o rel/path/ $(srctree)/rel/path/x.c

Would this be an acceptable approach? Also, for automated collection of
coverage data, there must be some algorithm to find the source file for
a given .gcda file. Is the assumption correct that the "rel/path/" part
is the same for $(srctree) and $(objtree), i.e. can the source file
be derived like this?:

    $(objtree)/rel/path/x.o -> $(srctree)/rel/path/x.c

Alternatively, kbuild could also create a link to x.c in $(objtree),
though I'm not sure if that wouldn't have side effects like e.g. naming
conflicts with generated .c files in $(objtree).
