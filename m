Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232Ab0CAFEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:04:45 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62440 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0CAFEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:04:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i21EetAY9V5PeHQDw3m70U1ncTd3pTVXc61QV5T5GGxuOQG80nt2kkSzoQHGBNlA5b
         IxwDjOm+4LppbS0zrAhJ9FaUxjFX/ui5iSQxTVi64YaDz+4+wfQCpBbjUYUy6aB0bND8
         UTjyeCHcuLfkA2HI3u6WZvsHJE5H9AbrzfE+k=
Date: Sun, 28 Feb 2010 21:04:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net,
       Henrik Rydberg <rydberg@euromail.se>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
Message-ID: <20100301050437.GE765@core.coreip.homeip.net>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
 <1267132893-23624-24-git-send-email-jason.wessel@windriver.com>
 <20100226080329.GD17062@core.coreip.homeip.net>
 <4B87F17B.6040305@windriver.com>
 <20100227075528.GA793@core.coreip.homeip.net>
 <4B8B3B08.7000705@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8B3B08.7000705@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 09:56:56PM -0600, Jason Wessel wrote:
> Dmitry Torokhov wrote:
> > The problem with your patch is that you end up using input_pass_event()
> > which only passes events to handler, but it does not reset device state.
> > This will cause loss of the first press of the same button after
> > returning from kdb. input_inject_event() should do what you need. You
> > just need to do it from a tasklet or, better yet (there is no
> > performance issue) schedule a work on keventd so you don't deadlock
> > on the event lock. It will also do all necessary locking, which is
> > something you seem to be ignoring.
> >
> > ...
> >
> >   
> 
> For now I am just going to drop this patch from the series, and I think
> we should pick up the continuation of the discussion on the
> linux-input.  The lack of this patch simply means keys can stuck down
> sometimes if you go in and out of the kernel debug shell when running
> X.   People were able to live with this a long time in the original kdb
> v4.4, so they can live with it a while longer while a solution is hashed
> out to "unstick the keys".
> 
> This will allow me to re-issue a pull request which has no patches which
> are in the discussion state.
> 

OK.

> It is not obvious to me how walk through the input device list with the
> right locks and then obtain the handle required to call the inject
> input.  It does not appear that it is possible to hold the locks while
> walking through the keycode device bitmap and issue calls to inject
> input. Is there any kind of input API function to obtain the device bitmaps?
> 

There is key_down bitmap right there in keyboard.c that reflects all
keys that are considered "down" as far as keyboard driver is concerned.
You can use input_handler_for_each_handle() for kbd_handler to iterate
through all input handles and send "up" events for all keys that
keyboard.c is considering as being "down". There is no harm in sending
extra "up" events for keys that are not pressed - the event will simply
be ignored by input core.

Hope this helps.

-- 
Dmitry
