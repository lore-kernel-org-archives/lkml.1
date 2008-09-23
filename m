Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYIWU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYIWU6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYIWU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:58:11 -0400
Received: from vena.lwn.net ([206.168.112.25]:46613 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYIWU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:58:10 -0400
Date: Tue, 23 Sep 2008 14:58:07 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jmoriss@namei.org,
       serue@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com, paulmck@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com
Subject: Re: [PATCH 1/4] TPM: update char dev BKL pushdown
Message-ID: <20080923145807.63f9b904@bike.lwn.net>
In-Reply-To: <1222190371-23814-1-git-send-email-srajiv@linux.vnet.ibm.com>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
	<1222190371-23814-1-git-send-email-srajiv@linux.vnet.ibm.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 14:19:26 -0300
Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:

> + * It's assured that the chip will be opened just once,
> + * by the check of is_open variable, which is protected
> + * by driver_lock.

Taking a look at the code, I'm convinced.  BKL removal seems
appropriate.

While I was in the neighborhood, though, something caught my eye:

int tpm_release(struct inode *inode, struct file *file)
{
	struct tpm_chip *chip = file->private_data;

	flush_scheduled_work();

Here you have waited until you've got nothing in the workqueue.

	spin_lock(&driver_lock);
	file->private_data = NULL;
	del_singleshot_timer_sync(&chip->user_read_timer);

But, until you get here, your timer could have resubmitted a job into
the workqueue - job which could run after you've freed "chip" and
forgotten all about it. I think you need either a "don't resubmit" flag,
or you need to delete the timer first.

jon
