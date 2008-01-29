Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYA2XdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYA2XdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYA2Xcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:32:54 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:45097 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYA2Xcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:32:52 -0500
To: rdreier@cisco.com
Cc: James.Bottomley@HansenPartnership.com, bart.vanassche@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <adazluoe2t3.fsf@cisco.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	<1201639331.3069.58.camel@localhost.localdomain>
	<adazluoe2t3.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 30 Jan 2008 08:32:39 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 13:31:52 -0800
Roland Dreier <rdreier@cisco.com> wrote:

>  > .                           .   STGT read     SCST read    .    STGT read      SCST read    .
>  > .                           .  performance   performance   . performance    performance   .
>  > .                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB, MB/s)   (1 MB, MB/s)  .
>  > . iSER     (8 Gb/s network) .     250            N/A       .       360           N/A       .
>  > . SRP      (8 Gb/s network) .     N/A            421       .       N/A           683       .
> 
>  > On the comparable figures, which only seem to be IPoIB they're showing a
>  > 13-18% variance, aren't they?  Which isn't an incredible difference.
> 
> Maybe I'm all wet, but I think iSER vs. SRP should be roughly
> comparable.  The exact formatting of various messages etc. is
> different but the data path using RDMA is pretty much identical.  So
> the big difference between STGT iSER and SCST SRP hints at some big
> difference in the efficiency of the two implementations.

iSER has parameters to limit the maximum size of RDMA (it needs to
repeat RDMA with a poor configuration)?


Anyway, here's the results from Robin Humble:

iSER to 7G ramfs, x86_64, centos4.6, 2.6.22 kernels, git tgtd,
initiator end booted with mem=512M, target with 8G ram

 direct i/o dd
  write/read  800/751 MB/s
    dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
    dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg13502.html

I think that STGT is pretty fast with the fast backing storage. 


I don't think that there is the notable perfornace difference between
kernel-space and user-space SRP (or ISER) implementations about moving
data between hosts. IB is expected to enable user-space applications
to move data between hosts quickly (if not, what can IB provide us?).

I think that the question is how fast user-space applications can do
I/Os ccompared with I/Os in kernel space. STGT is eager for the advent
of good asynchronous I/O and event notification interfances.


One more possible optimization for STGT is zero-copy data
transfer. STGT uses pre-registered buffers and move data between page
cache and thsse buffers, and then does RDMA transfer. If we implement
own caching mechanism to use pre-registered buffers directly with (AIO
and O_DIRECT), then STGT can move data without data copies.
