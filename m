Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYGWBi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYGWBi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 21:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYGWBis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 21:38:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:10510 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYGWBiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 21:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oMjGVDsTeuPxyNEut1sZp5qn8WsjAM2t9UMPUFAQQ2HZ1lCMXJfe7sK2KuIHhVEQfB
         DNpjqDZ0QTUBpTIMHUu1ldPYPfjP3iFrOGOOwltxS/rDeP5Il3mh3PWt8FE4xx+HZxjr
         snuJaAIe14ums+oB3K/ugdGK7PhYLByddQut0=
Message-ID: <e7d8f83e0807221838g2587a36bobaf058f68b6c2e59@mail.gmail.com>
Date: Wed, 23 Jul 2008 11:38:45 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Erez Zadok" <ezk@cs.sunysb.edu>
Subject: Re: [RFC] Add a counter in task_struct for skipping permission check. (Was: Should LSM hooks be called by filesystem's requests?)
Cc: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807221730.m6MHUwDf004730@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807221959.HDJ90154.FFLMOtVOOQJFSH@I-love.SAKURA.ne.jp>
	 <200807221730.m6MHUwDf004730@agora.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 3:30 AM, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> In message <200807221959.HDJ90154.FFLMOtVOOQJFSH@I-love.SAKURA.ne.jp>, Tetsuo Handa writes:
>> Hello.
>>
>> I have a problem with unionfs and LSM.
>> The unionfs causes NULL pointer dereference if copyup_dentry()
>> failed by LSM's decision, so I'm searching for a solution.
>>
>> http://marc.info/?l=linux-security-module&m=121609490418118&w=2
>>
>> It seems that the unionfs is not handling error paths correctly.
>> But since the unionfs's operation is not always atomic,
>> there is no guarantee that unionfs can rollback unionfs's internal
>> operations properly.
>>
>> For example, unionfs is trying to create a rw copy of a ro file.
>>
>>  Request by unionfs                       Decision by LSM
>>  "I want to create a rw file."            "OK. You can create the file."
>>  "I want to copy the ro file's attribute" "No. You must not."
>>  "I have to delete the rw file."          "No. You must not."
>>
>> Then, it might be better to completely disable LSM for unionfs's
>> internal operations.
>> At least, I think we need to disable LSM for rollback operation so that
>> the rw file in the above example is properly deleted.
>>
>> I think this patch can disable LSM checks if vfs_*() and
>> notify_change() is called by unionfs's internal operations.
>> This patch is just an idea, not tested at all.
>>
>> Does somebody have a solution?
>
> I think there needs to be a better way for stackable f/s to work with
> LSM/Smack, and the VFS.  I'd like to do things as cleanly as possible, not
> just come up with quick-n-dirty hacks or workarounds. :-)
>
> One possibility I'm looking into is the S_PRIVATE flag.  Another is
> cap_raise/lower pairs.  Ideally there'd be a way to pass security-related
> flags to vfs_* methods, but I think that generally such solutions haven't
> been received well.  (If the LSM folks know of a better/cleaner way in which
> Unionfs can utilize LSM, I'd love to hear about it.)
>
> In the end, I believe the solution would be some combination of improved VFS
> and changes to Unionfs.
>
> The atomicity issue is a problem for all stackable file systems, yes.  Viro
> had suggested to me at LSF'08 that perhaps the superblock struct would need
> a "want_write" type of interface as has been done struct vfsmount: that'd
> allow an upper layer to make multiple ops on a lower superblock, locking it
> from any possible interleaving of other callers, and even rolling back
> undesired changes.
>
> Cheers,
> Erez.

Ok issue in unionfs is very simpler to umsdos filesystem.
Credentials patch will provide equal ablility to do what umsdos file
system does but on every file system.

We currently have VFS bindings ro and rw in main kernel but we cannot
stack VFS bindings.   Working out how to stack VFS itself would
destroy the need for Unionfs and in the VFS bind itself removes from
having to worry that much about secuirty since its secuirty resolved
before it enters the VFS bind or after it leaves no in the central
code.   Reason the VFS itself does not have to.  Some how we have to
get rid of unionfs being the way it is because being a full filesystem
it has to deal with the messes of being a full filesystem.

CacheFS has to provide a overlay over network file systems so they can
be cached.  So is doing a simpler overlay ok not as complex but needs
looking at.

The credentials patch is critical to look at.   CacheFS cannot go main
line without it does a lot of changes to permission handling.

Might provide some ways around unionfs issues.   The battle about
being a filesystem is going to last as long as unionfs is a
filesystem. Wrong place in the code base causes all kinds of
unrequired fights with the LSM.

Peter Dolding
