Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYDZPnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYDZPnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYDZPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:42:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52887 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYDZPmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:42:52 -0400
Date: Sat, 26 Apr 2008 16:42:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: mainline boot failures I: qemu
Message-ID: <20080426154241.GH5882@ZenIV.linux.org.uk>
References: <20080426140210.GA13365@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426140210.GA13365@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 04:02:10PM +0200, Andi Kleen wrote:
> 
> FYI
> 
> I see lots of boot failures on various setups with current mainline
> (git8, b1721d0da266b4af8cb4419473b4ca36206ab200). Unfortunately 
> they are all different. 

See http://lkml.org/lkml/2008/4/26/1

FWIW, I've reconstructed what had happened:
	* broken changeset in local tree
	* breakage caught, fixed (still in local tree)
	* cherry-pick into new branch in local tree, fix folded
	* *old* changeset taken into the public tree
	* a couple of days later Linus asked to pull
	* pull from Linus' tree into local triggering conflict
	* what the... oh, hell.

Again, the missing bit is this, see if it fixes all of the breakage
you see.  It's a memory corruptor that got immediately caught in
testing, of course - most of the boots don't even get past exec
of /sbin/init.

Brown paperbag time ;-/

diff --git a/kernel/fork.c b/kernel/fork.c
index 4df3949..a647542 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1788,7 +1788,7 @@ bad_unshare_out:
 int unshare_files(struct files_struct **displaced)
 {
 	struct task_struct *task = current;
-	struct files_struct *copy;
+	struct files_struct *copy = NULL;
 	int error;
 
 	error = unshare_fd(CLONE_FILES, &copy);
