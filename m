Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYI0QNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYI0QNQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYI0QNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:13:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:52170 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYI0QNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:13:01 -0400
Date: Sat, 27 Sep 2008 09:13:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][RFC] ioctl dispatcher
Message-ID: <20080927091304.12b8c4c3@infradead.org>
In-Reply-To: <1222530242-1272-1-git-send-email-avi@redhat.com>
References: <1222530242-1272-1-git-send-email-avi@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Sep 2008 18:43:59 +0300
Avi Kivity <avi@redhat.com> wrote:

> While ioctls are officially ugly, they are the best choice for some
> use cases, not to mention compatibility issues.  Currently ioctl
> writers face the following hurdles:
> 
> - if the ioctl uses a data buffer, the ioctl handler must allocate
>   kernel memory for this buffer
>   - the memory may be allocated on the heap or on the stack,
> depending on the buffer size
> - handle any errors from the operation
> - copy the data from userspace, if necessary
> - handle any errors from the operation
> - actually perform the operation
> - copy the data back to userspace, if necessary
> - handle any errors from the operation
> - free the buffer, if allocated from the heap
> 
> The first patch automates these operations, only requiring the caller
> to supply the ioctl number and a callback in a table.
> 
> The second patch addresses another problem with ioctls: they are
> brittle. Once written, an ioctl cannot be extended, since the buffer
> sizes used for transferring data are encoded in the ioctl number.
> This is addressed by allowing the user-supplied size and the
> kernel-visible size of the data buffer to be different; the kernel
> will zero fill or truncate appropriately. With the new mechanism, it
> is easy to write forward- and backward- compatible ioctl handlers.
> 
> The third patch demonstrates the effectiveness of the first patch; it
> converts some of kvm's ioctl handlers to the new mechanism, removing
> around 90 lines in the process.
> 

this doesn't seem to be much different from the way the DRM code deals
with ioctls. Or the V4L code.
Personally I hate that code though.....

There is a fine balance here; between driver writers screwing something
up they shouldn't be doing in the first place and us being able to
clearly see what the code is doing; your patch kinda hides some key
elements of the ioctl path... I'm afraid it gives a false sense of
security though. Not having to deal with one aspect of security just to
have to deal with the rest....
Lets put it this way: if the driver author has to type "copy_from_user"
there's a chance that he'll remember that the data comes from the user
and isn't to be trusted on face value.
