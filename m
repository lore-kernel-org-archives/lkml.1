Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXGZQcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXGZQcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759734AbXGZQcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:32:00 -0400
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:33604 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758432AbXGZQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:31:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=T/f1evTc53uFSBqsK8aC9+rM5CNTd/HRYozxheK6QSh8K6+Ndso2pyl8w/4i6kW7baL+7OcBSLcK5T5oQDDZXfolWdrDU+aBGOmPOV2c0qb37d99vgvMA6Qqn2Sopbmy5KDnizcM+tP9mohhsggOu0KAZTXuTsJd8jJCnBAjOWM=  ;
X-YMail-OSG: LgLgUrsVM1lw11kzRxVsVut0tDWXcCOvmTEgyMAP17KHhDTurbUtjvJVf6KXWILqggm8.m5zlg--
Date: Thu, 26 Jul 2007 18:30:53 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070726163053.GA4570@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46A8BB6C.6050903@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 08:19:08AM -0700, H. Peter Anvin wrote:
> Xudong Guan wrote:
> > On 13:26(+0200) Tue 24 Jul, Borislav Petkov wrote:
> >>    2.6.23-rc1 won't boot on my Asus M6N laptop and the last thing it shows after loading
> >> grub is "No setup signature found...," which, imho, comes from
> >> arch/i386/boot/header.S. I tried printing out the value of setup_sig like so
> > 
> > I hitted the same error message with v2.6.23-rc1-171-ge4903fb.
> > No problem with v2.6.21-3770-g01e73be.
> > Seems there has been some cleanup of the i386/boot code.
> > Anyone can give a quick clue, or should I do a bisect?

I just finished bisecting between v2.6.22..v2.6.23-rc1 (13 kernels compiled, whew...) and Peter you are
right, here's the evidoer:

4fd06960f120e02e9abc802a09f9511c400042a5 is first bad commit
commit 4fd06960f120e02e9abc802a09f9511c400042a5
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Jul 11 12:18:56 2007 -0700

    Use the new x86 setup code for i386

    This patch hooks the new x86 setup code into the Makefile machinery.  It
    also adapts boot/tools/build.c to a two-file (as opposed to three-file)
    universe, and simplifies it substantially.

    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 6560eb5b7e40d93813276544bced8c478f9067f5 fe5f90d9ca08e526559815789175602ba2c51743 M      arch

> The bisect will almost guaranteed show a change at the change to the new
> setup code.  The message means that the setup code wasn't loaded
> correctly into memory; the big question is *why*.

> What distro/version of grub are you running?  
Debian unstable
> I'm wondering if there are
> some old version of grub out there which did the "load four sectors"
> way-anciently-obsolete crap; the other possibility that comes to mind is
> setting up the stack in an invalid manner.
grub version:

[boris@gollum:18:17:27:->  apt-cache show grub
Package: grub
Priority: optional
Section: admin
Installed-Size: 708
Maintainer: Grub Maintainers <pkg-grub-devel@lists.alioth.debian.org>
Architecture: i386
Version: 0.97-29
Depends: libc6 (>= 2.5-5), libncurses5 (>= 5.4-5)
Suggests: grub-doc, mdadm
Filename: pool/main/g/grub/grub_0.97-29_i386.deb
Size: 366884
MD5sum: 2da7a5942db06eaba046dff4615bcce9
SHA1: 7f4da793da209d011ce94fceebaebe0e5f08790f
SHA256: 2596782c08f1f7365e9935f687fef74c67d8702503188f22448db9f0ac98e18e
Description: GRand Unified Bootloader
...

so any ideas/test patches for debugging this are welcome.

-- 
Regards/Gruﬂ,
    Boris.
