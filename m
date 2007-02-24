Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbXBXB0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbXBXB0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 20:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXBXB0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 20:26:05 -0500
Received: from ns.suse.de ([195.135.220.2]:60485 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933312AbXBXB0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 20:26:04 -0500
Date: Sat, 24 Feb 2007 02:26:02 +0100
From: Nick Piggin <npiggin@suse.de>
To: Zach Brown <zab@zabbo.net>, David Miller <davem@davemloft.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070224012602.GB2201@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de> <5FD7605C-E132-4893-86FA-F76DDFB16389@zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD7605C-E132-4893-86FA-F76DDFB16389@zabbo.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 09:25:28AM -0800, Zach Brown wrote:
> 
> On Feb 23, 2007, at 7:37 AM, Nick Piggin wrote:
> 
> >
> >The dentry hash uses up 8MB for 1 million entries on my 4GB system  
> >is one
> >of the biggest wasters of memory for me. Because I rarely have more  
> >than one or
> >two hundred thousand dentries. And that's with several kernel trees  
> >worth of
> >entries. Most desktop and probably even many types of servers will  
> >only use a
> >fraction of that.
> >
> >So I introduce a new method for resizing hash tables with RCU, and  
> >apply
> >that to the dentry hash.
> 
> Can you compare what you've done to the design that Paul and David  
> talked about a year ago?
> 
>   http://lkml.org/lkml/2006/1/30/74

Thanks for the link, I wasn't aware of Paul's algorithm before.

I guess most variants are going to have a double pointer scheme,
so they are similar in that regard.

I think Paul's is quite complex in moving entries to the new table,
and it looks like it requires a lot of grace periods. I avoid all
that by using the seqlock.

It wasn't clear to me how Paul handled the case where an item is
present in the not_current table, but the lookup misses it when it
gets moved between the tables. It is a little tricky to follow
the find details because it is not in code or pseudo code format.


> I'd love to see a generic implementation of RCU hashing that  
> subsystems can then take advantage of.  It's long been on the fun  
> side of my todo list.  The side I never get to :/.

Yeah if this is to be used anywhere else, I think it definitely
needs to be made into a generic library if possible. Main thing
I wanted was to get something working and see what people think
about it.

Thanks,
Nick
