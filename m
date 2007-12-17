Return-Path: <linux-kernel-owner+w=401wt.eu-S937597AbXLQUVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937597AbXLQUVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761859AbXLQUVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:21:06 -0500
Received: from kuber.nabble.com ([216.139.236.158]:37420 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937513AbXLQUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:21:04 -0500
Message-ID: <14374028.post@talk.nabble.com>
Date: Mon, 17 Dec 2007 12:21:03 -0800 (PST)
From: cable_plug <pratapagiri.ak@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: problem with ending requests asynchronously in my block device
 driver
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: pratapagiri.ak@gmail.com
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

when I say 'fails' it just hangs without any error ....I'm using dt(Data
test) to write to the disk. The logs show that all the requests that have
been sent for processing, have completed sucessfully. Its just that new
requests never enter the request function. So, the dt writes almost half the
data and then simply hangs. 

  
  The actual code does nothing but, call the scsi_execute_async , which 
 later on calls the callback function which is used to end the request. 
 So, both the callback function and the request function need to share 
 the queue lock. So the code samples I sent cover all the aspects of my 
 program. What I'm looking for here is how can I end the requests 
 asynchronously much later after the request processing is done. Please note 
 here that the asynchronous end requests is done by the callback function 
 of the scsi_execute_async, which needs to share the queue lock with 
 the request function. 
    
  when I say 'fails' it just hangs without any error ....I'm using 
 dt(Data 
test) to write to the disk. The logs show that all the requests that 
 have 
been sent for processing, have completed successfully. Its just that new 
requests never enter the request function. So, the dt writes almost 
 half the 
data and then simply hangs. 


Thanks in advance for an early reply. 
Anil P.
-- 
View this message in context: http://www.nabble.com/problem-with-ending-requests-asynchronously-in-my-block-device-driver-tp14374028p14374028.html
Sent from the linux-kernel mailing list archive at Nabble.com.

