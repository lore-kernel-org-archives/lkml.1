Return-Path: <linux-kernel-owner+w=401wt.eu-S965136AbXCSEiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136AbXCSEiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 00:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964883AbXCSEiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 00:38:00 -0400
Received: from relay4.usu.ru ([194.226.235.39]:37539 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965136AbXCSEh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 00:37:58 -0400
Message-ID: <45FE13B9.8000203@ums.usu.ru>
Date: Mon, 19 Mar 2007 09:38:17 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>
In-Reply-To: <87d535vqrz.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> "Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:
> 
>>> You allow to set any nls to codepage? If so, it is not good.
>> I did this because it involved less changes. Only FAT treats codepage as a 
>> number. All other filesystems already allow arbitrary NLS as a codepage 
>> mount parameter.
> 
> I'm saying here, it is not good for vfat.

All valid options (i.e. numbers) are still available. Prohibiting 
non-numbers is a lot of work (changing module_param_string to 
module_param_call and validating the passed string, and also changing the 
code for all filesystems so that they also validate manually-passed codepage 
string).

>>> No, utf-8 makes completely wrong entry. It's more wrong than other nls.
>> For any non-UTF-8 based locales, the other NLS is correct and utf8 indeed 
>> would produce completely wrong characters. But for UTF-8 based locales, utf8 
>> is the only correct iocharset.
> 
> No, iocharset=utf8 is wrong always.

Here we just disagree, but I think I can change your opinion by giving you a 
correctly configured UTF-8 Japanese system in the form of a LiveCD (note: 
the kernel doesn't have this patch there). If you can afford ~500 MB of 
downloads, please do this:

1) download http://ftp.lfs-matrix.net/pub/lfs-livecd/lfslivecd-x86-6.2-5.iso 
and burn it
2) write (from Windows, because it cannot be misconfigured) some files with 
Japanese filenames to your flash drive
3) boot the CD, type the following at the boot prompt: linux 
LANG=ja_JP.UTF-8 TZ=Asia/Tokyo
4) edit /etc/X11/xorg.conf (should be probably unneeded, but I ask just in 
case. If you have to edit xorg.conf, report a bug to me privately)
5) startx (to get a Japanese environment)
6) open the terminal
7) yes --help (are the proper Japanese characters displayed? If not, change 
the font in the menu to some Kochi family and report this to me as a bug - 
yes I know about the Japanese opposition to Unicode because of Han Unification)
8) mount -o iocharset=utf8,codepage=932 /dev/sda1 /mnt (here I assume that 
your flash drive appears as sda1, adjust as needed)
9) ls -l /mnt (do Japanese filenames appear correctly?)
10) umount /mnt

If you want to experiment with the more traditional ja_JP.eucjp locale, you 
are also welcome to do so (but then iocharset=euc-jp will be needed to show 
filenames correctly).

> Why I can't use utf8 for jfs or something, and use other nls for vfat?

Because you'll get a mismatch between the userspace locale and the iocharset 
used by the kernel in at least one of these two cases. The mismatch will 
result in the following:

1) Your system (e.g., the "ls" command) will not correctly interpret 
filenames written by known-good setups.
2) Known-good setups will not correctly interpret filenames written by your 
system.

What probably happened in your case is that you have no known-good jfs-based 
setup and are the only user of your jfs disk, and thus can't see (2). It 
looks like you don't use UTF-8 userspace locale. Then, the on-disk filenames 
on your jfs filesystem are wrong, but your system misinterprets them, and 
two errors seem to cancel each other (but this still doesn't make it a 
correct setup).

-- 
Alexander E. Patrakov
