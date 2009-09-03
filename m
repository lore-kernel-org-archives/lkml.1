Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZICSRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZICSRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZICSRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:17:15 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56491 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZICSRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:17:14 -0400
Date: Thu, 3 Sep 2009 11:17:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: System freeze on reboot - general protection fault
Message-ID: <20090903181715.GI6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090811154853.GF2763@sgi.com> <c4e36d110908111410y29b922ceod6871fda2514f6e6@mail.gmail.com> <c4e36d110908121516u504809e9y537e9babfa95df1d@mail.gmail.com> <alpine.DEB.1.10.0908121820410.3257@gentwo.org> <c4e36d110908131009l78b29bffvb4d41b90f9b83288@mail.gmail.com> <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com> <4A87CE60.4020506@gmail.com> <4A896324.3040104@trash.net> <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com> <4A9EEF07.5070800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A9EEF07.5070800@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 12:17:43AM +0200, Eric Dumazet wrote:
> Zdenek Kabelac a écrit :
> > 2009/8/17 Patrick McHardy <kaber@trash.net>:
> >> Eric Dumazet wrote:
> >>> Zdenek Kabelac a écrit :
> >>>>  [<ffffffffa02c502f>] nf_conntrack_ftp_fini+0x2f/0x70 [nf_conntrack_ftp]
> >>>>  [<ffffffff8027bcc5>] sys_delete_module+0x1a5/0x270
> >>>>  [<ffffffff8020d329>] ? retint_swapgs+0xe/0x13
> >>>>  [<ffffffff80271bf2>] ? trace_hardirqs_on_caller+0x162/0x1b0
> >>>>  [<ffffffff80292121>] ? audit_syscall_entry+0x191/0x1c0
> >>>>  [<ffffffff80526dae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >>>>  [<ffffffff8020c84b>] system_call_fastpath+0x16/0x1b
> >>>> Code: c6 00 00 0f 82 66 ff ff ff 49 8b 9e d8 05 00 00 48 85 db 75 16
> >>>> e9 8e 00 00 00 0f 1f 44 00 00 48 85 c0 0f 84 80 00 00 00 48 89 c3 <0f>
> >>>> b6 4b 37 48 8b 03 48 8d 14 cd 00 00 00 00 0f 18 08 48 29 ca
> >>>> RIP  [<ffffffffa02b2c2c>] nf_conntrack_helper_unregister+0x16c/0x320
> >>>> [nf_conntrack]
> >>>>  RSP <ffff88013982fe68>
> >>>> CR2: 0000000000000038
> >>>> ---[ end trace bc3a0ede3d0084db ]---
> >>>>
> >>> I am currently traveling and wont be able to help you before next week.
> >>>
> >>> I added netdev, Patrick, and netfilter-devel in CC so that more eyes can take a look.
> >> Thanks for the report, I'll have a look at this. Zdenek, please
> >> send me the nf_conntrack.ko file used in the above oops. Thanks.
> >>
> > 
> > Ok
> > 
> > I've found the solution for my problem.
> > 
> > http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/30483
> > 
> > I've made this small fix from this thread:
> > 
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core
> > index b5869b9..68488f8 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -1108,6 +1108,7 @@ static void nf_conntrack_cleanup_init_net(void)
> >  {
> >         nf_conntrack_helper_fini();
> >         nf_conntrack_proto_fini();
> > +       rcu_barrier();
> >         kmem_cache_destroy(nf_conntrack_cachep);
> >  }
> > 
> > @@ -1266,7 +1267,7 @@ static int nf_conntrack_init_init_net(void)
> > 
> >         nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
> >                                                 sizeof(struct nf_conn),
> > -                                               0, SLAB_DESTROY_BY_RCU, NULL);
> > +                                               0, 0, NULL);
> >         if (!nf_conntrack_cachep) {
> >                 printk(KERN_ERR "Unable to create nf_conn slab cache\n");
> >                 ret = -ENOMEM;
> > 
> > 
> > As the thread nf_conntrack: Use rcu_barrier() and fix kmem_cache_create flags
> > seems to be samewhat 'unfinished'  and already a bit old and I've no
> > idea whether it actually fixes problem completely or just hides it in
> > my case - I'm leaving it to some RCU gurus to fix this issue.
> > 
> > All I could say is - this this extra rcu_barrier() and removal of
> > SLAB_DESTROY removes my GPF on reboot.
> > 
> > Zdenek
> 
> Ouch..
> 
> Dont think such a patch makes your kernel better, it'll crash too.
> 
> You cannot remove SLAB_DESTROY_BY_RCU like this, it's there for very good reasons.

And if I understand correctly, this is more evidence that
kmem_cache_destroy() needs to do an rcu_barrier() in the
SLAB_DESTROY_BY_RCU case.

							Thanx, Paul
