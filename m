Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbXFOUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbXFOUBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXFOUBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:01:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:45977 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbXFOUBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:01:39 -0400
Date: Fri, 15 Jun 2007 13:01:14 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Gerrit Huizenga <gh@us.ibm.com>, holzheu@linux.vnet.ibm.com,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070615200114.GA14130@suse.de>
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com> <4672DFC7.20801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4672DFC7.20801@oracle.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 11:51:51AM -0700, Randy Dunlap wrote:
>  Gerrit Huizenga wrote:
> > On Thu, 14 Jun 2007 12:38:53 +0200, holzheu wrote:
> >> On Thu, 2007-06-14 at 11:41 +0200, Jan Kara wrote:
> >>>   <snip>
> >>>
> >>>> Your proposal is similar to one I made to some Japanese developers
> >>>> earlier this year.  I was more modest, proposing that we
> >>>>
> >>>> - add an enhanced printk
> >>>>
> >>>> 	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);
> >>>   Maybe a stupid idea but why do we want to assign these numbers by hand?
> >>> I can imagine it could introduce collisions when merging tons of patches
> >>> with new messages... Wouldn't it be better to compute say, 8-byte hash
> >>> from the message and use it as it's identifier? We could do this
> >>> automagically at compile time.
> >> Of course automatically generated message numbers would be great and
> >> something like:
> >>
> >> hub.4a5bcd77: Detected some problem.
> >>
> >> looks acceptable for me.
> >>
> >> We could generate the hash using the format string of the printk. Since
> >> we specify the format string also in KMSG_DOC, the hash for the
> >> KMSG_DOC and the printk should match and we have the required link
> >> between printk and description.
> >>
> >> So technically that's probably doable.
> >>
> >> Problems are:
> >>
> >> * hashes are not unique
> >> * We need an additional preprocessor step
> >> * The might be people, who find 8 character hash values ugly in printks
> >>
> >> The big advantage is, that we do not need to maintain message numbers.
> >>
> >>> I know it also has it's problems - you
> >>> fix a spelling and the message gets a different id and you have to
> >>> update translation/documentation catalogue but maybe that could be
> >>> solved too...
> >> Since in our approach the message catalog is created automatically for
> >> exactly one kernel and the message catalog belongs therefore to exactly
> >> one kernel, I think the problem of changing error numbers is not too
> >> big.
> > We just had a meeting with the Japanese and several other participants
> > from the vendor and community side and came up with a potential proposal
> > that is similar to many things discussed here.  It has the benefit that
> > it seems implementable and low/no overhead on most kernel developers.
> > The basic proposal is to use a tool, run by the kernel Makefile to
> > extract kernel messages from either the kernel source or the .i files
> > (both have advantages, although I prefer the source to the .i file
> > since it 1) gets all messages and 2) is probably a little quicker with
> > less impact to the standard kernel make.
> > These messages would be stored in a file in the source tree, e.g.
> > usr/src/linux/Translations/English.  As each message is added to that
> > file, we calculate, say, an MD5 sum of the printk (dev_printk, sdev_printk,
> > etc.) string, and the text file ultimately contains:
> > MD5 Checksum of text; the printk text itself, the File name, the line 
> > number.
> > The checksum is run over just the printk.  We definitely would not include
> > the line number since the line number is too volatile.  Including the
> > file name in the hash *might* help disambiguate the hash a bit better in
> > the case of duplicates, but there was some debate that duplicates might
> > be better handled in other ways.
> > Andrew mentioned a mechanism for adding a subsystem tag or other tag
> > which helps disambiguate the message, either in the message file or in
> > the end user documentation (e.g. the Message Pedia/mPedia that the Japanese
> > have already created with ~350 messages, and a total of ~700 targetted
> > by the end of the year).
> > That tag could be appended to the beginning of the printk, to the end of
> > the printk, or even in a formatted comment at the end of the printk that
> > the tool could extract.
> > Then, the translations could be managed by anyone outside of the normal/
> > core kernel community, by simply creating a translation file, e.g.
> > usr/src/linux/Translations/Japanese, which contained the MD5 sum, the
> > translated message, the file name and line number (the last two redundent
> > perhaps but informational, and automatically generated if possible).
> > The files in the Translations directory could be uesd as the unique
> > keys for an external database (such as the Message Pedia, vendors or
> > distributions help pages, etc.) to help look up and explain root cause
> > of a problem.  The key property here is that the MD5 sum becomes the
> > key to all database entries to look up that key.
> > Further, yet another kernel config option could allow distros to output
> > the calculated MD5 sum to be printed, much like we do with timestamps
> > today.
> > End result is that these in-kernel message catalogs for translation are
> > updated automatically (mostly no kernel developer changes needed) and
> > the translations can be maintained by anyone who is interested.
> > On the topic of MD5 collisions, using a disambiguating tag would be a
> > simple addition for the few cases where that happens, the tool could
> > be educated to use that tag in the calculation of the MD5 sum, and we
> > have a 98% solution which impacts <1% of the kernel developers.
> > Folks present for this discussion included Ted T'so, James Bottomley,
> > several of the key Japenese folks interested in using this for debugging,
> > and reps from several vendors who would find this sort of info useful
> > for their folks supporting Linux in the field.
> > Comments?
> 
>  For those of us who have not been in on these meetings, I think that
>  some serious justifications are needed.  The last paragraph began to
>  go in that direction, but it needs to be more detailed and convincing.
>  And "for debugging" doesn't cut it IMO.

Full "justification" has never really been clear outside of the need to
try to duplicate what other Unixes have had for their support
departments in the past.  And yes, I've seen and sat through the
presentation by the Japanese group many different times, and talked to
the individual people who want this.

And you know, that's fine.  If anyone wants to go off and do such a
project like this, in a way that is almost entirely self-contained with
no affect on the development process or any kernel developer, I have no
objection to it at all.

And I think the proposal that Andrew made meets that requirement, so
let's wait and see what actual code comes out of this and judge it on
that merit at that time.

thanks,

greg k-h
