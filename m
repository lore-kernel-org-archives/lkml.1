Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZELDnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZELDnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 23:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZELDnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 23:43:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58369 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZELDnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 23:43:07 -0400
Subject: Re: [PATCH 03/11] block: add rq->resid_len
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com,
       axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com,
       mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       dgilbert@interlog.com, djwong@us.ibm.com
In-Reply-To: <4A08C094.2060602@kernel.org>
References: <1241423927-11871-4-git-send-email-tj@kernel.org>
	 <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org>
	 <20090511145024B.fujita.tomonori@lab.ntt.co.jp>
	 <1242051500.3338.9.camel@mulgrave.int.hansenpartnership.com>
	 <4A08C094.2060602@kernel.org>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:43:03 -0500
Message-Id: <1242099783.19949.8.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 09:19 +0900, Tejun Heo wrote:
> Hello, all.
> 
> James Bottomley wrote:
> >>> Does resid_len make any sense w/ failed requests?  I think we would be
> >>> better off with declaring residual count to be undefined on request
> >>> failure.  Is there any place which depends on it?
> >> IIRC, I wrote the code. I think that this doesn't matter but it's
> >> better not to change the behavior unless Eric ack on this change
> >> (maybe LSI has some management binary that assume this behavior though
> >> it's unlikely).
> > 
> > Actually, yes it does, for many possible reasons.
> > 
> > The first being if the device is too stupid to report an actual sector
> > location the next best way of determining where the error occurred is
> > from the residual.  We don't make use of this in kernel (perhaps we
> > should?) but some of the user space programs for CD/DVD burning do.
> 
> Really?  Residual count on command success is used but on failure?
> That's a dangerous territory.  When a SG_IO fails, the only data the
> app should be accessing is the sense data if the status indicates its
> validity.  The problems with residual count on failed command are...
> 
> * Not well defined.  What does it mean really?  It can't indicate
>   successful partial transfer.  If the request partially succeeded,
>   the required behavior is to successfully complete the request
>   partially with residual count and then fail the latter part when
>   issued again.  If the failure applies to the whole request but
>   location information is useful, it should be carried in the sense
>   data.

The definition is the amount of data transfer requested less the actual
that went over the wire ... that's certainly a well defined quantity;
although, one could argue about what this means in the device.
Certainly I agree that just because the data was transferred to or from
the device is no guarantee that the device did anything with it (or
transferred it accurately).

> * What about corner values?  What does 0 or full resid count on
>   failure mean?

0 means everything transferred, full residual means nothing did.

> * Different layers of failing.  In SG_IO interface, a request may fail
>   with -EIO way before it reaches block layer.  Residual count can't
>   be set to any meaningful value in these cases.  We can set it to
>   full count for these fast fail paths, but do we really wanna go
>   there?  Another problem is when a driver is missing SG_IO
>   capability.  Who's responsible for setting resid count in that case?
>   How is upper layer gonna determine a SG_IO failed because lower
>   level driver didn't support it or it genuinely failed?

Well, I prefer the concept of transfer length, which would be
initialised to zero ... however, residuals should be initialised to the
actual transfer count.

> I think it's just silly to give any meaning to resid count when the
> request fails.  It's best to leave the field unmodified or just
> declare it undefined.

It's current behaviour.  Technically that makes it part of the SG_IO
ABI ... although it could be deprecated if someone can verify there are
no current users.

James


