Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbZD3CDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbZD3CDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 22:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZD3CCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 22:02:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:55271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbZD3CCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 22:02:49 -0400
Message-ID: <49F905EE.2020407@kernel.org>
Date: Thu, 30 Apr 2009 10:59:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
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
References: <1240996428-10159-1-git-send-email-tj@kernel.org>	 <1240996428-10159-4-git-send-email-tj@kernel.org> <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 01:59:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

James Bottomley wrote:
> This looks good (although I'd like to test it first).

Yeah, this will need quite a bit of testing.

> Might it not be better to have an accessor setting resid_len?  All
> the other patches in the series insulate users from the actual
> members of struct request by accessors, so this is a bit the odd man
> out.

I actually think it's better to expose resid_len in this case as the
semantics of the field is - initialized to zero on issue, contains
residual count on completion and whatever it contains inbetween is
upto the low level driver.  Request position or length are different
as they must contain well defined values throughout request processing
and both block layer and low level driver should agree on what they
mean.

Fancy words aside, it basically boils down to allowing llds to do
either "rq->resid_len = blk_rq_bytes() - xferred" on completion or
"rq->resid_len = blk_rq_bytes()" on issue and "rq->resid_len -=
increments" while processing.

It would be better to check that the value is sane on completion tho.

Thanks.

-- 
tejun
