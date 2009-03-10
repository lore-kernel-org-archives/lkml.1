Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZCJV7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZCJV7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbZCJV6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:58:40 -0400
Received: from 1wt.eu ([62.212.114.60]:1243 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbZCJV6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:58:38 -0400
Date: Tue, 10 Mar 2009 22:58:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keymap 0: Permission denied
Message-ID: <20090310215818.GA3540@1wt.eu>
References: <1236533626.1479.8.camel@rh9.satnam> <20090308181056.GM26043@1wt.eu> <1236692166.1582.5.camel@rh9.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236692166.1582.5.camel@rh9.satnam>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder,

On Tue, Mar 10, 2009 at 07:06:06PM +0530, Jaswinder Singh Rajput wrote:
> On Sun, 2009-03-08 at 23:40, Willy Tarreau wrote:
> > Hi,
> > 
> > On Sun, Mar 08, 2009 at 11:03:46PM +0530, Jaswinder Singh Rajput wrote:
> > > Hello Willy,
> > > 
> > > On Red Hat 9 With latest 2.4-git kernel, when I log in as a regular user
> > > on a TTY, I get the following error:
> > > 
> > > Keymap 0: Permission denied
> > > Keymap 1: Permission denied
> > > Keymap 2: Permission denied
> > > KDSKBENT: Operation not permitted
> > > loadkeys: could not deallocate keymap 3
> > > 
> > > How to fix this error.
> > 
> > No idea yet. Could you please try "loadkey us" for instance, to ensure
> > it is the program which fails ? If so, please send me the output of
> > "strace loadkeys us".
> > 
> 
> I am attaching the strace for your reference.

Thanks, and indeed I agree with your analysis !

> This patch solves above problem, Is this a correct way ?

I'm not sure, as it approximately consists in reverting that patch in
a different way, which I've verified is similar in 2.6 :

commit f7d4ff67d9c7481f720885e5ec37111bb081921f
Author: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Date:   Tue Nov 1 14:03:08 2005 -0200

    [PATCH] only disallow _setting_ of function key string
    
    Mikael Pettersson <mikpe@csd.uu.se> noted that the current 2.6-git (and
    2.4) patch to disallow KDSKBSENT for unpriviledged users should be less
    restrictive allowing reading of current function key string entry, but
    not writing.
    
    Signed-off-by: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 40ce683..8b8f95d 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -166,6 +166,9 @@ do_kdsk_ioctl(int cmd, struct kbentry *user_kbe, int perm, struct kbd_struct *kb
 	if (i >= NR_KEYS || s >= MAX_NR_KEYMAPS)
 		return -EINVAL;	
 
+	if (!capable(CAP_SYS_TTY_CONFIG))
+		perm = 0;
+
 	switch (cmd) {
 	case KDGKBENT:
 		key_map = key_maps[s];
@@ -277,7 +280,7 @@ do_kdgkb_ioctl(int cmd, struct kbsentry *user_kdgkb, int perm)
 	int i, j, k;
 
 	if (!capable(CAP_SYS_TTY_CONFIG))
-		return -EPERM;
+		perm = 0;
 
 	/* we mostly copy too much here (512bytes), but who cares ;) */
 	if (copy_from_user(&tmp, user_kdgkb, sizeof(struct kbsentry)))


I'm now thinking that RH9 might have relied on an expected feature to
provide per-user keymaps. I indeed have never encountered a case where
loadkeys was performed by a user, it was always some init script at
boot time. Granting the access to plain users causes a DoS issue where
a user might load a crappy map and log out, waiting for the next guy
to try to log in and have fun with the remapped chars.

After a bit of googling, I found the original discussion leading to
this patch (sorry I closed the window too fast). One of the suggestion
was to setuid loadkeys in environments where local users were trusted
enough to change the keymaps.

You could also add them to the sudoers file so that they do "sudo loadkeys".

Anyway, given the security implications around this patch, I don't want
to revert it, eventhough they are minor. This is the first reported breakage
in 3+ years and the workarounds are quite non-intrusive.

Best regards,
Willy

