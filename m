Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbXLAOlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbXLAOlK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 09:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXLAOkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 09:40:53 -0500
Received: from mailfe07.tele2.at ([212.247.154.199]:57068 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752397AbXLAOkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 09:40:51 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Dec 2007 09:40:51 EST
X-Cloudmark-Score: 0.000000 []
Date: Sat, 01 Dec 2007 14:41:29 +0100
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [cifs] Share root directory appears in subdirectories. (Well, can't actually see it but can cd into it, even if its not there.)
From: "Wiesner Thomas" <thomas@bau-konform.at>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed	delsp=yes
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Message-ID: <op.t2nsbgwh88izfi@barton2>
User-Agent: Opera Mail/9.24 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having some problem with cifs mounts here, it seems so be a bug.
I've posted this on the samba mailing list, but it seems to me like the  
samba mailing list
is not the right one for the client side stuff. (Correct me, if I'm wrong.)

This is the reason I post it here, too.

My initial post was:

Additionally to the problems I reported earlier, I'Ve discovered another  
problem with my server/client setup.

find reports

find: WARNING: Hard link count is wrong for ./foo: this may be a bug in  
your filesystem driver.
Automatically turning on find's -noleaf option.  Earlier results may have  
failed to include directories that should have been searched.

in one directory and if I browse this directorya and I see
completely wrong files in it (Actually, I seem to see the contents of the  
upper level directory). This problem doesn't appear with
Win2K clients and the filesystem itself is OK.

Samba Version 3.0.24 on the server (Debian Etch), according to smbd -V.
As mount helper I use mount.cifs, compiled from samba-3.0.26a.
The kernels on the server and client are the Debian default kernels  
(2.6.18-5-486 and 2.6.18-5-686).

The directory structure looks like:
/dir1/dir2/dir3

where dir2 is the mountpoint.

If I 'cd' into dir4 from dir3, I see the contest of dir2. It may have to  
do with the fact, that the name of dir4 is the
same as dir2 ...

Example:
/coffee/cup$ ls
   Dir contents of cup
/coffee/cup$ cd foo
/coffee/cup/foo$ ls
   cup, water
/coffee/cup/foo$ cd cup
/coffee/cup/foo/cup$ ls
   The contents of /coffee/cup and not of /coffee/cup/foo/cup are shown and  
I can even access those wrong files!

This seems to be a definite bug in either Samba or the filesystem driver.  
This may even be a security hole in some way.
(Can't think of any now, but who knows.)

I played around a bit and found the following out: The problem appears  
when a directory has the same name as the mount point.
I can even 'cd' into a directory which isn't there:

(Mount point is gstorage, share name is gstorage too, don't know if this  
matters, I haven't investigated it)
/cifsmounts/gstorage$ cd anydir
/cifsmounts/gstorage/anydir$ cd gstorage
/cifsmounts/gstorage/anydir/gstorage$
Crazy. I seem to be in the root of the share again(!), even if the  
directory gstorage doesn't exist in 'anydir'.
I called it anydir, because it works from any directory (but it must be  
one level below the share root).
In /cifsmounts/gstorage/anydir/gstorage I can see the contents of the root  
of the share, again. If there is a dir with the share name
the contents are overridden, like described above.

I've tried this on a client running 2.6.22.10. Same problem from this one  
too. Seems to be either an undisovered kernel or Samba Bug.


    mfg Wiesner Thomas


===============================

I had some private EMail exchange with Mark Adams and it seems like I  
really hit a bug in cifs.
The remaining text of this message is our correspondence so that everybody  
can read what was going on:
(In chronological order. Thank you for your help, Mark.)

Mark:

Check your filesystem.
Reminder, unmount then fsck.ext3 /my/dev/path
Mark.

---------------------

I:

Well. I already knew, that the filesystem was ok, but I checked:

# fsck.ext3 -f -v /dev/md0
e2fsck 1.40-WIP (14-Nov-2006)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

   100103 inodes used (0.08%)
      446 non-contiguous inodes (0.4%)
          # of inodes with ind/dind/tind blocks: 8675/1222/0
  8694820 blocks used (3.56%)
        0 bad blocks
        1 large file

    93225 regular files
     6848 directories
        0 character device files
        0 block device files
        0 fifos
        0 links
       21 symbolic links (21 fast symbolic links)
        0 sockets
--------
   100094 files

No problems as far as I can see. As I wrote, from Win2k clients and on the  
server itself,
everything is ok. But if I mount it on a Linux client, i experience the  
problem.

    mfg Thomas

------------------------

Mark:

have you tried using smbfs drivers instead of what you have compiled?
there is a deb for this. You could also then put your mounts in fstab,
if required.

seems as though a hardlink has been created somehow, either with
mount.cifs or on the server or host.


 From the sound of things there is a hardlink somewhere pointing back to
the higher level directory?

------------------------

have you tried using smbfs drivers instead of what you have compiled?
there is a deb for this. You could also then put your mounts in fstab,
if required.

Ok. I've just tried mouting the share with cifs without the mount.cifs  
helper
(with which it works from fstab, too). Same problem.

I've also tried smbfs. It seems to work correctly.
(I think this should be the proof, that the problem is on the client side.)

seems as though a hardlink has been created somehow, either with
mount.cifs or on the server or host.
 From the sound of things there is a hardlink somewhere pointing back to
the higher level directory?

Hm.
find . -links +1 -type f
executed from the root of all shares finds nothing. The find command  
executed on the client on the mounted share
finds nothing, too, but spills out the cited hard-link-count-error.

It seems like I will have to use smbfs, as cifs seems to be too buggy.
(I experience occasional hangs with it, too as you may have read on the  
mailing list.)

    cheers Thomas

------------------------

Yes if smbfs works fine then it definatly appears like a bug in cifs. You  
should report the findings here to the samba list for future reference by  
others.

Mark.

=================================================

I hope this helps.

   Greetings Thomas
