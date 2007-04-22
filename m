Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbXDVSAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbXDVSAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbXDVSAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:00:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59269 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXDVSAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:00:21 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Wrong free clusters count on FAT32
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, DervishD <lkml@dervishd.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sun, 22 Apr 2007 19:21:04 +0200
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it> <8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it> <8cAMl-du-3@gated-at.bofh.it> <8cBS7-1Qa-1@gated-at.bofh.it> <8cIqE-3qZ-9@gated-at.bofh.it> <8cITG-40H-5@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Hffkv-0001QP-3C@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX199IwNj0jb4nWUWi5Zv9adY3ODWPTqHyfa41Em
 5Osx1EZH0JDwjWaPaS8H7jWc2sAd1cWux7pKAqUrWHd/jmcjno
 au8pKKaWSQ1H1rIIcHz4A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
> DervishD <lkml@dervishd.net> writes:

>>     Probably it's stupid to update the free clusters count at mount time
>> (sorry if so...) but it looks like a good idea to me. And of course, I
>> don't mean to update the value _on disk_, but the kernel's idea of free
>> clusters (so even FAT filesystems mounted R/O will report correct
>> values).
> 
> It would add the limitation to following simple usage,
> 
> # mount -t vfat /dev/sda1 /mnt
>         # cp -a * /mnt
>         # umount
> 
> if /dev/sda1 was the large and slow device, "mount" will need several
> minutes to counts free clusters. I think the user will be hard to
> accept the several minutes at "mount".

I simulated recalculating the FAT using a suboptimal perl script on my
32 GB FAT32 partition on a 40 GB drive. The results should show the worst
case for my system.

The results were below 2 seconds (optimized perl at 0.5 s) on my AMD Athlon
XP 2400+. (BTW: I don't think the device speed itself will be relevant in
many cases even if you'd asume a slow link, since you'll need to read the
FAT anyway.)

I think this is acceptable, and on this system, I'd like to enable
recalculating by default. On slower systems, you'll need to chose another
default.

I think you'll want that option as a module parameter to make all users happy.
And while you're at it, fmask and dmask are good candidates for module
parameters, too.-)


# echo 3 > /proc/sys/vm/drop_caches

# /usr/bin/time sh -c "dd if=/dev/hda2 bs=$((77834925/64)) count=4 | perl -e
'"'use POSIX;while (sysread STDIN,$x,4) {$n++ if $x eq "\0\0\0\0"} print
$n*32,"\n"'\'
4+0 records in
4+0 records out
13954720
0.76user 0.60system 0:01.95elapsed 69%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (8major+1583minor)pagefaults 0swaps

# /usr/bin/time sh -c "dd if=/dev/hda2 bs=$((77834925/64)) count=4 | perl -e
'"'use POSIX;while (sysread STDIN,$x,4) {$n++ if $x eq "\0\0\0\0"} print
$n*32,"\n"'\'
4+0 records in
4+0 records out
13955392
0.74user 0.69system 0:01.50elapsed 95%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+1591minor)pagefaults 0swaps

# /usr/bin/time sh -c "dd if=/dev/hda2 bs=$((77834925/64)) count=4 | perl -e
'"'use POSIX;while (sysread STDIN,$x,4096) {for (unpack "L*",$x){$n++ if !$_}}
print $n*32,"\n"'\'
4+0 records in
4+0 records out
13955392
0.43user 0.06system 0:00.50elapsed 97%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+1599minor)pagefaults 0swaps


-- 
The worse the weather, the more you are required to be out in it. 

Friﬂ, Spammer: fv@upXs.7eggert.dyndns.org z@Z1rk.7eggert.dyndns.org
 VRo@Gb2b4rxc.7eggert.dyndns.org LimmgYHv@smpZsGtB.7eggert.dyndns.org
