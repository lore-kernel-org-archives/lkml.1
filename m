Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170Ab0AETAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0AETAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739Ab0AETAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:00:48 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:59982 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab0AETAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=xOlNBjYfY3KC70CSZGSC8BA3WK8nmXW8ng1kKF2CP1lsLpsSylEkFwJA7eO1lx0skZ
         L5T2KaEfoiLBC+dMO5jp3we7KS81A5yX/BoP19Y9pTD1D214oXugCGtWecrRuoThDcg4
         EXlkua5sKG06Ns9AAOt4Fc1a2+TASRF7Q7kgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] fujitsu-laptop: driver [un]registration fixes
Date: Tue, 5 Jan 2010 17:46:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200912212232.nBLMWe5r016214@turbo.physics.adelaide.edu.au> <200912211446.32380.dmitry.torokhov@gmail.com>
In-Reply-To: <200912211446.32380.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Message-Id: <201001051746.46942.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 21 December 2009 11:46:32 pm Dmitry Torokhov wrote:
> Hi Jonathan,
> 
> On Monday 21 December 2009 02:32:40 pm Jonathan Woithe wrote:
> > Hi Dmitry
> > 
> > > On Wed, Jul 29, 2009 at 10:15:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > @@ -722,22 +722,22 @@ static int acpi_fujitsu_add(struct acpi_
> > > >
> > > >  	return result;
> > > >
> > > > -end:
> > > > +err_unregister_input_dev:
> > > > +	input_unregister_device(input);
> > > >  err_free_input_dev:
> > > >  	input_free_device(input);
> > > >  err_stop:
> > >
> > > Just noticed it scanning ACPI list. You must not use input_free_device()
> > > after calling input_unregister_device() since unregister likely drops the
> > > last reference to the device and it will get freed by input core.
> > 
> > So what's the correct way to deal with that in this case?  Something like
> > 
> > -end:
> > +err_unregister_input_dev:
> > +	input_unregister_device(input);
> > +	goto err_stop;
> >  err_free_input_dev:
> >  	input_free_device(input);
> >  err_stop:
> > 
> > (with a short comment to explain the goto) would circumvent the problem but
> > it looks ugly (at least to my eyes - I've never really liked "goto"s :-) ).
> 
> Just do "input = NULL;" after calling  input_unregister_device() -
> input_free_device() is like kfree() and will happily ignore passed NULL 
> pointers.
> 
> Or rearrange the code to register device last, when everything is ready.

I don't see it fixed in Linus' tree or linux-next yet so here is a patch:
(thanks for noticing the issue and sorry for the delayed reply).

[ Jonathan, please apply.  Thanks! ]

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] fujitsu-laptop: fix input_free_device() usage

input_free_device() must not be used after calling input_unregister_device()
since unregister likely drops the last reference to the device and it will
get freed by input core.

Fix all input_unregister_device()+input_free_device() occurences accordingly.

Noticed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against current Linus' tree

 drivers/platform/x86/fujitsu-laptop.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: b/drivers/platform/x86/fujitsu-laptop.c
===================================================================
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -724,6 +724,7 @@ static int acpi_fujitsu_add(struct acpi_
 
 err_unregister_input_dev:
 	input_unregister_device(input);
+	input = NULL;
 err_free_input_dev:
 	input_free_device(input);
 err_stop:
@@ -737,8 +738,6 @@ static int acpi_fujitsu_remove(struct ac
 
 	input_unregister_device(input);
 
-	input_free_device(input);
-
 	fujitsu->acpi_handle = NULL;
 
 	return 0;
@@ -929,6 +928,7 @@ static int acpi_fujitsu_hotkey_add(struc
 
 err_unregister_input_dev:
 	input_unregister_device(input);
+	input = NULL;
 err_free_input_dev:
 	input_free_device(input);
 err_free_fifo:
@@ -952,8 +952,6 @@ static int acpi_fujitsu_hotkey_remove(st
 
 	input_unregister_device(input);
 
-	input_free_device(input);
-
 	kfifo_free(&fujitsu_hotkey->fifo);
 
 	fujitsu_hotkey->acpi_handle = NULL;

