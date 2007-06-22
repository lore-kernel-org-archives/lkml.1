Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbXFVRuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbXFVRuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXFVRuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:50:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:9745 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbXFVRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U6JYdBnRhoAv65a+LEC3ThUcKYA1W2r3Y1MlkOvm4E60eYwCA9KfTwpYQWXvEnHXfuWMIQcPNCl83ZqwOGogzvif3HJojPicDffNdfIx9ASp+OA87Ucbw0LLuHxCnWSTXi/2S+BlLiNr+3N7uEuw+GKpFh2w8bTWDdmI2nFijBs=
Message-ID: <a781481a0706221050y6c7adba6l27d11e35db69fc31@mail.gmail.com>
Date: Fri, 22 Jun 2007 23:20:04 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Florin Iucha" <florin@iucha.net>
Subject: Re: "upping" a semaphore from interrupt context?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070622173839.GB8398@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622173839.GB8398@iucha.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florin,

On 6/22/07, Florin Iucha <florin@iucha.net> wrote:
> Hello,
>
> I am writing a USB driver for some custom hardware, and I need to
> synchronize between the user-space and the USB subsystem.  Can I
> create a semaphore and "down" it in the reader then "up" it in the
> completion handler?

It's not exactly clear from your description what you are
"synchronizing" exactly ... if there is some shared data you want
accessed from process as well as interrupt context, the (only) safe
primitives to use are spin_lock_irqsave / spin_unlock_irqrestore.

If you simply want the process context task to block _till_ it receives
some kind of notification that some other job has been completed
(seems to be from interrupt context in your case from your
description) than I suspect "struct completion" and associated
primitives are what you are looking for.

> I know the completion handler runs in interrupt context so you are not
> allowed to acquire any semaphores: but can you release them?  Will the
> waiting tasks wake up after the handler and its caller returned - IOW
> will the waking up task run in interrupt context as well?

The waiting task (say if it was blocked at wait_for_completion) would
continue to execute in the same context it was from that point onwards.

> This is with Linux 2.4 (if it makes a difference).

Whoa, it does, I would expect. I'm not sure completion handlers
exist in 2.4? If they do, they're the way to go. If not, sorry, I'm not
well versed with the 2.4 kernel at all.

Satyam
