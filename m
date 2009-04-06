Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZDFI4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZDFI4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 04:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZDFIzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 04:55:52 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38201
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZDFIzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 04:55:51 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: Squashfs 4.0 tools
Date: Mon, 6 Apr 2009 03:55:43 -0500
User-Agent: KMail/1.9.10
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       squashfs-devel@lists.sourceforge.net
References: <20090323180808.2c2ef1a7@nehalam> <49D2BDE6.7030304@lougher.demon.co.uk> <49D93E75.6000203@lougher.demon.co.uk>
In-Reply-To: <49D93E75.6000203@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904060355.44679.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009 18:27:49 Phillip Lougher wrote:
> Phillip Lougher wrote:
> > Rob Landley wrote:
> >> On Monday 30 March 2009 19:55:24 Stephen Hemminger wrote:
> >>> I built it from cvs (imported into git), and it works okay.
> >>
> >> I grabbed the cvs snapshot gentoo's been using, but I don't see any
> >> way to feed in a device list text file so I can create the
> >> /dev/console node root filesystems need without needing root access on
> >> the host to mknod.
> >>
> >> genext2fs has the -D option, which takes:
> >>
> >>   /dev d 755 0 0 - - - - -
> >>   /dev/console c 640 0 0 5 1 0 0 -
> >>
> >> gen_init_cpio takes:
> >>
> >>   dir /dev 755 0 0
> >>   nod /dev/console 660 0 0 c 5 1
> >>
> >> Is there a squashfs option I'm missing...?
> >
> > I'll delay the release of the 4.0 tools and see if I can
> > implement this option in the next day or two.
>
> The Squashfs 4.0 tools have been released on sourceforge
> (http://www.squashfs.org), and mksquashfs now includes support for
> fake devices and directories.
>
>  From README-4.0

Some suggested wordsmithing on the text you posted:

---

Mksquashfs now supports pseudo-files, which may be specified via the -p 
and -pf command line options.

Pseudo-files allow fake directories, character devices, and block devices to 
be added to the Squashfs filesystem being built without requiring them to be 
present in the source filesystem.  This allows a non-root user to create a 
squashfs filesystem containing device nodes and directories (but files) with 
arbitrary ownership/permissions.

The -p option specifies an individual pseudo-file, and takes a single argument 
such as -p "/dev d 755 root root".  The -p option may be repeated as 
necessary.

The -pf option specifies a file containing a list of pseudo-file definitions, 
one per line.

Pseudo-file definitions look like this:

  /dev d 755 root root
  /dev/chr_dev c 666 root root 100 1
  /dev/blk_dev b 444 0 0 200 200

The first field is the complete path to the new entry in the squashfs 
filesystem. (This path cannot currently contain any whitespace space 
characters.)  The second field is a single letter indicating the entry type.  
Currently supported types are d (directory), b (block device), and c (char 
device).  The third, fourth, and fifth fields are (respectively) octal mode, 
user id, and group ID.  UID and GID can be specified either by decimal number 
or using a name valid on the host filesystem.

Directory pseudo-file definitions only contain five fields.  Device 
pseudo-file definitions include major and minor numbers in the sixth and 
seventh fields.

To ensure the pseudo-file definition is parsed as one argument, and to
ensure it isn't interpreted by the shell, the definition should be enclosed
in quotes when using the -p option, i.e.

  mksquashfs test test.sqsh -p "/dev/chrdev c 666 root 100 1"

If a directory given in a pseudo file path exists in the real source
directories it doesn't have to be specified as a pseudo directory, if it
doesn't exist in the source directories, it must first be specified as a 
pseudo directory (otherwise any pseudo devices under the directory will be
ignored).

For example

  /dev d 755 root root
  /dev/chr_dev c 666 root root 100 1

---

Thanks, looks good.  I should be able to test it out in the morning.

Rob
-- 
GPLv3 is to GPLv2 what Attack of the Clones is to The Empire Strikes Back.
