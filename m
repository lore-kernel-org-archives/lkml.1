Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZDNWM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZDNWM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZDNWMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:12:44 -0400
Received: from vena.lwn.net ([206.168.112.25]:54734 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbZDNWMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:12:43 -0400
Date: Tue, 14 Apr 2009 16:12:40 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, <linux-mm@kvack.org>,
       <linux-fsdevel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 5/9] vfs: Introduce basic infrastructure for
 revoking a file
Message-ID: <20090414161240.73fe6bcd@bike.lwn.net>
In-Reply-To: <m163hb75ph.fsf@fess.ebiederm.org>
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<m163hb75ph.fsf@fess.ebiederm.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric,

One little thing I noticed as I was looking at this...

> +int fops_substitute(struct file *file, const struct file_operations *f_op,
> +			struct vm_operations_struct *vm_ops)
> +{

 [...]

> +	/*
> +	 * Wait until there are no more callers in the original
> +	 * file_operations methods.
> +	 */
> +	while (atomic_long_read(&file->f_use) > 0)
> +		schedule_timeout_interruptible(1);

You use an interruptible sleep here, but there's no signal check to get you
out of the loop.  So it's not really interruptible.  If f_use never goes to
zero (a distressingly likely possibility, I fear), this code will create
the equivalent of an unkillable D-wait state without ever actually showing
up that way in "ps".

Actually, now that I look, once you've got a signal pending you'll stay
in TASK_RUNNING, so the above could turn into a busy-wait.

Unless I've missed something...?

I have no idea what the right thing to do in the face of a signal would
be.  Perhaps the wait-for-zero and release() call stuff should be dumped
into a workqueue and done asynchronously?  OTOH, I can see a need to know
when the revoke operation is really done...

jon
