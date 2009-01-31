Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbZAaDBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbZAaDBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZAaCrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:23 -0500
Received: from kroah.org ([198.145.64.141]:55227 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756510AbZAaCrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:14 -0500
Date: Fri, 30 Jan 2009 18:42:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Bastien ROUCARIES <roucaries.bastien@gmail.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch 08/43] klist.c: bit 0 in pointer cant be used as flag
Message-ID: <20090131024229.GI12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="klist.c-bit-0-in-pointer-can-t-be-used-as-flag.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesper Nilsson <Jesper.Nilsson@axis.com>

commit c0e69a5bbc6fc74184aa043aadb9a53bc58f953b upstream.

The commit a1ed5b0cffe4b16a93a6a3390e8cee0fbef94f86
(klist: don't iterate over deleted entries) introduces use of the
low bit in a pointer to indicate if the knode is dead or not,
assuming that this bit is always free.

This is not true for all architectures, CRIS for example may align data
on byte borders.

The result is a bunch of warnings on bootup, devices not being
added correctly etc, reported by Hinko Kocevar <hinko.kocevar@cetrtapot.si>:

------------[ cut here ]------------
WARNING: at lib/klist.c:62 ()
Modules linked in:

Stack from c1fe1cf0:
       c01cc7f4 c1fe1d11 c000eb4e c000e4de 00000000 00000000 c1f4f78f c1f50c2d
       c01d008c c1fdd1a0 c1fdd1a0 c1fe1d38 c0192954 c1fe0000 00000000 c1fe1dc0
       00000002 7fffffff c1fe1da8 c0192d50 c1fe1dc0 00000002 7fffffff c1ff9fcc
Call Trace: [<c000eb4e>] [<c000e4de>] [<c0192954>] [<c0192d50>] [<c001d49e>] [<c000b688>] [<c0192a3c>]
       [<c000b63e>] [<c000b63e>] [<c001a542>] [<c00b55b0>] [<c00411c0>] [<c00b559c>] [<c01918e6>] [<c0191988>]
       [<c01919d0>] [<c00cd9c8>] [<c00cdd6a>] [<c0034178>] [<c000409a>] [<c0015576>] [<c0029130>] [<c0029078>]
       [<c0029170>] [<c0012336>] [<c00b4076>] [<c00b4770>] [<c006d6e4>] [<c006d974>] [<c006dca0>] [<c0028d6c>]
       [<c0028e12>] [<c0006424>] <4>---[ end trace 4eaa2a86a8e2da22 ]---
------------[ cut here ]------------
Repeat ad nauseam.

Wed, Jan 14, 2009 at 12:11:32AM +0100, Bastien ROUCARIES wrote:
> Perhaps using a pointerhackalign trick on this structure where
> #define pointerhackalign(x) __attribute__ ((aligned (x)))
> and declare
> struct klist_node {
> ...
> }  pointerhackalign(2);
>
> Because  __attribute__ ((aligned (x))) could only increase alignment
> it will safe to do that and serve as documentation purpose :)

That works, but we need to do it not for the struct klist_node,
but for the struct we insert into the void * in klist_node,
which is struct klist.

Reported-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si
Cc: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/klist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -23,7 +23,7 @@ struct klist {
 	struct list_head	k_list;
 	void			(*get)(struct klist_node *);
 	void			(*put)(struct klist_node *);
-};
+} __attribute__ ((aligned (4)));
 
 #define KLIST_INIT(_name, _get, _put)					\
 	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\

