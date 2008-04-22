Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbYDVNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbYDVNka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbYDVNkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:40:08 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59997 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234AbYDVNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:40:06 -0400
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20080422131020.GB7311@elte.hu>
References: <20080419085758.GA18612@elte.hu>
	 <1208611357.3280.5.camel@localhost.localdomain>
	 <20080421134925.GK9554@elte.hu>
	 <1208793440.3640.22.camel@localhost.localdomain>
	 <20080422131020.GB7311@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 08:39:59 -0500
Message-Id: <1208871600.3105.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 15:10 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > Thanks ... it looks like we may have trouble from devices that alter 
> > the unchecked isa dma flag after scsi_host_alloc.  The guilty parties 
> > appear to be gdth, eata, u14-34f, ultrastor, BusLogic and advansys.
> > 
> > The trouble is that if you alloc the host with it one way and free it 
> > with it the other, the wrong freelist is used and the ref counts are 
> > invalid.
> > 
> > Try this pseudo fix: it avoids allocating the freelist until add time 
> > (by which time they should all have fixed the flag).  It still doesn't 
> > change the fact that the host is allocated in the wrong region, but 
> > that shouldn't matter too much.
> 
> ok - do you intend to push this pseudo-fix upstream? If yes then please 
> consider it fixed as far as i'm concerned - i'll re-reply if the warning 
> resurfaces (it wasnt lethal to the bootup otherwise). Or if you've got 
> some other approach/fix then i can test that too.

It's certainly the line of least resistance.  The more correct fix would
be to haul unchecked_isa_dma out of the host and make everything use the
template, so it becomes immutable (as it should be).  However, that's a
lot of work and given that Andi's gunning for unchecked_isa_dma anyway,
probably not worth it.

So, unless I think of something better in the next few days, this is the
way I'll fix it.

James


