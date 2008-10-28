Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYJ1VaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYJ1VaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYJ1VaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:30:05 -0400
Received: from mail.crca.org.au ([67.207.131.56]:49688 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYJ1VaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:30:04 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu>
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop>  <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu>
	 <1225145607.26724.54.camel@nigel-laptop>
	 <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 29 Oct 2008 08:29:59 +1100
Message-Id: <1225229399.9661.13.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2008-10-28 at 21:25 +0100, Miklos Szeredi wrote:
> > To deal with requests that are already in progress, I'd suggest three
> > possibilities, in the order I think they should be preferred.
> > 
> > 1) Use wait_event_freezeable[_timeout] in fuse code. Probably preferable
> > to #2, but I thought of it later :)
> > 
> > 2) Use freezer_do_not_count as part of FUSE_MIGHT_FREEZE (resetting
> > before exiting the callers, of course). If the request doesn't complete
> > during the freezing period, it must be because the userspace thread was
> > already frozen. If the request does complete, we're counted again during
> > the normal freezing of userspace that follows the freezing of
> > filesystems.
> > 
> > 3) Adding a means to check whether processes being frozen are fuse
> > requests. The code could then wait for fc->num_waiting - (say)
> > fc->num_frozen == 0.
> 
> Yup, these fix the freezing of tasks which have outstanding fuse
> requests.
> 
> However it does not fix the freezing of tasks which are waiting for
> VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> This is the tricky part...

Convert them all to wait_event_freezeable. If you know the locks they're
waiting on definitely aren't going to be free until post-resume and
we're going to be trying to freeze them while they're waiting, that
would be the right behaviour.

Regards,

Nigel

