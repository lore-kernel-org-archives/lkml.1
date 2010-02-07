Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0BGJWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 04:22:36 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:44167 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0BGJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 04:22:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cRWJodev+ufzl+yRsuaHHyl1xFP6yBphHEL55VTPXMUUoFQGCHT0YM+efgkxd0Sb8A
         r+JR9nEJdF8w4nRJ3V/4XEt1c9M10HU0sFT0x9jUq8Z9D05rj6MAFe9fGivB1CxKmKY4
         EXFDy8lbvuLG+5pcNeK4pfLBUy/wQnEfVDAOc=
Date: Sun, 7 Feb 2010 17:22:16 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
Message-ID: <20100207092216.GA2585@darkstar>
References: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org> <1265384517.30057.50.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265384517.30057.50.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 04:41:57PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-02-05 at 10:30 -0500, Alan Stern wrote:
> > On Fri, 5 Feb 2010, Peter Zijlstra wrote:
> > 
> > > Right, so this device stuff is much more complicated than I was led to
> > > believe ;-)
> > 
> > Haven't I told you all along that tree-structured locking is
> > complicated?  :-)
> 
> Well, regular tree's aren't all that complicated, but multiple
> inter-locking trees is a whole different story indeed.
> 

I ever tried converting device semaphore to mutex, but failed with same issue.

At least now there's no lockdep solution for it, so I recommend revert
the mutex converting patch.

following lockdep warning with rc6-mm1:

[    0.397123] 
[    0.397124] =============================================
[    0.397359] [ INFO: possible recursive locking detected ]
[    0.397480] 2.6.33-rc6-mm1 #1
[    0.397596] ---------------------------------------------
[    0.397717] swapper/1 is trying to acquire lock:
[    0.397836]  (&dev->mutex){+.+...}, at: [<c12662e4>] __driver_attach+0x38/0x63
[    0.398162] 
[    0.398162] but task is already holding lock:
[    0.398393]  (&dev->mutex){+.+...}, at: [<c12662d8>] __driver_attach+0x2c/0x63
[    0.399999] 
[    0.399999] other info that might help us debug this:
[    0.399999] 1 lock held by swapper/1:
[    0.399999]  #0:  (&dev->mutex){+.+...}, at: [<c12662d8>] __driver_attach+0x2c/0x63
[    0.399999] 
[    0.399999] stack backtrace:
[    0.399999] Pid: 1, comm: swapper Not tainted 2.6.33-rc6-mm1 #1
[    0.399999] Call Trace:
[    0.399999]  [<c13d5851>] ? printk+0xf/0x11
[    0.399999]  [<c105460c>] __lock_acquire+0x880/0xc0d
[    0.399999]  [<c13d66e4>] ? __mutex_unlock_slowpath+0xf0/0xff
[    0.399999]  [<c1054a34>] lock_acquire+0x9b/0xb8
[    0.399999]  [<c12662e4>] ? __driver_attach+0x38/0x63
[    0.399999]  [<c13d685c>] __mutex_lock_common+0x35/0x2f2
[    0.399999]  [<c12662e4>] ? __driver_attach+0x38/0x63
[    0.399999]  [<c13d6bb7>] mutex_lock_nested+0x30/0x38
[    0.399999]  [<c12662e4>] ? __driver_attach+0x38/0x63
[    0.399999]  [<c12662e4>] __driver_attach+0x38/0x63
[    0.399999]  [<c1265a43>] bus_for_each_dev+0x3d/0x67
[    0.399999]  [<c1265f8f>] driver_attach+0x14/0x16
[    0.399999]  [<c12662ac>] ? __driver_attach+0x0/0x63
[    0.399999]  [<c126541c>] bus_add_driver+0xc4/0x20c
[    0.399999]  [<c1266553>] driver_register+0x8b/0xeb
[    0.399999]  [<c11d8e3a>] acpi_bus_register_driver+0x3a/0x3c
[    0.399999]  [<c165dc9a>] acpi_ec_init+0x2b/0x4a
[    0.399999]  [<c165daf8>] acpi_init+0x289/0x2c8
[    0.399999]  [<c165d86f>] ? acpi_init+0x0/0x2c8
[    0.399999]  [<c1001139>] do_one_initcall+0x4c/0x13f
[    0.399999]  [<c163d315>] kernel_init+0x123/0x174
[    0.399999]  [<c163d1f2>] ? kernel_init+0x0/0x174
[    0.399999]  [<c10035ba>] kernel_thread_helper+0x6/0x10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
