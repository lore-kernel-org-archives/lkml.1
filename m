Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbYBSE7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbYBSE7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYBSE7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:59:23 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:27333 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYBSE7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z8e0vyPefC5zNxF7EKGlY1y+MHfTXWORR98H/AZdxTEk5ZxfNhddNe1QlOwoaogZRx7Acn2hw3epQnsi3+6QxEltvBfw03n6Z2d3B7qDa5lr76D12JJhakqBHKLiiQHsdAdzOTbvFtc74mFGFgfBaDGIglQ7Xk+iTsiaQWgjSFU=
Message-ID: <97a0a9ac0802182059h36d32ac6o841bb0a1b766b74@mail.gmail.com>
Date: Mon, 18 Feb 2008 21:59:21 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
In-Reply-To: <200802190101.27429.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <200802190017.04432.mb@bu3sch.de>
	 <20080218234212.GA25680@uranus.ravnborg.org>
	 <200802190101.27429.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 5:01 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> On Tuesday 19 February 2008 00:42:12 Sam Ravnborg wrote:
> > On Tue, Feb 19, 2008 at 12:17:04AM +0100, Michael Buesch wrote:
> > > On Tuesday 19 February 2008 00:00:58 Russell King wrote:
> > > > > > Why can't we have an array of this structure on ARM?
> > > > > >
> > > > > > struct ssb_device_id {
> > > > > >        __u16   vendor;
> > > > >
> > > > > 2 bytes
> > > > >
> > > > > >        __u16   coreid;
> > > > >
> > > > > 2 bytes
> > > > >
> > > > > >        __u8    revision;
> > > > >
> > > > > 1 byte
> > > > >
> > > > > > };
> > > > >
> > > > > and therefore sizeof this structure will be 5 bytes, but because of the
> > > > > ABI rules (which are _explicitly_ allowed by the C standard), it'll
> > > > > become 8 bytes due to padding afterwards.
> > > >
> > > > Another guess might be that, if using AEABI, this structure might
> > > > be 6 bytes in size, but the linker will align structures to 4 bytes.
> > >
> > > If the struct is padded to 6 bytes and the linker aligns it to 4 byte
> > > everything will be naturally aligned, as far as I can see.
> > >
> > > > FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
> > > > not a modulo of the size of section __mod_ssb_device_table=64.
> > > > Fix definition of struct ssb_device_id in mod_devicetable.h
> > >
> > > So this message tells me the table size is 64 bytes. There are 8 entries,
> > > so it seems the structure is padded to 8 bytes.
> > > But above that it says that sizeof(struct ssb_device_id)=6
> > >
> > > IMO this sanity check is broken and not the code.
> > >
> > > Where does this sanity check message come from? The linker?
> > $ git grep 'not a modulo'
> > scripts/mod/file2alias.c:               fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
> >
> > It is a consistencycheck between host and target
> > layout of data.
> > You need to pad the structure so it becomes 8 byte in size.
>
> Ok, I looked at the code and it is hightly questionable to me that this
> check does work in a crosscompile environment (which the ARM build
> most likely is).
>
> It seems to check the size of the structure in the .o file against
> the size of the structure on the _host_ where it is compiled.
> I can't see why we would want to check _anything_ of the target stuff
> to the host this stuff is compiled on.
> I can compile an ARM kernel on any machine I want.
>
> There actually is a comment:
>  * Check that sizeof(device_id type) are consistent with size of section
>  * in .o file. If in-consistent then userspace and kernel does not agree
>  * on actual size which is a bug.
>
> So it seems what this check _wants_ to compare the sizeof the structure
> in the kernel to the size of the stucture in the userland of the target system.
> But it does _not_ do that.
> It does compare the size of the structure in the kernel against the size of
> the stucture in userland on the machine it is _compiled_ on.
> That is wrong.

Does this thread [1] provide any clues as to the Right Thing (TM) to do?

It should be noted that Linus and Andrew signed off on the m68k fix
[2]. I'm CC'ing them and Al Viro on this email to solicit their input.

Gordon

[1] http://www.gossamer-threads.com/lists/linux/kernel/801528
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7492d4a416d68ab4bd254b36ffcc4e0138daa8ff

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
