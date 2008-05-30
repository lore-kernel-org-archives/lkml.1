Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYE3KZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYE3KZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYE3KZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:25:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56501 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYE3KZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:25:30 -0400
Date: Fri, 30 May 2008 12:26:19 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080530102619.GA2468@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

sync_file_range(SYNC_FILE_RANGE_WRITE) blocks ... which makes problem
for s2disk: there we want to start writeout as early as possible
(system is going to shut down after write, and we need the data on
disk).

Unfortuantely, sync_file_range(SYNC_FILE_RANGE_WRITE) blocks, which
does not work for us. Is there non-blocking variant? "Start writeout
on this fd, but don't block me"?

For now I'm doing:

static inline int start_writeout(int fd)
{
#ifdef SYS_sync_file_range
        if (fork())
                return 0;
        else {
                syscall(SYS_sync_file_range, fd,
                        (loff_t)0, (loff_t)0, SYNC_FILE_RANGE_WRITE);
                exit(0);
        }
#else
        errno = ENOSYS;
        return -1;
#endif
}

...but I'd prefer something more elegant...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
