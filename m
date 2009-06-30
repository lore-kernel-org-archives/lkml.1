Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbZF3DXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbZF3DXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 23:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZF3DW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 23:22:57 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47529 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZF3DW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 23:22:56 -0400
Date: Tue, 30 Jun 2009 04:22:57 +0100
From: Jamie Lokier <jamie@shareable.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] vfat: change the default from shortname=lower to shortname=mixed
Message-ID: <20090630032257.GA32096@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ws70ulho.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Hi,
> 
> I was asked like the following sometimes,
> 
>   Why is shortname=lower the default mount option for vfat filesystems?
>   Because, with "shortname=lower", copying one FAT filesystem tree to
>   another FAT filesystem tree using Liux results in semantically
>   different filesystems. (E.g.: Filenames which were once "all
>   uppercase" are now "all lowercase").
> 
> And from recently email 
> 
>   http://bugs.debian.org/476903
>   http://bugs.debian.org/497121
>   http://bugzilla.gnome.org/554031
>   https://bugs.launchpad.net/ubuntu/+bug/290362
> 
> My usual answer for it is, personally I agree that "winnt" or "mixed"
> is proper. However, it is long-standing default behavior. Um...
> 
> But, now, situation would not be same with long past (didn't have
> shortname= option).
> 
> Well, so, what do you think about changing the default of vfat from
> "shortname=lower" to "shortname=mixed"?  If default was changed, the
> shortname (8.3) will not changed to lower case to show. And if possible,
> it will try to preserve created shortname.

I agree with the change to "shortname=mixed" being the default.

Not only does it solve problems with Linux seeing files it created
_itself_ change, "shortname=mixed" is the only option where files
created on all versions of Windows appear the same in Linux, and vice
versa.  It is better than Windows itself in that respect...

"shortname=winnt" is not as good.  It solves the problem of
Linux<->itself compatibility and Linux<->Windows-NT/2000/XP/Vista
compatibility, but not Linux<->Windows-95/98/ME compatibility.

I don't see any problems with changing the option from it's default,
for filesystems which were written as VFAT by any OS.  For filesystems
written as plain FAT, it may change them to appear as upper case in
Linux, when they previously showed as lower case.  If there is a
reliable way to detect filenames written by a plain FAT system, it
might be desirable to show the names as lower case from them.

Below are my notes, when I had to add "shortname=mixed" to a program
because of user bug reports when they created files on various
versions of Windows and they didn't work on an embedded Linux media
player.  Feel free to use the notes in the Changelog or documentation.

    Why use shortname=mixed.

    This affects 8.3 filename reading and creation for maximum
    compatibility with the behaviour of all versions of Windows.

    There is a classic conflict between Windows 95 derivatives and
    Windows NT derivatives, which causes spurious case changes when
    moving some file names between them on removable media.  This
    Linux setting manages to be compatible with both of them reliably,
    and is therefore superior to all versions of Windows.

    1. Filename reading uses the algorithm of Windows NT: if there
       is only an 8.3 short name, its case is calculated from flags in
       byte 12 of the short name entry.

       This is needed for compatibility with files written by Windows
       NT derivatives (including 2000, XP and Vista).  When Windows NT
       creates two files called "PLAYLIST" and "file.ogg", the default
       Linux algorithm ("shortname=lower") would see them as
       "playlist" and "file.ogg" together, and the Windows 95
       algorithm would see them as "PLAYLIST" and "FILE.OGG" together.
       Both cause problems.

    2. Filename creation uses the algorithm of Windows 95: Linux
       creates a long name entry unless the original name fits into
       8.3 and is entirely upper case.  This is more compatible than
       shortname=winnt, because it creates a long name in more cases
       to remove uncertainty.

       This is needed for compatability with files created by Linux
       and read by Windows 95 derivatives (and MS-DOS).  Windows 95
       derivatives and MS-DOS interpret short name entries as upper
       case, even when case flags are set in byte 12.  By storing a
       long name entry, files stored by Linux will be read in the
       desired case by all versions of Windows.

The patch has my

Signed-Off-By: Jamie Lokier <jamie@shareable.org>

-- Jamie
