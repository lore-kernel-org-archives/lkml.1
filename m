Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206Ab0AEWEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0AEWEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923Ab0AEWEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:04:46 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:55534 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885Ab0AEWEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:04:45 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201001052203.o05M3rdL023913@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: driver [un]registration fixes
To: dmitry.torokhov@gmail.com (Dmitry Torokhov)
Date: Wed, 6 Jan 2010 08:33:53 +1030 (CST)
Cc: lenb@kernel.org, bzolnier@gmail.com (Bartlomiej Zolnierkiewicz),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100105191439.GB2854@core.coreip.homeip.net> from "Dmitry Torokhov" at Jan 05, 2010 11:14:39 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Tue, Jan 05, 2010 at 05:46:46PM +0100, Bartlomiej Zolnierkiewicz wrote:
> :
> > > > So what's the correct way to deal with that in this case?  Something like
> > > > 
> > > > -end:
> > > > +err_unregister_input_dev:
> > > > +	input_unregister_device(input);
> > > > +	goto err_stop;
> > > >  err_free_input_dev:
> > > >  	input_free_device(input);
> > > >  err_stop:
> > > > 
> > > > (with a short comment to explain the goto) would circumvent the problem but
> > > > it looks ugly (at least to my eyes - I've never really liked "goto"s :-) ).
> > > 
> > > Just do "input = NULL;" after calling  input_unregister_device() -
> > > input_free_device() is like kfree() and will happily ignore passed NULL 
> > > pointers.
> > > 
> > > Or rearrange the code to register device last, when everything is ready.
> > 
> > I don't see it fixed in Linus' tree or linux-next yet so here is a patch:
> > (thanks for noticing the issue and sorry for the delayed reply).

Yeah, sorry about that.  I was going to do up a patch but got caught up on
other things over the past two weeks.  It got close to the top of my TODO
list yesterday, but it seems you beat me to it. :-)  Thanks.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

Len: please apply.

Regards
  jonathan


From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] fujitsu-laptop: fix input_free_device() usage

input_free_device() must not be used after calling input_unregister_device()
since unregister likely drops the last reference to the device and it will
get freed by input core.

Fix all input_unregister_device()+input_free_device() occurences accordingly.

Noticed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
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
