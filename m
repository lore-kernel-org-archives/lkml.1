Return-Path: <linux-kernel-owner+w=401wt.eu-S1423230AbXBHQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423230AbXBHQiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423229AbXBHQiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:38:51 -0500
Received: from mr.exanet.com ([212.143.73.109]:38962 "EHLO mr.exanet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423226AbXBHQiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:38:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Getting the nfs_fh of a specific file/dir from the kernel 
Date: Thu, 8 Feb 2007 18:38:48 +0200
Message-ID: <A6FDE6B975803043804A49F12F49028E0F573A@hawk.exanet-il.co.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Getting the nfs_fh of a specific file/dir from the kernel 
Thread-Index: AcdLn5up1/T1xYF9QYycBACAGjynQg==
From: "Menny Hamburger" <menny@exanet.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a piece of code in my 2.6 kernel that associates an ioctl
file_operation to nfs in file.c and dir.c.
This ioctl sends the nfs_fh to a userland application.
I have been trying to remove this ugly code by creating my own device
and implementing the ioctl but I keep getting junk instead.
Please tell me if I'm doing anything wrong here:

1) Define the I/O structure:
    struct nfs_getfh {
        int fd;
        struct nfs_fh *fh;
    };
2) Receive the  fd of the wanted file/dir.
3) inside the ioctl function:

    struct file *filp;
    struct dentry *dentp;
    struct inode *inop;
    struct nfs_getfh getfh;
    struct files_struct *files;
    struct nfs_getfh __user *user_getfh = (struct nfs_getfh __user *)
arg;

    files = current->files;
    if (files) {
        spin_lock(&files->file_lock);
        filp = fcheck(getfh.fd);
        if (filp) {
            dentp = dget(filp->f_dentry);
	if (dentp) {
	    inop = dentp->d_inode;
	    if (inop) {
	        getfh.fh = NFS_FH(inop);
	        if (getfh.fh) {
                        copy_to_user((void*) user_getfh->fh, getfh.fh,
getfh.fh->size + ((int) &((struct nfs_fh*)0)->data)))
                    }
                }
            }
        }
        spin_unlock(&files->file_lock);
     }

Best Regards,
Menny

