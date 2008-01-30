Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbYA3LTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbYA3LTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbYA3LTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:19:11 -0500
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:36246 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756553AbYA3LTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:19:09 -0500
Message-ID: <47A05D19.4090606@vlnb.net>
Date: Wed, 30 Jan 2008 14:18:49 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: rdreier@cisco.com, James.Bottomley@HansenPartnership.com,
       bart.vanassche@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<adazluoe2t3.fsf@cisco.com> <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 29 Jan 2008 13:31:52 -0800
> Roland Dreier <rdreier@cisco.com> wrote:
> 
> 
>> > .                           .   STGT read     SCST read    .    STGT read      SCST read    .
>> > .                           .  performance   performance   . performance    performance   .
>> > .                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB, MB/s)   (1 MB, MB/s)  .
>> > . iSER     (8 Gb/s network) .     250            N/A       .       360           N/A       .
>> > . SRP      (8 Gb/s network) .     N/A            421       .       N/A           683       .
>>
>> > On the comparable figures, which only seem to be IPoIB they're showing a
>> > 13-18% variance, aren't they?  Which isn't an incredible difference.
>>
>>Maybe I'm all wet, but I think iSER vs. SRP should be roughly
>>comparable.  The exact formatting of various messages etc. is
>>different but the data path using RDMA is pretty much identical.  So
>>the big difference between STGT iSER and SCST SRP hints at some big
>>difference in the efficiency of the two implementations.
> 
> 
> iSER has parameters to limit the maximum size of RDMA (it needs to
> repeat RDMA with a poor configuration)?
> 
> 
> Anyway, here's the results from Robin Humble:
> 
> iSER to 7G ramfs, x86_64, centos4.6, 2.6.22 kernels, git tgtd,
> initiator end booted with mem=512M, target with 8G ram
> 
>  direct i/o dd
>   write/read  800/751 MB/s
>     dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
>     dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct
> 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg13502.html
> 
> I think that STGT is pretty fast with the fast backing storage. 

How fast SCST will be on the same hardware?

> I don't think that there is the notable perfornace difference between
> kernel-space and user-space SRP (or ISER) implementations about moving
> data between hosts. IB is expected to enable user-space applications
> to move data between hosts quickly (if not, what can IB provide us?).
> 
> I think that the question is how fast user-space applications can do
> I/Os ccompared with I/Os in kernel space. STGT is eager for the advent
> of good asynchronous I/O and event notification interfances.
> 
> One more possible optimization for STGT is zero-copy data
> transfer. STGT uses pre-registered buffers and move data between page
> cache and thsse buffers, and then does RDMA transfer. If we implement
> own caching mechanism to use pre-registered buffers directly with (AIO
> and O_DIRECT), then STGT can move data without data copies.

Great! So, you are going to duplicate Linux page cache in the user 
space. You will continue keeping the in-kernel code as small as possible 
and its mainteinership effort as low as possible by the cost that the 
user space part's code size and complexity (and, hence, its 
mainteinership effort) will rocket to the sky. Apparently, this doesn't 
look like a good design decision.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

