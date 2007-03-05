Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXCEVKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXCEVKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXCEVKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:10:37 -0500
Received: from ns2.suse.de ([195.135.220.15]:52519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbXCEVKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:10:35 -0500
From: Neil Brown <neilb@suse.de>
To: Olaf Kirch <olaf.kirch@oracle.com>
Date: Tue, 6 Mar 2007 08:09:12 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17900.34552.69250.247125@notabene.brown>
Cc: nfs@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 001 of 3] knfsd: Use recv_msg to get peer address for NFSD instead of code-copying
In-Reply-To: message from Olaf Kirch on Monday March 5
References: <20070302151748.5226.patches@notabene>
	<1070302042825.5760@suse.de>
	<200703051959.56914.olaf.kirch@oracle.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday March 5, olaf.kirch@oracle.com wrote:
> 
> Hi Neil,
> 
> here's another minor comment:
> 
> On Friday 02 March 2007 05:28, NeilBrown wrote:
> > +static inline void svc_udp_get_dest_address(struct svc_rqst *rqstp,
> > +					    struct cmsghdr *cmh)
> >  {
> >  	switch (rqstp->rq_sock->sk_sk->sk_family) {
> >  	case AF_INET: {
> > +		struct in_pktinfo *pki = CMSG_DATA(cmh);
> > +		rqstp->rq_daddr.addr.s_addr = pki->ipi_spec_dst.s_addr;
> >  		break;
> > +		}
> ...
> 
> The daddr that is extracted here will only ever be used to build
> another PKTINFO cmsg when sending the reply. So it would be
> much easier to just store the raw control message in the svc_rqst,
> without looking at its contents, and send it out along with the reply,
> unchanged.

Yes, sounds tempting, doesn't it?
Unfortunately it isn't that simple as I found out when the sunrpc code
in glibc did exactly that.

You see sendmsg will use the interface-number as well as the source
address from the PKTINFO structure.

Suppose my server has two interfaces (A and B) on two subnets that
both are connected to some router which is connected to a third subnet
that my client is on.  Further, suppose my server has only one default
route, out interface A.
The client chooses the IP address of interface B and sends a request.
It arrives on interface B and is processed.
If the PKTINFO received is passed unchanged to sendmsg, the pack will
be sent out interface B.  But interfacve B doesn't have a route to
that client, so the packet is dropped.

This exactly what was happening for me with mountd a few years ago.

So yes, we could just zero the interface field, but I think it is
clearer to extract that wanted data, then re-insert it.  They really
are different structures with different meanings (send verse receive)
which happen to have the same layout.

Thanks,
NeilBrown

