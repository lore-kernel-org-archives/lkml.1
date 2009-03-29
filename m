Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZC2M0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZC2M0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 08:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZC2M0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 08:26:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51078 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZC2M0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 08:26:09 -0400
Date: Sun, 29 Mar 2009 14:26:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: replace() system call needed (was Re: EXT4-ish "fixes" in UBIFS)
Message-ID: <20090329122600.GA13737@elf.ucw.cz>
References: <49CCCB0A.6070701@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CCCB0A.6070701@nokia.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-03-27 14:48:10, Artem Bityutskiy wrote:
> UBIFS has exactly the same properties like ext4 - in case
> of power cuts:
>
> 1. truncate/write/close leads to empty files
> 2. create/write/rename leads to empty files
>
> UBIFS is used in hand-held and and power-cuts are very
> often there, because users just remove battery often.
>
> I realize the "reality is different" argument, and already
> concluded that we need a similar changes as Theo has done
> for ext4:
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=bf1b69c0db7f9b9d8f02e94d40b19fca8336b991
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=f32b730a69bd56c5c9d704d8b75f03e90e290971
> http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=8411e347c3306ed36b8ca88611bf5fbf4d27d705
>
> We have a problem that user-space people do not want to
> use 'fsync()', even when they are pointed to their code
> which is doing create/write/rename/close without fsync().

Well... they really don't want to spin the disk up for the
fsync(). I'm not sure if fsync() is really sensible operation to use
there.

> 1. truncate/write/close leads to empty files

this is buggy.

> 2. create/write/rename leads to empty files

...but this should not be. If we want to make that explicit, we should
provide "replace()" operation; where replace is rename that makes sure
that source file is completely on media before commiting the rename.

It is somehow similar to fsync()/rename(), but does not force disk
spin up immediately -- it only inserts "barrier" between data blocks
and rename. (And yes, it should be implemented as fsync()+rename() for
filesystems like xfs. It can be implemented as plain rename for ext3
and ext4 after the fixes...)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
