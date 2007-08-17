Return-Path: <linux-kernel-owner+w=401wt.eu-S1761894AbXHQK4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894AbXHQK4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 06:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbXHQK4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 06:56:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44346 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbXHQK4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 06:56:32 -0400
Date: Fri, 17 Aug 2007 16:26:30 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: Keith Owens <kaos@ocs.com.au>, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070817105630.GA18167@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de> <20070814132454.GA8293@in.ibm.com> <46C4184B.5030303@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C4184B.5030303@ah.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 06:26:35PM +0900, Takenori Nagano wrote:
> Vivek Goyal wrote:
>  > So for the time being I think we can put RAS tools on die notifier list
> > and if it runs into issues we can always think of creating a separate list.
> > 
> > Few things come to mind.
> > 
> > - Why there is a separate panic_notifier_list? Can't it be merged with
> >   die_chain? die_val already got one of the event type as PANIC. If there
> >   are no specific reasons then we should merge the two lists. Registering
> >   RAS tools on a single list is easier.
> 
> I think it is difficult, because die_chain is defined by each architecture.
> 

I think die_chain is arch independent definition (kernel/die_notifier.c)? 
But anyway, to begin with it can be done only for panic_notifier.

> > - Modify Kdump to register on die_chain list. 
> > - Modify Kdb to register on die_chain list.
> > - Export all the registered members of die_chain through sysfs along with
> >   their priorities. Priorities should be modifiable. Most likely one 
> >   shall have to introduce additional field in struct notifier_block. This
> >   field will be a string as an identifier of the user registerd. e.g
> >   "Kdump", "Kdb" etc.
> > 
> > Now user will be able to view all the die_chain users through sysfs and
> > be able to modify the order in which these should run by modifying their
> > priority. Hence all the RAS tools can co-exist.
> 
> This is my image of your proposal.
> 
> - Print current order
> 
> # cat /sys/class/misc/debug/panic_notifier_list
> priority   name
> 1          IPMI
> 2          watchdog
> 3          Kdb
> 4          Kdump
> 

I think Bernhard's suggestion looks better here. I noticed that 
/sys/kernel/debug is already present. So how about following.

/sys/kernel/debug/kdump/priority
/sys/kernel/debug/kdb/priority
/sys/kernel/debug/IPMI/priority

I think at some point of time we shall have to create another file say
description.

/sys/kernel/debug/IPMI/description

Which can tell what does this tool do? Other a user might not have any
clue how to prioritize various things.

Thanks
Vivek
