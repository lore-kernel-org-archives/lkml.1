Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZHYOn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZHYOn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbZHYOn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:43:58 -0400
Received: from mx01.bfk.de ([193.227.124.2]:37993 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbZHYOn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:43:57 -0400
To: Theodore Tso <tytso@mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
       Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<20090316122847.GI2405@elf.ucw.cz>
	<200903161426.24904.rob@landley.net>
	<20090323104525.GA17969@elf.ucw.cz>
	<87ljqn82zc.fsf@frosties.localdomain>
	<20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de>
	<20090824130125.GG23677@mit.edu>
From: Florian Weimer <fweimer@bfk.de>
Date: Tue, 25 Aug 2009 14:43:42 +0000
In-Reply-To: <20090824130125.GG23677@mit.edu> (Theodore Tso's message of "Mon\, 24 Aug 2009 09\:01\:25 -0400")
Message-ID: <82ljl8ar8h.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Theodore Tso:

> The only one that falls into that category is the one about not being
> able to handle failed writes, and the way most failures take place,

Hmm.  What does "not being able to handle failed writes" actually
mean?  AFAICS, there are two possible answers: "all bets are off", or
"we'll tell you about the problem, and all bets are off".

>> Isn't this by design?  In other words, if the metadata doesn't survive
>> non-atomic writes, wouldn't it be an ext3 bug?
>
> Part of the problem here is that "atomic-writes" is confusing; it
> doesn't mean what many people think it means.  The assumption which
> many naive filesystem designers make is that writes succeed or they
> don't.  If they don't succeed, they don't change the previously
> existing data in any way.  

Right.  And a lot of database systems make the same assumption.
Oracle Berkeley DB cannot deal with partial page writes at all, and
PostgreSQL assumes that it's safe to flip a few bits in a sector
without proper WAL (it doesn't care if the changes actually hit the
disk, but the write shouldn't make the sector unreadable or put random
bytes there).

> Is that a file system "bug"?  Well, it's better to call that a
> mismatch between the assumptions made of physical devices, and of the
> file system code.  On Irix, SGI hardware had a powerfail interrupt,
> and the power supply and extra-big capacitors, so that when a power
> fail interrupt came in, the Irix would run around frantically shutting
> down pending DMA transfers to prevent this failure mode from causing
> problems.  PC class hardware (according to Ted's law), is cr*p, and
> doesn't have a powerfail interrupt, so it's not something that we
> have.

The DMA transaction should fail due to ECC errors, though.

> Ext3, ext4, and ocfs2 does physical block journalling, so as long as
> journal truncate hasn't taken place right before the failure, the
> replay of the physical block journal tends to repair this most (but
> not necessarily all) cases of "garbage is written right before power
> failure".  People who care about this should really use a UPS, and
> wire up the USB and/or serial cable from the UPS to the system, so
> that the OS can do a controlled shutdown if the UPS is close to
> shutting down due to an extended power failure.

I think the general idea is to protect valuable data with WAL.  You
overwrite pages on disk only after you've made a backup copy into WAL.
After a power loss event, you replay the log and overwrite all garbage
that might be there.  For the WAL, you rely on checksum and sequence
numbers.  This still doesn't help against write failures where the
system continues running (because the fsync() during checkpointing
isn't guaranteed to report errors), but it should deal with the power
failure case.  But this assumes that the file system protects its own
data structure in a similar way.  Is this really too much to demand?

Partial failures are extremely difficult to deal with because of their
asynchronous nature.  I've come to accept that, but it's still
disappointing.

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
