Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYH1Rlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYH1Rlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYH1RlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:41:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbYH1RlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:41:12 -0400
Date: Thu, 28 Aug 2008 10:38:13 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert
	cdev_alloc() to use it
Message-ID: <20080828173813.GC18097@kroah.com>
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6D8D0.6080506@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 06:56:48PM +0200, Tejun Heo wrote:
> Greg KH wrote:
> > Ick, I really don't want struct cdev to be used for lifecycle
> > management, as it is only for major:minor stuff.  Why do you want to
> > make this change?
> 
> Well, as cdev can be referenced from userspace, ->release is required
> for most purposes.  The reason why devices have been getting by without
> it is because most chardevs are created on module load and destroyed on
> module unload and in the meantime cdev refcount virtually equals module
> refcnt, but I'm fairly sure we have cases where cdev can be destroyed
> for other reasons then module unloading and it's very likely those cases
> are buggy in the current code (backing structure gone bug cdev still
> hanging around).

Hm, I thought Al covered that when he created the cdev interface, I
would be a bit supprised if this was the case.

> As CUSE can create and destroy devices regardless of module reference
> count, it falls in the second category and needs cdev->release() to make
> sure the backing structure doesn't go away till cdev is released.

But CUSE should be it's own module, right?  And it would "own" the cdev,
so the module and cdev count should be fine and matching.  The userspace
code could go away but the CUSE code should handle that with a different
reference count.  This is the way that hardware drivers handle the
issue.

thanks,

greg k-h
