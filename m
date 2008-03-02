Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYCBSxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYCBSxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYCBSxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:53:23 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47410 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbYCBSxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:53:22 -0500
Message-ID: <47CAF614.5050206@cs.wisc.edu>
Date: Sun, 02 Mar 2008 12:46:44 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: htejun@gmail.com, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] block: fix residual byte count handling
References: <1204303656.4003.19.camel@localhost.localdomain>	<20080229201123.GK6704@kernel.dk>	<47C8F4FC.1040505@gmail.com> <20080302235223X.tomof@acm.org>
In-Reply-To: <20080302235223X.tomof@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> sum(sg) == rq->data_len is already broken; sg sends such requests
> (though it would be nice if it doesn't).
> 

Actually, I think I was half wrong on that when you asked about 
scsi_debug. The scatterlist that sg.c uses is never seen by the block 
layer or scsi layer. It is just used as a container to hold segments. 
sg.c and st.c use their scatterlist to manage their preallocated 
pages/segments. When they pass it to scsi_execute_async, that function 
will create a request struct and add bios for the pages.

In 2.6.24 and below, sg.c will send a scatterlist length that does not 
match the IO length, and scsi_execute_async will goof up and send a 
rq->data_len that does not match the sum of the bios. That is what I was 
trying to fix in 2.6.24, but the patch got messed up. In 2.6.25-rc2 and 
above that is fixed and scsi_execute_async will catch sg.c doing this 
and set rq->data_len and the bio lengths correctly.

So hopefully that helps any fixes you might have planned.
