Return-Path: <linux-kernel-owner+w=401wt.eu-S1422959AbXCOQwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422959AbXCOQwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXCOQwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:52:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59392 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030603AbXCOQwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:52:05 -0400
Date: Thu, 15 Mar 2007 09:51:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       gregkh@suse.de, Richard Purdie <rpurdie@rpsys.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <Pine.LNX.4.64.0703151555240.26565@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0703150944250.3816@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0703150953420.13086-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0703151555240.26565@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Mar 2007, Hugh Dickins wrote:
> 
> sysfs_access_in_other_task() left me wondering what this "other" task
> was, and what kind of "access" it's trying to get - or is the calling
> task the other, and it's trying to access something it wouldn't
> directly have access to?

For naming clashes, I'd suggest:

 - try to name according to *why* something is done, not necessarily what 
   it does.

   For example, is it really in "another task"? Maybe it's just an 
   on-demand thread of the same task?  Do you actually care how the 
   deferred work is done?

 - avoid being vague. I agree with not liking the name much, and the 
   "other" thing bothers me. Like Hugh, it makes me ask "_What_ other 
   task?"

So I would suggest not concentrating on some implementation issue, but on 
the reason why you need it in the first place. Namely that you want to 
defer the actual action to avoid deadlock due to recursive locking. So 
that "why do I actually do this" thing implies something like 
"sysfs_store_async()" or "sysfs_store_deferred()" or maybe actually 
concentrate on the locking angle and say something like 
"sysfs_store_needs_to_reacquire_lock()".

(That last one wasn't really serious - it's too long and cumbersome, but 
it's an example of not caring _how_ you do it, just abotu what you want 
done).

		Linus
