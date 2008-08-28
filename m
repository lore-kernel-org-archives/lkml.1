Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYH1Q6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYH1Q6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYH1Q6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:58:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:44868 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYH1Q6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:58:14 -0400
Message-ID: <48B6D8D0.6080506@kernel.org>
Date: Thu, 28 Aug 2008 18:56:48 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com>
In-Reply-To: <20080828164741.GA17475@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 16:58:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Ick, I really don't want struct cdev to be used for lifecycle
> management, as it is only for major:minor stuff.  Why do you want to
> make this change?

Well, as cdev can be referenced from userspace, ->release is required
for most purposes.  The reason why devices have been getting by without
it is because most chardevs are created on module load and destroyed on
module unload and in the meantime cdev refcount virtually equals module
refcnt, but I'm fairly sure we have cases where cdev can be destroyed
for other reasons then module unloading and it's very likely those cases
are buggy in the current code (backing structure gone bug cdev still
hanging around).

As CUSE can create and destroy devices regardless of module reference
count, it falls in the second category and needs cdev->release() to make
sure the backing structure doesn't go away till cdev is released.

Thanks.

-- 
tejun
