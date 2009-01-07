Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZAGODm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZAGODm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZAGODe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:03:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZAGODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:03:33 -0500
Date: Wed, 7 Jan 2009 14:03:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Beulich <jbeulich@novell.com>
Cc: ccache@lists.samba.org, "Theodore Ts'o" <tytso@mit.edu>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107140328.GV28946@ZenIV.linux.org.uk>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090107051027.GU28946@ZenIV.linux.org.uk> <49647A9E.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49647A9E.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 08:49:18AM +0000, Jan Beulich wrote:
> >>> Al Viro <viro@ZenIV.linux.org.uk> 07.01.09 06:10 >>>
> >On Tue, Jan 06, 2009 at 10:15:26AM -0500, Theodore Ts'o wrote:
> >> Or, if that's too complicated, maybe it would be worthwhile to have
> >> kbuild create its own specialized ccache system?  Note that the last two
> >> solutions rule out using distcc, unless we can encapsulate the build
> >> process from a series of Makefile macros to a shell or C program, which
> >> could then be injected to the remote host system to be executed by
> >> distcc.  One value of doing that is the CRC or MD5 of the shell script
> >> could be used as the version tag for the cache system.
> >
> >Ho-hum...  Could somebody explain why the hell had we switched to this
> >"intermediate .s" approach, anyway?  It's not as if we couldn't run
> >objcopy after what we used to do...
> 
> Because objcopy wouldn't remove the __crc_* symbols the way the
> object files were generated previously. I explored all possibilities I could
> think of, with that two step process being the last, but the only one that
> had the intended effect. In the end I queried the binutils list, and got
> confirmation that there's no (existing) way to get rid of symbols used in
> relocations in an already existing object file without corrupting it.

I do not understand two things.
	a) WTF would we care about ones in vmlinux, when kallsyms drops the
absolute ones anyway?
	b) is there any reason why we can't copy symbol table out of module
ourselves (instead of setting SHF_ALLOC on it) and trim the crap out of
it?  Note that __crc_... is not the only junk in there - you don't need
(or want) to keep the things like undefs for /proc/kallsyms purposes.
And modules *using* an exported symbol are more common that modules exporting
one...  Why not copy it at add_kallsyms() time, skipping the junk we don't
want anyway?
