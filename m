Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbYBZHzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbYBZHzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761145AbYBZHze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:55:34 -0500
Received: from mail2.shareable.org ([80.68.89.115]:54435 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761132AbYBZHzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:55:33 -0500
Date: Tue, 26 Feb 2008 07:55:26 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226075526.GF30238@shareable.org>
References: <20080226072649.GB30238@shareable.org> <47C3C33F.1070908@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C3C33F.1070908@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jamie Lokier wrote:
> >By durable, I mean that fsync() should actually commit writes to
> >physical stable storage,
> 
> Yes, it should.

Glad we agree :-)

> >I was surprised that fsync() doesn't do this already.  There was a lot
> >of effort put into block I/O write barriers during 2.5, so that
> >journalling filesystems can force correct write ordering, using disk
> >flush cache commands.
> >
> >After all that effort, I was very surprised to notice that Linux 2.6.x
> >doesn't use that capability to ensure fsync() flushes the disk cache
> >onto stable storage.
> 
> It's surprising you are surprised, given that this [lame] fsync behavior 
> has remaining consistently lame throughout Linux's history.

I was surprised because of the effort put into IDE write barriers to
get it right for in-kernel filesystems, and the messages in 2004
telling concerned users that fsync would use barriers in 2.6, which it
does sometimes but not always.

> [snip huge long proposal]
> 
> Rather than invent new APIs, we should fix the existing ones to _really_ 
> flush data to physical media.
>
> Linux should default to SAFE data storage, and permit users to retain 
> the older unsafe behavior via an option.  It's completely ridiculous 
> that we default to an unsafe fsync.

Well, I agree with you.  Which is why the "new API" I suggested, being
really just an extension of an existing one, allows fsync() to be SAFE
if that's what people want.

To be fair, fsync() is rather overkill for some apps.
sync_file_range() is obviously the right place for fine tuning "less
safe" variations.

> And [anticipating a common response from others] it is completely 
> irrelevant that POSIX fsync(2) permits Linux's current behavior.  The 
> current behavior is unsafe.
> 
> Safety before performance -- ESPECIALLY when it comes to storing user data.

Especially now that people work a lot in guest VMs, where the IDE
barrier stuff doesn't work if the host fdatasync() doesn't work.

Since it happened with Mac OS X, I wouldn't be surprised if changing
fsync() and just that wasn't popular.  Heck, you already get people
asking "how to turn off fsync in PostGreSQL"...  (Haven't those people
heard of transactions...?)

But with changes to sync_file_range() [or whatever... I don't care] to
support database's finely tuned commit needs, and then adoption of
that by database vendors, perhaps nobody will mind fsync() becoming
safe then.

Nobody seems bothered by it's performance for other things.

-- Jamie
