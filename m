Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZAECmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZAECmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZAECmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:42:42 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39746
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZAECmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:42:40 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [patch] Re: document ext3 requirements
Date: Sun, 4 Jan 2009 20:42:35 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <20090104220634.GD22958@mit.edu> <20090104230053.GG1913@elf.ucw.cz>
In-Reply-To: <20090104230053.GG1913@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042042.36418.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 17:00:53 Pavel Machek wrote:
> Document linux filesystem expectations. Ext3 can't handle write errors
> of any kind, and can't handle non-atomic sector writes. Other
> filesystems are probably even worse...

These concerns look like they're specifically for block backed filesystems, 
which is one of four different types.  I wrote a longish incoherent rant to 
the busybox list about the different types of filesystems a couple months 
back, in the context of a thread about implementing the "mount" command.  
Dunno how relevant it is:
http://lists.busybox.net/pipermail/busybox/2008-November/067970.html

There are a couple fun relevant corner cases, such as the fact that nfs is the 
only filesystem I'm aware of where the return value of close() can actually 
mean something.  (Due to the cacheing, you tend to get errors reported 
_there_.  I don't remember why, if I ever knew.)

> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
> diff --git a/Documentation/filesystems/expectations.txt
> b/Documentation/filesystems/expectations.txt new file mode 100644
> index 0000000..7817a9c
> --- /dev/null
> +++ b/Documentation/filesystems/expectations.txt
> @@ -0,0 +1,44 @@
> +Linux filesystems can only work correctly when several conditions are
> +met in the block layer and below (disks, flash cards). Some of them
> +are obvious ("data on media should not change randomly"), some are
> +less so.
> +
> +Write errors not allowed (NO-WRITE-ERRORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Writes to media never fail. Even if disk returns error condition
> +during write, filesystems can't handle that correctly, because success
> +on fsync was already returned when data hit the journal.
> +
> +	Fortunately writes failing are very uncommon on traditional
> +	spinning disks, as they have spare sectors they use when write
> +	fails.

The failures show up in dmesg(), and some filesystems will remount themselves 
read only if the physical media driver manages to propogate an error back to 
to the filesystem.  (Note that the scsi subsystem has historically had so many 
glue layers that it couldn't manage to do this; that's been improved over the 
years but whether or not it actually _works_ now, I couldn't tell you.)

Some kind of system monitor could notice the dmesg entries, but the actual 
write goes into the cache and the physical media error normally happens long 
after the program that did the write returned from its write call, often after 
it closed the file, and sometimes after it exited.

Even sync() and fsync() won't help you there because if multiple processes do 
that, only the _first_ one will get the physical media error.  (The filesystem 
doesn't associate physical media errors with processes; there's too many 
layers in between and it's not necessarily a 1:1 relationship anyway.)

> +Sector writes are atomic (ATOMIC-SECTORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written during
> +powerfail.
> +
> +	Unfortuantely, none of the cheap USB/SD flash cards I seen do
> +	behave like this, and are unsuitable for all linux filesystems
> +	I know.

My impression is you might as well leave the suckers vfat.  It's a stupid 
little filesystem but its very stupidity makes it as resistant to damage as 
anything else (which admittedly isn't much), and it's had such a history of 
_taking_ damage that the tools to cope with damage to it are actually pretty 
good.

That said, constant updates to the first few sectors will burn out your USB 
flash disk if you use it as something other than a backup media.  That's true 
with a lot of filesystems.  (Hardware wear levelling isn't very good, it 
cycles between the same dozen or so physical sectors for each logical sector.)

In general, those game consoles that say "please don't power off the thing 
while we're writing to flash" have a reason for the message. :)

> +		An inherent problem with using flash as a normal block
> +		device is that the flash erase size is bigger than
> +		most filesystem sector sizes.  So when you request a
> +		write, it may erase and rewrite the next 64k, 128k, or
> +		even a couple megabytes on the really _big_ ones.
> +
> +		If you lose power in the middle of that, filesystem
> +		won't notice that data in the "sectors" _after_ the
> +		one your were trying to write to got trashed.
> +
> +	Because RAM tends to fail faster than rest of system during
> +	powerfail, special hw killing DMA transfers may be neccessary;
> +	otherwise, disks may write garbage during powerfail.
> +	Not sure how common that problem is on generic PC machines.
> +
> +
> +
> +
> diff --git a/Documentation/filesystems/ext3.txt
> b/Documentation/filesystems/ext3.txt index 9dd2a3b..8cb64b0 100644
> --- a/Documentation/filesystems/ext3.txt
> +++ b/Documentation/filesystems/ext3.txt
> @@ -188,6 +197,25 @@ mke2fs: 	create a ext3 partition with th
>  debugfs: 	ext2 and ext3 file system debugger.
>  ext2online:	online (mounted) ext2 and ext3 filesystem resizer
>
> +Requirements
> +============
> +
> +Ext3 expects disk/storage subsystem to behave sanely. On sanely
> +behaving disk subsystem, data that have been successfully synced will
> +stay on the disk. Sane means:
> +
> +* write errors not allowed
> +
> +* sector writes are atomic
> +
> +(see expectations.txt; note that most/all linux filesystems have similar
> +expectations)

nfs, cifs, procfs, sysfs, usbfs, tmpfs, ramfs, fuse...

> +* either write caching is disabled, or hw can do barriers and they are
> enabled. +
> +	   (Note that barriers are disabled by default, use "barrier=1"
> +	   mount option after making sure hw can support them).

So how does one make sure hw can support them?

Rob
