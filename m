Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562Ab0AZX64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0AZX64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467Ab0AZXna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:30 -0500
Received: from kroah.org ([198.145.64.141]:35231 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0AZXn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:28 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233925.472413013@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Neil Brown <neilb@suse.de>
Subject: [35/98] NFS: Revert default r/wsize behavior
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit dd47f96c077b4516727e497e4b6fd47a06778c0a upstream.

When the "rsize=" or "wsize=" mount options are not specified,
text-based mounts have slightly different behavior than legacy binary
mounts.  Text-based mounts use the smaller of the server's maximum
and the client's maximum, but binary mounts use the smaller of the
server's _preferred_ size and the client's maximum.

This difference is actually pretty subtle.  Most servers advertise
the same value as their maximum and their preferred transfer size, so
the end result is the same in most cases.

The reason for this difference is that for text-based mounts, if
r/wsize are not specified, they are set to the largest value supported
by the client.  For legacy mounts, the values are set to zero if these
options are not specified.

nfs_server_set_fsinfo() can negotiate the transfer size defaults
correctly in any case.  There's no need to specify any particular
value as default in the text-based option parsing logic.

Note that nfs4 doesn't use nfs_server_set_fsinfo(), but the mount.nfs4
command does set rsize and wsize to 0 if the user didn't specify these
options.  So, make the same change for text-based NFSv4 mounts.

Thanks to James Pearson <james-p@moving-picture.com> for reporting and
diagnosing the problem.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -734,8 +734,6 @@ static struct nfs_parsed_mount_data *nfs
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (data) {
-		data->rsize		= NFS_MAX_FILE_IO_SIZE;
-		data->wsize		= NFS_MAX_FILE_IO_SIZE;
 		data->acregmin		= NFS_DEF_ACREGMIN;
 		data->acregmax		= NFS_DEF_ACREGMAX;
 		data->acdirmin		= NFS_DEF_ACDIRMIN;


