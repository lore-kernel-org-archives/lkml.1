Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZKSTf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZKSTf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 14:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZKSTfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 14:35:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZKSTfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 14:35:55 -0500
Date: Thu, 19 Nov 2009 14:35:55 -0500
From: Jeff Layton <jlayton@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal"
 symlinks
Message-ID: <20091119143555.7851953f@barsoom.rdu.redhat.com>
In-Reply-To: <m1skca2vi3.fsf@fess.ebiederm.org>
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
	<m14ooq5tq3.fsf@fess.ebiederm.org>
	<20091119132833.30bc93a4@barsoom.rdu.redhat.com>
	<m1skca2vi3.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009 10:57:08 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Jeff Layton <jlayton@redhat.com> writes:
> 
> > On Thu, 19 Nov 2009 09:07:16 -0800
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> >
> >> 
> >> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> 
> >> This is broken.  If the referenced file is in a different mount namespace
> >> the path returned could point to a completely different path in your
> >> own mount namespace.  Even in your own mount namespace this makes the
> >> proc symlinks racy and not guaranteed to return the file of interest.
> >> 
> >> I don't see any hope of this approach ever working.
> >> 
> >> Eric
> >> 
> >
> > Then is proc_pid_readlink broken in the same way?
> 
> proc_pid_readlink has the same deficiencies.  The race is fundamental
> to all readlink operations, the difference is that for normal symlinks
> it is a don't care, and for proc it is incorrect behavior if you follow
> the symlink to the wrong file.   If you are dealing with a file in a
> different namespace or a socket what you get back doesn't actually
> work as a file in your local namespace but that is the best we can do
> with a pathname, and if you know the context of what is going on readlink
> is still useful.
> 
> Adding all of the short comings to followlink that readlink has is a problem,
> especially as followlink does much better now.
> 
> At a practical level I think your changes are much easier to exploit than
> Pavels contrived example.
> 
> I really don't have any problems with your first patch to proc to add the
> missing revalidate.
> 

Thanks, that makes sense. The raciness was evident once you pointed it
out, so I think you're correct that we can't take this approach.

Adding the missing revalidations is fine, but I don't believe that
helps to fix Pavel's issue. I'll go back and take a more careful look
at the suggestion that Miklos made and see whether it makes sense to
implement a new FS_* flag for this, and see what it'll take to fix
Pavel's issue.

-- 
Jeff Layton <jlayton@redhat.com>
