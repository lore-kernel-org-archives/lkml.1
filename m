Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZAGNMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZAGNMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZAGNM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:12:27 -0500
Received: from THUNK.ORG ([69.25.196.29]:42120 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZAGNM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:12:26 -0500
Date: Wed, 7 Jan 2009 08:12:21 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107131221.GA17110@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kernel@vger.kernel.org, ccache@lists.samba.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LKDeQ-0002xz-7E@closure.thunk.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:15:26AM -0500, Theodore Ts'o wrote:
> The following commit, ad7a953c, "kbuild: strip generated symbols from
> *.ko" which was merged to the mainline last week (December 28th) has the
> unfortunate side effct of making ccache useless.

I've just discovered another problem with this commit.

% du -s /lib/modules/2.6.28
63072	/lib/modules/2.6.28/
 du -s /lib/modules/2.6.28-git7
221556	/lib/modules/2.6.28-git7/

The two configs are largely equal.  I'm building with
CONFIG_DEBUG_KERNEL=y, but then installing with "make
INSTALL_MOD_STRIP=1 modules_install".   

But look:

% ls /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko 
10460 /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko

% ls /lib/modules/2.6.28/kernel/fs/xfs/xfs.ko 
564 /lib/modules/2.6.28/kernel/fs/xfs/xfs.ko

The reason?  The ad7a953c commit uses this procedure to do the installation:

# objcopy --strip-debug --wildcard --strip-symbols /usr/projects/linux/linux-2.6/scripts/strip-symbols fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko  || cp fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko 
objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation

So because it can't safely strip __ksymtab_strings it returns a
non-zero exit status, and doesn't do anything at all, and then the cp
command doesn't do any stripping whatso ever.

I could fix this by patching Makefile and scripts/Makefile.modist to
do this instead:

# objcopy --strip-debug --wildcard --strip-symbols /usr/projects/linux/linux-2.6/scripts/strip-symbols fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko  || (cp fs/xfs/xfs.ko /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko ; strip --strip-debug /lib/modules/2.6.28-git7/kernel/fs/xfs/xfs.ko)

... but at this point, is there going to be any massive downside if I
just revert commit ad7a953c?  Quite frankly, it's causing me a huge
amount of trouble, and I'm still a bit unclear what the upside of this
patch is.  As near as I can tell there is *single* __crc_ symbol in
xfs.ko which all of this rigamorale is doing to strip out.  From what
I can tell, not quite doubling the compile time when fully cached by
ccache, causing INSTALL_MOD_STRIP to fail randomly so that the
installed modules are a factor of 4 larger, compromising the amount of
space in my root partition, is all to remove a handful of __crc_*
symbols from the generated .ko file?

What am I missing?  Why is stripping the __crc_* symbols so
gosh-darned important?

						- Ted
