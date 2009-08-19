Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZHSUso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZHSUso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZHSUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:48:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZHSUsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:48:42 -0400
Date: Wed, 19 Aug 2009 22:48:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: configfs/sysfs
Message-ID: <20090819204821.GA27292@elte.hu>
References: <4A8971A8.2040102@gmail.com> <20090817150844.GA3307@elte.hu> <4A89B08A.4010103@gmail.com> <4A8A674E.8070200@redhat.com> <4A8ABEC9.6090006@gmail.com> <4A8AD678.7050609@redhat.com> <4A8B9B79.9050004@gmail.com> <4A8BA5AE.3030308@redhat.com> <1250706227.27590.156.camel@haakon2.linux-iscsi.org> <4A8C5CBB.10605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8C5CBB.10605@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> You may argue, correctly, that syscalls and ioctls are 
> not as flexible.  But this is because no one has 
> invested the effort in making them so.  A struct passed 
> as an argument to a syscall is not extensible.  But if 
> you pass the size of the structure, and also a bitmap 
> of which attributes are present, you gain extensibility 
> and retain the atomicity property of a syscall 
> interface.  I don't think a lot of effort is needed to 
> make an extensible syscall interface just as usable and 
> a lot more efficient than configfs/sysfs.  It should 
> also be simple to bolt a fuse interface on top to 
> expose it to us commandline types.

FYI, an example of such a syscall design and 
implementation has been merged upstream in the .31 merge 
window, see:

 kernel/perf_counter.c::sys_perf_counter_open()

SYSCALL_DEFINE5(perf_counter_open,
                struct perf_counter_attr __user *, attr_uptr,
                pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)

We embedd a '.size' field in struct perf_counter_attr. We 
copy the attribute from user-space in an 
'auto-extend-to-zero' way:

        ret = perf_copy_attr(attr_uptr, &attr);
        if (ret)
                return ret;

where perf_copy_attr() extends the possibly-smaller 
user-space structure to the in-kernel structure and 
zeroes out remaining fields.

This means that older binaries can pass in older 
(smaller) versions of the structure.

This syscall ABI design works very well and has a lot of 
advantages:

 - is extensible in a flexible way

 - it is forwards ABI compatible

 - the kernel is backwards compatible with applications

 - extensions to the ABI dont uglify the interface.

 - new applications can fall back gracefully to older ABI 
   versions if they so choose. (the kernel will reject 
   overlarge attr.size) So full forwards and backwards 
   compatibility can be implemented, if an app wants to.

 - 'same version' ABI uses dont have any interface quirk 
   or performance penalty. (i.e. there's no increasingly 
   complex maze of add-on ABI details for the syscall to 
   multiplex through)

 - the system call stays nice and readable

We've made use of this property of the perfcounters ABI 
and extended it in a compatible way several times 
already, with great success.

	Ingo
