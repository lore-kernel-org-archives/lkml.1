Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbXHIVmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbXHIVmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXHIVmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:42:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXHIVma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:42:30 -0400
Date: Thu, 09 Aug 2007 17:42:14 -0400 (EDT)
Message-Id: <20070809.174214.35657111.k-ueda@ct.jp.nec.com>
To: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [QUESTION] xsysace: moving the end_that_request_last() call
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any problem if end_that_request_last() in ace_fsm_dostate()
is moved to ACE_FSM_STATE_REQ_TRANSFER state from
ACE_FSM_STATE_REQ_COMPLETE state like the patch below?

BACKGROUND:
I'm working on refining request completion procedures like:
    Before: 2 steps completion using "end_that_request_{first/chunk}"
            and "end_that_request_last"
    After:  1 step completion using generic block-layer helper
            which I'm calling "blk_end_request"
"blk_end_request" works like calling "__end_that_request_first"
and "end_that_request_last".
<http://marc.info/?l=linux-kernel&m=116846938806220&w=2>

However, while auditing various drivers, I found xsysace driver
doesn't call end_that_request_first() and end_that_request_last()
at a time.  It makes implementation of blk_end_request complicated.
So I'd like to move the end_that_request_last() call.

I think it's no problem because after the successful call to
end_that_request_first() in ACE_FSM_STATE_REQ_TRANSFER, the state
changes immediately to ACE_FSM_STATE_REQ_COMPLETE without interruption,
where it calls end_that_request_last().
There is no other transition to ACE_FSM_STATE_REQ_COMPLETE state.

Thanks,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--- 2.6.23-rc1-mm1/drivers/block/xsysace.c	2007-07-25 15:12:05.000000000 -0400
+++ xsysace/drivers/block/xsysace.c	2007-08-09 16:40:34.000000000 -0400
@@ -707,13 +707,14 @@ static void ace_fsm_dostate(struct ace_d
 			break;
 		}
 
+		/* Complete the block request */
+		blkdev_dequeue_request(ace->req);
+		end_that_request_last(ace->req, 1);
+
 		ace->fsm_state = ACE_FSM_STATE_REQ_COMPLETE;
 		break;
 
 	case ACE_FSM_STATE_REQ_COMPLETE:
-		/* Complete the block request */
-		blkdev_dequeue_request(ace->req);
-		end_that_request_last(ace->req, 1);
 		ace->req = NULL;
 
 		/* Finished request; go to idle state */
