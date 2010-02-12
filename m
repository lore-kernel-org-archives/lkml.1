Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0BLSDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 13:03:53 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37914 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0BLSDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 13:03:51 -0500
Message-ID: <4B7597F4.6070403@cs.wisc.edu>
Date: Fri, 12 Feb 2010 12:03:32 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
CC: linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_transport_fc: handle transient error on multipath
 environment
References: <4B750CB7.4030805@jp.fujitsu.com> <4B7593F4.2050102@cs.wisc.edu>
In-Reply-To: <4B7593F4.2050102@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 11:46 AM, Mike Christie wrote:
> - Maybe you want to instead hook something into the dm-mutlipath's
> request (no more bios like in 2004 :)). Can you set a timer on that
> level of request. If that times out then, dm-multipath could do
> something like call blk_abort_queue.

Some more detail. I was thinking maybe you could stack the timeout
handlers like is done for request_fn handlers or maybe the scsi cmd
would use the upper layer's timer somehow. Not sure... but at the least
I think we would not want both a scsi request and dm request timers
running at the same time.

Then for the error handling and timeout handling, most FC drivers have a
terminate_rport_io which works without having to block the entire host.
Those drivers could implement a newer eh where instead of firing the
code in scsi_error.c when a cmd times out, it would run
terminate_rport_io from some workqueue.

new dm request timed out()
	-> scsi_timed_out
		-> fc_timed_out()
			{
				run new eh from workqueue();
			}


new_eh()
	/* no new cmds should be started until we figure out what is going on */
	block rport()
	/* releases cmds upwards so they can run while we try to figure out
what is going on */
	terminate_rport_io()
	/* check if devices are ok */
	send_tur()
	if (tur failed)
		start old scsi_error.c code to unjam us.
	else
		/* everything looks ok so let IO run to this path again */
		unblock rport()


> 
> I think the problem with blk_abort_queue might be that it stops all IO
> to the entire host where you probably just want to work on the remote
> port/path. For that you could call something like
> recover_transient_error. Maybe it could just be a call to
> terminate_rport_io from a workqueue though.

