Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYDXCH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYDXCH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYDXCHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:07:18 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:53534 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831AbYDXCHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:07:17 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Date: Thu, 24 Apr 2008 12:07:06 +1000
Message-ID: <480FEB4A.7090905@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080316)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 3/3] Do not use rqhash when merges disabled
References: <480F8936.5030406@hp.com> <480F8AB9.2050805@hp.com> <480FD648.70404@gelato.unsw.edu.au> <480FDB72.4030005@hp.com>
In-Reply-To: <480FDB72.4030005@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan D. Brunelle wrote:
> Good catch - that was a last minute addition, the ELV_ON_HASH should be
> sufficient without the check for blk_queue_nomerges, right?

Yes.  With that line reverted it seems to work fine.  FWIW, I'm testing
it like so:

=================================x8=======================================

#!/bin/bash

DEV=sdb

echo deadline > /sys/block/${DEV}/queue/scheduler

~/bin-ia64/fio - <<! &
[reader]
filename=/dev/${DEV}
ioengine=sync
direct=1
norandommap
randrepeat=0
zero_buffers
bs=16k
rw=randread:16
numjobs=128
time_based
runtime=600
!

while /bin/true ; do
	echo 0 > /sys/block/${DEV}/queue/nomerges
	sleep 0.1
	echo 1 > /sys/block/${DEV}/queue/nomerges
	sleep 0.1
done
