Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbZLUWqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbZLUWqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbZLUWqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:46:47 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:48908 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbZLUWqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:46:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=LUtQFzUoan7B4mjNXdxVVDGLm+mQCXjWWTrwsU9z6jNP8ppCPJ2m9wM883k9rXG9ZL
         3TtwEso07Yg0IfcQPfIM9jPOgN51rgm0xPW62F2IVvvIX9fg5U45x79zupaj5nmbiNqH
         z3Vn0evI9Bu6gpYhJaFixHG7/fo9mrcQVHok0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: driver [un]registration fixes
Date: Mon, 21 Dec 2009 14:46:32 -0800
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1; KDE/4.3.3; x86_64; ; )
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200912212232.nBLMWe5r016214@turbo.physics.adelaide.edu.au>
In-Reply-To: <200912212232.nBLMWe5r016214@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912211446.32380.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Monday 21 December 2009 02:32:40 pm Jonathan Woithe wrote:
> Hi Dmitry
> 
> > On Wed, Jul 29, 2009 at 10:15:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > @@ -722,22 +722,22 @@ static int acpi_fujitsu_add(struct acpi_
> > >
> > >  	return result;
> > >
> > > -end:
> > > +err_unregister_input_dev:
> > > +	input_unregister_device(input);
> > >  err_free_input_dev:
> > >  	input_free_device(input);
> > >  err_stop:
> >
> > Just noticed it scanning ACPI list. You must not use input_free_device()
> > after calling input_unregister_device() since unregister likely drops the
> > last reference to the device and it will get freed by input core.
> 
> So what's the correct way to deal with that in this case?  Something like
> 
> -end:
> +err_unregister_input_dev:
> +	input_unregister_device(input);
> +	goto err_stop;
>  err_free_input_dev:
>  	input_free_device(input);
>  err_stop:
> 
> (with a short comment to explain the goto) would circumvent the problem but
> it looks ugly (at least to my eyes - I've never really liked "goto"s :-) ).

Just do "input = NULL;" after calling  input_unregister_device() -
input_free_device() is like kfree() and will happily ignore passed NULL 
pointers.

Or rearrange the code to register device last, when everything is ready.

> 
> > For polled input devices you need to use both unregister and free though
> > because polled device structure is not refcounted (but underlying input
> > device is).
> 
> This isn't a polled input device AFAIK so this doesn't apply here, right?

Right, it was more of a general statement so I don't get bunch of patches 
removing input_free_polled_device() after calls to
input_unregister_polled_device() ;)

-- 
Dmitry
