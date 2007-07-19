Return-Path: <linux-kernel-owner+w=401wt.eu-S935914AbXGSDzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935914AbXGSDzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbXGSDzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:55:00 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:35511 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbXGSDzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:55:00 -0400
X-IronPort-AV: i="4.16,553,1175486400"; 
   d="scan'208"; a="45903023:sNHT25575326"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Date: Wed, 18 Jul 2007 23:58:24 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Tim Bird" <tim.bird@am.sony.com>, bryan.wu@analog.com
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <200707181939.46910.rgetz@blackfin.uclinux.org> <20070718172603.231351ea.akpm@linux-foundation.org>
In-Reply-To: <20070718172603.231351ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707182358.24984.rgetz@blackfin.uclinux.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jul 2007 03:54:49.0467 (UTC) FILETIME=[8DDE4CB0:01C7C9B8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18 Jul 2007 20:26, Andrew Morton pondered:
> Robin Getz wrote:
> > [need to access _log_buf from external for early debugging code]
> > 
> > Something simple like - early_copy_log_buff(void *dest, size_t n) 
> > 
> > copies n bytes from log_buf to memory area dest. Returns number of
> > bytes that could not be copied. Can find out how many bytes are in
> > the log_buff by calling with zero size.
> 
> When I was at $EARLIER_EMPLOYER, we had code in there to copy the last
> kilobyte-odd of the log buffer into flash when the box oopsed.
> 

Hmm - I think that if you call with NULL dest, and have it advance the 
pointer, you could do the same thing with something like:

 /* see how many bytes are in the buff */
 length = early_copy_log_buff(NULL, NULL);
 /* advance the pointer, so we only copy the last 1k */
 if (length >= 1024 )
    left = early_copy_log_buff(NULL, length - 1024);
 /* copy to temp buffer, to save to flash */
 early_copy_log_buff(buff, 1024);
 save_buff_to_flash(buff);

That way - you can put this in the standard places for failure, and still have 
only one function polluting printk.c (Although if you want to use it for 
failure trapping - it's up for "normal" run time use, and doesn't go into 
__init. 

> Probably there are others, but they'll mainly be in the consumer/embedded
>  area, and those sorts of engineers don't read this mailing list much.

Adding a few more 'embedded' folks - who might have some thoughts/opinions.

-Robin

