Return-Path: <linux-kernel-owner+w=401wt.eu-S1764374AbXHVQHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764374AbXHVQHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760227AbXHVQHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:07:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbXHVQHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:07:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 3/4] Hibernation: Pass CR3 in the image header on x86_64
Date: Wed, 22 Aug 2007 18:17:50 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708221015.16493.rjw@sisk.pl> <200708221020.34988.rjw@sisk.pl> <20070822082825.GC2479@elf.ucw.cz>
In-Reply-To: <20070822082825.GC2479@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708221817.51334.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 22 August 2007 10:28, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Since we already pass the address of restore_registers() in the image header,
> > we can also pass the value of the CR3 register from before the hibernation in
> > the same way.  This will allow us to avoid using init_level4_pgt page tables
> > during the restore.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> > @@ -253,10 +262,13 @@ int arch_hibernation_header_save(void *a
> >  {
> >  	struct restore_data_record *rdr = addr;
> >  
> > -	if (max_size < sizeof(struct restore_data_record))
> > +	if (max_size < sizeof(*rdr))
> >  		return -EOVERFLOW;
> >  	rdr->jump_address = restore_jump_address;
> > -	rdr->control = (restore_jump_address ^ RESTORE_MAGIC);
> > +	rdr->cr3 = restore_cr3;
> > +	rdr->magic = RESTORE_MAGIC;
> > +	rdr->crc = 0;
> > +	rdr->crc = crc32_le(0, addr, sizeof(*rdr));
> >  	return 0;
> >  }
> 
> No, I do not think I like that. I believe both -> control and -> crc
> is just useless paranoia. Bitflip in this area is not going to be any
> worse than bitflip anywhere else, we should not pretend this is
> somehow "more important".
> 
> -> control should really be "protocol version"... probably should
> contain some field that is easy to increment.

OK

Perhaps I'll just remove the crc field.  What do you think?

Rafael
