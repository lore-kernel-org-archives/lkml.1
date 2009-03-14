Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCNOdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCNOdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZCNOdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:33:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:49410 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZCNOde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:33:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 14 Mar 2009 07:32:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Jeff Moyer <jmoyer@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, Benjamin LaHaise <bcrl@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] fs: fput() can be called from interrupt context
In-Reply-To: <1237003328.7265.98.camel@heimdal.trondhjem.org>
Message-ID: <alpine.DEB.1.10.0903140729060.26556@makko.or.mcafeemobile.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>  <49B54143.1010607@redhat.com>  <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com>  <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com>  <49B87CFE.4000701@cosmosbay.com>
 <49B89B22.7080303@cosmosbay.com>  <20090311224712.fb8db075.akpm@linux-foundation.org>  <49B8A75E.6040409@cosmosbay.com>  <20090311233903.f036027a.akpm@linux-foundation.org>  <alpine.DEB.1.10.0903120625340.6040@makko.or.mcafeemobile.com> 
 <1236986902.7265.73.camel@heimdal.trondhjem.org>  <alpine.DEB.1.10.0903131732300.13254@makko.or.mcafeemobile.com> <1237003328.7265.98.camel@heimdal.trondhjem.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009, Trond Myklebust wrote:

> > Did I miss something? This wouldn't be (eventually) on keventd shoulders, 
> > but on aio work queue (aio_wq).
> > I guess we could do the same optimization we're already doing for ki_filp, 
> > for ki_eventfd ...
> 
> Last I checked, a call to schedule_work(&fddef->wq) would still run
> fd_defer_queue() under keventd.

Oh, you were commenting about Eric's patch-set. I thought you were talking 
about the current status (that my reply to Andrew was hinting to), and was 
wondering for a while from where fd_defer_queue() came from.



> That said, even if you were to run it under aio_wq, the argument remains
> the same: do you really want to add potentially long lasting sleeps onto
> a work queue that was designed to service fast i/o requests?

No, and if you roll back, you couldn't miss to notice that mine was a 
question about the f_count direct manipulation/optimization. We can do the 
same optimization for eventfd, although both will fall in the aio kthread 
in any case, if we're holding the last insteance of the file* (that I 
guess we can consider an unlikely case).
Dunno how worth it could be adding a new NCPU*thread(s) just to handle 
delayed fputs.


- Davide


