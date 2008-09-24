Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYIXNSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYIXNSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIXNSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:18:41 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:53905 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYIXNSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:18:40 -0400
Subject: Re: [PATCH 1/4] TPM: update char dev BKL pushdown
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jmoriss@namei.org,
       serue@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com, paulmck@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com
In-Reply-To: <20080923145807.63f9b904@bike.lwn.net>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
	 <1222190371-23814-1-git-send-email-srajiv@linux.vnet.ibm.com>
	 <20080923145807.63f9b904@bike.lwn.net>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 10:14:40 -0300
Message-Id: <1222262080.24276.32.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 14:58 -0600, Jonathan Corbet wrote:
> On Tue, 23 Sep 2008 14:19:26 -0300
> Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:
> 
> > + * It's assured that the chip will be opened just once,
> > + * by the check of is_open variable, which is protected
> > + * by driver_lock.
> 
> Taking a look at the code, I'm convinced.  BKL removal seems
> appropriate.
> 
> While I was in the neighborhood, though, something caught my eye:
> 
> int tpm_release(struct inode *inode, struct file *file)
> {
> 	struct tpm_chip *chip = file->private_data;
> 
> 	flush_scheduled_work();
> 
> Here you have waited until you've got nothing in the workqueue.
> 
> 	spin_lock(&driver_lock);
> 	file->private_data = NULL;
> 	del_singleshot_timer_sync(&chip->user_read_timer);
> 
> But, until you get here, your timer could have resubmitted a job into
> the workqueue - job which could run after you've freed "chip" and
> forgotten all about it. I think you need either a "don't resubmit" flag,
> or you need to delete the timer first.
> 
> jon

Yes, like in tpm_read(), the timer must be deleted before
flush_scheduled_work(). Since it's a fix to a new issue, I'm going to
submit a another patch.

Thanks,
Rajiv Andrade
IBM Linux Technology Center
Security Development

