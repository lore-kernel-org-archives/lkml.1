Return-Path: <linux-kernel-owner+w=401wt.eu-S1765240AbYBVTOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765240AbYBVTOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbYBVTOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:14:34 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3642 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbYBVTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:14:32 -0500
Subject: Re: [PATCH 1/2] char: hide sparse expensive pointer subtraction
	warning in specialix.c
From: Joe Perches <joe@perches.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203705247.5962.17.camel@brick>
References: <1203705247.5962.17.camel@brick>
Content-Type: text/plain; charset=utf-8
Date: Fri, 22 Feb 2008 11:13:30 -0800
Message-Id: <1203707610.19319.73.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 10:34 -0800, Harvey Harrison wrote:
> Andrew, take it or leave it, I just did this to make it easier to look at the other
> sparse issues....but without this sparse produces > 100 of these warnings for this
> file.
> 
>  drivers/char/specialix.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
> index c0e08c7..5487f37 100644
> --- a/drivers/char/specialix.c
> +++ b/drivers/char/specialix.c
> @@ -228,21 +228,21 @@ static inline int sx_paranoia_check(struct specialix_port const * port,
>  /* Get board number from pointer */
>  static inline int board_No (struct specialix_board * bp)
>  {
> -	return bp - sx_board;
> +	return ((char *)bp - (char *)sx_board) * sizeof(*bp);
>  }

You've casted addresses to char then multiplied.
You need to divide.

Maybe it'd be better to change your sparse settings to
not print this warning rather than change normally
readable code to avoid the warning.

I like the control name "ptr-subtraction-blows".

$ make C=1 CHECKFLAGS="-Wno-ptr-subtraction-blows" drivers/char/specialix.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   drivers/char/specialix.c
drivers/char/specialix.c:2112:3: warning: context imbalance in 'sx_throttle' - unexpected unlock
  CC      drivers/char/specialix.o
drivers/char/specialix.c:2488: warning: ‘specialx_pci_tbl’ defined but not used


