Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZBTOL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZBTOL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZBTOLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:11:50 -0500
Received: from thunk.org ([69.25.196.29]:38058 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbZBTOLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:11:49 -0500
Date: Fri, 20 Feb 2009 07:46:18 -0500
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of ext4 tools
Message-ID: <20090220124618.GH14810@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090219234838.4c06c98b@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090219234838.4c06c98b@werewolf.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 11:48:38PM +0100, J.A. Magallón wrote:
> 
> - Where is the 'official' source for e4defrag ?
> - I've read that e4defrag needs in-kernel support.
>   Is it already in mainline ?
>   From what kernel version ?

Ext4's defragmentation code is still under development.  There are
multiple versions of e4defrag, paired with kernel patches that have
been submitted to linux-ext4@vger.kernel.org.  The patches are not yet
in in mainline, and the kernel/userspace interface is still subject to
change (which is why it's not in mainline yet).

> - I have seen that some distros refer to a package called 'e4fsprogs'.
>   Does that thing exist ? Where ?

e4fsprogs was a snapshot of something between e2fprogs 1.41.1 and
e2fsprogs 1.41.2, if I remember correctly, and it was created for
RHEL5's technology preview of ext4; the concern was that Red Hat
didn't want to risk making a major change to e2fsprogs in an
enterprise distribution; so e4fsprogs is the e2fsprogs's various
binaries with ext4 support, statically linked.

> - Booting:
>   - There seem to be patches for grub
>     http://lists.openwall.net/linux-ext4/2008/11/19/8
>     to boot ext4
>   - and a Google SoC called 'grub4ext4'.
>    -and there is also grub2 (ext4 support in svn).
>   What would you recommend ?

I can't speak to that; I'm still using an ext3 boot partition since
until very recently I was still using an somewhat oldish (Ubuntu
Hardy) userspace.  It's exciting enough to be on the bleeding edge of
the kernel, I don't need to be on the bleeding edge of userspace too.  :-)

(For example, after my laptop got stolen and I decided to finally move
to Ubuntu Intrepid, with pulseaudio sound is only sporadically
working.  And I don't have time to debug how and why the new
complexities in the !@#!@ sound system is failing.  I'll probably have
to carve out a few hours to figure out how to rip out pulseaudio by
its roots, since it clearly isn't working for me.  Lovely...)

> Apart from that, it works pretty fine.
> The thing that most surprised me was that after the needed fsck, it had
> converted files with contiguous blocks to big extents ;). Nice.

Um, e2fsck won't convert files to use extents.  Once you set the
extents flag, new files that are created will be created with extents,
but existing files are left untouched.  Also, some of ext4's
performance improvements will only come after doing a
dump/mke2fs/restore pass.  People who are thinking about doing that
would be advised to wait until after 2.6.30 or 2.6.31, though, since
we have a patch that changes how the block/inode allocator works
currently pending in development.

Eventually, I hope the online defragger will be able to fully convert
an ext3 filesystem to use extents, with files defragged and placed in
locations that is as close as possible to a dump/mke2fs/restore pass
--- but we're not there yet.  Obviously you'll get a some of the
performance improvements simply going to ext4, and more by enabling
various ext4 features, such as extents et. al.  But for example, the
defragger still tries to keep blocks in the same block group, and it's
not aware of the new allocation policies that tries to keep inodes and
blocks within the same flex_bg (which is a collection of block
groups).  So that's an example of how the defragger needs to be made
more intelligent, and that work hasn't happened yet.

							- Ted
