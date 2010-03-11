Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab0CKQ3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:29:37 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:49460 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab0CKQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:29:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YAlBJsubQde6TXy80snfirXYVDbyazteb8SbXuEBDjzl6dwyJgUpnmfxU3IHFaQcda
         7L/gxW3U1YUIGuKWsqBYdtAnVfW07/hBEl+qAz6b5kF2x1LZSMlV7xAQT5eL1hINqlcC
         evaO2xngSDNdKYCD+vgkEGQWhBjLQxl5ZwisA=
Date: Thu, 11 Mar 2010 17:29:30 +0100
From: Johan Hovold <jhovold@gmail.com>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Race condition in TTY ldisc layer in 2.6.33
Message-ID: <20100311162930.GA18217@localhost>
References: <20100311133222.GA19884@rere.qmqm.pl>
 <20100311135009.GA8801@kroah.com>
 <20100311155015.GA25607@rere.qmqm.pl>
 <20100311160653.GA30832@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100311160653.GA30832@rere.qmqm.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 05:06:53PM +0100, Michał Mirosław wrote:
> On Thu, Mar 11, 2010 at 04:50:15PM +0100, Michał Mirosław wrote:
> > On Thu, Mar 11, 2010 at 05:50:09AM -0800, Greg KH wrote:
> > > On Thu, Mar 11, 2010 at 02:32:22PM +0100, Micha? Miros?aw wrote:
> > > > Looks like there's some race contition in switching ldiscs on USB serial
> > > > ports. The following warnings trigger sometimes after killing and restarting
> > > > process that changes ldisc and waits forever. In case you want to look at
> > > > the code, there it is: http://rere.qmqm.pl/~mirq/sermmc/
> > > If you apply git commit 638b9648ab51c9c549ff5735d3de519ef6199df3 to the
> > > 2.6.33 kernel, does it solve the issue for you?
> > I'm running with the patch now. After couple cycles of starting and killing
> > the ldisc-setting process I get no warnings. I'll get back to you when/if
> > I encounter them again.
> 
> Hah. Just seconds after I sent that mail I hit this again. The stack traces
> are exactly the same (except for different starting address of
> flush_to_ldisc()).
> 
> The warnings are triggered by:
> 
> 	struct usb_serial_port *port = tty->driver_data;
> 	...
> 	/* count is managed under the mutex lock for the tty so cannot
> 	   drop to zero until after the last close completes */
> 	WARN_ON(!port->port.count);

This is a false warning that was fixed by commit
49d3380e3f1297ff7bdc700c0a7fe6c3a036b3ab.

> BTW, Couple of minutes earlier I got this message:
> 
> [  201.629616] cp210x ttyUSB0: usb_serial_generic_resubmit_read_urb - failed resubmitting read urb, error -1
> 
> But after that I disconnected and reconnected the device, so this is probably
> not relevant here.

You're right, it's unrelated. I submitted a patch a while ago that
removes this message (as it is not an error):

http://thread.gmane.org/gmane.linux.usb.general/28047/focus=28052

Regards,
Johan

