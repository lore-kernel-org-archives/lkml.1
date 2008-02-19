Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbYBSACU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbYBSACU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYBSACJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:02:09 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:59491 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbYBSACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:02:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Date: Tue, 19 Feb 2008 01:01:27 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802190017.04432.mb@bu3sch.de> <20080218234212.GA25680@uranus.ravnborg.org>
In-Reply-To: <20080218234212.GA25680@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802190101.27429.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 00:42:12 Sam Ravnborg wrote:
> On Tue, Feb 19, 2008 at 12:17:04AM +0100, Michael Buesch wrote:
> > On Tuesday 19 February 2008 00:00:58 Russell King wrote:
> > > > > Why can't we have an array of this structure on ARM?
> > > > > 
> > > > > struct ssb_device_id {
> > > > >        __u16   vendor;
> > > > 
> > > > 2 bytes
> > > > 
> > > > >        __u16   coreid;
> > > > 
> > > > 2 bytes
> > > > 
> > > > >        __u8    revision;
> > > > 
> > > > 1 byte
> > > > 
> > > > > };
> > > > 
> > > > and therefore sizeof this structure will be 5 bytes, but because of the
> > > > ABI rules (which are _explicitly_ allowed by the C standard), it'll
> > > > become 8 bytes due to padding afterwards.
> > > 
> > > Another guess might be that, if using AEABI, this structure might
> > > be 6 bytes in size, but the linker will align structures to 4 bytes.
> > 
> > If the struct is padded to 6 bytes and the linker aligns it to 4 byte
> > everything will be naturally aligned, as far as I can see.
> > 
> > > FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
> > > not a modulo of the size of section __mod_ssb_device_table=64.
> > > Fix definition of struct ssb_device_id in mod_devicetable.h
> > 
> > So this message tells me the table size is 64 bytes. There are 8 entries,
> > so it seems the structure is padded to 8 bytes.
> > But above that it says that sizeof(struct ssb_device_id)=6
> > 
> > IMO this sanity check is broken and not the code.
> > 
> > Where does this sanity check message come from? The linker?
> $ git grep 'not a modulo'
> scripts/mod/file2alias.c:               fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
> 
> It is a consistencycheck between host and target
> layout of data.
> You need to pad the structure so it becomes 8 byte in size.

Ok, I looked at the code and it is hightly questionable to me that this
check does work in a crosscompile environment (which the ARM build
most likely is).

It seems to check the size of the structure in the .o file against
the size of the structure on the _host_ where it is compiled.
I can't see why we would want to check _anything_ of the target stuff
to the host this stuff is compiled on.
I can compile an ARM kernel on any machine I want.

There actually is a comment:
 * Check that sizeof(device_id type) are consistent with size of section
 * in .o file. If in-consistent then userspace and kernel does not agree
 * on actual size which is a bug.

So it seems what this check _wants_ to compare the sizeof the structure
in the kernel to the size of the stucture in the userland of the target system.
But it does _not_ do that.
It does compare the size of the structure in the kernel against the size of
the stucture in userland on the machine it is _compiled_ on.
That is wrong.

-- 
Greetings Michael.
