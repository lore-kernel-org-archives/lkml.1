Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYLBJjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYLBJjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLBJjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:39:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35015 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYLBJjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:39:10 -0500
Date: Tue, 2 Dec 2008 10:40:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: mikulas@artax.karlin.mff.cuni.cz, clock@atrey.karlin.mff.cuni.cz,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: writing file to disk: not as easy as it looks
Message-ID: <20081202094059.GA2585@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, it looks like POSIX file interface is on the lowest step of
Rusty's scale: one that is impossible to use correctly. Yes, it seems
impossible to reliably&safely write file to disk under Linux. Double
plus uncool.

So... how to write file to disk and wait for it to reach the stable
storage, with proper error handling?

> file

	...does not work, because it fails to check for errors.

touch file || error_handling.

	Is not a lot better, unless you mount your filesystems "sync"
	... and noone does that.

dd conv=fsync if=something of=file 2> /dev/zero || error_handling

	Is a bit better; not much, unless you mount your filesystems
	"dirsync", because you have file data on disk, but they do not have
	directory entry pointing to them. Noone uses dirsync.

	So you need something like

dd conv=fsync if=something of=file 2> /dev/zero || error_handling
fsync . || error_handling
fsync .. || error_handling
fsync ../.. || error_handling
fsync ../../.. || error_handling

	... which mostly works...

	If you are alone on the filesystem... fsync only returns
	errors to the first process. So if you have other process that
	does fsync ., maybe it gets "your" error and you do not learn
	of the problem.

Question is... Is there way that I missed and that actually works?
									Pavel	
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
