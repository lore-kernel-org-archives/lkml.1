Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZFAVpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZFAVpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZFAVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:45:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59737 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbZFAVpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:45:23 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
References: <m1skkf761y.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Jun 2009 14:45:17 -0700
In-Reply-To: <m1skkf761y.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sat\, 11 Apr 2009 05\:01\:29 -0700")
Message-ID: <m1oct739xu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 0/23] File descriptor hot-unplug support v2
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found myself looking at the uio, seeing that it does not support pci
hot-unplug, and thinking "Great yet another implementation of
hotunplug logic that needs to be added".

I decided to see what it would take to add a generic implementation of
the code we have for supporting hot unplugging devices in sysfs, proc,
sysctl, tty_io, and now almost in the tun driver.

Not long after I touched the tun driver and made it safe to delete the
network device while still holding it's file descriptor open I someone
else touch the code adding a different feature and my careful work
went up in flames.  Which brought home another point at the best of it
this is ultimately complex tricky code that subsystems should not need
to worry about.

What makes this even more interesting is that in the presence of pci
hot-unplug it looks like most subsystems and most devices will have to
deal with the issue one way or another.

This infrastructure could also be used to implement both force
unmounts and sys_revoke.  When I could not think of a better name for
I have drawn on that and used revoke.

The following changes draw on and generalize the work in tty_io sysfs,
proc, and sysctl and move it into the vfs level.  Where the basic
primitives are running faster, and the solution is more general.


... Changes since version 1.

All of that lead to the first version of this patchset.  The feedback
I got from that was generally positive but there was a concern about
performance  when two there are two simultaneous accessors to the tty
at the same time.

After looking into the performance concerns of what happens when
multiple programs access the same struct file and finding that I could
not rule out a performance regression I have gone back and redesigned
my mutual exclusion primitive creating something simpler and faster.

I have also changed my synchronization primitives extending them to
protect most of what is read-only in struct file today and abandoning
rcu-ness of struct file.

Giving up rcu-ness leads to true exclusion and makes the code much
easier to think about.

In this patchset is the basic code patchs 1-4 and a conversion of
the vfs except for the nfsd entry points.  Enough for a reasonable
result. 

These patches are based on Al's vfs/for-next tree.

The vfs changes in this patchset.

 Documentation/filesystems/vfs.txt |    5 +
 drivers/char/pty.c                |    2 +-
 drivers/char/tty_io.c             |   22 ++--
 fs/Kconfig                        |    4 +
 fs/aio.c                          |   51 +++++--
 fs/compat.c                       |   16 ++-
 fs/compat_ioctl.c                 |   14 ++-
 fs/eventpoll.c                    |   41 +++++-
 fs/fcntl.c                        |   28 +++--
 fs/file_table.c                   |  281 +++++++++++++++++++++++++++++--------
 fs/inode.c                        |    1 +
 fs/ioctl.c                        |    8 +-
 fs/locks.c                        |    8 +-
 fs/namei.c                        |   11 ++-
 fs/open.c                         |   81 +++++++++--
 fs/proc/base.c                    |   29 ++--
 fs/read_write.c                   |  122 ++++++++++++----
 fs/readdir.c                      |   20 ++-
 fs/select.c                       |   53 ++++++-
 fs/splice.c                       |  111 ++++++++++-----
 fs/super.c                        |    1 -
 fs/sync.c                         |    9 +-
 include/linux/fs.h                |   49 ++++++-
 include/linux/mm.h                |    2 +
 include/linux/poll.h              |    3 +
 include/linux/sched.h             |    7 +
 include/linux/tty.h               |    2 +-
 mm/fadvise.c                      |    7 +
 mm/filemap.c                      |   25 ++--
 mm/memory.c                       |   98 +++++++++++++
 mm/mmap.c                         |   78 +++++++----
 mm/nommu.c                        |   21 +++-
 security/selinux/hooks.c          |    8 +-
 33 files changed, 950 insertions(+), 268 deletions(-)

The necessary changes to proc to take advantage of this functionality.

 fs/proc/Kconfig         |    1 +
 fs/proc/generic.c       |   56 +++-----
 fs/proc/inode.c         |  354 ++++-------------------------------------------
 fs/proc/internal.h      |    1 +
 include/linux/proc_fs.h |    4 -
 5 files changed, 44 insertions(+), 372 deletions(-)
