Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZDEX1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZDEX1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZDEX1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:27:33 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:65379 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbZDEX1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:27:33 -0400
Message-ID: <49D93E75.6000203@lougher.demon.co.uk>
Date: Mon, 06 Apr 2009 00:27:49 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       squashfs-devel@lists.sourceforge.net
Subject: Re: Squashfs 4.0 tools
References: <20090323180808.2c2ef1a7@nehalam> <10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com> <20090330175524.4e8f802e@nehalam> <200903311431.20494.rob@landley.net> <49D2BDE6.7030304@lougher.demon.co.uk>
In-Reply-To: <49D2BDE6.7030304@lougher.demon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:
> Rob Landley wrote:
>> On Monday 30 March 2009 19:55:24 Stephen Hemminger wrote:
>>> I built it from cvs (imported into git), and it works okay.
>>
>> I grabbed the cvs snapshot gentoo's been using, but I don't see any 
>> way to feed in a device list text file so I can create the 
>> /dev/console node root filesystems need without needing root access on 
>> the host to mknod.
>>
>> genext2fs has the -D option, which takes:
>>
>>   /dev d 755 0 0 - - - - -
>>   /dev/console c 640 0 0 5 1 0 0 -
>>
>> gen_init_cpio takes:
>>
>>   dir /dev 755 0 0
>>   nod /dev/console 660 0 0 c 5 1
>>
>> Is there a squashfs option I'm missing...?
>>
> I'll delay the release of the 4.0 tools and see if I can
> implement this option in the next day or two.

The Squashfs 4.0 tools have been released on sourceforge
(http://www.squashfs.org), and mksquashfs now includes support for
fake devices and directories.

 From README-4.0

Mksquashfs now supports pseudo files, these allow fake directories, character
and block devices to be specified and added to the Squashfs filesystem being
built, rather than requiring them to be present in the source directories.
This, for example, allows device nodes to be added to the filesystem without
requiring root access.

Two options are supported, -p allows one pseudo file to be specified on the
command line, and -pf allows a pseudo file to be specified containing a
list of pseudo definitions, one per line.

Pseudo device nodes are specified using 7 arguments

Filename type mode uid gid major minor

Where type is either
         b - for block devices, and
         c - for character devices

mode is the octal mode specifier, similar to that expected by chmod.

Uid and gid can be either specified as a decimal number, or by name.

For example:

/dev/chr_dev c 666 root root 100 1
/dev/blk_dev b 444 0 0 200 200

Directories are specified using 5 arguments

Filename type mode uid gid

Where type is d.

To ensure the pseudo definition is parsed as one argument and to
ensure it isn't interpreted by the shell, the definition should be enclosed
in quotes when using the -p option, i.e.

mksquashfs test test.sqsh -p "/dev/chrdev c 666 root 100 1"

If a directory given in a pseudo file path exists in the real source
directories it doesn't have to be specified as a pseudo directory, if it
doesn't exist in the source directories, it must be specified as a pseudo
directory (otherwise any pseudo devices under the directory will be ignored).

For example

/dev d 777 root root
/dev/chr_dev c 666 root root 100 1

Phillip

