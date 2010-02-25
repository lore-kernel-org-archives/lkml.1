Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0BYLwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:52:35 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38219 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0BYLwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:52:33 -0500
Date: Thu, 25 Feb 2010 06:52:19 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] supress uid comparison test if core output files are
 pipes
Message-ID: <20100225115219.GA13996@hmsreliant.think-freely.org>
References: <20100222200851.GD3344@hmsreliant.think-freely.org>
 <20100224135053.e75800c1.akpm@linux-foundation.org>
 <20100225013210.GA10527@localhost.localdomain>
 <20100224181332.5cdc2454.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224181332.5cdc2454.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 06:13:32PM -0800, Andrew Morton wrote:
> On Wed, 24 Feb 2010 20:32:10 -0500 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > > > diff --git a/fs/exec.c b/fs/exec.c
> > > > index 6303d18..6af2214 100644
> > > > --- a/fs/exec.c
> > > > +++ b/fs/exec.c
> > > > @@ -1987,8 +1987,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> > > >  	/*
> > > >  	 * Dont allow local users get cute and trick others to coredump
> > > >  	 * into their pre-created files:
> > > > +	 * Note, this is not relevant for pipes
> > > >  	 */
> > > > -	if (inode->i_uid != current_fsuid())
> > > > +	if (!ispipe && (inode->i_uid != current_fsuid()))
> > > >  		goto close_fail;
> > > >  	if (!cprm.file->f_op)
> > > >  		goto close_fail;
> > > 
> > > hm, this actually appears to fix a regression, added by:
> > > 
> > In a sense yes.  Previously though, Ingos check was both useless for pipes
> > (since you can't have a user create a pipe that will map to what the coredump
> > path creates anyway, making this check useless), but it worked anyway, since the
> > crashing process created the pipe, so the uid check always matched.  With the
> > refactoring andi and I did, thats no longer true, so the check could fail.  This
> > patch just fixes it up by recongnizing that the check isn't needed at all for
> > pipes
> 
> Which refactoring?  Please identify precisely the patch which this patch fixes up?
> 

kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch

Sorry, when I say refactoring, I was referring to the addition of the init and
cleanup functions that Andi and I added a few weeks ago.
Neil

