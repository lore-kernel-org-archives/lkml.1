Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYKQXG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYKQXG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYKQXGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:06:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:22516 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKQXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:06:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HsWTrB93Ya0PAfiZaf1EFeqgZ3olANku9Fg/8CL0U4SfuJI0IwVH7Cntw2EFrCx/d2
         hshckzWAcINV2tkA4tl0BjM4mc6qAUNv7EBmhB/IQr24xBmsESF+82Ot8fwvbGXfD9Nj
         m/nxIa30+h4/qt3+En3vmKcfw8MDgjsJr8cnU=
Message-ID: <524f69650811171506y1f518c3bnac03e4f557ba29fb@mail.gmail.com>
Date: Mon, 17 Nov 2008 17:06:43 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: third patch
Cc: "Jeff Layton" <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
In-Reply-To: <20081117055603.GA1381@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114185039.1f3af842@tleilax.poochiereds.net>
	 <524f69650811141609n63f3631bn6493e2be76b1bed6@mail.gmail.com>
	 <20081115063641.26003498@tleilax.poochiereds.net>
	 <524f69650811161918i738ba50frd87666a58640b76f@mail.gmail.com>
	 <20081117055603.GA1381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 11:56 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Nov 16, 2008 at 09:18:43PM -0600, Steve French wrote:
>> Jeff and I have worked on a series of patches to fix the oopses,
>> memory corruption and mount failures due to races in various linked
>> list handling relating to socket, session and tree connection when
>> using the reproducer detailed here:
>>
>> https://bugzilla.samba.org/show_bug.cgi?id=5720
>>
>> The fix series is now merged into cifs-2.6.git
>
> Are these patches going to be sent to Linus for the 2.6.28 release?
> Should they be also added to the 2.6.27-stable tree when they get to
> Linus's tree?  If so, what are their git commit ids?

The fixes passed testing (both Jeff's and mine) and I am planning to
request a merge upstream tomorrow morning.   I am waiting on testing
to finish of an unrelated fix, a one line fix (to cifs_writepages) for
a writepages corruption under heavy stress that Shaggy suggested,
before requesting the merge.

I don't mind the large mount/umount fix series (diffstat shows about
800 lines added, 800 removed) being included in stable, it does fix
some oopses that can occur with simultaneous cifs mounts/umounts
racing.

The size is as follows:

 fs/cifs/cifs_debug.c   |  277 +++++++++--------
 fs/cifs/cifs_spnego.c  |    4 +-
 fs/cifs/cifsfs.c       |   30 +-
 fs/cifs/cifsglob.h     |   41 ++--
 fs/cifs/cifssmb.c      |  136 +++++----
 fs/cifs/connect.c      |  825 ++++++++++++++++++++++++------------------------
 fs/cifs/file.c         |    2 +-
 fs/cifs/misc.c         |   90 +++---
 8 files changed, 761 insertions(+), 715 deletions(-)


The list of patches in cifs-2.6.git on kernel.org follows:

commit ab3f992983062440b4f37c666dac66d987902d91
Author: Steve French <sfrench@us.ibm.com>
Date:   Mon Nov 17 16:03:00 2008 +0000

    [CIFS] Fix check for tcon seal setting and fix oops on failed
mount from earlier patch

    set tcon->ses earlier

    If the inital tree connect fails, we'll end up calling cifs_put_smb_ses
    with a NULL pointer. Fix it by setting the tcon->ses earlier.

    Acked-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit c2b3382cd4d6c6adef1347e81f20e16c93a39feb
Author: Steve French <sfrench@us.ibm.com>
Date:   Mon Nov 17 03:57:13 2008 +0000

    [CIFS] Fix build break

    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit f1987b44f642e96176adc88b7ce23a1d74806f89
Author: Jeff Layton <jlayton@redhat.com>
Date:   Sat Nov 15 11:12:47 2008 -0500

    cifs: reinstate sharing of tree connections

    Use a similar approach to the SMB session sharing. Add a list of tcons
    attached to each SMB session. Move the refcount to non-atomic. Protect
    all of the above with the cifs_tcp_ses_lock. Add functions to
    properly find and put references to the tcons.

    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit d82c2df54e2f7e447476350848d8eccc8d2fe46a
