Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbYB1UE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbYB1UE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYB1UEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:04:14 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43484 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYB1UEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:04:12 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 28 Feb 2008 12:04:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Roland Dreier <rdreier@cisco.com>
cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from
 anon_inode_getfd()
In-Reply-To: <adar6eyx8y5.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0802281150060.7660@alien.or.mcafeemobile.com>
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
 <Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com> <adabq62yx5r.fsf@cisco.com>
 <Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com> <ada7igqyurw.fsf@cisco.com>
 <adar6eyx8y5.fsf@cisco.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Roland Dreier wrote:

>  > http://git.kernel.org/?p=linux/kernel/git/viro/vfs-2.6.git;a=commit;h=49be4f8114e6ff0efdab10ebba2493fb67bc3034
> 
> Actually, looking closer at the kvm changes here, I think that
> create_vcpu_fd() needs the same treatment as kvm_dev_ioctl_create_vm()
> gets in the patch because of the race I mentioned in the changelog
> for my patch: otherwise kvm_vcpu_release() could drop the last
> reference to vcpu->kvm->filp before the get_file() gets an extra
> reference.
> 
> I'm beginning to think that moving the fd_install() out of
> anon_inode_getfd() really is worth it to make a safer interface.

If we let the caller call fd_install(), then it may be messed up WRT 
cleanup (fd, file, inode).
How about removing the inode pointer handout altogether, and *doing* 
fd_install() inside anon_inode_getfd() like:

	if (pfile != NULL) {
		get_file(file);
		*pfile = file;
	}
	fd_install(fd, file);

In this way, if the caller want the file* back, he gets the reference 
bumped before fd_install().



- Davide


