Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbZKRNzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbZKRNzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZKRNzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:55:37 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:40021 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001AbZKRNzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:55:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=TTaZjry7Zq0XiHzoO83uFVM3ID1f2PYU6gAPpb7m8wrV6skuRTQKBTCYpvJvrgUqIJ
         /6wT3eZUpoAUp/H1QGqhfu2AMjWTCXw+Dp+SerhiRat/fZhFM6yom6tEWC4e5xnWCmPW
         lSD0B+43uIbo69G/nUkPAwLmS2JnLupEhNKQk=
Date: Wed, 18 Nov 2009 22:17:56 +0800
From: JiSheng Zhang <jszhang3@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org,
       jack@suse.cz, rmk@arm.linux.org.uk, linux-arm@lists.infradead.org
Subject: Re: [BUG]2.6.27.y some contents lost after writing to mmaped file
Message-ID: <20091118221756.367c005e@ustc>
In-Reply-To: <20091117190635.GB31105@duck.suse.cz>
References: <2df346410911151938r1eb5c5e4q9930ac179d61ef01@mail.gmail.com>
	<20091117015655.GA8683@suse.de>
	<20091117123622.GI27677@think>
	<20091117190635.GB31105@duck.suse.cz>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 20:06:35 +0100
Jan Kara <jack@suse.cz> wrote:

> On Tue 17-11-09 07:36:22, Chris Mason wrote:
> > On Mon, Nov 16, 2009 at 05:56:55PM -0800, Greg KH wrote:
> > > On Mon, Nov 16, 2009 at 11:38:57AM +0800, JiSheng Zhang wrote:
> > > > Hi,
> > > > 
> > > > I triggered a failure in an fs test with fsx-linux from ltp. It seems that
> > > > fsx-linux failed at mmap->write sequence.
> > > > 
> > > > Tested kernel is 2.6.27.12 and 2.6.27.39
> > > 
> > > Does this work on any kernel you have tested?  Or is it a regression?
> > > 
> > > > Tested file system: ext3, tmpfs.
> > > > IMHO, it impacts all file systems.
> > > > 
> > > > Some fsx-linux log is:
> > > > 
> > > > READ BAD DATA: offset = 0x2771b, size = 0xa28e
> > > > OFFSET  GOOD    BAD     RANGE
> > > > 0x287e0 0x35c9  0x15a9     0x80
> > > > operation# (mod 256) for the bad datamay be 21
> > > > ...
> > > > 7828: 1257514978.306753 READ     0x23dba thru 0x25699 (0x18e0 bytes)
> > > > 7829: 1257514978.306899 MAPWRITE 0x27eeb thru 0x2a516 (0x262c bytes)
> > > >  ******WWWW
> > > > 7830: 1257514978.307504 READ     0x2771b thru 0x319a8 (0xa28e bytes)
> > > >  ***RRRR***
> > > > Correct content saved for comparison
> > > > ...
>   Hmm, how long does it take to reproduce? I'm running fsx-linux on tmpfs
> for a while on 2.6.27.21 and didn't hit the problem yet.

I forget to mention that the test were done on an arm board with 64M ram. 
I have tested fsx-linux again on pc, it seems that failure go away.

> 
> > > Are you sure that the LTP is correct?  It wouldn't be the first time it
> > > wasn't...
> > 
> > I'm afraid fsx usually finds bugs.  I thought Jan Kara recently fixed
> > something here in ext3, does 2.6.32-rc work?
>   Yeah, fsx usually finds bugs. Note that he sees the problem also on tmpfs
> so it's not ext3 problem. Anyway, trying to reproduce with 2.6.32-rc? would
> be interesting.

Currently the arm board doesn't support 2.6.32-rc. But I test with 2.6.32-rc7
On my pc box, there's no failure so far.

> 
> 								Honza

I found this via google:
http://marc.info/?t=118026315000001&r=1&w=2

I even tried the code from
http://marc.info/?l=linux-arch&m=118030601701617&w=2
I got mostly:
firstfirstfirst
firstfirstfirst
firstfirstfirst


No change after pass "MS_SYNC|MS_INVALIDATE" to msync and make the 
flush_dcache_page() call unconditional in do_generic_mapping_read.
This behavior is different from what I read from the mail thread above.

> void do_generic_mapping_read(struct address_space *mapping,
>                              struct file_ra_state *_ra,
>                              struct file *filp,
>                              loff_t *ppos,
>                              read_descriptor_t *desc,
>                              read_actor_t actor)
> {
> ...
>                 /* If users can be writing to this page using arbitrary
>                  * virtual addresses, take care about potential aliasing
>                  * before reading the page on the kernel side.
>                  */
>                 if (1 || mapping_writably_mapped(mapping))
>                         flush_dcache_page(page);

Then I run fsx-linux after the above modification, fsx-linux failed all 
the same both on tmpfs and ext3
