Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbXHETLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbXHETLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXHETLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:11:25 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:25122 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754524AbXHETLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:11:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jeV0iqxI+JCeNURftk7oP3efLotRIPMNW5VieYzJOaGlgcWI5CvMWL8gynm5pqjB4bOagbSdGjuOYlmTaAtzxl0V4DJrabHfrmKAbw4U7aEl97SbMwTTZ0M5tgo/8eHBs+TiRTjYkhveY3Sfxo8JMLY8LxFau/vqCILKKmWYtWU=  ;
X-YMail-OSG: HuPRkFEVM1ntFEbcC2K2nGm2sNv7YDn9EoSl1SeqJuSwBDrDTNC81oC6CDUfZ_bhWOP_RVhzInibybOVb5BrrbxuLdS9DgSqzUpUxPDCKqi135wKwlJEs5bAlUAh01igc77u5DNuXg--
From: David Brownell <david-b@pacbell.net>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.23-rc1: USB hard disk broken
Date: Sun, 5 Aug 2007 12:11:19 -0700
User-Agent: KMail/1.9.6
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org
References: <20070725072343.GA3483@dose.home.local> <20070805110942.GA26278@dose.home.local> <200708051746.32439.oliver@neukum.org>
In-Reply-To: <200708051746.32439.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708051211.19356.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 August 2007, Oliver Neukum wrote:
> > 
> > 2007-08-05_10:30:27.75572 kern.err:
> > 		ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterlist error 0/-121

That's rather strange since it means a *success* (urb->status 0) was
reported after a short read (scatterlist status -120, -EREMOTEIO).

The hardware should have stopped queue processing after the short
read, because of how qtd->hw_alt_next gets set up ... at least,
that's how I remember it, these many years after writing that code.

It might be that because of the issue noted below, it was wrongly
restarted by the software.


> > 2007-08-05_10:30:27.86576 kern.info: usb 1-6: reset high speed USB device using ehci_hcd and address 5
> > 2007-08-05_10:30:55.95293 kern.info: usb 1-6: USB disconnect, address 5
> > 2007-08-05_10:30:55.95300 kern.err:
> > 		ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterlist error -108/-108 

That one just means nobody updated that test to recognize that
the -ESHUTDOWN (-108) triggered after disconnect is a "clean"
failure like the ones triggered by unlinking.

However it also indicates that something changed in the unlink
code paths, since I see the *expected* code (-ECONNRESET) is no
longer being set by usbcore during unlinks ... it's not quite
clear to me what else that change will have broken.  Including
whether that might not explain how the hardware queue got wrongly
restarted after the short read above.

- Dave

 
> David, does this error say anything to you?


