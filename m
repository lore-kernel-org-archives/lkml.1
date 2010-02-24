Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab0BXWRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:17:55 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53736 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841Ab0BXWRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:17:54 -0500
Date: Wed, 24 Feb 2010 14:17:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: Re: [PATCH 07/10] module: __rcu annotations
Message-ID: <20100224221749.GI6980@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100223180127.GF6700@linux.vnet.ibm.com> <1267041846-10469-8-git-send-email-arnd@arndb.de> <20100224201354.GA3399@core2> <201002242126.09994.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002242126.09994.arnd@arndb.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 09:26:09PM +0100, Arnd Bergmann wrote:
> On Wednesday 24 February 2010, Alexey Dobriyan wrote:
> > On Wed, Feb 24, 2010 at 09:04:03PM +0100, Arnd Bergmann wrote:
> > > @@ -360,10 +360,12 @@ struct module *find_module(const char *name)
> > >  {
> > >       struct module *mod;
> > >  
> > > -     list_for_each_entry(mod, &modules, list) {
> > > +     rcu_read_lock();
> > > +     list_for_each_entry_rcu(mod, &modules, list) {
> > >               if (strcmp(mod->name, name) == 0)
> > >                       return mod;
> > >       }
> > > +     rcu_read_unlock();
> > >       return NULL;
> > >  }
> > >  EXPORT_SYMBOL_GPL(find_module);
> > 
> > modules list is under module_mutex, nothing should be done here.
> 
> Ok, this is a significant limitation of the list rcu annotation
> then, it's not possible to pass the same list into list_for_each_entry
> and list_for_each_entry_rcu with the way I changed the rcu list
> definition. I would be possible to do a __list_for_each_entry_rcu
> macro that takes an rcu_list_head but does not actually use
> rcu_dereference, but I'm not sure if that's good enough.

Hmmm...  If the __rcu annotation was visible at runtime, it would be
easy provide an annotated version of list_for_each_entry_rcu() that
checks for module_mutex being held under lockdep.

							Thanx, Paul
