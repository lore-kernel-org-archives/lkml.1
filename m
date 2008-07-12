Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYGLOy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYGLOy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 10:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYGLOyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 10:54:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:26197 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYGLOyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 10:54:50 -0400
Subject: Re: [PATCH 9/12] ipv4: assign PDE->data before gluing PDE into
	/proc tree
From: "Denis V. Lunev" <den@openvz.org>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <6d291e080807112012r7ae44318oc41366b83d484b7f@mail.gmail.com>
References: <1209467538.29647.11.camel@iris.sw.ru>
	 <1209467602-20001-9-git-send-email-den@openvz.org>
	 <6d291e080807112012r7ae44318oc41366b83d484b7f@mail.gmail.com>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Sat, 12 Jul 2008 18:55:14 +0400
Message-Id: <1215874514.13944.3.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 22:12 -0500, Stoyan Gaydarov wrote:
> First off, sorry to bring such an old email back but I can seem to get
> a bad feeling when looking back over it.
> 
> On Tue, Apr 29, 2008 at 6:13 AM, Denis V. Lunev <den@openvz.org> wrote:
> > The check for PDE->data != NULL becomes useless after the replacement
> > of proc_net_fops_create with proc_create_data.
> >
> > Signed-off-by: Denis V. Lunev <den@openvz.org>
> > Cc: Alexey Dobriyan <adobriyan@openvz.org>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > ---
> >  net/ipv4/tcp_ipv4.c |   10 +++-------
> >  net/ipv4/udp.c      |    7 +++----
> >  2 files changed, 6 insertions(+), 11 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 7766151..4d97b28 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -2214,9 +2214,6 @@ static int tcp_seq_open(struct inode *inode, struct file *file)
> >        struct tcp_iter_state *s;
> >        int err;
> >
> > -       if (unlikely(afinfo == NULL))
> > -               return -EINVAL;
> I think that this check needs to stay in some form, reason below.
> > -
> >        err = seq_open_net(inode, file, &afinfo->seq_ops,
> >                          sizeof(struct tcp_iter_state));
> >        if (err < 0)
> > @@ -2241,10 +2238,9 @@ int tcp_proc_register(struct net *net, struct tcp_seq_afinfo *afinfo)
> >        afinfo->seq_ops.next            = tcp_seq_next;
> >        afinfo->seq_ops.stop            = tcp_seq_stop;
> >
> > -       p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
> > -       if (p)
> > -               p->data = afinfo;
> > -       else
> > +       p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
> 
> When you try to pass in afinfo->name (and also the seq_fops) you are
> assuming that afinfo is not null meaning in the unlikely(as shown
> above) even that it is null you get a very bad null pointer problem.
> If I am just way off do let me know because this just seams to me like
> a bad idea. This is also still present in 2.6.26-rc9.

The reason to remove the check is simple - afinfo comes in the form of
the static pointer during init time. It is impossible to face NULL
pointer the problem in the reality. It can come as the programmer
mistake, but the OOPS will be immediate and straightforward. Namely, the
kernel will not boot/work at all.

Regards,
	Den

