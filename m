Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZLUWcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZLUWcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZLUWcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:32:46 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:46038 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbZLUWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:32:46 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200912212232.nBLMWe5r016214@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: driver [un]registration fixes
To: dmitry.torokhov@gmail.com (Dmitry Torokhov)
Date: Tue, 22 Dec 2009 09:02:40 +1030 (CST)
Cc: bzolnier@gmail.com (Bartlomiej Zolnierkiewicz),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200912211003.22227.dmitry.torokhov@gmail.com> from "Dmitry Torokhov" at Dec 21, 2009 10:03:21 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

> On Wed, Jul 29, 2009 at 10:15:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > @@ -722,22 +722,22 @@ static int acpi_fujitsu_add(struct acpi_
> >  
> >  	return result;
> >  
> > -end:
> > +err_unregister_input_dev:
> > +	input_unregister_device(input);
> >  err_free_input_dev:
> >  	input_free_device(input);
> >  err_stop:
> 
> Just noticed it scanning ACPI list. You must not use input_free_device()
> after calling input_unregister_device() since unregister likely drops the
> last reference to the device and it will get freed by input core.

So what's the correct way to deal with that in this case?  Something like

-end:
+err_unregister_input_dev:
+	input_unregister_device(input);
+	goto err_stop;
 err_free_input_dev:
 	input_free_device(input);
 err_stop:

(with a short comment to explain the goto) would circumvent the problem but
it looks ugly (at least to my eyes - I've never really liked "goto"s :-) ).

> For polled input devices you need to use both unregister and free though
> because polled device structure is not refcounted (but underlying input
> device is).

This isn't a polled input device AFAIK so this doesn't apply here, right?

Regards
  jonathan
