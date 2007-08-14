Return-Path: <linux-kernel-owner+w=401wt.eu-S1761445AbXHNNZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445AbXHNNZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbXHNNYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:24:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41586 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbXHNNYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:24:52 -0400
Date: Tue, 14 Aug 2007 18:54:54 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>, Keith Owens <kaos@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070814132454.GA8293@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com> <46C1691E.7090708@ah.jp.nec.com> <20070814083710.GA14538@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070814083710.GA14538@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 10:37:10AM +0200, Bernhard Walle wrote:
> * Takenori Nagano <t-nagano@ah.jp.nec.com> [2007-08-14 10:34]:
> > Vivek Goyal wrote:
> > > On Fri, Aug 03, 2007 at 02:05:47PM +1000, Keith Owens wrote:
> > > 
> > > 
> > > To sum up, couple of options come to mind.
> > > 
> > > - Register all the RAS tools on die notifier and panic
> > >   notifier lists with fairly high priority. Export list
> > >   of RAS tools to user space and allow users to decide the
> > >   order of execution and priority of RAS tools.
> > > 
> > > - Create a separate RAS tool notifier list (ras_tool_notifer_list).
> > >   All the RAS tools register on this list. This list gets priority
> > >   over die or panic notifier list. User decides the oder of execution
> > >   of RAS tools. 
> > > 
> > >   Here assumption is that above list will not be exported to modules.
> > >   All the RAS tools will be in kernel and they always get a priority
> > >   to inspect an event.
> > > 
> > > What do others think?
> > 
> > Very good idea. But there is a problem how to give default priority to RAS tools.
> > 
> > How about priority changeable notifier_list? User can change list order
> > dynamically if they want. Of course, we have to give highest priority to kdump
> > by default. It is very useful for users who want to use some RAS tools.
> 
> I think that was the idea of the first “-” (“export list of RAS tools
> to user space”).
> 

So for the time being I think we can put RAS tools on die notifier list
and if it runs into issues we can always think of creating a separate list.

Few things come to mind.

- Why there is a separate panic_notifier_list? Can't it be merged with
  die_chain? die_val already got one of the event type as PANIC. If there
  are no specific reasons then we should merge the two lists. Registering
  RAS tools on a single list is easier.
- Modify Kdump to register on die_chain list. 
- Modify Kdb to register on die_chain list.
- Export all the registered members of die_chain through sysfs along with
  their priorities. Priorities should be modifiable. Most likely one 
  shall have to introduce additional field in struct notifier_block. This
  field will be a string as an identifier of the user registerd. e.g
  "Kdump", "Kdb" etc.

Now user will be able to view all the die_chain users through sysfs and
be able to modify the order in which these should run by modifying their
priority. Hence all the RAS tools can co-exist.

Any thoughts?

Thanks
Vivek




> 
> Thanks,
>    Bernhard
