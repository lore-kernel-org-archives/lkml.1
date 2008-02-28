Return-Path: <linux-kernel-owner+w=401wt.eu-S1764078AbYB1UZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764078AbYB1UZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760977AbYB1UYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:24:55 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:40520 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497AbYB1UYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:24:54 -0500
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH/RFC 1/2] anon-inodes: Remove fd_install() from anon_inode_getfd()
X-Message-Flag: Warning: May contain useful information
References: <20080225191043.GA32342@lst.de> <adak5kqyzv1.fsf@cisco.com>
	<Pine.LNX.4.64.0802271138170.377@alien.or.mcafeemobile.com>
	<adabq62yx5r.fsf@cisco.com>
	<Pine.LNX.4.64.0802271218210.377@alien.or.mcafeemobile.com>
	<ada7igqyurw.fsf@cisco.com> <adar6eyx8y5.fsf@cisco.com>
	<Pine.LNX.4.64.0802281150060.7660@alien.or.mcafeemobile.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 28 Feb 2008 12:24:50 -0800
In-Reply-To: <Pine.LNX.4.64.0802281150060.7660@alien.or.mcafeemobile.com> (Davide Libenzi's message of "Thu, 28 Feb 2008 12:04:10 -0800 (PST)")
Message-ID: <adabq60x20d.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Feb 2008 20:24:52.0840 (UTC) FILETIME=[F991AE80:01C87A47]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > If we let the caller call fd_install(), then it may be messed up WRT 
 > cleanup (fd, file, inode).

Yes, that is a tiny bit tricky (need to call put_unused_fd() if you
don't install the fd).

 > How about removing the inode pointer handout altogether, and *doing* 
 > fd_install() inside anon_inode_getfd() like:
 > 
 > 	if (pfile != NULL) {
 > 		get_file(file);
 > 		*pfile = file;
 > 	}
 > 	fd_install(fd, file);
 > 
 > In this way, if the caller want the file* back, he gets the reference 
 > bumped before fd_install().

I think that may be a bit cleaner than Al's approach, but it still
leaves the same trap that create_vcpu_fd() falls into.  The current
code is:

static int create_vcpu_fd(struct kvm_vcpu *vcpu)
{
	int fd, r;
	struct inode *inode;
	struct file *file;

	r = anon_inode_getfd(&fd, &inode, &file,
			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
	if (r)
		return r;
	atomic_inc(&vcpu->kvm->filp->f_count);
	return fd;
}

and with your proposal, the natural way to write that becomes:

static int create_vcpu_fd(struct kvm_vcpu *vcpu)
{
	int fd, r;

	r = anon_inode_getfd(&fd, NULL,
			     "kvm-vcpu", &kvm_vcpu_fops, vcpu);
	if (r)
		return r;
	atomic_inc(&vcpu->kvm->filp->f_count);
	return fd;
}

which still has the same bug.

Maybe a good way to handle this is just to make the get_file() not
optional.  I dunno... I feel like we've spent more discussion on this
point than it deserves, so someone should just make a decision and
I'll adapt the ib_uverbs code to work with whatever it is.

 - R.
