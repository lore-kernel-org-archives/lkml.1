Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYEVTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYEVTmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYEVTmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:42:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbYEVTmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:42:09 -0400
Date: Thu, 22 May 2008 12:41:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, prussell@au1.ibm.com, shaggy@us.ibm.com,
       sergeh@us.ibm.com
Subject: Re: [PATCH] eCryptfs: Clean up kthread synchronization
Message-Id: <20080522124142.a850ab0e.akpm@linux-foundation.org>
In-Reply-To: <20080522193155.GB4057@halcrowt61p.ibm.com>
References: <20080520214610.GD32643@halcrowt61p.austin.ibm.com>
	<20080521160000.717fb1ef.akpm@linux-foundation.org>
	<20080522193155.GB4057@halcrowt61p.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 14:31:55 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> > > +void ecryptfs_destroy_kthread(void)
> > > +{
> > > +	struct ecryptfs_open_req tmp_req;
> > > +	struct ecryptfs_open_req *req;
> > > +
> > > +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> > > +	ecryptfs_kthread_ctl.flags |= ECRYPTFS_KTHREAD_ZOMBIE;
> > > +	list_for_each_entry(req, &ecryptfs_kthread_ctl.req_list,
> > > +			    kthread_ctl_list) {
> > > +		mutex_lock(&req->mux);
> > > +		req->flags |= ECRYPTFS_REQ_ZOMBIE;
> > > +		wake_up_process(req->requesting_task);
> > > +		mutex_unlock(&req->mux);
> > > +	}
> > > +	memset(&tmp_req, 0, sizeof(tmp_req));
> > > +	tmp_req.flags = ECRYPTFS_REQ_ZOMBIE;
> > > +	list_add_tail(&tmp_req.kthread_ctl_list,
> > > +		      &ecryptfs_kthread_ctl.req_list);
> > > +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> > > +	wake_up(&ecryptfs_kthread_ctl.wait);
> > > +}
> > 
> > eh?  We attach a local variable to a global list and then return?
> > That won't last very long.
> 
> Adding this dummy entry to the list is just my own way of getting the
> kthread to wake up and shut down. This actually works, albeit a little
> ugly. The list and its contents get dropped on the floor at this point
> because (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE). The
> only consumer of this list (the kthread) checks for this flag
> immediately after getting the mux, and if it is there, it just
> exits. The only producer on this list (ecryptfs_privileged_open())
> checks for this flag immediately after getting the mux and bows out if
> it is set. In other words, once this flag is set, the list and its
> contents become untouchable by anything other than
> ecryptfs_destroy_kthread().

Unconvinced.

As soon as ecryptfs_destroy_kthread() returns, tmp_req is destroyed. 
But it remains on ecryptfs_kthread_ctl.req_list.

> 	memset(&tmp_req, 0, sizeof(tmp_req));
> 	tmp_req.flags = ECRYPTFS_REQ_ZOMBIE;
> 	list_add_tail(&tmp_req.kthread_ctl_list,
> 		      &ecryptfs_kthread_ctl.req_list);
> 	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> 	wake_up(&ecryptfs_kthread_ctl.wait);

-> it's dead.

> }

