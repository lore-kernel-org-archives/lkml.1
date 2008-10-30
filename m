Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYJ3R1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYJ3R1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYJ3R0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:26:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:41463 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbYJ3R0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wtvyu+E2UgEeXSxt1pYqSuDGaM9no0G4YtjCqQ3p76uRBT+hT76Mw6MbIs4apklBNG
         ViH6O40pzZyyep90zEofmPUzrCQaOP/pfPEYBMpu21wYu6kyUNT4s5llpD5dCuzbChMm
         TJ2zTnfHIuG1y9K3dk3jz+8w72JzwwNguYjS8=
Message-ID: <524f69650810301026w4ad6b652r3ef83c8b2e4f41e3@mail.gmail.com>
Date: Thu, 30 Oct 2008 12:26:51 -0500
From: "Steve French" <smfrench@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH 0/4] cifs: fix oopses and mem corruption with concurrent mount/umount (try #4)
In-Reply-To: <524f69650810301025t3f3b7fb6t10d96b6567a67715@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
	 <524f69650810301025t3f3b7fb6t10d96b6567a67715@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is much better since it doesn't regress the tcon sharing (which
we still need to extend for the shared superblock case) - I
particularly like the new routines to put (free) the tcon and put the
smb session, but think the locking gets more complicated (with little
performance gain) moving from one global spinlock covering
tcon/smb-session/cifs-tcp-socket to one embedded within each
structure, and also could be confusing since the cifs tcp socket is
already protected by a semaphore and now would have a spinlock too.
I think we greatly increase the chance of deadlock having to nest
spinlocks.



On Thu, Oct 30, 2008 at 10:16 AM, Jeff Layton <jlayton@redhat.com> wrote:
>
> This patchset is intended to fix the oopses, memory corruption and mount
> failures when using the reproducer detailed here:
>
> https://bugzilla.samba.org/show_bug.cgi?id=5720
>
> This is the fourth attempt at this. Since the third attempt, Steve
> French has committed the patch to handle the server->tsk pointer more
> atomically so that patch is ommitted here. While that patch helps ensure
> that the shutdown of the demux thread happens cleanly, there are still
> other races.
>
> Andrew Morton has also taken the patch to clean up the server protocol
> handling for -mm. I've included this patch in the set since Steve has
> not yet taken it, and I've had to modify it slightly for changes that
> have gone into Steve's tree.
>
> This patchset is based on Steve French's cifs-2.6 git tree and should
> apply cleanly to its current state.
>
> The main differences in this patchset are that it fixes some bugs in
> list handling in the earlier patchsets. It also reenables the sharing
> of tree connects. With this, any structures that were previously
> shared should remain so (no loss of functionality).
>
> There's still some remaining cleanup work that can be done here. The
> cifs_mount code could stand to be broken up into smaller functions.
> cifs_debug_data_proc_show could also stand to be reorganized to better
> reflect the heirarchy of server->session->tcon. Those changes are
> probably more suitable in follow-on patches. I'd like to know whether
> these are acceptible before I spend time working on them.
>
> I've been able to run the reproducer in the above BZ overnight on this
> patchset. Without it, it usually crashes within a few minutes.
>
> Jeff Layton (4):
>  cifs: clean up server protocol handling for TCP_Server_Info
>  cifs: disable sharing session and tcon and add new TCP sharing code
>  cifs: reinstate sharing of SMB sessions
>  cifs: reinstate sharing of tree connections
>
>  fs/cifs/cifs_debug.c |  286 +++++++++++++++++++---------------
>  fs/cifs/cifsfs.c     |   33 +++--
>  fs/cifs/cifsglob.h   |   28 ++--
>  fs/cifs/cifssmb.c    |   54 +------
>  fs/cifs/connect.c    |  426 +++++++++++++++++++++++++-------------------------
>  fs/cifs/misc.c       |   93 +++++------
>  6 files changed, 456 insertions(+), 464 deletions(-)
>



--
Thanks,

Steve



--
Thanks,

Steve
