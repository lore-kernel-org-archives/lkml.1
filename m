Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbXE3U1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbXE3U1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXE3U1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:27:20 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:21794 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751994AbXE3U1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:27:19 -0400
Message-ID: <465DDE1D.3000809@cfl.rr.com>
Date: Wed, 30 May 2007 16:27:09 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Andreas Dilger <adilger@clusterfs.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <465DAA15.3070703@cfl.rr.com>
In-Reply-To: <465DAA15.3070703@cfl.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2007 20:27:32.0280 (UTC) FILETIME=[F36ACB80:01C7A2F8]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15208.001
X-TM-AS-Result: No--11.982500-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi wrote:
> Hrm... I may have misunderstood the perspective you were talking from. 
> Yes, when the bio is completed it must be on the media, but the 
> filesystem should issue both requests, and then really not care when 
> they complete.  That is to say, the filesystem should not wait for block 
> A to finish before issuing block B; it should issue both, and use 
> barriers to make sure they hit the disk in the correct order.

Actually now that I think about it, that wasn't correct.  The request 
CAN be completed before the data has hit the medium.  The barrier just 
constrains the ordering of the writes, but they can still sit in the 
disk write back cache for some time.

Stefan Bader wrote:
> That would be the exactly how I understand Documentation/block/barrier.txt:
> 
> "In other words, I/O barrier requests have the following two properties.
> 1. Request ordering
> ...
> 2. Forced flushing to physical medium"
> 
> "So, I/O barriers need to guarantee that requests actually get written
> to non-volatile medium in order." 

I think you misinterpret this, and it probably could be worded a bit 
better.  The barrier request is about constraining the order.  The 
forced flushing is one means to implement that constraint.  The other 
alternative mentioned there is to use ordered tags.  The key part there 
is "requests actually get written to non-volatile medium _in order_", 
not "before the request completes", which would be synchronous IO.

