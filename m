Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZEFUBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZEFUBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZEFUBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:01:39 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:56431 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbZEFUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:01:38 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force writes
Date: Wed, 6 May 2009 22:01:42 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905061447500.4430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905062201.42965.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Mai 2009 21:24:56 schrieb Alan Stern:
> On Wed, 6 May 2009, Oliver Neukum wrote:

> A little thought yielded the following algorithm.  It assumes there is
> a fixed set of URBs allocated, unlike what you have done.  Does it make

No, it does not ;-) Your approach is more general than you think.
The only important constraint is that the number of URBs in flight
be limited. It doesn't matter when they are allocated.

> sense to take this approach?

Yes.

> Let N be the total number of URBs allocated, each capable of holding up
> to B bytes.  Let NIF be the number of URBs in flight at any time, so
> the number of available URBs is N - NIF.  The number of available bytes
> might be < (N - NIF)*B because the next URB might be partially full.
>
> P is an adjustable parameter of the algorithm.  For simplicity you can
> take P = 1, but increasing P (any value below N is okay) would yield
> reduced latency at the cost of more partially-filled URB submissions
> (so possibly reduced throughput).
>
>     Write routine:
> 	Copy bytes into the available URB buffers, submitting URBs as
> 	they get filled.  At the end, if the next URB is partially full
> 	then submit it only if NIF < P.

I did so. In principle. I am leaving the iteration to the tty layer.

>     Completion routine:
> 	If the next URB to send is partially filled, submit it.

Much easier if P = N - 1

>     write_room routine:
> 	Return the actual number of bytes remaining in the available
> 	URBs, but no more than (N-P)*B.

Yes.

> How does that sound?  Converting \n to \r\n will add some complication
> but not too much.
>
> Allocating URBs on the fly adds a lot of complication.  There has to be
> a minimum number of pre-allocated URBs; otherwise write_room could

Why? You can always calculate with the number of URBs you'd
allocate as a maximum.

> never return a positive value.  If you allocate additional URBs
> later on, when would you free them?

Like you free all URBs, on completion.

	Regards
		Oliver

