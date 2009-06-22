Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZFVRHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZFVRHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZFVRHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:07:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:37076 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZFVRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:07:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 10:01:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3FABD9.7080108@novell.com>
Message-ID: <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
 <4A3C07FF.3000406@novell.com> <alpine.DEB.1.10.0906191447330.14884@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906191525470.14884@makko.or.mcafeemobile.com> <4A3C44DA.7000503@novell.com> <alpine.DEB.1.10.0906201202170.25534@makko.or.mcafeemobile.com>
 <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com>
 <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Sun, 21 Jun 2009, Gregory Haskins wrote:
> >
> >   
> >> This looks great, Davide.  I am fairly certain I can now solve the races
> >> and even implement Michael's DEASSIGN feature with this patch in place. 
> >> I will actually fire it up tomorrow when I am back in the office and
> >> give it a spin, but I do not spy any more races via visual inspection.
> >>
> >> Kind Regards,
> >> -Greg
> >>
> >> PS: I was wrong with my previous statement about requiring an embeddable
> >> object (eventfd_notifier for me, eventfd_pollcb for you).  I think you
> >> can technically solve this issue minimally by merely locking the POLLHUP
> >> and exposing the kref.  However, I think that leads to an more awkward
> >> interface (e.g. we already have eventfd_fget() plus we add a new one
> >> like eventfd_refget(), which might confuse users), so I prefer what you
> >> did here.  Just thought I would throw that out there in case you would
> >> prefer to change even fewer lines.
> >>     
> >
> > I actually ended up exposing the eventfd context anyway, since IMO is a 
> > better option instead of holding references to the eventfd file (that 
> > makes VFS people uneasy).
> >   
> 
> I liked "version - 1"  better ;)
> 
> I think ultimately we still want to hold the fget() for
> eventfd_signal(), as it is the producer side.  Without it, we have no
> way of knowing when the last producer goes away if they happen to be an
> in-kernel user.

No you don't. Holding a file* reference does not give you any assurance 
whatsoever that the last consumer did not go away. The f_count value will 
simply be 1 (just you).
If a producer side want to take proper action when the last consumer 
leaves the building, it needs to register a pollcb hook and handle 
POLLHUP.
Exposing the opaque eventfd context, and basing the eventfd operations on 
that one (instead of the live referenced file*) is a cleaner interface.
Can you please base your IRQfd bits on top of that, so that we can give 
this IRQfd thread a closure?


- Davide


