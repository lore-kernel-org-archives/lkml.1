Return-Path: <linux-kernel-owner+w=401wt.eu-S965996AbXCPWXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965996AbXCPWXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965995AbXCPWXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:23:38 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:60758 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965990AbXCPWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:23:37 -0400
Subject: Re: [PATCH] scsi: megaraid_sas - throttle io if cmds are in risk
	of being timed-out
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Sumant Patro <sumant.patro@lsi.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       neela.kolli@lsi.com, bo.yang@lsi.com
In-Reply-To: <1172784593.19842.21.camel@dumbo>
References: <1172784593.19842.21.camel@dumbo>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 17:22:55 -0500
Message-Id: <1174083775.3519.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 13:29 -0800, Sumant Patro wrote:
> Driver to throttle IO to reduce risk of OS timing out cmds.
> 
> Implemented a circular queue to keep track of pending OS cmds in FW. 
> This queue is periodically (every 10 sec) checked by a timer routine.
> If there is any cmd that is in risk of getting timed-out by the OS, 
> the host->can_queue is reduced to 16 and MEGASAS_FW_BUSY flag is set. 
> The host->can_queue will be restored to default value when the following 
> two conditions are met : 5 secs has elapsed and the # of outstanding cmds
> in FW is less than 17.
> Also increased the per cmd timeout to 120*HZ from 90*HZ.

OK, this is still not nice.  What you need to be doing is intercepting
the timeout before it fires (and quiesces the machine).  Currently the
eh_timed_out() callback is only exposed to transport classes, I'll put
it back into the host template and then you can use it.

James


