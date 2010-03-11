Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab0CKMCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 07:02:20 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:14627 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757672Ab0CKMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 07:02:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAA5qmEvCTtAn/2dsb2JhbACaWXO7cYR6BA
Date: Thu, 11 Mar 2010 13:02:14 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] allow retrieving entries with trailing dots
Message-ID: <20100311120214.GA23767@frolo.macqel>
References: <20100310123257.GA2899@frolo.macqel> <87d3zc1bjo.fsf@devron.myhome.or.jp> <20100310161429.GA16799@frolo.macqel> <87hboow105.fsf@devron.myhome.or.jp> <20100310235808.GA4353@frolo.macqel> <87bpevryxt.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpevryxt.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ogawa,

On Thu, Mar 11, 2010 at 06:26:54PM +0900, OGAWA Hirofumi wrote:
> Philippe De Muyter <phdm@macqel.be> writes:
> 
> >> >> This introduces unneeded directory-parse to standard one.  And for
> >> >
> >> > No.  There will only be a second parse if someone is looking for a filename
> >> > with a trailing dot, and it is not found (*).  I there is no trailing dot in qname, only the first fat_search_long will be called, because len after vfat_striptail_len would be equal to qname->len.
> >> 
> >> Yes, I'm saying about trailing-dot filename case. Any disadvantage to
> >> standard one is unacceptable to workaround.
> >
> > This is unavoidable.

We could perhaps reduce the disadvantage by moving the logic (test first
with the trailing dots, and then without if needed) into fat_search_long
instead of putting it in vfat_find as my patch proposal does.  This way
the name to find would only be compared once to unrelated entries,
instead of possibly twice as my patch does.

But therefore I need your help : fat_search_long isn't easy to read/modify.

The logic could be modified as such :
    - if the searched name contains trailing dots, first compare
	the truncated part to the same length of the directory entry
    - if they are the same, test the length of the rest of the directory entry
	- if length_of_rest is 0, this could be the matching entry,
	    but there could be a better one later; keep searching till the end.
	- if length_of_rest is not 0, compare the rest with the trailing dots
	    - if rests are equal, we have found it; return
	    - if rests are unequal, continue searching

> 
> We would be able to introduce new mount option to do it if needed.

A new mount option should be the last programming option.  It is better to
automatically do the right thing than to require the user to figure out
he must add a mount option in /etc/fstab or whatever.  Remember this is
for hot-plug disks.

> 
> >> 	$ ls
> >>         a.. a. a
> >>         $ rm -rf *
> >> 
> >>         $ ls
> >>         a..
> >>         $ touch a.
> >>         $ touch a
> >> ...
> >> 
> >> I assumed you want to define "a." and "a" are different name on
> >> "mv a a.", and _totally_.
> >
> > For file creation and renaming, I want to introduce no change, because there
> > is no problem.  If one wants to create a "a." file on a IO-MEGA disk suing
> > linux and USB, it is currently called "a", and that will remain exactly the
> > same.
> 
> This changed vfat_find(), so, this patch will change the behavior of all
> callers more or less. And the behavior seems to be really strange, you
> can remove "a.", but you can't create it?

Yes, you can remove any existing file, but if you want to create a file, 
the name creation rules are kept unchanged. So, creating "a." will
succeed, it will actually be called "a" on disk, but you can still refer
to it as "a." : that will succeed.  That's the strange part of the behavior
but that part is already present for compatibility reasons nor you nor me
can do anything about :(

> The behavior sounds random, right?

It's a compromise to avoid creating name entries that are not universally
accepted, but to allow accessing existing files and directories.

The mount option could be useful then to allow the creation of file and
directory names with trailing dot, but consistency between getdents and
stat/open must be automatic.

Best regards

Philippe
