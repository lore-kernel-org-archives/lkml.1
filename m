Return-Path: <linux-kernel-owner+w=401wt.eu-S965049AbXCANb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049AbXCANb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 08:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965050AbXCANb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 08:31:26 -0500
Received: from p02c11o145.mxlogic.net ([208.65.145.68]:41538 "EHLO
	p02c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049AbXCANbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 08:31:25 -0500
Subject: wait_for_completion_timeout problem ???
From: Eli Cohen <eli@mellanox.co.il>
Reply-To: eli@mellanox.co.il
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rdreier@cisco.com, "Michael S. Tsirkin" <mst@mellanox.co.il>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Mellanox Technologies
Date: Thu, 01 Mar 2007 15:32:12 +0200
Message-Id: <1172755932.5175.37.camel@mtls03>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
X-Spam: [F=0.0100000000; S=0.010(2007010901)]
X-MAIL-FROM: <eli@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	
I have a problem with using this function. I am referring to
drivers/infiniband/hw/mthca/mthca_cmd.c line 394. For convenience I
quote from this code:

	init_completion(&context->done);

	err = mthca_cmd_post(dev, in_param,
			     out_param ? *out_param : 0,
			     in_modifier, op_modifier,
			     op, context->token, 1);
	if (err)
		goto out;

	if (!wait_for_completion_timeout(&context->done, timeout)) {
		err = -EBUSY;
		goto out;
	}

timeout is 10 * HZ. Sometimes this function returns 0 which signifies
timeout. However I can see that the interrupt handler called
complete(&context->done)
around 200 usec after calling wait_for_completion_timout(). When the
function returns I can see that context->done.done equals 1 which
confirms that complete was indeed called. Looking at the implementation
of wait_for_completion_timout() it appears that complete() did not
succeed to wake the process sleeping. But the timer callback function in
schedule_timeout() did manage to wake up the sleeping process. Do you
have any idea if there are any known circumstances that can lead to this
behaviour. Any idea how to debug this?

Thanks
Eli
