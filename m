Return-Path: <linux-kernel-owner+w=401wt.eu-S1763240AbYB1Uw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763240AbYB1Uw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbYB1UwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:52:16 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37416 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759817AbYB1UwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:52:14 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 28 Feb 2008 12:52:11 -0800 (PST)
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
In-Reply-To: <adabq60x20d.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0802281245580.7660@alien.or.mcafeemobile.com>
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
 <Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com> <adabq62yx5r.fsf@cisco.com>
 <Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com> <ada7igqyurw.fsf@cisco.com>
 <adar6eyx8y5.fsf@cisco.com> <Pine.LNX.4.64.0802281150060.7660@alien.or.mcafeemobile.com>
 <adabq60x20d.fsf@cisco.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Roland Dreier wrote:

>  > If we let the caller call fd_install(), then it may be messed up WRT 
>  > cleanup (fd, file, inode).
> 
> Yes, that is a tiny bit tricky (need to call put_unused_fd() if you
> don't install the fd).
> 
>  > How about removing the inode pointer handout altogether, and *doing* 
>  > fd_install() inside anon_inode_getfd() like:
>  > 
>  > 	if (pfile != NULL) {
>  > 		get_file(file);
>  > 		*pfile = file;
>  > 	}
>  > 	fd_install(fd, file);
>  > 
>  > In this way, if the caller want the file* back, he gets the reference 
>  > bumped before fd_install().
> 
> I think that may be a bit cleaner than Al's approach, but it still
> leaves the same trap that create_vcpu_fd() falls into.  The current
> code is:
> 
> static int create_vcpu_fd(struct kvm_vcpu *vcpu)
> {
> 	int fd, r;
> 	struct inode *inode;
> 	struct file *file;
> 
> 	r = anon_inode_getfd(&fd, &inode, &file,
> 			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
> 	if (r)
> 		return r;
> 	atomic_inc(&vcpu->kvm->filp->f_count);
> 	return fd;
> }
> 
> and with your proposal, the natural way to write that becomes:
> 
> static int create_vcpu_fd(struct kvm_vcpu *vcpu)
> {
> 	int fd, r;
> 
> 	r = anon_inode_getfd(&fd, NULL,
> 			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
> 	if (r)
> 		return r;
> 	atomic_inc(&vcpu->kvm->filp->f_count);
> 	return fd;
> }

I don't know KVM code, but can't the "private_data" setup be completed 
before calling anon_inode_getfd()?
Or ...

static int create_vcpu_fd(struct kvm_vcpu *vcpu)
{
	int fd, r;

	get_file(vcpu->kvm->filp);
	r = anon_inode_getfd(&fd, NULL,
			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
	if (r) {
		fput(vcpu->kvm->filp);
		return r;
	}
	return fd;
}

Hmm...?



- Davide


