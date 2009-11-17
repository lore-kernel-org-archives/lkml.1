Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZKRDzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZKRDzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZKRDzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:55:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZKRDzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:55:24 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/2] Fix mm->flags consistency issue in coredump
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 17 Nov 2009 18:53:05 -0500
Message-ID: <20091117235305.30900.43344.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

These patches are for fixing coredump mm->flags consistency issue.

---
1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
1788                 up_write(&mm->mmap_sem);
1789                 put_cred(cred);
1790                 goto fail;
1791         }
1792
[...]
1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
1799                 flag = O_EXCL;          /* Stop rewrite attacks */
1800                 cred->fsuid = 0;        /* Dump root private */
1801         }
---

Since dumpable bits are not protected by lock, there is a
chance to change these bits between (1) and (2).

To solve this issue, this patch copies mm->flags to
coredump_params.mm_flags at the beginning of do_coredump()                      and uses it instead of get_dumpable() while dumping core.
This series also introduce coredump parameter structure
for simplify bimfmt->core_dump interface.

Thank you,

---

Masami Hiramatsu (2):
      Pass mm->flags as a coredump parameter for consistency
      mm: Introduce coredump parameter structure


 fs/binfmt_aout.c        |   13 ++++++-----
 fs/binfmt_elf.c         |   50 +++++++++++++++++++----------------------
 fs/binfmt_elf_fdpic.c   |   38 ++++++++++++-------------------
 fs/binfmt_flat.c        |    6 ++---
 fs/binfmt_som.c         |    2 +-
 fs/exec.c               |   58 ++++++++++++++++++++++++++++++-----------------
 include/linux/binfmts.h |   11 ++++++++-
 7 files changed, 97 insertions(+), 81 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
