Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYAGPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYAGPYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYAGPYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:24:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:20164 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYAGPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=D1UIRdjV/94jrIQJvbx/pFRMEKNG8yxdhzH8M5vhBArEx0CcWnXO3TODdYnCf486HVm5p0L6oou24zPZzJd9gQOD08yvZwovKOrNPg44OKHmNdJhwg60JO2874VlL9hldogoVL4ss/r7bjd2AWKEnnCiPE/aDolCTiw1jVYbrYg=
Message-ID: <47824415.80703@gmail.com>
Date: Tue, 08 Jan 2008 00:24:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Gabor Gombas <gombasg@sztaki.hu>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <20080107141300.GB12763@boogie.lpds.sztaki.hu>
In-Reply-To: <20080107141300.GB12763@boogie.lpds.sztaki.hu>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------080309060701040302010706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080309060701040302010706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Gabor Gombas wrote:
> Hi,
> 
> On Sat, Jan 05, 2008 at 07:50:39AM +0000, Al Viro wrote:
> 
>> Could you stick
>> 	if (!parent->d_inode)
>> 		printk(KERN_WARNING "sysfs locking blows: %s",
>> 			parent->d_name.name);
>> right before
>>                 mutex_lock(&parent->d_inode->i_mutex);
>>                 dentry = lookup_one_noperm(cur->s_name, parent);
>>                 mutex_unlock(&parent->d_inode->i_mutex);
>> in sysfs_get_dentry() (fs/sysfs/dir.c) and verify that it does, indeed,
>> trigger?
> 
> Here it is:
> 
> Jan  7 14:35:43 twister kernel: sysfs locking blows: acl001BAFE1624D<1>Unable to handle kernel NULL pointer dereference at 00000000000000b8 RIP: 

Does the attached patch fix the problem?

-- 
tejun

--------------080309060701040302010706
Content-Type: text/x-patch;
 name="kill-extra-put-in-sysfs_move_dir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kill-extra-put-in-sysfs_move_dir.patch"

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3371629..4e7f3bf 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -878,7 +878,6 @@ again:
 	error = 0;
 	d_add(new_dentry, NULL);
 	d_move(old_dentry, new_dentry);
-	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
 	sysfs_unlink_sibling(sd);

--------------080309060701040302010706--
