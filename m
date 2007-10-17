Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbXJQTdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbXJQTdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbXJQTdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:33:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33445 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbXJQTdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:33:24 -0400
Date: Wed, 17 Oct 2007 20:33:21 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] file operations: release can race with read/write?
Message-ID: <20071017193320.GK8181@ftp.linux.org.uk>
References: <adave96ki0x.fsf@cisco.com> <adaodexh9uz.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaodexh9uz.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 11:30:44AM -0700, Roland Dreier wrote:
> static unsigned long flag;
> 
> static int cw_open(struct inode *inode, struct file *filp)
> {
> 	return 0;
> }
> 
> static int cw_close(struct inode *inode, struct file *filp)
> {
> 	clear_bit(1, &flag);
> 
> 	msleep(1);
> 
> 	if (test_and_set_bit(1, &flag))
> 		printk(KERN_ERR "Write raced with close?\n");

Of _course_ you can trigger that - just open two files and have write
on one of them while another gets closed.

That is certainly possible, but it has nothing whatsoever with the
race you've described - you have two different objects and method
call on one of them might happen when destructor is called on another.

You have protection against ->release() for a struct file called
while you are in ->write() for _same_ struct file.
