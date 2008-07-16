Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYGPUAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYGPUAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbYGPT74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:59:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbYGPT7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:59:55 -0400
Date: Wed, 16 Jul 2008 15:58:18 -0400
From: Jason Baron <jbaron@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       joe@perches.com, greg@kroah.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 2/7] dynamic debug v2 - nfs conversion
Message-ID: <20080716195818.GA6106@redhat.com>
References: <20080715213241.GC23331@redhat.com> <1216161003.7981.73.camel@localhost> <20080715154323.b7d5f14d.akpm@linux-foundation.org> <1216162567.7981.82.camel@localhost> <1216163745.7981.90.camel@localhost> <20080715162441.4aa011e0.akpm@linux-foundation.org> <1216165492.7981.105.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216165492.7981.105.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 07:44:52PM -0400, Trond Myklebust wrote:
> On Tue, 2008-07-15 at 16:24 -0700, Andrew Morton wrote:
> > On Tue, 15 Jul 2008 19:15:45 -0400
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > On Tue, 2008-07-15 at 18:56 -0400, Trond Myklebust wrote:
> > > 
> > > > The point is that he is changing a semi-official interface for tracing
> > > > the NFS kernel activity from userspace. I'd like to know why and how it
> > > > is being modified before I can ack it.
> > > > 
> > > > In addition there are several other developers who have a daily interest
> > > > in using this interface when helping our users, and who might have
> > > > comments.
> > > 
> > > OK. Having looked up the missing patch on gmane, I'd like to know
> > > whether or not there is a followup plan to fix up utilities like
> > > 'rpcdebug'? Apparently this patch doesn't remove the existing sunrpc
> > > sysctl interface, but does circumvent it. The result is that while
> > > rpcdebug will happily continue to run, it just won't work any more...
> > > 
> > 
> > I'm suspecting that Jason chose the wrong starter subsystem here ;)
> > Probably we should have started with the many hundreds of simpler
> > cases.
> > 
> > OTOH, it's important that Jason understand NFS's requirements here. 
> > Treat it as a testcase for his design.  Will his infrastructure be
> > usable by NFS?  If not, does his infrastructure need generalising and
> > strengthening so that it _does_ suit?
> 
> Since rpcdebug + the sysctl interface are well established interfaces
> that are probably scripted all over the place by administrators who are
> using it to as a debugging tool, I'd say that any interface breakages
> need a managed transition period.
> 
> IOW: I'd say that any changes are going to need a transition period
> where a compatibility mode can be compiled in and where both interfaces
> work. It doesn't have to be too sophisticated, perhaps just something
> along the lines of
> 
> +#  define ifdebug(fac)          if (dynamic_dbg_enabled(TYPE_FLAG,   \
> +                                                       RPCDBG_##fac,\
> +                                                       rpc_debug) || \
> +					unlikely(rpc_debug & RPCDBG_##fac))
> +# define dfprintk(fac, args...) do { ifdebug(fac) printk(args); } while(0)
> 
> So that scripts can choose either interface, and still continue to operate.
> Please also note the 'special' command
> 
> 	echo "n" >/proc/sys/sunrpc/rpc_debug
> 
> (where "n" is an integer) which always triggers a listing of the
> currently executing rpc calls (see net/sunrpc/sysctl.c:proc_dodebug())
> in addition to enabling/disabling debugging.
> 
> 

hi,

yes, i was aware of the breakage this patch introduced in the 
/proc/sys/sunrpc/* area...however, at his stage I was more interested in
feedback on the approach in the 'core' part of this patch. that is, the usage
of the hash table and bitmask to do module lookups. I didn't even feel this
was ready to be run by subsystem maintainers yet...but maybe it is...I will
try and 'cc the correct ppl going forward.

I like the above code suggestion for usage during a transition period. Perhaps,
all reads/writes to the /proc/sys/sunrpc/* files also emit a deprecation 
warning during the transition period.

I think the listing of the currently executing rpc calls, is so specific that
it continues to live on in /proc/sys/sunrpc/rpc_debug.

thanks,

-Jason

