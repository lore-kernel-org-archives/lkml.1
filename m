Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbYCEJgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbYCEJgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 04:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757742AbYCEJgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 04:36:09 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51086
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbYCEJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:36:07 -0500
Message-ID: <47CE68BE.7000201@qumranet.com>
Date: Wed, 05 Mar 2008 11:32:46 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Roland Dreier <rdreier@cisco.com>, kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [kvm-devel] [PATCH/RFC 1/2] anon-inodes: Remove fd_install()
 from anon_inode_getfd()
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>	<Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>	<adabq62yx5r.fsf@cisco.com>	<Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com>	<ada7igqyurw.fsf@cisco.com> <adar6eyx8y5.fsf@cisco.com>	<Pine.LNX.4.64.0802281150060.7660@alien.or.mcafeemobile.com>	<adabq60x20d.fsf@cisco.com> <Pine.LNX.4.64.0802281245580.7660@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0802281245580.7660@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Wed, 05 Mar 2008 11:32:47 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
>> I think that may be a bit cleaner than Al's approach, but it still
>> leaves the same trap that create_vcpu_fd() falls into.  The current
>> code is:
>>
>> static int create_vcpu_fd(struct kvm_vcpu *vcpu)
>> {
>> 	int fd, r;
>> 	struct inode *inode;
>> 	struct file *file;
>>
>> 	r = anon_inode_getfd(&fd, &inode, &file,
>> 			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
>> 	if (r)
>> 		return r;
>> 	atomic_inc(&vcpu->kvm->filp->f_count);
>> 	return fd;
>> }
>>
>> and with your proposal, the natural way to write that becomes:
>>
>> static int create_vcpu_fd(struct kvm_vcpu *vcpu)
>> {
>> 	int fd, r;
>>
>> 	r = anon_inode_getfd(&fd, NULL,
>> 			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
>> 	if (r)
>> 		return r;
>> 	atomic_inc(&vcpu->kvm->filp->f_count);
>> 	return fd;
>> }
>>     
>
> I don't know KVM code, but can't the "private_data" setup be completed 
> before calling anon_inode_getfd()?
>   

Creating the fd is the last thing done when creating a vcpu.

> Or ...
>
> static int create_vcpu_fd(struct kvm_vcpu *vcpu)
> {
> 	int fd, r;
>
> 	get_file(vcpu->kvm->filp);
> 	r = anon_inode_getfd(&fd, NULL,
> 			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
> 	if (r) {
> 		fput(vcpu->kvm->filp);
> 		return r;
> 	}
> 	return fd;
> }
>   

This seems reasonable.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

