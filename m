Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXGTVPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXGTVPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXGTVPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:15:41 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:40086 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbXGTVPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:15:40 -0400
Message-ID: <46A125F4.3030504@nortel.com>
Date: Fri, 20 Jul 2007 15:15:32 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: posible latency issues in seq_read
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jul 2007 21:15:35.0775 (UTC) FILETIME=[1D2E76F0:01C7CB13]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We've run into an issue (on 2.6.10) where calling "lsof" triggers lost 
packets on our server.  Preempt is disabled, and NAPI is enabled.

It appears that for some reason the networking softirq is not being 
handled in a timely fashion, which means that the rx ring buffer fills 
up and packets overflow.

It appears that the problem path is:

seq_read
	tcp_seq_next
		established_get_next
			read_lock/read_unlock

The issue appears to be related to the amount of time that this syscall 
takes.  While we're in the syscall we cannot run the softirqd thread, 
and so the rx buffer is not being cleaned.

The fact that there are kmalloc(GFP_KERNEL) calls in seq_read() seems to 
indicate that sleeping is safe, so would it be reasonable to call 
schedule() periodically (maybe based on elapsed time) to ensure that 
system latency is kept under control?

Thanks,

Chris
