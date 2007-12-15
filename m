Return-Path: <linux-kernel-owner+w=401wt.eu-S1765447AbXLOVHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765447AbXLOVHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 16:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbXLOVHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 16:07:04 -0500
Received: from kuber.nabble.com ([216.139.236.158]:47507 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXLOVHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 16:07:03 -0500
Message-ID: <14355076.post@talk.nabble.com>
Date: Sat, 15 Dec 2007 13:07:01 -0800 (PST)
From: a_kumar <cable_plug2000@yahoo.com>
To: linux-kernel@vger.kernel.org
Subject: problem with ending requests asynchronously in my block device
 driver
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: cable_plug2000@yahoo.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

I've a block device driver which does the following, 

Inside the request function I do something like this: 
request(fn) { 

 while ((req = elv_next_request(q)) != NULL) { 
....................set up the request; 
 spin_unlock_irq(q->queue_lock); 
call the transfer(set_up_req) function; 
spin_lock_irq(q->queue_lock); 
} 
       spin_unlock_irq (q->queue_lock); 
        /* allow callback to execute as it needs the lock!!! */ 
        spin_lock_irq (q->queue_lock); 


} 
and the transfer function calls the scsi_execute_asyn(....) with the
callback function doing the end request. So, the ending of the request is
done like below: 

callback(fn) { 

 spin_lock_irqsave(q->queue_lock, flags); 
        if (!end_that_request_first(set_up_req->req, cmpstatus, 
                        set_up_req->req->nr_sectors)) { 
                add_disk_randomness(...); 
                end_that_request_last(set_up_req->req,0); 
        } 
        spin_unlock_irqrestore(q->queue_lock, flags); 
} 


This code works fine with most of the kernel versions, but fails on some
like , Linux 2.6.18-8.el5-xen 

Please help me to find out where I'm going wrong? 

Thanks in advance for an early reply. 
Anil P. 


-- 
View this message in context: http://www.nabble.com/problem-with-ending-requests-asynchronously-in-my-block-device-driver-tp14355076p14355076.html
Sent from the linux-kernel mailing list archive at Nabble.com.

