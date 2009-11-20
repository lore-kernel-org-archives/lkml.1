Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZKTQkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZKTQkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZKTQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:40:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZKTQks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:48 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 00/15] Remove BKL from default_llseek() and other issues (v2)
Date: Fri, 20 Nov 2009 17:40:30 +0100
Message-Id: <1258735245-25826-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

I worked on the list of driver that need fixing and found some other issue that
I think are worth fixing. I post them in one big series because they are all
related to llseek in some way even it they are not directly related to the
removal of the big kernel lock from default_llseek():

 - the osst driver does not really support seeking but wants to work around
   broken userspace and therefore needs a succeeding llseek
 - use of f_pos in frv due to incomplete patch when removing file argument from
   proc_handler
 - filesystems that use BKL in readdir and don't have llseek set shouldn't fall
   back to default_llseek() but use generic_file_llseek() instead

I hope that the patches address your feedback well.

Comments?

Cheers,
	Jan

Jan Blunck (15):
  Introduce noop_llseek()
  osst: Use noop_llseek() instead of default_llseek()
  osst: Update ppos instead of using file->f_pos
  s390: tape_char should update ppos instead of using file->f_pos
  flash_read should update ppos instead of file->f_pos
  eeprom_read()/eeprom_write() should update ppos instead of
    file->f_pos
  sched_feat_write: Update ppos instead of file->f_pos
  airo: Use ppos instead of file->f_pos
  frv: remove "struct file *" argument from sysctl ->proc_handler
  mISDN: Remove unnecessary test on f_pos
  zcrypt: Use nonseekable_open()
  rtc-m41t80: Use nonseekable_open()
  Do not fallback to default_llseek() when readdir() uses BKL
  BKL: Remove BKL from default_llseek()
  BKL: Update documentation on llseek()

 Documentation/filesystems/Locking   |    5 +++--
 arch/cris/arch-v10/drivers/eeprom.c |   34 +++++++++++++---------------------
 arch/frv/kernel/sysctl.c            |   18 ++++++++++--------
 drivers/isdn/mISDN/timerdev.c       |    2 --
 drivers/net/wireless/airo.c         |    2 +-
 drivers/rtc/rtc-m41t80.c            |    6 +-----
 drivers/s390/char/tape_char.c       |    4 ++--
 drivers/s390/crypto/zcrypt_api.c    |    2 +-
 drivers/sbus/char/flash.c           |    6 +++---
 drivers/scsi/osst.c                 |    9 +++++----
 fs/autofs/root.c                    |    1 +
 fs/freevxfs/vxfs_lookup.c           |    2 ++
 fs/isofs/dir.c                      |    1 +
 fs/ncpfs/dir.c                      |    1 +
 fs/qnx4/dir.c                       |    1 +
 fs/read_write.c                     |    8 ++++++--
 fs/reiserfs/dir.c                   |    1 +
 fs/smbfs/dir.c                      |    1 +
 fs/udf/dir.c                        |    1 +
 include/linux/fs.h                  |    1 +
 kernel/sched.c                      |    2 +-
 21 files changed, 56 insertions(+), 52 deletions(-)

