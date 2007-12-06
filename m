Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXLFXUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXLFXUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbXLFXUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:20:22 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50715 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXLFXUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:20:20 -0500
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: syslets v7: back to basics
Date: Thu,  6 Dec 2007 15:20:13 -0800
Message-Id: <1196983219534-git-send-email-zach.brown@oracle.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patches are a substantial refactoring of the syslet code.  I'm
branding them as the v7 release of the syslet infrastructure, though they
represent a signifiant change in focus.

My current focus is to see the most fundamental functionality brought to
maturity.  To me, this means getting a ABI that is used by applications through
glibc on x86 and PPC64.   Only once that is ready should we distract ourselves
with advanced complexity.

To that end, this patch series differs from v6 in significant ways:

 * syslets are initiated by providing syslet arguments to sys_indirect().

 * uatoms, threadlets, and the kaio changes are postponed until they can be
   justified and rebuilt on more complete infrastructure.  (I'm not saying
   these shouldn't or won't be persued.  I'm saying that we should get the
   simplest piece working first.)

 * the code is clarified and commented, the patches are bisectable and pass
   checkpatch.

The use of sys_indirect() and the move from 'atom's simplified the ABI
considerably.  I've put a trivial example in a syslet-userspace git tree:

    git://git.kernel.org/pub/scm/linux/kernel/git/zab/syslets-userspace.git

This git repository will grow more tests and documentation over time.

The patches sent with this mail are based on the v6 indirect patches but they
aren't included.  The full syslets patch series, including the indirect
patches, are available in a few forms:

broken out patch series:
    http://www.kernel.org/pub/linux/kernel/people/zab/broken-out/syslets/

in a 'syslets' git branch off of current linux-2.6.git:
    git://git.kernel.org/pub/scm/linux/kernel/git/zab/linux-2.6.git syslets

git tree of the guilt .git/patches directory:
    git://git.kernel.org/pub/scm/linux/kernel/git/zab/guilt-series.git

The patches were barely tested on i386 and x86_64.

There are both implementation details and design problems left.  My hope is
that we can address these in the coming weeks.

 - Do we stop the user from initiating more syslets than fit in the ring? 
 - Do we worry now about the hashed ring mutexes scaling poorly?  (They will.)
 - What are the semantics of ptrace()ing a syslet submission which blocks?
 - How should applications deal with waiting syslet tasks with stale data
   in their task_struct?  (syslet, setuid, syslet..)
 - Issuing a syslet is an implicit sys_clone(), will apps pass in clone flags?
 - Are the u32 ring index reads and writes atomic for supported architectures?

Any feedback on these questions would be greatly appreciated.

I'm particularly interested in hearing from people who are trying to use
syslets in their applications.  This will involve awkward wrappers instead of
glibc calls for now, and your machine may explode, but hopefully the chance to
influence the design of syslets would make it worth the effort.

Finally, I carried the enormous cc: list for this mail over from previous
syslet releases.  If you want to be removed or added to the list for future
syslet releases, please do let me know.

- z
