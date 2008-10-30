Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYJ3SCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYJ3SCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbYJ3SBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:01:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbYJ3SBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:01:38 -0400
Date: Thu, 30 Oct 2008 14:01:34 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French" <smfrench@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] cifs: fix oopses and mem corruption with concurrent
 mount/umount (try #4)
Message-ID: <20081030140134.7adcef56@barsoom.rdu.redhat.com>
In-Reply-To: <524f69650810301051j7400a3f6m1840d06924ab8e89@mail.gmail.com>
References: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
	<524f69650810301025t3f3b7fb6t10d96b6567a67715@mail.gmail.com>
	<20081030134235.6d1276ae@barsoom.rdu.redhat.com>
	<524f69650810301051j7400a3f6m1840d06924ab8e89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 12:51:03 -0500
"Steve French" <smfrench@gmail.com> wrote:

> On Thu, Oct 30, 2008 at 12:42 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > I think we want to resist having locks that protect too many things.
> > With that, we end up with the locks held over too much code. Not only is
> > that generally worse for performance, but it can paper over race
> > conditions.
> 
> I agree that it is trivially worse for performance to have a single
> spinlock protecting the three interrelated structures (cifs tcp, smb
> and tree connection structs), but since they point to one another and
> frequently have operations that require us to use all three lists -
> to do things like iterate through all tree connections within a
> particular smb session, or iterate across all cifs smb sessions within
> each cifs tcp session - it makes code more complicated to have to grab
> and unlock multiple spinlocks in the correct order every time across
> all exit paths etc.
> 

A fair point, but most of that is in rarely-traveled procfile code. One
thing we could consider is some helper macros or functions. For
instance, a for_all_tcons() function or something that would take a
pointer to a function that takes a tcon arg. It would
basically just walk over all the tcons and handle the locking
correctly and call the function for each.

In any case, I don't see the benefit of not using fine grained locking
here. deadlock is a possibility, but I think having well-defined
locking rules mitigates that danger.

-- 
Jeff Layton <jlayton@redhat.com>
