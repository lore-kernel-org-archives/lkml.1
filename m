Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYALUmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYALUmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYALUmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:42:24 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:45558 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754079AbYALUmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:42:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=zlt9FGnTP2+Xj6NeJEIJIBuM3Emh6+wrWsxci3TC1pize2bt7sU80998mcBpj0BFd2hkkgJmpfvF8A7JPp1oz0Z6ittuKnx174ss5pIm0wf0942noXpN2TqfyCtGK8uRnx5HJR8p8bqqYfU2QyTSwShJ5tEm9vSGTTPR8cyfbIU=  ;
X-YMail-OSG: ZKgUkTsVM1kDz9G9rfL7cW6NepT.j2YeLJj_fY86A4CxYI5nSZUAD8.Nihz_fe6MtlKGXpF.CA--
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 12 Jan 2008 21:38:48 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 06/21] ide-floppy: remove struct
	idefloppy_flexible_disk_page
Message-ID: <20080112203848.GA31954@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de> <200801120158.57895.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801120158.57895.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[...]

> This is not an equivalent transformation:
> 
> header->wp is 0 or 1
> pc.buffer[3] & 0x80 is 0 or 0x80
> 
> It seems to work fine for ->wp (because it is needlessly defined as 'int')
> but may seriously confuse set_disk_ro() and thus bdev_read_only() users.
> 
> Should be fixed to '(pc.buffer[3] & 0x80) ? 1 : 0' (or something similar).

upps, sorry, that was silly. I changed it to:

        floppy->wp = !!(pc.buffer[3] & 0x80);

> >  	set_disk_ro(floppy->disk, floppy->wp);
> > -	page = (idefloppy_flexible_disk_page_t *) (header + 1);
> > -
> > -	page->transfer_rate = be16_to_cpu(page->transfer_rate);
> > -	page->sector_size = be16_to_cpu(page->sector_size);
> > -	page->cyls = be16_to_cpu(page->cyls);
> > -	page->rpm = be16_to_cpu(page->rpm);
> > -	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
> > -	if (memcmp (page, &floppy->flexible_disk_page, sizeof (idefloppy_flexible_disk_page_t)))
> > +
> > +	transfer_rate = be16_to_cpu(*(u16 *)&pc.buffer[8 + 2]);
> > +	sector_size   = be16_to_cpu(*(u16 *)&pc.buffer[8 + 6]);
> > +	cyls          = be16_to_cpu(*(u16 *)&pc.buffer[8 + 8]);
> > +	rpm           = be16_to_cpu(*(u16 *)&pc.buffer[8 + 28]);
> > +	heads         = pc.buffer[8 + 4];
> > +	sectors       = pc.buffer[8 + 5];
> > +
> > +	capacity = cyls * heads * sectors * sector_size;
> > +
> > +	if ((1UL << IDEFLOPPY_MEDIA_CHANGED) & floppy->flags)
> 
> IDEFLOPPY_MEDIA_CHANGED is set when block device is opened for the first
> time (please check idefloppy_open() for details) so I don't think it is
> the right change.  'Flexible Disk Page' is only 32 bytes so we are better
> off with leaving 'u8 flexible_disk_page[32]' in idefloppy_floppy_t and
> doing things the old way.
> 
> Besides please do not intermix real changes like the above one with purely
> cleanup ones like idefloppy_flexible_disk_page_t removal.  This is bad from
> maintainability point of view.  If some patch causes problems it is easier
> to narrow it down by heaving purely cleanup changes separated out + if we
> would need to revert the real change we would have to make a separate patch
> doing it instead of just reverting the guilty commit (given that we don't
> want cleanup changes to be reverted as well).

How about we get rid of that chunk altogether? floppy->flexible_disk_page is
used only here for the purpose of printk-ing to the syslog and has no "real"
purpose otherwise. Do we need that info spewed into the syslog at all?

-- 
Regards/Gruﬂ,
    Boris.
