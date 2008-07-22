Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYGVRbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYGVRbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYGVRbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:31:08 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34094 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYGVRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:31:06 -0400
Date: Tue, 22 Jul 2008 13:30:58 -0400
Message-Id: <200807221730.m6MHUwDf004730@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add a counter in task_struct for skipping permission check. (Was: Should LSM hooks be called by filesystem's requests?) 
In-reply-to: Your message of "Tue, 22 Jul 2008 19:59:04 +0900."
             <200807221959.HDJ90154.FFLMOtVOOQJFSH@I-love.SAKURA.ne.jp> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200807221959.HDJ90154.FFLMOtVOOQJFSH@I-love.SAKURA.ne.jp>, Tetsuo Handa writes:
> Hello.
> 
> I have a problem with unionfs and LSM.
> The unionfs causes NULL pointer dereference if copyup_dentry()
> failed by LSM's decision, so I'm searching for a solution.
> 
> http://marc.info/?l=linux-security-module&m=121609490418118&w=2
> 
> It seems that the unionfs is not handling error paths correctly.
> But since the unionfs's operation is not always atomic,
> there is no guarantee that unionfs can rollback unionfs's internal
> operations properly.
> 
> For example, unionfs is trying to create a rw copy of a ro file.
> 
>  Request by unionfs                       Decision by LSM
>  "I want to create a rw file."            "OK. You can create the file."
>  "I want to copy the ro file's attribute" "No. You must not."
>  "I have to delete the rw file."          "No. You must not."
> 
> Then, it might be better to completely disable LSM for unionfs's
> internal operations.
> At least, I think we need to disable LSM for rollback operation so that
> the rw file in the above example is properly deleted.
> 
> I think this patch can disable LSM checks if vfs_*() and
> notify_change() is called by unionfs's internal operations.
> This patch is just an idea, not tested at all.
> 
> Does somebody have a solution?

I think there needs to be a better way for stackable f/s to work with
LSM/Smack, and the VFS.  I'd like to do things as cleanly as possible, not
just come up with quick-n-dirty hacks or workarounds. :-)

One possibility I'm looking into is the S_PRIVATE flag.  Another is
cap_raise/lower pairs.  Ideally there'd be a way to pass security-related
flags to vfs_* methods, but I think that generally such solutions haven't
been received well.  (If the LSM folks know of a better/cleaner way in which
Unionfs can utilize LSM, I'd love to hear about it.)

In the end, I believe the solution would be some combination of improved VFS
and changes to Unionfs.

The atomicity issue is a problem for all stackable file systems, yes.  Viro
had suggested to me at LSF'08 that perhaps the superblock struct would need
a "want_write" type of interface as has been done struct vfsmount: that'd
allow an upper layer to make multiple ops on a lower superblock, locking it
from any possible interleaving of other callers, and even rolling back
undesired changes.

Cheers,
Erez.
