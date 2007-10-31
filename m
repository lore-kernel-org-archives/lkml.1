Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXJaP0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXJaP0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759720AbXJaPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33441 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758892AbXJaPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:24 -0400
Date: Wed, 31 Oct 2007 08:11:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 09/26] Fix sys_ipc() SEMCTL on sparc64.
Message-ID: <20071031151127.GJ2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sys_ipc-semctl-on-sparc64.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

changeset 6536a6b331d3225921c398eb7c6e4ecedb9b05e0 from mainline

Thanks to Tom Callaway for the excellent bug report and
test case.

sys_ipc() has several problems, most to due with semaphore
call handling:

1) 'err' return should be a 'long'
2) "union semun" is passed in a register on 64-bit compared
   to 32-bit which provides it on the stack and therefore
   by reference
3) Second and third arguments to SEMCTL are swapped compared
   to 32-bit.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/sys_sparc.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -436,7 +436,7 @@ out:
 asmlinkage long sys_ipc(unsigned int call, int first, unsigned long second,
 			unsigned long third, void __user *ptr, long fifth)
 {
-	int err;
+	long err;
 
 	/* No need for backward compatibility. We can start fresh... */
 	if (call <= SEMCTL) {
@@ -453,16 +453,9 @@ asmlinkage long sys_ipc(unsigned int cal
 			err = sys_semget(first, (int)second, (int)third);
 			goto out;
 		case SEMCTL: {
-			union semun fourth;
-			err = -EINVAL;
-			if (!ptr)
-				goto out;
-			err = -EFAULT;
-			if (get_user(fourth.__pad,
-				     (void __user * __user *) ptr))
-				goto out;
-			err = sys_semctl(first, (int)second | IPC_64,
-					 (int)third, fourth);
+			err = sys_semctl(first, third,
+					 (int)second | IPC_64,
+					 (union semun) ptr);
 			goto out;
 		}
 		default:

-- 
