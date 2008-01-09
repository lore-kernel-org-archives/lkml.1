Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYAIXmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYAIXmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758587AbYAIXm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:42:28 -0500
Received: from mail.impinj.com ([206.169.229.170]:47750 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758197AbYAIXm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:42:27 -0500
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2008 18:42:27 EST
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Wed, 9 Jan 2008 15:31:00 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <478551A6.9050803@nortel.com> <20080109230545.GG3510@agk.fab.redhat.com>
In-Reply-To: <20080109230545.GG3510@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200801091531.00483.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 09 Jan 2008 23:31:04.0110 (UTC) FILETIME=[B382B4E0:01C85317]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 03:05:45 pm Alasdair G Kergon wrote:
> On Wed, Jan 09, 2008 at 04:58:46PM -0600, Chris Friesen wrote:
> > Alasdair G Kergon wrote:
> > >On Wed, Jan 09, 2008 at 11:46:03PM +0100, Andi Kleen wrote:
> > >>struct inode *inode = file->f_dentry->d_inode;
> > >
> > >And oops if that's not defined?
> >
> > Isn't this basically identical to what was being passed in to .ioctl()?
>
> Not in every case, unless someone's been through and created fake
> structures in all the remaining places that pass in a NULL 'file' because
> there isn't one available.

>From 2.6.23's fs/ioctl.c - do_ioctl():

        if (filp->f_op->unlocked_ioctl) {
                error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
                if (error == -ENOIOCTLCMD)
                        error = -EINVAL;
                goto out;
        } else if (filp->f_op->ioctl) {
                lock_kernel();
                error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
                                          filp, cmd, arg);
                unlock_kernel();
        }

As a sidenote, please don't use f_dentry and f_vfsmnt, since they are just 
#defines for the correct fields. They were meant to be temporary transition 
helpers, but (alas) have refused to die thus far. If noone beats me to it, 
I'll take a look-see at deprecating them all the way.

-- Vadim Lobanov
