Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0CJQOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 11:14:36 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:51029 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756785Ab0CJQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 11:14:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACZTl0vCTtAn/2dsb2JhbACaU3O9QoR5BA
Date: Wed, 10 Mar 2010 17:14:30 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] allow retrieving entries with trailing dots
Message-ID: <20100310161429.GA16799@frolo.macqel>
References: <20100310123257.GA2899@frolo.macqel> <87d3zc1bjo.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3zc1bjo.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ogawa

Thanks for the quick answer.

On Wed, Mar 10, 2010 at 11:44:27PM +0900, OGAWA Hirofumi wrote:
> Philippe De Muyter <phdm@macqel.be> writes:
> 
> > --- a/fs/fat/namei_vfat.c	2009-09-10 00:13:59.000000000 +0200
> > +++ b/fs/fat/namei_vfat.c	2010-02-08 02:28:37.010096903 +0100
> > @@ -702,9 +702,22 @@
> >  static int vfat_find(struct inode *dir, struct qstr *qname,
> >  		     struct fat_slot_info *sinfo)
> >  {
> > -	unsigned int len = vfat_striptail_len(qname);
> > +	int err;
> > +	unsigned int len;
> > +
> > +	/* Some combined ethernet + usb external hard drive do not
> > +	 * remove the trailing dots when creating entries in ethernet mode.
> > +	 * (e.g. Iomega Home Network Hard Drive)
> > +	 * Make accessing those entries possible.
> > +	 */
> > +	err = fat_search_long(dir, qname->name, qname->len, sinfo);
> > +	if (!err)
> > +		return err;
> > +	len = vfat_striptail_len(qname);
> >  	if (len == 0)
> >  		return -ENOENT;
> > +	if (len == qname->len)
> > +		return err;
> >  	return fat_search_long(dir, qname->name, len, sinfo);
> >  }
> 
> This would be bad for both (standard and IO-MEGA hack).
> 
> This introduces unneeded directory-parse to standard one.  And for

No.  There will only be a second parse if someone is looking for a filename
with a trailing dot, and it is not found (*).  I there is no trailing dot in qname, only the first fat_search_long will be called, because len after vfat_striptail_len would be equal to qname->len.

> IO-MEGA, this wouldn't provide proper filename handling.

For accessing IO-MEGA disk in read mode, this is perfect.  I didn't want
to replicate IO-MEGA write behaviour here, only fix the read behaviour for
such simple commands as 'ls', 'find' and all the directory browsers.

> 
> If it wants to handle the tailing-dot as a part of filename, it
> shouldn't be able to access to the stripped-dots filename. (For simple
> example, I guess you can't do "mv a a." with this patch.)

As I explained above, I only fix read-access on IO-MEGA drives, while
preserving standard behaviour for write mode.

But I'll try your testcase asap.  Which behaviour do you expect ?
I would expect a no-op, because I did not change the write-behaviour.

Best regards

Philippe

(*) This will never happen with 'ls', 'find' and friends who get their name
list from getdents.  This could only happen if someone tries to open
a file called 'a.' on his vfat file-system, which of course does not exist
in his normal vfat file-system.
