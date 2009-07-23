Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZGWV0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZGWV0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZGWV0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:26:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105AbZGWV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:26:42 -0400
Date: Thu, 23 Jul 2009 14:26:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DAC960: Fix undefined behavior on empty string
Message-Id: <20090723142603.4ba09c5a.akpm@linux-foundation.org>
In-Reply-To: <200907191505.47243.mb@bu3sch.de>
References: <200907191505.47243.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jul 2009 15:05:47 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This patch fixes undefined behavior due to buffer underrun,
> if an empty string is written to the proc file.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Cc: stable@kernel.org
> 
> ---
> 
> This patch is untested, because I do not have the hardware.
> 
> ---
>  drivers/block/DAC960.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/drivers/block/DAC960.c
> +++ linux-2.6/drivers/block/DAC960.c
> @@ -6555,21 +6555,21 @@ static int DAC960_ProcWriteUserCommand(s
>  				       const char __user *Buffer,
>  				       unsigned long Count, void *Data)
>  {
>    DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
>    unsigned char CommandBuffer[80];
>    int Length;
>    if (Count > sizeof(CommandBuffer)-1) return -EINVAL;
>    if (copy_from_user(CommandBuffer, Buffer, Count)) return -EFAULT;
>    CommandBuffer[Count] = '\0';
>    Length = strlen(CommandBuffer);
> -  if (CommandBuffer[Length-1] == '\n')
> +  if (Length > 0 && CommandBuffer[Length-1] == '\n')
>      CommandBuffer[--Length] = '\0';
>    if (Controller->FirmwareType == DAC960_V1_Controller)
>      return (DAC960_V1_ExecuteUserCommand(Controller, CommandBuffer)
>  	    ? Count : -EBUSY);
>    else
>      return (DAC960_V2_ExecuteUserCommand(Controller, CommandBuffer)
>  	    ? Count : -EBUSY);
>  }

I suspect this is NotABug, as it requires that
DAC960_ProcWriteUserCommand() be called in response to a zero-length
write, and various bits of code will terminate early if they see such a
write go past.  But we shouldn't rely on that here.

Surely we have a library function somewhere which will remove any
terminating whitespace from a C string?  Sigh.

I note that you cc'ed stable@kernel.org on this patch.  Why was that? 
I assume that this pseudo-file is root-only, in which case the fix
isn't particularly urgent?

Thanks.
