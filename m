Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZI3JFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZI3JFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZI3JFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:05:42 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:45527 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3JFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TR6VZVMt+9K7RK5eSeh8IKbvprnZwoeUxUV6Ux0zTNlDPfCh0xngaoBwlFkNsHNM26
         fUI4H9HvNxtktt+GuNN6qA1B+NGYbmWto/qgjAdBfLosArWbNoFNJpEqpE7NpCwJaLqL
         K3fRGcY+vN+4TGLNVo7lOUiFI7h6aQTCRu+kU=
Date: Wed, 30 Sep 2009 11:05:41 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20090930090541.GA13263@localhost>
References: <20090924154023.GA27480@localhost>
 <200909242103.48562.oliver@neukum.org>
 <20090924202107.4730f2af@lxorguk.ukuu.org.uk>
 <20090924211459.GB27963@localhost>
 <4ABD020B.4040901@gandalf.sssup.it>
 <20090929145514.GF2152@localhost>
 <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 11:52:32PM +0100, Alan Cox wrote:
> > As it stands today ftdi_sio does indeed call tty_flip_buffer_push from
> > interrupt context with low_latency set and that is obviously incorrect,
> > right?
> 
> It seems to do it from a work queue - or did I miss a case ?

The function used for deferred work is actually called directly from
ftdi_read_bulk_callback: 

  ftdi_process_read(&priv->rx_work.work);

It only gets scheduled on the work queue when unthrottled (or if
tty_buffer_request_room(tty, length) < length before serial_throttle is
called).

So basically, unless throttled, it is always called from interrupt
context.

/Johan

