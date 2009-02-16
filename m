Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZBPOXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZBPOXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 09:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZBPOXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 09:23:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZBPOXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:23:34 -0500
Subject: Re: RT scheduling and a way to make a process hang, unkillable
From: Peter Zijlstra <peterz@infradead.org>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Corey Hickey <bugfood-ml@fatooh.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
In-Reply-To: <1234790371.30178.8.camel@laptop>
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop>
	 <20090216103636.GC17355@linux.vnet.ibm.com>
	 <1234782516.4703.15.camel@laptop>
	 <20090216120213.GB3925@linux.vnet.ibm.com>
	 <1234787082.30178.3.camel@laptop>
	 <20090216131440.GC3925@linux.vnet.ibm.com>
	 <1234790371.30178.8.camel@laptop>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 15:23:24 +0100
Message-Id: <1234794204.30178.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 14:19 +0100, Peter Zijlstra wrote:
> On Mon, 2009-02-16 at 18:44 +0530, Dhaval Giani wrote:
> >  (This is not a good day!)
> 
> Monday strikes again ;-)
> 
> > @@ -572,6 +572,9 @@ static int set_user(struct cred *new)
> >  	if (!new_user)
> >  		return -EAGAIN;
> 
> So here we just allocated new_user and made sure we didn't fail that
> allocation.
> 
> > +	if (!task_can_switch_user(new->uid, current))
> > +		return -EAGAIN;
> 
> And here you bail, without freeing new_user. The idea was to do this
> check before alloc_uid().
> 
> >  	if (atomic_read(&new_user->processes) >=
> >  				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
> >  			new_user != INIT_USER) {

Ah, I now see I send you down a hole here,.. your find_user() in
task_can_switch_user() relies on that alloc_uid(). So you have to do it
after, and just free the new_user thingy when the test fails.

