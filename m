Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZD3Hht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZD3Hht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbZD3Hhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:37:31 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:35453 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759507AbZD3Hh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=nGL8zCYaPRrCHD63hBDWea4gOSwh84jb+VerbVUnlzG3FJTmieIQjN2NKuXZgchQOY
         KI2RwdIvZBHfZqPlM7Z2WsN/ibRiswkWHR1Npl6Eb015BFG+UnelQaVoc2OhapB186t1
         y7AY8CT3EXrscr9TEcWJ+0fqcuv4bT0iIm42Y=
Date: Thu, 30 Apr 2009 09:37:19 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
       jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
       dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
       davem@davemloft.net, rusty@rustcorp.com.au,
       Markus.Lidel@shadowconnect.com, bharrosh@panasas.com,
       Doug Gilbert <dgilbert@interlog.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/10] block: add rq->resid_len
Message-ID: <20090430073719.GA9640@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	bzolnier@gmail.com, petkovbb@googlemail.com,
	sshtylyov@ru.mvista.com, mike.miller@hp.com,
	chirag.kantharia@hp.com, Eric.Moore@lsi.com,
	stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
	zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
	sfr@canb.auug.org.au, grant.likely@secretlab.ca,
	paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net,
	jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com,
	dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com,
	davem@davemloft.net, rusty@rustcorp.com.au,
	Markus.Lidel@shadowconnect.com, bharrosh@panasas.com,
	Doug Gilbert <dgilbert@interlog.com>,
	"Darrick J. Wong" <djwong@us.ibm.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-4-git-send-email-tj@kernel.org> <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com> <49F905EE.2020407@kernel.org> <20090430064549.GC6725@liondog.tnic> <49F95101.3010004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49F95101.3010004@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 04:19:29PM +0900, Tejun Heo wrote:
> Borislav Petkov wrote:
> >> Fancy words aside, it basically boils down to allowing llds to do
> >> either "rq->resid_len = blk_rq_bytes() - xferred" on completion or
> >> "rq->resid_len = blk_rq_bytes()" on issue and "rq->resid_len -=
> >> increments" while processing.
> > 
> > Actually, the second one sounds more natural: resid_len == data_len on
> > issue and decrementing while travelling through block layer and LLDD,
> > while resid_len == 0 in issue might get confused somewhere.
> 
> Yeap, it depends on how the specific low level driver is doing it.
> 
> > And I like it too, we've been coming up with all sorts of hacks in
> > ide-atapi wrt to residual completion and accounting of what got xferred
> > already and rq->resid_len is much more cleaner, IMHO.
> > 
> > /me testing...
> 
> AFAICT, residual count handling in ide was most broken.

Tell me about it :).

> This patch doesn't fix anything other than making it report 0
> resid_len on SG_IO which is usually better than reporting full
> residual count. The only place inside ide where residual count is used
> in the tape driver to determine actually transferred size. That part
> works okay with the patch applied.

> Hmmm... maybe it's about time to finally clean up residual count
> handling in ide and libata, which BTW doesn't do anything about it at
> the moment.

Completely agreed. This doesn't do anything about it right now but
with rq->resid_len in place I could get rid of a bunch of pc->xferred,
cmd->nleft and similar on-stack structs we've been introducing, and use
solely an rq in the LLD. I'll get to do some experimenting tomorrow and
whip up some cleanup patches in order to see how it could look exactly.
Stay tuned.

Thanks.

-- 
Regards/Gruss,
    Boris.
