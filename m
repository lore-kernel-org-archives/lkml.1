Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbZKBWiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbZKBWiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbZKBWiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:38:21 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48028 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174AbZKBWiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:38:20 -0500
Date: Mon, 2 Nov 2009 16:38:18 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andrea@cpushare.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: pidns memory leak
Message-ID: <20091102223818.GA15628@us.ibm.com>
References: <20091006040526.GA22923@us.ibm.com> <4ACAFD6A.3060008@fr.ibm.com> <20091008030828.GA18973@us.ibm.com> <4ACD9ECC.90508@fr.ibm.com> <20091009032928.GA2031@us.ibm.com> <4ACF381F.9050808@fr.ibm.com> <20091010013235.GA11904@us.ibm.com> <4AD2EBC7.2020109@fr.ibm.com> <20091014061533.GA23569@us.ibm.com> <20091102133326.e3dc51fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102133326.e3dc51fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Tue, 13 Oct 2009 23:15:33 -0700
> Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:
> 
> > Daniel Lezcano [dlezcano@fr.ibm.com] wrote:
> > > Sukadev Bhattiprolu wrote:
> > >> Ccing  Andrea's new email id:
> > >>
> > >> Daniel Lezcano [dlezcano@fr.ibm.com] wrote:
> > >>   
> > >>> Following your explanation I was able to reproduce a simple program   
> > >>> added in attachment. But there is something I do not understand is 
> > >>> why  the leak does not appear if I do the 'lstat' (cf. test program) 
> > >>> in the  pid 2 context.
> > >>>     
> > >>
> > >> Hmm, are you sure there is no leak with this test program ? If I put back
> > >> the commit (7766755a2f249e7), I do see a leak in all three data structures
> > >> (pid_2, proc_inode, pid_namespace).
> > >>   
> > >
> > > Let me clarify :)
> > >
> > > The program leaks with the commit 7766755a2f249e7 and does not leak  
> > > without this commit.
> > > This is the expected behaviour and this simple program spots the problem.
> > >
> > > I tried to modify the program and I moved the lstat to the process 2 in  
> > > the child namespace. Conforming your analysis, I was expecting to see a  
> > > leak too, but this one didn't occur. I was wondering why, maybe there is  
> > > something I didn't understood in the analysis.
> > 
> > Hmm, There are two separate dentries associated with the processes.
> > One in each mount of /proc. The proc dentries in the child container
> > are freed when the child container unmounts its /proc so you don't see
> > the leak when the lstat() is inside the container.
> > 
> > When the lstat() is in the root container, it is accessing proc-dentries
> > from the _root container_ - They are supposed to  be flushed when the task
> > exits (but the above commit prevents that flush). They should be freed
> > when the /proc in root container is unmounted - and leak until then ?
> > 
> 
> This bug hasn't been fixed yet, has it?

Well Suka did trace the bug to commit 7766755a2f249e7, and posted a patch
to revert that, acked by Eric on Oct 20.  Suka, were you going to repost
that patch?

-serge