Author: Steve French <sfrench@us.ibm.com>
Date:   Sat Nov 15 00:07:26 2008 +0000

    [CIFS] minor cleanup to cifs_mount

    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit 14fbf50d695207754daeb96270b3027a3821121f
Author: Jeff Layton <jlayton@redhat.com>
Date:   Fri Nov 14 13:53:46 2008 -0500

    cifs: reinstate sharing of SMB sessions sans races

    We do this by abandoning the global list of SMB sessions and instead
    moving to a per-server list. This entails adding a new list head to the
    TCP_Server_Info struct. The refcounting for the cifsSesInfo is moved to
    a non-atomic variable. We have to protect it by a lock anyway, so there's
    no benefit to making it an atomic. The list and refcount are protected
    by the global cifs_tcp_ses_lock.

    The patch also adds a new routines to find and put SMB sessions and
    that properly take and put references under the lock.

    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit e7ddee9037e7dd43de1ad08b51727e552aedd836
Author: Jeff Layton <jlayton@redhat.com>
Date:   Fri Nov 14 13:44:38 2008 -0500

    cifs: disable sharing session and tcon and add new TCP sharing code

    The code that allows these structs to be shared is extremely racy.
    Disable the sharing of SMB and tcon structs for now until we can
    come up with a way to do this that's race free.

    We want to continue to share TCP sessions, however since they are
    required for multiuser mounts. For that, implement a new (hopefully
    race-free) scheme. Add a new global list of TCP sessions, and take
    care to get a reference to it whenever we're dealing with one.

    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit 3ec332ef7a38c2327e18d087d4120a8e3bd3dc6e
Author: Steve French <sfrench@us.ibm.com>
Date:   Fri Nov 14 03:35:10 2008 +0000

    [CIFS] clean up server protocol handling

    We're currently declaring both a sockaddr_in and sockaddr6_in on the
    stack, but we really only need storage for one of them. Declare a
    sockaddr struct and cast it to the proper type. Also, eliminate the
    protocolType field in the TCP_Server_Info struct. It's redundant since
    we have a sa_family field in the sockaddr anyway.

    We may need to revisit this if SCTP is ever implemented, but for now
    this will simplify the code.

    CIFS over IPv6 also has a number of problems currently. This fixes all
    of them that I found. Eventually, it would be nice to move more of the
    code to be protocol independent, but this is a start.

    Signed-off-by: Jeff Layton <jlayton@redhat.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit fb396016647ae9de5b3bd8c4ee4f7b9cc7148bd5
Author: Steve French <sfrench@us.ibm.com>
Date:   Thu Nov 13 20:04:07 2008 +0000

    [CIFS] remove unused list, add new cifs sock list to prepare for
mount/umount fix

    Also adds two lines missing from the previous patch (for the need
reconnect flag in the
    /proc/fs/cifs/DebugData handling)

    The new global_cifs_sock_list is added, and initialized in
init_cifs but not used yet.
    Jeff Layton will be adding code in to use that and to remove the
GlobalTcon and GlobalSMBSession
    lists.

    CC: Jeff Layton <jlayton@redhat.com>
    CC: Shirish Pargaonkar <shirishp@us.ibm.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

commit 3b7952109361c684caf0c50474da8662ecc81019
Author: Steve French <sfrench@us.ibm.com>
Date:   Thu Nov 13 19:45:32 2008 +0000

    [CIFS] Fix cifs reconnection flags

    In preparation for Jeff's big umount/mount fixes to remove the
possibility of
    various races in cifs mount and linked list handling of sessions,
sockets and
    tree connections, this patch cleans up some repetitive code in cifs_mount,
    and addresses a problem with ses->status and tcon->tidStatus in which we
    were overloading the "need_reconnect" state with other status in that
    field.  So the "need_reconnect" flag has been broken out from those
    two state fields (need reconnect was not mutually exclusive from some of the
    other possible tid and ses states).  In addition, a few exit cases in
    cifs_mount were cleaned up, and a problem with a tcon flag (for
lease support)
    was not being set consistently for the 2nd mount of the same share

    CC: Jeff Layton <jlayton@redhat.com>
    CC: Shirish Pargaonkar <shirishp@us.ibm.com>
    Signed-off-by: Steve French <sfrench@us.ibm.com>




-- 
Thanks,

Steve
