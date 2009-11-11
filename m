Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZKKPTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZKKPTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbZKKPTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:19:33 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:43225 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276AbZKKPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:19:33 -0500
Date: Wed, 11 Nov 2009 16:19:37 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: posix_fadvise/WILLNEED synchronous on fuse/sshfs instead of async?
Message-ID: <20091111151937.GC20655@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to use posix_fadvise(...POSIX_FADVISE_WILLNEED) to
implement userspace read-ahead (with a bigger read-ahead window than
the kernel default) I found that if the underlying filesystem is
fuse/sshfs posix_fadvise is no longer doing asynchronous reads:

strace -tt with mnt/testfile on sshfs and server with very slow
upstream (ADSL):
5345  00:00:17.334209 open("mnt/testfile", O_RDONLY|O_LARGEFILE) = 3
5345  00:00:18.011383 _llseek(3, 0, [3544379], SEEK_END) = 0
5345  00:00:18.011626 _llseek(3, 0, [0], SEEK_SET) = 0
5345  00:00:18.012393 fadvise64_64(3, 0, 1048576, POSIX_FADV_WILLNEED) = 0
5345  00:01:02.438097 write(1, "[file] File size is 3544379 byte"..., 34) = 34

Note that fadvise takes 40 seconds...
Is this expected behaviour?
I would have expected that fadvise is always asynchronous and I
could rely on the call to return almost immediately.

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
