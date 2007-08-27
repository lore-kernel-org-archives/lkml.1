Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbXH0Xg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbXH0Xg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbXH0XgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:36:18 -0400
Received: from mail.fieldses.org ([66.93.2.214]:39772 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbXH0XgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:36:18 -0400
Date: Mon, 27 Aug 2007 19:36:15 -0400
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 08/15] knfsd: spawn kernel thread to probe callback
	channel
Message-ID: <20070827233615.GP3118@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org> <1188246176681-git-send-email-bfields@fieldses.org> <1188246176897-git-send-email-bfields@fieldses.org> <1188246177833-git-send-email-bfields@fieldses.org> <11882461773576-git-send-email-bfields@fieldses.org> <11882461771774-git-send-email-bfields@fieldses.org> <1188246177195-git-send-email-bfields@fieldses.org> <11882461773396-git-send-email-bfields@fieldses.org> <1188246177259-git-send-email-bfields@fieldses.org> <18131.23980.89642.364179@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18131.23980.89642.364179@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 09:26:36AM +1000, Neil Brown wrote:
> On Monday August 27, bfields@fieldses.org wrote:
> >  
> > +/* Reference counting, callback cleanup, etc., all look racy as heck.
> > + * And why is cb_set an atomic? */
> 
> Agreed.... so do we really want this code in mainline?  is the old
> code so bad that this is better?

The code in question is just moved, not rewritten, so those are
preexisting problems that I was just adding a whiny comment about in
hopes it would remind me some more patches were probably needed.
(Thanks for the reminder....)

>  - cb_set should not be atomic.
>  - This looks like a job for async-rpc rather than a kernel thread

The problem isn't the wait for the rpc itself, it's the creation of the
new cred that's needed in the gss case.  That could also be made
asynchronous, but as there's several other delicate changes in the
pipeline (keyring stuff, etc.), I'd rather not touch it for now.

>  - If you do use a thread, you at least want __module_get before
>    starting the thread, and module_put_and_exit to terminate the
>    thread.
>  - Can you just use 'cb_client' rather than cb_set?  If you move
>    rpc_create into the thread, you don't need to set cb_client until
>    the callback is successful.  Then add a 'cb_active' flag bit
>    so that you don't have two callbacks at the same time, and it
>    should be less racy..

Yep, probably so.

--b.
