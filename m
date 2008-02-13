Return-Path: <linux-kernel-owner+w=401wt.eu-S934356AbYBMX5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbYBMX5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764491AbYBMX5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:57:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765005AbYBMX5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:57:32 -0500
Date: Wed, 13 Feb 2008 15:57:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging
 printk, take #3
Message-Id: <20080213155701.48871761.akpm@linux-foundation.org>
In-Reply-To: <12028937731333-git-send-email-htejun@gmail.com>
References: <12028937731333-git-send-email-htejun@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 18:09:28 +0900
Tejun Heo <htejun@gmail.com> wrote:

> This is the third take of implement-printk_header-and-mprintk
> patchset.
> 
> Changes from the last take[L] are...
> 
> * Now header is printed on every line of a multiline message.  If the
>   header ends with ':' followed by spaces.  The colon is replaced with
>   space from the second line.
> 
> * s/mprintk/mprintk_flush/ and s/mprintk_add/mprintk/ as suggested.
> 
> * mprintk_init_alloc() and mprintk_free() added to ease malloc'd
>   buffer handling.  No need to specify buffer size.  Sizing is left to
>   mprintk.
> 
> This patchset aims to make printing multiline messages and assembling
> message piece-by-piece easier.
> 
> In a nutshell, printk_header() lets you do the following atomically
> (against other messages).
> 
>  code:
>   printk(KERN_INFO "ata1.00: ", "line0\nline1\nline2\n");
> 
>  output:
>   <6>ata1.00: line0
>   <6>ata1.00  line1
>   <6>ata1.00  line2

That seems sensible.

> And mprintk the following.
> 
>  code:
>   DEFINE_MPRINTK(mp, 2 * 80);
> 
>   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
>   mprintk_push(&mp, "ATA %d", 7);
>   mprintk_push(&mp, ", %u sectors\n", 1024);
>   mprintk(&mp, "everything seems dandy\n");
> 
>  output:
>   <6>ata1.00: ATA 7, 1024 sectors
>   <6>ata1.00  everything seems dandy
> 

And that looks like an awful lot of fuss.  Is it really worth doing?
