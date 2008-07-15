Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYGOXpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYGOXpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYGOXpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:45:13 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:42807 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYGOXpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:45:11 -0400
Subject: Re: [PATCH 2/7] dynamic debug v2 - nfs conversion
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
In-Reply-To: <20080715162441.4aa011e0.akpm@linux-foundation.org>
References: <20080715213241.GC23331@redhat.com>
	 <1216161003.7981.73.camel@localhost>
	 <20080715154323.b7d5f14d.akpm@linux-foundation.org>
	 <1216162567.7981.82.camel@localhost> <1216163745.7981.90.camel@localhost>
	 <20080715162441.4aa011e0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 19:44:52 -0400
Message-Id: <1216165492.7981.105.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: CC61FEBC9AACEBE2391D81AECBC6FEB19C489972
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 101 total 9205562 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 16:24 -0700, Andrew Morton wrote:
> On Tue, 15 Jul 2008 19:15:45 -0400
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > On Tue, 2008-07-15 at 18:56 -0400, Trond Myklebust wrote:
> > 
> > > The point is that he is changing a semi-official interface for tracing
> > > the NFS kernel activity from userspace. I'd like to know why and how it
> > > is being modified before I can ack it.
> > > 
> > > In addition there are several other developers who have a daily interest
> > > in using this interface when helping our users, and who might have
> > > comments.
> > 
> > OK. Having looked up the missing patch on gmane, I'd like to know
> > whether or not there is a followup plan to fix up utilities like
> > 'rpcdebug'? Apparently this patch doesn't remove the existing sunrpc
> > sysctl interface, but does circumvent it. The result is that while
> > rpcdebug will happily continue to run, it just won't work any more...
> > 
> 
> I'm suspecting that Jason chose the wrong starter subsystem here ;)
> Probably we should have started with the many hundreds of simpler
> cases.
> 
> OTOH, it's important that Jason understand NFS's requirements here. 
> Treat it as a testcase for his design.  Will his infrastructure be
> usable by NFS?  If not, does his infrastructure need generalising and
> strengthening so that it _does_ suit?

Since rpcdebug + the sysctl interface are well established interfaces
that are probably scripted all over the place by administrators who are
using it to as a debugging tool, I'd say that any interface breakages
need a managed transition period.

IOW: I'd say that any changes are going to need a transition period
where a compatibility mode can be compiled in and where both interfaces
work. It doesn't have to be too sophisticated, perhaps just something
along the lines of

+#  define ifdebug(fac)          if (dynamic_dbg_enabled(TYPE_FLAG,   \
+                                                       RPCDBG_##fac,\
+                                                       rpc_debug) || \
+					unlikely(rpc_debug & RPCDBG_##fac))
+# define dfprintk(fac, args...) do { ifdebug(fac) printk(args); } while(0)

So that scripts can choose either interface, and still continue to operate.
Please also note the 'special' command

	echo "n" >/proc/sys/sunrpc/rpc_debug

(where "n" is an integer) which always triggers a listing of the
currently executing rpc calls (see net/sunrpc/sysctl.c:proc_dodebug())
in addition to enabling/disabling debugging.


