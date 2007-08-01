Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXHAEjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXHAEjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXHAEjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:39:44 -0400
Received: from smtp110.plus.mail.mud.yahoo.com ([68.142.206.243]:32620 "HELO
	smtp110.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751985AbXHAEjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:39:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=dGG2Pe0JaGzdx9BhEEqeem3I20cTdeXgV9VoJo7s9790L8oKd9px1sMNjDI02YXYyvUWRLki/WviEu+0r+FKMP+9YSO0rGOQzpvOb9unbSHvvJYDcMKs12ZJj/JgnlQHUaOMqQ7ALci3obfz6TbdrkY1CH46I9TWwPjOK3uPfoc=  ;
X-YMail-OSG: o7cJ02AVM1l6kwBXcnwGgN8kdI.diASBjniJnL6WzYFe2OVGNrCr_7naMlzHOjEydie5uOJExA--
Date: Wed, 1 Aug 2007 06:38:36 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070801043835.GA4676@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com> <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop> <20070729103706.GA16780@gollum.tnic> <46AC9B28.6060906@zytor.com> <20070729191528.GA5166@gollum.tnic> <46ADF02F.7010800@zytor.com> <20070730185359.GA4290@gollum.tnic> <46AE4E29.7060402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46AE4E29.7060402@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 01:46:33PM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
>> Hi,
>> i decided to do some cheating :) and skipped the breakpoint where it used 
>> to
>> stop (0x40200). (by the way, hitting 'c' wouldn't continue at all and keep
>> executing the same instruction over and over again). This time it seems it 
>> behaves as expected:
>
> Uhm, it looks to me that you ran qemu with the -kernel option again (I can 
> tell because the dump exhibits a few bugs that are characteristic of the 
> qemu loader.)  This makes qemu itself load the kernel and not rely on the 
> boot loader that's on your bootloader.
>
> I was expecting you to run "qemu -S -s -hda /dev/hda -snapshot", which you 
> previously said when run (without the -S -s) options reproduced the 
> problem.
ups, sorry for that, i thought falsely here that you want to debug the kernel
part of the setup code ...
>
> After taking the dump, please do:
>
> 	delete
> 	c
>
> ... to verify the problem is reproduced.

In this case, we never land on a jump instruction:

GNU gdb 6.6-debian
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i486-linux-gnu".
(gdb) target remote localhost:1234
Remote debugging using localhost:1234
0x0000fff0 in ?? ()
	(gdb) set arch i8086
	The target architecture is assumed to be i8086
	(gdb) disp/i ($cs << 4)+$eip
	1: x/i ($cs << 4) + $eip  0xffff0:      ljmp   $0xf000,$0xe05b
	(gdb) br *0x10200
	Breakpoint 1 at 0x10200
	(gdb)         br *0x20200
	Breakpoint 2 at 0x20200
	(gdb)         br *0x30200
	Breakpoint 3 at 0x30200
	(gdb)         br *0x40200
	Breakpoint 4 at 0x40200
	(gdb)         br *0x50200
	Breakpoint 5 at 0x50200
	(gdb)         br *0x60200
	Breakpoint 6 at 0x60200
	(gdb)         br *0x70200
	Breakpoint 7 at 0x70200
	(gdb)         br *0x80200
	Breakpoint 8 at 0x80200
	(gdb)         br *0x90200
	Breakpoint 9 at 0x90200
	(gdb) c
	Continuing.

	Breakpoint 4, 0x00040200 in ?? ()
	1: x/i ($cs << 4) + $eip  0x40300:      lea    (%si),%dx
	(gdb) c
	Continuing.

if i do delete here, it loads the second stage of grub and continues to load the
kernel. Is there another way to land at the jmp instruction instead of poking
blindly, maybe disassemble something parts of the initial code. \me reading
grub-docs...

-- 
Regards/Gruß,
    Boris.
