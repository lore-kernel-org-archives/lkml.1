Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbYI3SLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbYI3SLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYI3SK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:10:59 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56879 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYI3SK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:10:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MJn3r++sHRtR9S0k9MSwQlFC3we+QproDKrZQE90+/fSG+iRGnfCrtC+F+wG480aBD
         mpRCnFCQ6y8VxUGASjh+qU7ywl35dmNeQ9Yoi2GWwi8F4DxyH6KpmffbhJJZgcIxhkdN
         48M3GlAj8uKnaFRCn1aaGwfpPUn6G+/rwVh1Y=
Message-ID: <806dafc20809301110h2817e9e8g42ba031220763e9d@mail.gmail.com>
Date: Tue, 30 Sep 2008 14:10:56 -0400
From: "Monty Montgomery" <monty@xiph.org>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
	 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
	 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
	 <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
	 <806dafc20809300551i7678660aq5e4fd6e8080382a0@mail.gmail.com>
	 <Pine.LNX.4.64.0809301648490.5818@vixen.sonytel.be>
	 <806dafc20809300807h6d38bbeex2f2b4e496b0d155c@mail.gmail.com>
	 <Pine.LNX.4.64.0809301719000.5818@vixen.sonytel.be>
X-Google-Sender-Auth: 66dc0085ca37a08c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It happens on anything after 2.6.24 (cfr.
> http://bugzilla.kernel.org/show_bug.cgi?id=10974).
> E.g. mainline 2.6.27-rc8.

Ah.

Geert, I'm sorry this has come up and thanks for bringing it to my attention.

I'm relying on 15 year old behavior.  It has always been the case that
the packet pass-through interfaces treat O_NONBLOCK as 'don't wait for
commands' (ie, classic async communication or, in the case of SGIO,
don't block on mandatory locks) not 'change how you mediate the
communication'.  The whole point of the passthrough interface is
'please don't fuck with the packet stream.  My userspace application
knows better than the kernel in this case'.  If the kernel has
suddenly changed that, it is responsible for the loss of
functionality, not cdparanoia.

It is also the case that the kernel randomly interspersing its own
packets, commands and setup would be yanking setup state out from
under cdparanoia.  What am I supposed to do if I set density and
completely change the data mode of a cdrom drive (persistent across
disc changes), or change the block descriptor caching extents, only to
have the kernel decide to change them back without warning? If you
eject media with one of these new kernels, do I still get any
meaningful sense state, or is the sense key and all subsequent
commands merely intercepted and refused?  What happens on a timeout?
A media error?  A bus reset?  Does any 'CHECK CONDITION' status
completely yank the rug out from under the passthrough?

The kernel must not interfere with the pass-through or cdparanoia is
castrated. Or... I'm back to the era of enacting workarounds based on
kernel dot-version.  Regardless, this is a change to a longstanding
behavior.  Is it on purpose, unintentional or 'intentional but without
realizing it was actually important'?  Would be interesting to know.

> In this case, sg means scatter/gather, and it's a purely internal
> interface.  It does not start/stop the drive, nor the scsi interface.

Ah, I confused it with a much older utility that would up/down an SG
device entirely.

Monty
