Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbYIBPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbYIBPhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYIBPhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:37:39 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43357 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751000AbYIBPhi (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:37:38 -0400
Date: Tue, 2 Sep 2008 17:37:33 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jared Hulbert <jaredeh@gmail.com>
cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
In-Reply-To: <Pine.LNX.4.64.0808281737150.28552@vixen.sonytel.be>
Message-ID: <Pine.LNX.4.64.0809021725480.3986@vixen.sonytel.be>
References: <48AD00C4.6060302@gmail.com> <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
 <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
 <Pine.LNX.4.64.0808281737150.28552@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-607078777-1220369853=:3986"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-607078777-1220369853=:3986
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 28 Aug 2008, Geert Uytterhoeven wrote:
> On Fri, 22 Aug 2008, Jared Hulbert wrote:
> > > The version in SVN seems to be slightly older than the one you submitted?
> > 
> > Oops.  Okay I must have neglected to sync at the very end.  Thanks.
> > 
> > I forgot, there is also a git repo at
> > 
> > git://git.infradead.org/users/jehulber/axfs.git
> > 
> > > Which platform(s) do you use for testing?
> > 
> > ARM, x86
> > 
> > > I gave AxFS a try on PS3 (ppc64, always use big-endian 64-bit for testing new
> > > code ;-).
> > 
> > Smart.  Hmmm, If only I had a PS3....
> 
> I heard you got one? ;-)
> 
> > > When mounting the image, I got the crash below:
> > >
> > > | attempt to access beyond end of device
> > > | loop0: rw=0, want=4920, limit=4912
> 
> Interestingly, it also doesn't work on UserModeLinux (x86, 32-bit):

I found what's wrong.

The size of an AxFS image created by mkfs.axfs is always n*4096+4 bytes large.
So when it wants to check the magic value in the last 4 bytes, the block layer
tries to read a whole 512-byte sector, which fails for loop-mounted images.

If you test on real FLASH, additional bytes after the end of the AxFS image can
be read, hence it works.

By padding the image with 508 zero bytes, I can mount it, on both PS3 (ppc64)
and UML (ai32). I can even read images created on PS3.

However, there still are weird things going on, like `find' not seeing all
files and directories, or just aborting, and `ls -lR' showing actual file
contents in its output.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-607078777-1220369853=:3986--
