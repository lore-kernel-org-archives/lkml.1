Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889Ab0AETO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0AETO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498Ab0AETOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:14:55 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40798 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0AETOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HFcklGwgkQHTNkMDuPjaPCYNDNM6occZ6HeB/TcHLAQnQm9999YMG6FHdU00fB8Eul
         uvmuDI37w55a7CVEbzYV6KG2E49nhaBAWPShw0ovCEqiURwNIWOroKpCzSoS7zmBtJP5
         1Jo3O6wQ26emDw6WUqS5o2SmqlsTbPfW3WDVc=
Date: Tue, 5 Jan 2010 11:14:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fujitsu-laptop: driver [un]registration fixes
Message-ID: <20100105191439.GB2854@core.coreip.homeip.net>
References: <200912212232.nBLMWe5r016214@turbo.physics.adelaide.edu.au>
 <200912211446.32380.dmitry.torokhov@gmail.com>
 <201001051746.46942.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001051746.46942.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 05:46:46PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday 21 December 2009 11:46:32 pm Dmitry Torokhov wrote:
> > Hi Jonathan,
> > 
> > On Monday 21 December 2009 02:32:40 pm Jonathan Woithe wrote:
> > > Hi Dmitry
> > > 
> > > > On Wed, Jul 29, 2009 at 10:15:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > > @@ -722,22 +722,22 @@ static int acpi_fujitsu_add(struct acpi_
> > > > >
> > > > >  	return result;
> > > > >
> > > > > -end:
> > > > > +err_unregister_input_dev:
> > > > > +	input_unregister_device(input);
> > > > >  err_free_input_dev:
> > > > >  	input_free_device(input);
> > > > >  err_stop:
> > > >
> > > > Just noticed it scanning ACPI list. You must not use input_free_device()
> > > > after calling input_unregister_device() since unregister likely drops the
> > > > last reference to the device and it will get freed by input core.
> > > 
> > > So what's the correct way to deal with that in this case?  Something like
> > > 
> > > -end:
> > > +err_unregister_input_dev:
> > > +	input_unregister_device(input);
> > > +	goto err_stop;
> > >  err_free_input_dev:
> > >  	input_free_device(input);
> > >  err_stop:
> > > 
> > > (with a short comment to explain the goto) would circumvent the problem but
> > > it looks ugly (at least to my eyes - I've never really liked "goto"s :-) ).
> > 
> > Just do "input = NULL;" after calling  input_unregister_device() -
> > input_free_device() is like kfree() and will happily ignore passed NULL 
> > pointers.
> > 
> > Or rearrange the code to register device last, when everything is ready.
> 
> I don't see it fixed in Linus' tree or linux-next yet so here is a patch:
> (thanks for noticing the issue and sorry for the delayed reply).
> 

Yep, the patch looks good.

> [ Jonathan, please apply.  Thanks! ]
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] fujitsu-laptop: fix input_free_device() usage
> 
> input_free_device() must not be used after calling input_unregister_device()
> since unregister likely drops the last reference to the device and it will
> get freed by input core.
> 
> Fix all input_unregister_device()+input_free_device() occurences accordingly.
> 
> Noticed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> against current Linus' tree
> 
>  drivers/platform/x86/fujitsu-laptop.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> Index: b/drivers/platform/x86/fujitsu-laptop.c
> ===================================================================
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -724,6 +724,7 @@ static int acpi_fujitsu_add(struct acpi_
>  
>  err_unregister_input_dev:
>  	input_unregister_device(input);
> +	input = NULL;
>  err_free_input_dev:
>  	input_free_device(input);
>  err_stop:
> @@ -737,8 +738,6 @@ static int acpi_fujitsu_remove(struct ac
>  
>  	input_unregister_device(input);
>  
> -	input_free_device(input);
> -
>  	fujitsu->acpi_handle = NULL;
>  
>  	return 0;
> @@ -929,6 +928,7 @@ static int acpi_fujitsu_hotkey_add(struc
>  
>  err_unregister_input_dev:
>  	input_unregister_device(input);
> +	input = NULL;
>  err_free_input_dev:
>  	input_free_device(input);
>  err_free_fifo:
> @@ -952,8 +952,6 @@ static int acpi_fujitsu_hotkey_remove(st
>  
>  	input_unregister_device(input);
>  
> -	input_free_device(input);
> -
>  	kfifo_free(&fujitsu_hotkey->fifo);
>  
>  	fujitsu_hotkey->acpi_handle = NULL;
> 

-- 
Dmitry
