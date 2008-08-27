Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYH0OhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYH0OhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYH0Ogh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:36:37 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:33859 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbYH0Ogg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:36:36 -0400
Subject: Re: [PATCH][resubmit] TPM: update char dev BKL pushdown
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       zohar@us.ibm.com, dvelarde@us.ibm.com, safford@us.ibm.com
In-Reply-To: <20080827031948.GA5184@us.ibm.com>
References: <1219784185.4768.6.camel@blackbox>
	 <20080826220823.509571fd@lxorguk.ukuu.org.uk>
	 <20080827031948.GA5184@us.ibm.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 11:32:15 -0300
Message-Id: <1219847535.4768.18.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was all about this section:

>       chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8),
GFP_KERNEL);
>       if (chip->data_buffer == NULL) {
> -             chip->num_opens--;
> +             atomic_set(&chip->is_open, 0);
>               put_device(chip->dev);

num_opens wasn't protected by driver_lock, so we made num_opens/is_open
atomic_t. But an int seems too much for just a flag (as Serge pointed),
and the code would be cleaner if we make only this line atomic, by using
test_and_set_bit(). Thanks Alan.
I'll rewrite it.

Rajiv


On Tue, 2008-08-26 at 22:19 -0500, Serge E. Hallyn wrote:
> Quoting Alan Cox (alan@lxorguk.ukuu.org.uk):
> > > +	atomic_set(&chip->is_open, 1);
> > > +	get_device(chip->dev); /* protect from chip disappearing */
> > 
> > Why not just use test_and_set_bit() ? You seem to be abusing atomic_t to
> > achieve this.
> 
> Good point.  Or heck just make it a simple flag.  Earlier I thought there
> was a place where driver_lock was taken just to do num_opens--, and so
> replacing the int num_opens with an atomic_t seemed worthwhile.  But since
> is_open is a boolean and now seems to be always protected by driver_lock,
> a flag seems best.
> 
> -serge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

