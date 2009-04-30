Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZD3GqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZD3GqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZD3Gp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:45:59 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58924 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZD3Gp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=bMNR4CmNHg53BzvA8rxYfgdw3iNtQaROlAmnLalv12JkcuUs2Yfx03lM6zBrumwTrp
         3kws9ZWgeDtz0WHphMzTZV/mhrWDFn+2Jn7OncAxLE/jEZfeYBWyNFFIDaRv8wRsnq8t
         Su6QFFwceB1YBXr/l5hSwEAHSLCSGLpcZMeL4=
Date: Thu, 30 Apr 2009 08:45:49 +0200
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
Message-ID: <20090430064549.GC6725@liondog.tnic>
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
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-4-git-send-email-tj@kernel.org> <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com> <49F905EE.2020407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49F905EE.2020407@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 10:59:10AM +0900, Tejun Heo wrote:
> Hello, James.
> 
> James Bottomley wrote:
> > This looks good (although I'd like to test it first).
> 
> Yeah, this will need quite a bit of testing.
> 
> > Might it not be better to have an accessor setting resid_len?  All
> > the other patches in the series insulate users from the actual
> > members of struct request by accessors, so this is a bit the odd man
> > out.
> 
> I actually think it's better to expose resid_len in this case as the
> semantics of the field is - initialized to zero on issue, contains
> residual count on completion and whatever it contains inbetween is
> upto the low level driver.  Request position or length are different
> as they must contain well defined values throughout request processing
> and both block layer and low level driver should agree on what they
> mean.
> 
> Fancy words aside, it basically boils down to allowing llds to do
> either "rq->resid_len = blk_rq_bytes() - xferred" on completion or
> "rq->resid_len = blk_rq_bytes()" on issue and "rq->resid_len -=
> increments" while processing.

Actually, the second one sounds more natural: resid_len == data_len on
issue and decrementing while travelling through block layer and LLDD,
while resid_len == 0 in issue might get confused somewhere.

And I like it too, we've been coming up with all sorts of hacks in
ide-atapi wrt to residual completion and accounting of what got xferred
already and rq->resid_len is much more cleaner, IMHO.

/me testing...

-- 
Regards/Gruss,
    Boris.
