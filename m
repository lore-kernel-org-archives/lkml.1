Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYAJBIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYAJBIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYAJBH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:07:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:42050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbYAJBH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:07:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ii+S3TOOAtbBBwEKlk2ggwPDTkK+eGYqDfCmB32n8JfSTJPUA4cJxqi7/92GSCZll9UeNCt0yZa/HxscV2nqPePUu1bimei9IyD2XjSCIWjaG/wf8gUQKdRLlc1GfuV1TNi/02RdUex5e0gSH5NKiJ8xFwR1gXJmdRlny4r7ehc=
Date: Thu, 10 Jan 2008 09:11:17 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080110011117.GA3968@darkstar.te-china.tietoenator.com>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <20080107141300.GB12763@boogie.lpds.sztaki.hu> <47824415.80703@gmail.com> <20080107210024.GA13537@boogie.lpds.sztaki.hu> <47834593.1000506@gmail.com> <20080108133215.GA15814@boogie.lpds.sztaki.hu> <478490D2.5050902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478490D2.5050902@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 06:16:02PM +0900, Tejun Heo wrote:
> Hello,
> 
> My laptop and cell finally decided to talk to each other and I could
> reproduce the bug here.  The attached patch should remove the oops.
> 
> The bug is two folded.  I just skimmed through the bluetooth code and am
> very likely to wrong at places.  Please correct me where I'm wrong.
> 
> 1. It's introduced by class device migration and the bug will go away
> with CONFIG_SYSFS_DEPRECATED turned on.  With CONFIG_SYSFS_DEPRECATED
> turned off, what used to be class devices live under actual devices.
> For rfcomm, this means the rfcommN tty device now lives under the
> aclXXXX node (probably represents an active connection?) instead of the
> class directory.
> 
> It seems rfcommN devices are supposed to survive over disconnects so the
> rfcommN device moves under the live connection while connection is alive
> and retreats back to a default directory when the connection is lost.
> This is all fine and dandy as long as the rfcommN device lives under
> class directory as class directory never goes away.
> 
> However, with recent sysfs updates, rfcommN now lives directly under the
> aclXXXX node.  If the connection goes away while rfcommN device is under
> it, it gets deleted but rfcommN is still treated as alive.
> 
> This isn't supported.  sysfs doesn't allow parents to die first and the
> dangling children to be salvaged using sysfs_move().
> 
> 2. Which in turn exposes three bugs in sysfs
> 	- sysfs_lookup() returning NULL on negative lookup.  sysfs
> 	  code requires that all negative dentries are shot down.
> 	  lookup should return -ENOENT instead of NULL.
> 	- in move and rename, error handling is wrong.  It ends up
> 	  passing ERR_PTR() values to dput().
> 	- there was an extra dput() in sysfs_move_dir().
> 
> The attached patch fixes all sysfs bugs and removes the oops.  However,
> rfcommX moving is still broken.  The rfcommX device won't be visible
> from sysfs tree after the initial move failure and all following moves
> will fail.
> 
> Please confirm the attached patch fixes the oops.  I'll separate it into
> two patches and forward them to Greg.  But bluetooth code also needs to
> be updated such that it moves the refcommX device before killing the
> connection node.
For bluetooth device_move, the only child device of hci_conn dev is the rfcomm tty_dev. How about the following patch, please verify :

---
net/bluetooth/hci_sysfs.c |    7 +++++++
1 file changed, 7 insertions(+)

diff -upr linux/net/bluetooth/hci_sysfs.c linux.new/net/bluetooth/hci_sysfs.c
--- linux/net/bluetooth/hci_sysfs.c	2008-01-10 09:01:51.000000000 +0800
+++ linux.new/net/bluetooth/hci_sysfs.c	2008-01-10 09:01:22.000000000 +0800
@@ -316,9 +316,16 @@ void hci_conn_add_sysfs(struct hci_conn 
 	schedule_work(&conn->work);
 }
 
+static int hci_conn_move_child(struct device *dev, void *data)
+{
+	device_move(dev, NULL);
+	return 0;
+}
+
 static void del_conn(struct work_struct *work)
 {
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
+	device_for_each_child(&conn->dev, NULL, hci_conn_move_child);
 	device_del(&conn->dev);
 	put_device(&conn->dev);
 }

> 
> Thanks.
> 
> -- 
> tejun

> diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
> diff --git a/fs/dcache.c b/fs/dcache.c
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 3371629..f281cc6 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -678,8 +678,10 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
>  	sd = sysfs_find_dirent(parent_sd, dentry->d_name.name);
>  
>  	/* no such entry */
> -	if (!sd)
> +	if (!sd) {
> +		ret = ERR_PTR(-ENOENT);
>  		goto out_unlock;
> +	}
>  
>  	/* attach dentry and inode */
>  	inode = sysfs_get_inode(sd);
> @@ -781,6 +783,7 @@ int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
>  	old_dentry = sysfs_get_dentry(sd);
>  	if (IS_ERR(old_dentry)) {
>  		error = PTR_ERR(old_dentry);
> +		old_dentry = NULL;
>  		goto out;
>  	}
>  
> @@ -848,6 +851,7 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
>  	old_dentry = sysfs_get_dentry(sd);
>  	if (IS_ERR(old_dentry)) {
>  		error = PTR_ERR(old_dentry);
> +		old_dentry = NULL;
>  		goto out;
>  	}
>  	old_parent = old_dentry->d_parent;
> @@ -855,6 +859,7 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
>  	new_parent = sysfs_get_dentry(new_parent_sd);
>  	if (IS_ERR(new_parent)) {
>  		error = PTR_ERR(new_parent);
> +		new_parent = NULL;
>  		goto out;
>  	}
>  
> @@ -878,7 +883,6 @@ again:
>  	error = 0;
>  	d_add(new_dentry, NULL);
>  	d_move(old_dentry, new_dentry);
> -	dput(new_dentry);
>  
>  	/* Remove from old parent's list and insert into new parent's list. */
>  	sysfs_unlink_sibling(sd);
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h

