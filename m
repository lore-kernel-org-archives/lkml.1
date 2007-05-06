Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbXEFQjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbXEFQjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXEFQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:39:51 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:22916 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXEFQju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FF564Djeqv0xScmZNrAYDAwwC32ifi4GlbyXJws3fVcHhjDARaaWNVi4DpKr77/u20Ax2XpLTSYKVpzIL9RENrQLFgEMnFPjNtuwS1Y+iU3DKKxILYvKkcQF1r+yJIjwJ5AAnmJrXH+N0V5jMuO/KR6ob2W6qXUOnS4fJ57PkGE=
Message-ID: <5486cca80705060939v7ae1c9e2x9eeeb68c02956a33@mail.gmail.com>
Date: Sun, 6 May 2007 18:39:49 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Oliver Neukum" <oliver@neukum.org>, "Paul Fulghum" <paulkf@microgate.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070506132849.62e1e218@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178381287.3379.8.camel@x2>
	 <20070505173647.544f6707@the-village.bc.nu>
	 <200705052007.16742.oliver@neukum.org>
	 <20070505225241.54a5d01d@the-village.bc.nu>
	 <5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com>
	 <20070506132849.62e1e218@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/6, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > However, whatever policy the buffer uses, the fundamental point it's that
> > when I flush the input buffer I should be sure that each byte read
> > after the flush is *new* (current) data and not old one. This because
>
> Define "new" and "old" in this case. I don't believe you can give a
> precise definition or that such a thing is physically possible.
>

You are right. In the case of buffers storing the *last* N bytes
received we always get "new" data. To be precise if we get a byte each
T seconds
we can read data N*T seconds old (worst case). This is a bound, known,
and perfectly acceptable jitter.

Let see instead the case a not flushable buffer in the chain (inside
the PC) uses the policy of storing the *first* N bytes received. That
is the case for the flip buffer in mainline. In this case we can read
bytes also one hour old, if we read the first byte one hour after the
external device begun to send data. This is an unbound, unknown and
thus unacceptable error in a measurement (think if we were acquiring a
physical "realtime" sampled quantity). That was exactly my original
problem causing data corruption in case of multi-byte data. Paul
Fulghum patches fix this problem for serial port and for the cdc-acm
driver making the "secondary buffers" flushable.

So, in general, all the buffers (in the host) that store the first
received N bytes (as policy) should be flushable in order to don't
read (potentially very) "old" data after we made a flush.

I understand that some internal HW buffer can be not flushable via
software, but in this case I doubt the buffer use the
store-the-first-N-bytes policy.
And even if some particular device does this, than it's *its* fault, not linux.

To conclude, the store the *last* N bytes received seems a more
reasonable policy for the input buffers managed by the kernel. If the
other policy is used (as tty does), then the kernel should flush all
the buffers he *can* physically flush, remaining inside the host
computer of course.

Hope my English is sufficiently clear.


Regards,

  ~ Antonio
