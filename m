Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZBWQeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZBWQeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZBWQe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:34:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58094 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbZBWQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:34:26 -0500
Date: Mon, 23 Feb 2009 08:33:28 -0800
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: Horst Reiterer <horst.reiterer@gmail.com>,
       linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: [PATCH] fs/cifs: send SMB_COM_FLUSH in
 cifs_fsync
Message-ID: <20090223083328.38667e69@tupile.poochiereds.net>
In-Reply-To: <524f69650902222007o3f56d394yecab17c22296aaa4@mail.gmail.com>
References: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local>
	<524f69650902201721l1c7f0d34p4708980a90d7fc8f@mail.gmail.com>
	<alpine.OSX.2.00.0902222137080.7676@horst-reiterers-macbook-air.local>
	<524f69650902221303h37feb366k3d89a07bfd100ea3@mail.gmail.com>
	<alpine.OSX.2.00.0902222206360.7676@horst-reiterers-macbook-air.local>
	<524f69650902222007o3f56d394yecab17c22296aaa4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009 22:07:05 -0600
Steve French <smfrench@gmail.com> wrote:

> diff --git a/fs/cifs/CHANGES b/fs/cifs/CHANGES
> index d43e0fe..b33c841 100644
> --- a/fs/cifs/CHANGES
> +++ b/fs/cifs/CHANGES
> @@ -8,7 +8,9 @@ user's smb session.  This fix allows cifs to mount multiple times to the
>  same server with different userids without risking invalidating earlier
>  established security contexts.  fsync now sends SMB Flush operation
>  to better ensure that we wait for server to write all of the data to
> -server disk (not just write it over the network).
> +server disk (not just write it over the network).  Add new mount
> +parameter to allow user to disable sending the (slow) SMB flush on
> +fsync if desired (fsync still flushes all cached write data to the server).
>  
>  Version 1.56
>  ------------
> diff --git a/fs/cifs/README b/fs/cifs/README
> index da4515e..6436966 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -472,6 +472,19 @@ A partial list of the supported mount options follows:
>  		even if the cifs server would support posix advisory locks.
>  		"forcemand" is accepted as a shorter form of this mount
>  		option.
> + nostrictsync   If this mount option is set, when an application does an
> +		fsync call then the cifs client does not send an SMB Flush
> +		to the server (to force the server to write all dirty data
> +		for this file immediately to disk), although cifs still sends
> +		all dirty (cached) file data to the server and waits for the
> +		server to respond to the write write.  Since SMB Flush can be
> +		very slow, and some servers may be reliable enough (to risk
> +		delaying slightly flushing the data to disk on the server),
> +		turning on this option may be useful to improve performance for
> +		applications that fsync too much, at a small risk of server
> +		crash.  If this mount option is not set, by default cifs will
> +		send an SMB flush request (and wait for a response) on every
> +		fsync call.
>   nodfs          Disable DFS (global name space support) even if the
>  		server claims to support it.  This can help work around
>  		a problem with parsing of DFS paths with Samba server
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index c4c306f..e9f177b 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -32,6 +32,7 @@
>  #define CIFS_MOUNT_OVERR_GID    0x800 /* override gid returned from server    */
>  #define CIFS_MOUNT_DYNPERM      0x1000 /* allow in-memory only mode setting   */
>  #define CIFS_MOUNT_NOPOSIXBRL   0x2000 /* mandatory not posix byte range lock */
> +#define CIFS_MOUNT_NO_SSYNC     0x4000 /* don't do slow SMBflush on every sync*/
>  
>  struct cifs_sb_info {
>  	struct cifsTconInfo *tcon;	/* primary mount */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index da0f4ff..18e84a4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -95,6 +95,7 @@ struct smb_vol {
>  	bool local_lease:1; /* check leases only on local system, not remote */
>  	bool noblocksnd:1;
>  	bool noautotune:1;
> +	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
>  	unsigned int rsize;
>  	unsigned int wsize;
>  	unsigned int sockopt;
> @@ -1274,6 +1275,10 @@ cifs_parse_mount_options(char *options, const char *devname,
>  			vol->intr = 0;
>  		} else if (strnicmp(data, "intr", 4) == 0) {
>  			vol->intr = 1;
> +		} else if (strnicmp(data, "nostrictsync", 12) == 0) {
> +			vol->nostrictsync = 1;
> +		} else if (strnicmp(data, "strictsync", 10) == 0) {
> +			vol->nostrictsync = 0;
>  		} else if (strnicmp(data, "serverino", 7) == 0) {
>  			vol->server_ino = 1;
>  		} else if (strnicmp(data, "noserverino", 9) == 0) {
> @@ -2160,6 +2165,8 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UNX_EMUL;
>  	if (pvolume_info->nobrl)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_BRL;
> +	if (pvolume_info->nostrictsync)
> +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_SSYNC;
>  	if (pvolume_info->mand_lock)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
>  	if (pvolume_info->cifs_acl)
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 83b4741..6411f5f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1538,7 +1538,8 @@ int cifs_fsync(struct file *file, struct dentry *dentry, int datasync)
>  		rc = CIFS_I(inode)->write_behind_rc;
>  		CIFS_I(inode)->write_behind_rc = 0;
>  		tcon = CIFS_SB(inode->i_sb)->tcon;
> -		if (!rc && tcon && smbfile)
> +		if (!rc && tcon && smbfile &&
> +		   !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_SSYNC))
		     ^^^^^^^
This doesn't compile as there is no cifs_sb defined in this function...

>  			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
>  	}
>  


-- 
Jeff Layton <jlayton@redhat.com>
