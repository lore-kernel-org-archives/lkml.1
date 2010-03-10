Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab0CJX6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:58:14 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:27637 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932635Ab0CJX6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:58:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABLBl0vCTtAn/2dsb2JhbACaV3O7bIR5BA
Date: Thu, 11 Mar 2010 00:58:08 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] allow retrieving entries with trailing dots
Message-ID: <20100310235808.GA4353@frolo.macqel>
References: <20100310123257.GA2899@frolo.macqel> <87d3zc1bjo.fsf@devron.myhome.or.jp> <20100310161429.GA16799@frolo.macqel> <87hboow105.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hboow105.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ogawa,

On Thu, Mar 11, 2010 at 02:16:26AM +0900, OGAWA Hirofumi wrote:
> Philippe De Muyter <phdm@macqel.be> writes:
> 
> >> This introduces unneeded directory-parse to standard one.  And for
> >
> > No.  There will only be a second parse if someone is looking for a filename
> > with a trailing dot, and it is not found (*).  I there is no trailing dot in qname, only the first fat_search_long will be called, because len after vfat_striptail_len would be equal to qname->len.
> 
> Yes, I'm saying about trailing-dot filename case. Any disadvantage to
> standard one is unacceptable to workaround.

This is unavoidable.
Let me explain again, with better words I hope,
IOMEGA firmware allows creation of files/directories whose name have
trailing dots.

When I connect such a disk (which is vfat-formatted) via USB to my
linux computer, I want consistency between what getdents says and what
open or stat will do : if getdents says there is a file called "a.",
currently open("a.") and stat("a.") fail with ENOENT No such file or directory.
I would like open("a.") or stat("a.") to succeed.  Nothing more.
For that, I need to first search for the not truncated name.  If that fails
and the filename can be truncated then and only then, try again with the
truncated name.  I cannot let getdents truncate the name, because there 
could also be a different file really called "a".

There would be no advantage in making the change in fat_search_long,
because while searching for "a.", even if it finds a "a" entry, it must
continue till the end of the directory to be sure there is no "a.".

> 
> >> IO-MEGA, this wouldn't provide proper filename handling.
> >
> > For accessing IO-MEGA disk in read mode, this is perfect.  I didn't want
> > to replicate IO-MEGA write behaviour here, only fix the read behaviour for
> > such simple commands as 'ls', 'find' and all the directory browsers.
> >
> >> If it wants to handle the tailing-dot as a part of filename, it
> >> shouldn't be able to access to the stripped-dots filename. (For simple
> >> example, I guess you can't do "mv a a." with this patch.)
> >
> > As I explained above, I only fix read-access on IO-MEGA drives, while
> > preserving standard behaviour for write mode.
> >
> > But I'll try your testcase asap.  Which behaviour do you expect ?
> > I would expect a no-op, because I did not change the write-behaviour.
> 
> Those sound like strange.  Well, I expect there is no any change to
> standard one for IO-MEGA.
> 
> And I can't see what is your read-access mean in here. What did this
> expect to behave like e.g. following operations,

Sorry bad wording. I meant I do not want to change the behaviour for file
creation, only to fix the behaviour while accessi8ng existing files.

> 
> 	$ ls
>         a.. a. a
>         $ rm -rf *
> 
>         $ ls
>         a..
>         $ touch a.
>         $ touch a
> ...
> 
> I assumed you want to define "a." and "a" are different name on
> "mv a a.", and _totally_.

For file creation and renaming, I want to introduce no change, because there
is no problem.  If one wants to create a "a." file on a IO-MEGA disk suing
linux and USB, it is currently called "a", and that will remain exactly the
same.

Best regards

Philippe
