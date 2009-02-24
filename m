Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbZBXUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbZBXUDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZBXUDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:03:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:32230 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZBXUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KOeH6tAwnHG4Gwp36XxNQClJQB8Zl53r5N4HuCKb6LwH/EPq+WuE6XgfdvVjGFYrNv
         zSVP7U6vPcGU3Z7nQJ9OuRAg+9OxHkKq6eQnasiTtFSkZwV6L0K9xD0foWAauFP5cSa6
         g3sYJvxQxrUqYsEzZLbim/MYSA9eH3M7eXFCM=
Date: Tue, 24 Feb 2009 23:09:34 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nathan Lynch <nathanl@austin.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       mpm@selenic.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
Subject: Re: Banning checkpoint (was: Re: What can OpenVZ do?)
Message-ID: <20090224200934.GA16862@x200.localdomain>
References: <20090218003217.GB25856@elte.hu> <1234917639.4816.12.camel@nimitz> <20090218051123.GA9367@x200.localdomain> <20090218181644.GD19995@elte.hu> <1234992447.26788.12.camel@nimitz> <20090218231545.GA17524@elte.hu> <20090219190637.GA4846@x200.localdomain> <1235070714.26788.56.camel@nimitz> <20090224044752.GB3202@x200.localdomain> <1235452285.26788.226.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235452285.26788.226.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 09:11:25PM -0800, Dave Hansen wrote:
> On Tue, 2009-02-24 at 07:47 +0300, Alexey Dobriyan wrote:
> > > I think what I posted is a decent compromise.  It gets you those
> > > warnings at runtime and is a one-way trip for any given process.  But,
> > > it does detect in certain cases (fork() and unshare(FILES)) when it is
> > > safe to make the trip back to the "I'm checkpointable" state again.
> > 
> > "Checkpointable" is not even per-process property.
> > 
> > Imagine, set of SAs (struct xfrm_state) and SPDs (struct xfrm_policy).
> > They are a) per-netns, b) persistent.
> > 
> > You can hook into socketcalls to mark process as uncheckpointable,
> > but since SAs and SPDs are persistent, original process already exited.
> > You're going to walk every process with same netns as SA adder and mark
> > it as uncheckpointable. Definitely doable, but ugly, isn't it?
> > 
> > Same for iptable rules.
> > 
> > "Checkpointable" is container property, OK?
> 
> Ideally, I completely agree.
> 
> But, we don't currently have a concept of a true container in the
> kernel.  Do you have any suggestions for any current objects that we
> could use in its place for a while?

After all foo_ns changes struct nsproxy is such thing.

More specific, a process with fully cloned nsproxy acting as init,
all its children. In terms of data structures, every task_struct in such
tree, every nsproxy of them, every foo_ns, and so on to lower levels.
