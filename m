Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYJ1U0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYJ1U0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYJ1UZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:25:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55152 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYJ1UZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:25:51 -0400
To: ncunningham@crca.org.au
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1225145607.26724.54.camel@nigel-laptop> (message from Nigel
	Cunningham on Tue, 28 Oct 2008 09:13:27 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop>  <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu> <1225145607.26724.54.camel@nigel-laptop>
Message-Id: <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 Oct 2008 21:25:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Nigel Cunningham wrote:
> The answer is to freeze the fuse filesystems first, stopping new
> requests (freezing the processes making them) before they are passed on
> to userspace and allowing existing requests to complete or freeze. Once
> that is done, the userspace fuse processes will be idle, at least as far
> as fuse activity is concerned. After fuse activity is stopped, userspace
> can be frozen without worrying about what processes are fuse and what
> aren't. This is what my patch implements so far.

OK.

> To deal with requests that are already in progress, I'd suggest three
> possibilities, in the order I think they should be preferred.
> 
> 1) Use wait_event_freezeable[_timeout] in fuse code. Probably preferable
> to #2, but I thought of it later :)
> 
> 2) Use freezer_do_not_count as part of FUSE_MIGHT_FREEZE (resetting
> before exiting the callers, of course). If the request doesn't complete
> during the freezing period, it must be because the userspace thread was
> already frozen. If the request does complete, we're counted again during
> the normal freezing of userspace that follows the freezing of
> filesystems.
> 
> 3) Adding a means to check whether processes being frozen are fuse
> requests. The code could then wait for fc->num_waiting - (say)
> fc->num_frozen == 0.

Yup, these fix the freezing of tasks which have outstanding fuse
requests.

However it does not fix the freezing of tasks which are waiting for
VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
This is the tricky part...

Miklos
