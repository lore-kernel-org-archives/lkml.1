Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZAGNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZAGNjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZAGNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:39:13 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:32381 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZAGNjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:39:12 -0500
Message-Id: <4964BEAA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 13:39:38 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Theodore Tso" <tytso@mit.edu>, "Sam Ravnborg" <sam@ravnborg.org>
Cc: <ccache@lists.samba.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <20090107131221.GA17110@mit.edu>
In-Reply-To: <20090107131221.GA17110@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Theodore Tso <tytso@mit.edu> 07.01.09 14:12 >>>
>objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation

Another thing I've never seen in any of my builds - these strings always
get relocations against the corresponding section symbol.

>So because it can't safely strip __ksymtab_strings it returns a
>non-zero exit status, and doesn't do anything at all, and then the cp
>command doesn't do any stripping whatso ever.
>
>I could fix this by patching Makefile and scripts/Makefile.modist to
>do this instead:
>
># objcopy --strip-debug --wildcard --strip-symbols /usr/projects/linux/linux-2.6/scripts/strip-symbols fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko  || (cp fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko ; strip --strip-debug /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko)

I'd rather insert a second objcopy attempt here with just --strip-debug.

>... but at this point, is there going to be any massive downside if I
>just revert commit ad7a953c?  Quite frankly, it's causing me a huge
>amount of trouble, and I'm still a bit unclear what the upside of this
>patch is.  As near as I can tell there is *single* __crc_ symbol in
>xfs.ko which all of this rigamorale is doing to strip out.  From what
>I can tell, not quite doubling the compile time when fully cached by
>ccache, causing INSTALL_MOD_STRIP to fail randomly so that the
>installed modules are a factor of 4 larger, compromising the amount of
>space in my root partition, is all to remove a handful of __crc_*
>symbols from the generated .ko file?

With this and the previous issue I certainly wouldn't mind this and the
subsequent vmlinux stripping patches to be reverted, and I'd aim at
providing an improved version for .30.

>What am I missing?  Why is stripping the __crc_* symbols so
>gosh-darned important?

In a separate response I already explained what the goal here is - size
reduction (i.e. making distro package sizes as well as foot print on disk
smaller, thus improving the already existing stripping). And it's not only
about __crc_*, those are just the ones that when removed have the
biggest overall effect. And, as pointed out above, the vmlinux stripping
patch, which has an even more significant effect as it reduces the in-
memory kernel size when using KALLSYMS_ALL, depends on this one.

I have to admit that I generally dislike the tendency for everything to
always only grow, and hence I'm trying to find opportunities to shrink
stuff where possible. I've got a couple of other patches in my local
queue that also aim in that direction, plus there are a few thoughts on
improvements beyond that.

Jan

