Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYICE0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYICE0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 00:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYICE0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 00:26:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51315 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYICE0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 00:26:40 -0400
Date: Tue, 2 Sep 2008 22:25:43 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080903042539.GB2772@parisc-linux.org>
References: <20080829140224.GC1968@parisc-linux.org> <20080829143017.GB18086@kroah.com> <20080829144354.GD1968@parisc-linux.org> <20080829145407.GB18423@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829145407.GB18423@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 07:54:07AM -0700, Greg KH wrote:
> Fair enough, patches welcome :)

Here's a document for discussion.  No code yet, though I'm quite willing
to modify the current usbip code to follow this new protocol.  Just a
matter of time.

http://www.kernel.org/pub/linux/kernel/people/willy/usbip/usbip-protocol-draft-1

To save some time for reviewers, here's a list of decisions I took while
working on the document.  I appreciate that some of the decisions I made
were not necessarily those another designer might have made, so I ask
that any comments along the lines of "I would have done it differently"
include a really good reason.

----

I've merged the two protocols.  It is no longer the case that the protocol
completely changes when userspace drops the connection into the kernel.
It's still possible to do a hybrid implementation where userspace
implements version, list and claim and kernelspace handles release,
submit and unlink.

During development of my own implementation, I noticed the client and
server get confused about where the packets were in the TCP stream.
No more; if using a stream protocol, we wrap each packet in a 'RM'.

I considered using the whole of sunrpc.  The encoding is quite
heavyweight and I felt I could do better by specialising the protocol to
USB's purposes.

'get version' is now a call rather than including a version field in
every request.

Devices are now referred to as an ascii string rather than an encoded
4-byte quantity.  This helps userspace configure the device and lets us
interoperate with other OSes that might want to implement this protocol.

Instead of transmitting the device number in every command, we now bind
each socket to a particular device.  This was already what happened,
so it was just overhead.

I've split 'cmd_submit' into four commands (control, data, isoc, irq).
That gives us the ability to make 'data' very small.

There's no need to respond with the call number to each call -- the
caller should be using the call identifier to find out what type of
call it was.  Often the implementation will issue a command and then
wait for the response, so even that is unnecessary.

Replying with the status is vital.

I decided to make the 'call' value 32-bit (instead of 8-bit) to make
everything align nicely.  Then I wanted to slim down the data command
call, so I tucked the endpoint and direction in there too.

I have no experience with isosynchronous transactions, nor interrupt
transactions, so I decline to define them at this moment.

I've given up on the big/little endian thing.  Network protocols are
traditionally BE, USB is LE and it can encapsulate SCSI which is BE again.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
