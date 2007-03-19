Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXCSPDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXCSPDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbXCSPDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:03:53 -0400
Received: from relay4.usu.ru ([194.226.235.39]:45322 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238AbXCSPDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:03:52 -0400
Message-ID: <45FEA669.1060301@ums.usu.ru>
Date: Mon, 19 Mar 2007 20:04:09 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>	<45FE2483.4060706@ums.usu.ru> <878xdtux71.fsf@duaron.myhome.or.jp>
In-Reply-To: <878xdtux71.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:

> No, the utf8 support of vfat is wrong. This is implementation
> thing, and it is not recommended until it is fixed.

Could you please explain your specific problem with screenshots, preferrably 
by running my LiveCD or Debian Etch in an emulator such as qemu or VMware?

But, anyway, this is a separate issue that my patch doesn't attempt to 
correct. The conclusion so far is that we disagree, and that there are 
situations where using utf8 iocharset is the least of all evils, so the 
warning is not justified enough. Reproducible testcase:

1) Install MS Windows 2000 or XP (English aka Pan-European version is just fine)
2) When the installer asks about locale settings, choose that you (a) want 
to have Cyrillic group of languages, (b) that your locale/location is 
Russia, (c) use Russian as a language for non-Unicode programs, and (d) add 
Russian keyboard layout in addition to the existing English layout if the 
system doesn't do this for you.
3) Using Windows, create a file on a floppy or flash drive. Press F2 to 
rename it. Press Alt+Shift to switch to Russian keyboard layout. Type a new 
file name. Remember (or copy to paper) what the letters that make the file 
name look like in Windows.
4) Boot my LiveCD and choose "Russian (UTF-8)" from the locale dialog (this 
matches the setup found in all modern distros such as Fedora). On the second 
screen, confirm the default settings. (Alternatively, install Debian Etch 
and select Russian during installation).
5) Try to mount the floppy or flash drive to /mnt using various iocharsets. 
List the directory contents with "ls -l". You will find that utf8 is the 
only iocharset that gives the correct letters.

OTOH, if you select Russian (KOI8-R) or Russian (CP1251), you will find that 
the only iocharset giving the correct letters will be koi8-r or cp1251, 
respectively.

> I'm talking about two filesystems on a system here, not two encoding
> on one filesystem.

I am also talking about this. Mounting two filesystems with different 
iocharsets is insane, because this will result in one of the following outcomes:

1) "ls" will show wrong characters in filenames on one of the filesystems
2) one of the two filesystems will contain wrong on-disk data for filenames, 
that, when misinterpreted by mounting with wrong iocharset, results in 
seemingly-correct output, but is misunderstood by the properly set up 
reference implementation (that's what is likely to happen with jfs in your 
example).

Testcase for (2), to be performed with my LiveCD:

1) Boot the CD, select "Russian (KOI8-R)" from the locale dialog. Agree with 
the default settings on the second screen.
2) Mount an empty floppy or flash drive with the (wrong) "cp1251" iocharset.
3) Using the right Ctrl key to switch between between English and Russian 
keyboard layouts, create a file with Russian letters in its name under /mnt.
4) umount /mnt
5) Install Windows 2000 or XP with Russian-specific settings, as described 
above.
6) Look what Windows finds on the floppy or flash. It is not the same 
filename you typed, but a sort of garbage (mojibake).

-- 
Alexander E. Patrakov
