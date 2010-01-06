Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175Ab0AFTmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0AFTmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034Ab0AFTmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:42:18 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33296 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab0AFTmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:42:17 -0500
Message-ID: <4B44E790.9070800@cs.wisc.edu>
Date: Wed, 06 Jan 2010 13:42:08 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Tao Ma <tao.ma@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: iscsi warning in 2.6.33-rc2
References: <4B3AE891.5010508@oracle.com>
In-Reply-To: <4B3AE891.5010508@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------070003040205030906050904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070003040205030906050904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/29/2009 11:43 PM, Tao Ma wrote:
> Hi all,
> 	I met with this warning when using iscsi with the 2.6.33-rc2.
>
> ------------[ cut here ]------------
> WARNING: at drivers/scsi/libiscsi_tcp.c:996

....

>
> The other thing I can confirm is that I didn't meet with such problem in
> 2.6.32-rc8.
>

Sorry for the late reply. I am just getting back.

I think this is due to the kfifo changes that got merged recently.

For the iscsi side if there is nothing in the r2tqueue fifo at this time 
it is fine. It just means that there is nothing to process, so I think 
that the warn on should just not have been added.

Could you try the attached patch? I have only compile tested it. I am 
starting up some testing for the patch and the other fifo changes that 
got merged now.

--------------070003040205030906050904
Content-Type: text/x-patch;
 name="iscsi-do-not-warn-on-empty-r2t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iscsi-do-not-warn-on-empty-r2t.patch"

An empty r2tqueue is a valid state. It just means that we have
processed all that there was to do.

This patch removes the WARN_ON.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index db6856c..4ad87fd 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -992,12 +992,10 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 		if (r2t == NULL) {
 			if (kfifo_out(&tcp_task->r2tqueue,
 			    (void *)&tcp_task->r2t, sizeof(void *)) !=
-			    sizeof(void *)) {
-				WARN_ONCE(1, "unexpected fifo state");
+			    sizeof(void *))
 				r2t = NULL;
-			}
-
-			r2t = tcp_task->r2t;
+			else
+				r2t = tcp_task->r2t;
 		}
 		spin_unlock_bh(&session->lock);
 	}

--------------070003040205030906050904--
