Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYJaVLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYJaVLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYJaVLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:11:43 -0400
Received: from mail.crca.org.au ([67.207.131.56]:58940 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYJaVLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:11:42 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for
	frozen	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1KvtMn-0004YD-00@pomaz-ex.szeredi.hu>
References: <Pine.LNX.4.44L0.0810300955020.2401-100000@iolanthe.rowland.org>
	 <1225403060.6574.10.camel@nigel-laptop>
	 <E1Kvpgo-00045l-GU@pomaz-ex.szeredi.hu>
	 <1225444253.6574.21.camel@nigel-laptop>
	 <E1Kvq72-00049W-O1@pomaz-ex.szeredi.hu>
	 <1225452484.6574.35.camel@nigel-laptop>
	 <E1KvtMn-0004YD-00@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Sat, 01 Nov 2008 08:11:38 +1100
Message-Id: <1225487498.6574.40.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2008-10-31 at 13:44 +0100, Miklos Szeredi wrote:
> On Fri, 31 Oct 2008, Nigel Cunningham wrote:
> > You don't. You just use FUSE_MIGHT_FREEZE to stop them before they take
> > locks that might cause problems. So my suggestion is:
> 
> Before?  FUSE_MIGHT_FREEZE is called _after_ i_mutex is taken by the
> VFS.

Ok. So I'll shift it backwards in the calling chain a bit.

> > 1) Stop new requests at FUSE_MIGHT_FREEZE
> > 2) Handle existing requests by using freezer_do_not_count in
> > request_send and request_send_nowait before the spin_lock and
> > freezer_count after the spin_unlock.
> > 
> > With #2, we don't need to care about whether the request is completed
> > before freezing completes or post-resume.
> > 
> > If the userspace process tries to use an already frozen fuse filesystem
> > and gets frozen, that's okay because we'll sit waiting for an answer,
> > not be counted by the freezer and so not contribute to any failure to
> > freeze processes.
> > 
> > If the userspace process completes its work, we'll either get caught at
> > the freezer_count (if we've already been told to freeze) or be gotten
> > later, after exiting the fuse code.
> 
> Yes, this is the variant of categorizing sleeps to freezing and
> non-freezing.  The problem is, you need to do that with all
> mutex_lock(&inode->i_mutex) instances as well.  Try grepping for that
> in fs/*.c!
> 
> It _is_ possible, it's just not practical.

Let's get practical. You know fuse a lot better than me. Can you give me
the most complicated, ugly configuration you can think of, and I'll work
on making it freeze first time, every time.

Regards,

Nigel

